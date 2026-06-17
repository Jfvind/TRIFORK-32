//! UART Bootloader upload tool for RustSoCTop.
//!
//! Reads a binary file, sends it to the FPGA's BootloaderTop (in little-endian
//! format) over serial, and can listen for UART output from the program.
//!
//! Steps:
//!   0. Send reset magic 0xDEADBEEF to reset the SoC back to boot mode.
//!   1. Send start magic 0xB00710AD to start the bootloader.
//!   2. For each 4-byte word in the binary, send 8 bytes: [address LE] [data LE].
//!   3. Send the "done" word: address=0x00000000, data=0xD0000000 to start the CPU.

use anyhow::{Context, Result};
use clap::Parser;
use serialport::SerialPort;
use std::fs;
use std::io::Write;
use std::process::ExitCode;
use std::thread::sleep;
use std::time::{Duration, Instant};

const START_MAGIC: u32 = 0xB00710AD;
const DONE_MAGIC: u32 = 0xD0000000;
const RESET_MAGIC: u32 = 0xDEADBEEF;
const DEFAULT_BAUD: u32 = 115_200;

/// Small delay between bytes so the bootloader has time to process each one.
const INTER_BYTE_DELAY: Duration = Duration::from_millis(1);

#[derive(Parser, Debug)]
#[command(
    author,
    version,
    about = "Upload a binary to the FPGA via UART bootloader"
)]
struct Args {
    /// Serial port (e.g. COM3, /dev/ttyUSB0)
    #[arg(long)]
    port: String,

    /// Path to binary file (.bin)
    #[arg(long)]
    binary: String,

    /// Baud rate
    #[arg(long, default_value_t = DEFAULT_BAUD)]
    baud: u32,

    /// Base address for the binary (accepts 0x prefix)
    #[arg(long, default_value = "0", value_parser = parse_address)]
    base: u32,

    /// Listen for UART output for N seconds after upload
    #[arg(long, default_value_t = 0.0)]
    listen: f64,

    /// Expected string in UART output (for testing / CI). May be given multiple
    /// times; all must be present for the run to pass.
    #[arg(long)]
    expect: Vec<String>,

    /// Timeout in seconds when using --expect
    #[arg(long, default_value_t = 5.0)]
    timeout: f64,
}

fn parse_address(s: &str) -> Result<u32, String> {
    let s = s.trim();
    let (radix, digits) = if let Some(rest) = s.strip_prefix("0x").or_else(|| s.strip_prefix("0X"))
    {
        (16, rest)
    } else {
        (10, s)
    };
    u32::from_str_radix(digits, radix).map_err(|e| format!("invalid address '{s}': {e}"))
}

/// Write bytes one at a time with the inter-byte delay.
fn write_slow(port: &mut dyn SerialPort, bytes: &[u8]) -> Result<()> {
    for b in bytes {
        port.write_all(std::slice::from_ref(b))
            .context("failed to write to serial port")?;
        sleep(INTER_BYTE_DELAY);
    }
    Ok(())
}

fn send_reset(port: &mut dyn SerialPort) -> Result<()> {
    write_slow(port, &RESET_MAGIC.to_le_bytes())?;
    println!("[loader] Sent reset: 0x{:08X}", RESET_MAGIC);
    Ok(())
}

fn send_start(port: &mut dyn SerialPort) -> Result<()> {
    write_slow(port, &START_MAGIC.to_le_bytes())?;
    println!("[loader] Sent magic: 0x{:08X}", START_MAGIC);
    Ok(())
}

/// Encode one (address, data) pair as the 8-byte bootloader frame: [address LE][data LE].
/// No I/O so the wire encoding can be verified in unit tests.
fn word_payload(address: u32, data: u32) -> [u8; 8] {
    let mut payload = [0u8; 8];
    payload[0..4].copy_from_slice(&address.to_le_bytes());
    payload[4..8].copy_from_slice(&data.to_le_bytes());
    payload
}

/// Split a raw binary image into the (address, data) word pairs the bootloader expects.
/// The image is zero-padded up to a 4-byte boundary and each word is decoded
/// little-endian. Addresses start at `base_address` and increment by 4; the SoC
/// routes them to IMEM (`< 0x1000`) or DMEM (`>= 0x1000`) by range. No I/O so the
/// framing can be verified in unit tests.
fn frame_binary(data: &[u8], base_address: u32) -> Vec<(u32, u32)> {
    let mut data = data.to_vec();
    let pad = (4 - data.len() % 4) % 4;
    data.resize(data.len() + pad, 0);

    (0..data.len() / 4)
        .map(|i| {
            let address = base_address.wrapping_add((i as u32) * 4);
            let word = u32::from_le_bytes(data[i * 4..i * 4 + 4].try_into().unwrap());
            (address, word)
        })
        .collect()
}

/// Returns the first expected marker that is absent from `output`, or `None` if
/// every marker is present. Pure function so the CI pass/fail rule is testable.
fn first_missing<'a>(output: &str, expected: &'a [String]) -> Option<&'a str> {
    expected
        .iter()
        .map(String::as_str)
        .find(|marker| !output.contains(marker))
}

/// Send one (address, data) pair of 8 bytes to the bootloader (LE).
fn send_word(port: &mut dyn SerialPort, address: u32, data: u32) -> Result<()> {
    write_slow(port, &word_payload(address, data))
}

fn send_done(port: &mut dyn SerialPort) -> Result<()> {
    send_word(port, 0x0000_0000, DONE_MAGIC)?;
    println!("[loader] Sent done signal: 0x{:08X}", DONE_MAGIC);
    Ok(())
}

fn upload_binary(port: &mut dyn SerialPort, binary_path: &str, base_address: u32) -> Result<usize> {
    let data = fs::read(binary_path)
        .with_context(|| format!("failed to read binary file {binary_path}"))?;

    let words = frame_binary(&data, base_address);
    let num_words = words.len();
    println!(
        "[loader] Uploading {}: {} bytes ({} words)",
        binary_path,
        num_words * 4,
        num_words
    );

    for (i, &(address, word)) in words.iter().enumerate() {
        send_word(port, address, word)?;

        if (i + 1) % 64 == 0 || (i + 1) == num_words {
            let pct = (i + 1) * 100 / num_words;
            print!(
                "\r[loader] Progress: {}/{} words ({}%)",
                i + 1,
                num_words,
                pct
            );
            std::io::stdout().flush().ok();
        }
    }
    println!();
    Ok(num_words)
}

fn listen_output(port: &mut dyn SerialPort, duration: Duration) -> Result<String> {
    println!("[loader] Listening for {:.2}s...", duration.as_secs_f64());
    let mut collected = String::new();
    let mut buf = [0u8; 256];
    let start = Instant::now();
    while start.elapsed() < duration {
        match port.read(&mut buf) {
            Ok(0) => sleep(Duration::from_millis(10)),
            Ok(n) => {
                let text = String::from_utf8_lossy(&buf[..n]);
                print!("{text}");
                std::io::stdout().flush().ok();
                collected.push_str(&text);
            }
            Err(e) if e.kind() == std::io::ErrorKind::TimedOut => {
                sleep(Duration::from_millis(10));
            }
            Err(e) => return Err(e).context("serial read failed"),
        }
    }
    println!();
    Ok(collected)
}

fn run() -> Result<ExitCode> {
    let args = Args::parse();

    let mut port = serialport::new(&args.port, args.baud)
        .timeout(Duration::from_millis(100))
        .open()
        .with_context(|| format!("could not open {}", args.port))?;

    // Give the FPGA a moment after opening the port
    sleep(Duration::from_millis(100));

    // Flush stale data
    port.clear(serialport::ClearBuffer::All).ok();

    // Step 0: reset
    send_reset(&mut *port)?;
    sleep(Duration::from_millis(200));
    port.clear(serialport::ClearBuffer::Input).ok();

    // Step 1: start magic
    send_start(&mut *port)?;
    sleep(Duration::from_millis(50));

    // Step 2: upload
    let num_words = upload_binary(&mut *port, &args.binary, args.base)?;
    sleep(Duration::from_millis(50));

    // Step 3: done
    send_done(&mut *port)?;
    sleep(Duration::from_millis(100));

    println!("[loader] Upload complete. CPU started. ({num_words} words loaded)");

    // Step 4: listen / expect
    if !args.expect.is_empty() {
        let output = listen_output(&mut *port, Duration::from_secs_f64(args.timeout))?;
        match first_missing(&output, &args.expect) {
            None => {
                println!(
                    "[loader] PASS: found all {} expected marker(s)",
                    args.expect.len()
                );
                Ok(ExitCode::SUCCESS)
            }
            Some(missing) => {
                eprintln!("[loader] FAIL: expected marker '{missing}' not found in output");
                eprintln!("[loader] Got: '{output}'");
                Ok(ExitCode::from(1))
            }
        }
    } else if args.listen > 0.0 {
        listen_output(&mut *port, Duration::from_secs_f64(args.listen))?;
        Ok(ExitCode::SUCCESS)
    } else {
        println!("[loader] Done. Use --listen N or --expect STRING to capture output.");
        Ok(ExitCode::SUCCESS)
    }
}

fn main() -> ExitCode {
    match run() {
        Ok(code) => code,
        Err(e) => {
            eprintln!("[loader] ERROR: {e:#}");
            ExitCode::from(1)
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// The bootloader protocol magics must stay fixed and distinct — the SoC matches
    /// these exact little-endian byte sequences.
    #[test]
    fn protocol_magics_are_fixed() {
        assert_eq!(START_MAGIC.to_le_bytes(), [0xAD, 0x10, 0x07, 0xB0]);
        assert_eq!(DONE_MAGIC.to_le_bytes(), [0x00, 0x00, 0x00, 0xD0]);
        assert_eq!(RESET_MAGIC.to_le_bytes(), [0xEF, 0xBE, 0xAD, 0xDE]);
    }

    /// A frame is [address LE][data LE]. This is the exact wire encoding the
    /// BootloaderTop decodes, so a regression here corrupts every instruction.
    #[test]
    fn word_payload_is_address_then_data_little_endian() {
        assert_eq!(
            word_payload(0x0000_1004, 0x0000_0013),
            [0x04, 0x10, 0x00, 0x00, 0x13, 0x00, 0x00, 0x00]
        );
    }

    /// The done word that releases the CPU: address 0, data = DONE_MAGIC.
    #[test]
    fn done_word_encoding() {
        assert_eq!(
            word_payload(0x0000_0000, DONE_MAGIC),
            [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xD0]
        );
    }

    /// Instruction words are decoded little-endian and paired with incrementing
    /// word addresses — i.e. the bytes the Rust toolchain emitted are the words
    /// sent to the core, in order.
    #[test]
    fn frame_decodes_words_little_endian_in_order() {
        // addi x0, x0, 0 (0x0000_0013) then add x0, x0, x0 (0x0000_0033)
        let bin = [0x13, 0x00, 0x00, 0x00, 0x33, 0x00, 0x00, 0x00];
        assert_eq!(
            frame_binary(&bin, 0),
            vec![(0x0000_0000, 0x0000_0013), (0x0000_0004, 0x0000_0033)]
        );
    }

    /// A non-word-multiple image is zero-padded up to the next word.
    #[test]
    fn frame_pads_partial_trailing_word_with_zeros() {
        let bin = [0xAA, 0xBB, 0xCC]; // 3 bytes -> one padded word
        assert_eq!(frame_binary(&bin, 0), vec![(0x0000_0000, 0x00CC_BBAA)]);
    }

    /// Addresses track the base and cross the IMEM→DMEM boundary (0x1000) cleanly,
    /// so .data words are routed to DMEM by the SoC's address decode.
    #[test]
    fn frame_addresses_cross_imem_dmem_boundary() {
        let bin = vec![0u8; 8]; // two words
        let words = frame_binary(&bin, 0x0000_0FFC);
        assert_eq!(words[0].0, 0x0000_0FFC); // last IMEM word
        assert_eq!(words[1].0, 0x0000_1000); // first DMEM word
    }

    /// An empty image produces no words (and must not panic).
    #[test]
    fn frame_empty_image_is_no_words() {
        assert!(frame_binary(&[], 0).is_empty());
    }

    /// The CI pass rule: all expected markers must be present, in any order.
    #[test]
    fn first_missing_requires_every_marker() {
        let output = "=== DTU MCU Booted ===\nSRAM Size: 4096 bytes\nStatus: PASS\n";
        let all = vec!["=== DTU MCU Booted ===".to_string(), "PASS".to_string()];
        assert_eq!(first_missing(output, &all), None);

        let with_absent = vec!["PASS".to_string(), "NOPE".to_string()];
        assert_eq!(first_missing(output, &with_absent), Some("NOPE"));

        // No markers configured -> nothing missing.
        assert_eq!(first_missing(output, &[]), None);
    }
}
