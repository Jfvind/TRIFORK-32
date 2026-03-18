#!/usr/bin/env python3
"""
UART Bootloader upload script for RustSoCTop.

Reads a binary file, sends it to the FPGAs BootloaderTop (in little-endian format) over serial,
and can listen for UART output from the program.

Steps:
  0. Send reset magic 0xDEADBEEF to reset the SoC back to boot mode.
  1. Send start magic 0xB00710AD to start the bootloader.
  2. For each 4-byte word in the binary, send 8 bytes: [address LE] [data LE].
  3. Send the "done" word: address=0x00000000, data=0xD0000000 to start the CPU.

Usage:
  python upload.py --port COM3 --binary program.bin
  python upload.py --port COM3 --binary program.bin --listen 5
  python upload.py --port COM3 --binary program.bin --expect "PASS" --timeout 10
"""

import argparse
import struct
import sys
import time
import serial


START_MAGIC = 0xB00710AD
DONE_MAGIC   = 0xD0000000
RESET_MAGIC  = 0xDEADBEEF
BAUD_RATE    = 115200

# Small delay between bytes to avoid overwhelming the bootloader.
# The bootloader needs a few cycles to process each byte.
INTER_BYTE_DELAY = 0.001  # 1 ms


def send_start(ser: serial.Serial) -> None:
    """Send the 4-byte start magic number."""
    # After 4 bytes, dataOut(63,32) must equal 0xB00710AD.
    # Send order: 0xAD, 0x10, 0x07, 0xB0
    # After shift: buffer = [B0][07][10][AD][xx][xx][xx][xx]
    # dataOut(63,32) = 0xB00710AD
    magic_bytes = struct.pack("<I", START_MAGIC)
    for b in magic_bytes:
        ser.write(bytes([b]))
        time.sleep(INTER_BYTE_DELAY)
    print(f"[loader] Sent magic: 0x{START_MAGIC:08X}")


def send_reset(ser: serial.Serial) -> None:
    """Send the 4-byte reset magic to put the SoC back in boot mode."""
    reset_bytes = struct.pack("<I", RESET_MAGIC)
    for b in reset_bytes:
        ser.write(bytes([b]))
        time.sleep(INTER_BYTE_DELAY)
    print(f"[loader] Sent reset: 0x{RESET_MAGIC:08X}")


def send_word(ser: serial.Serial, address: int, data: int) -> None:
    """Send one (address, data) pair of 8 bytes to the bootloader."""
    # Little-endian
    # First 4 bytes -> dataOut(31,0)  = address
    # Last 4 bytes  -> dataOut(63,32) = data
    payload = struct.pack("<II", address, data)
    for b in payload:
        ser.write(bytes([b]))
        time.sleep(INTER_BYTE_DELAY)


def send_done(ser: serial.Serial) -> None:
    """Send the done signal starts the CPU."""
    send_word(ser, 0x00000000, DONE_MAGIC)
    print(f"[loader] Sent done signal: 0x{DONE_MAGIC:08X}")


def upload_binary(ser: serial.Serial, binary_path: str, base_address: int = 0) -> int:
    """
    Upload a binary file to the FPGA via the bootloader.

    Returns the number of words sent.
    """
    with open(binary_path, "rb") as f:
        data = f.read()

    # Pad to a 4-byte boundary
    if len(data) % 4 != 0:
        data += b"\x00" * (4 - len(data) % 4)

    num_words = len(data) // 4
    print(f"[loader] Uploading {binary_path}: {len(data)} bytes ({num_words} words)")

    for i in range(num_words):
        address = base_address + i * 4
        word = struct.unpack_from("<I", data, i * 4)[0]
        send_word(ser, address, word)

        # Progress indicator every 64 words
        if (i + 1) % 64 == 0 or (i + 1) == num_words:
            pct = (i + 1) * 100 // num_words
            print(f"\r[loader] Progress: {i+1}/{num_words} words ({pct}%)", end="", flush=True)

    print()  # newline after progress
    return num_words


def listen_output(ser: serial.Serial, duration: float) -> str:
    """Listen for UART output from the CPU for a chosen duration."""
    print(f"[loader] Listening for {duration}s...")
    output = []
    start = time.time()
    while time.time() - start < duration:
        if ser.in_waiting > 0:
            chunk = ser.read(ser.in_waiting)
            text = chunk.decode("ascii", errors="replace")
            output.append(text)
            print(text, end="", flush=True)
        else:
            time.sleep(0.01)
    print()
    return "".join(output)


def main():
    parser = argparse.ArgumentParser(
        description="Upload a binary to the FPGA via UART bootloader"
    )
    parser.add_argument("--port", required=True, help="Serial port (e.g. COM3, /dev/ttyUSB0)")
    parser.add_argument("--binary", required=True, help="Path to binary file (.bin)")
    parser.add_argument("--baud", type=int, default=BAUD_RATE, help=f"Baud rate (default: {BAUD_RATE})")
    parser.add_argument("--base", type=lambda x: int(x, 0), default=0, help="Base address for the binary (default: 0x0)")
    parser.add_argument("--listen", type=float, default=0, help="Listen for UART output for N seconds after upload")
    parser.add_argument("--expect", type=str, default=None, help="Expected string in UART output (testing and CI)")
    parser.add_argument("--timeout", type=float, default=5.0, help="Timeout in seconds when using --expect (default: 5)")
    args = parser.parse_args()

    # Open serial port (from Makefile)
    try:
        ser = serial.Serial(args.port, args.baud, timeout=0.1)
    except serial.SerialException as e:
        print(f"[loader] ERROR: Could not open {args.port}: {e}", file=sys.stderr)
        sys.exit(1)

    try:
        # Give the FPGA a moment after serial port opens
        time.sleep(0.1)

        # Flush old data from a previous run
        ser.reset_input_buffer()
        ser.reset_output_buffer()

        # Step 0: reset the SoC (puts bootloader in Sleep)
        send_reset(ser)
        time.sleep(0.2)  # wait for reset to be finished and UART lines to be empty
        ser.reset_input_buffer()  # discard any garbage from the reset

        # Step 1: Send magic to transition bootloader from Sleep → Idle
        send_start(ser)
        time.sleep(0.05)

        # Step 2: Upload binary
        num_words = upload_binary(ser, args.binary, args.base)
        time.sleep(0.05)

        # Step 3: Send done signal to start the CPU
        send_done(ser)
        time.sleep(0.1)

        print(f"[loader] Upload complete. CPU started. ({num_words} words loaded)")

        # Step 4: Listen (for tests)
        if args.expect:
            # Test mode: listen and check for expected string
            output = listen_output(ser, args.timeout)
            if args.expect in output:
                print(f"[loader] PASS: Found expected output '{args.expect}'")
                sys.exit(0)
            else:
                print(f"[loader] FAIL: Expected '{args.expect}' not found in output", file=sys.stderr)
                print(f"[loader] Got: '{output}'", file=sys.stderr)
                sys.exit(1)
        elif args.listen > 0:
            # Just listen and print
            listen_output(ser, args.listen)
        else:
            print("[loader] Done. Use --listen N or --expect STRING to capture output.")

    finally:
        ser.close()


if __name__ == "__main__":
    main()
