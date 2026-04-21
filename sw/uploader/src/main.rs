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
const DONE_MAGIC:  u32 = 0xD0000000;
const RESET_MAGIC: u32 = 0xDEADBEEF;
const DEFAULT_BAUD: u32 = 115_200;

/// Small delay between bytes so the bootloader has time to process each one.
const INTER_BYTE_DELAY: Duration = Duration::from_millis(1);

#[derive(Parser, Debug)]
#[command(author, version, about = "Upload a binary to the FPGA via UART bootloader")]
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

    /// Expected string in UART output (for testing / CI)
    #[arg(long)]
    expect: Option<String>,

    /// Timeout in seconds when using --expect
    #[arg(long, default_value_t = 5.0)]
    timeout: f64,
}

fn parse_address(s: &str) -> Result<u32, String> {
    let s = s.trim();
    let (radix, digits) = if let Some(rest) = s.strip_prefix("0x").or_else(|| s.strip_prefix("0X")) {
        (16, rest)
    } else {
        (10, s)
    };
    u32::from_str_radix(digits, radix).map_err(|e| format!("invalid address '{s}': {e}"))
}

/// Write bytes one at a time with the inter-byte delay, mirroring the Python behaviour.
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

/// Send one (address, data) pair of 8 bytes to the bootloader (LE).
fn send_word(port: &mut dyn SerialPort, address: u32, data: u32) -> Result<()> {
    let mut payload = [0u8; 8];
    payload[0..4].copy_from_slice(&address.to_le_bytes());
    payload[4..8].copy_from_slice(&data.to_le_bytes());
    write_slow(port, &payload)
}

fn send_done(port: &mut dyn SerialPort) -> Result<()> {
    send_word(port, 0x0000_0000, DONE_MAGIC)?;
    println!("[loader] Sent done signal: 0x{:08X}", DONE_MAGIC);
    Ok(())
}

fn upload_binary(port: &mut dyn SerialPort, binary_path: &str, base_address: u32) -> Result<usize> {
    let mut data = fs::read(binary_path)
        .with_context(|| format!("failed to read binary file {binary_path}"))?;

    // Pad to 4-byte boundary
    let pad = (4 - data.len() % 4) % 4;
    data.extend(std::iter::repeat(0u8).take(pad));

    let num_words = data.len() / 4;
    println!(
        "[loader] Uploading {}: {} bytes ({} words)",
        binary_path,
        data.len(),
        num_words
    );

    for i in 0..num_words {
        let address = base_address.wrapping_add((i as u32) * 4);
        let word = u32::from_le_bytes(data[i * 4..i * 4 + 4].try_into().unwrap());
        send_word(port, address, word)?;

        if (i + 1) % 64 == 0 || (i + 1) == num_words {
            let pct = (i + 1) * 100 / num_words;
            print!("\r[loader] Progress: {}/{} words ({}%)", i + 1, num_words, pct);
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
    if let Some(expected) = args.expect.as_ref() {
        let output = listen_output(&mut *port, Duration::from_secs_f64(args.timeout))?;
        if output.contains(expected) {
            println!("[loader] PASS: Found expected output '{expected}'");
            Ok(ExitCode::SUCCESS)
        } else {
            eprintln!("[loader] FAIL: Expected '{expected}' not found in output");
            eprintln!("[loader] Got: '{output}'");
            Ok(ExitCode::from(1))
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