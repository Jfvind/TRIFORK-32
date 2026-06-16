//! I2C master driver.
//!
//! Talks to the I2cController hardware (memory-mapped at 0xF080_xxxx).
//! The controller executes one primitive command at a time (START, STOP,
//! WRITE, READ_ACK, READ_NACK); these helpers compose them into whole
//! transactions and poll the BUSY status bit between steps.

use crate::delay;
use crate::mmio::{I2C_CLKDIV, I2C_CMD, I2C_DATA, I2C_STATUS};

// Command codes written to I2C_CMD. Must match object I2cCmd in
// I2cController.scala.
const CMD_START: u32 = 0x01;
const CMD_STOP: u32 = 0x02;
const CMD_WRITE: u32 = 0x04;
const CMD_READ_ACK: u32 = 0x08;
const CMD_READ_NACK: u32 = 0x10;

// Status bits read from I2C_STATUS. Must match object I2cStatus.
const STATUS_BUSY: u32 = 1 << 0;
const STATUS_NACK: u32 = 1 << 1;
/// Reserved: declared in hardware but never set by the current controller.
#[allow(dead_code)]
const STATUS_BUS_ERR: u32 = 1 << 2;

/// Sets the SCL frequency via the clock divider.
///
/// divider = system_clock_hz / (i2c_hz * 2). At 100 MHz system clock:
/// 500 -> 100 kHz (standard mode), 125 -> 400 kHz (fast mode).
/// Writing 0 selects the hardware default (100 kHz).
pub fn set_clkdiv(divider: u16) {
    unsafe { I2C_CLKDIV.write_volatile(divider as u32) }
}

/// Blocks until the controller has finished the current command.
pub fn wait_idle() {
    unsafe { while (I2C_STATUS.read_volatile() & STATUS_BUSY) != 0 {} }
}

/// Reads the raw status register (BUSY/NACK/BUS_ERR bits). For debugging.
pub fn status() -> u32 {
    unsafe { I2C_STATUS.read_volatile() }
}

/// Generates a START condition. Call at the beginning of every transaction.
pub fn start() {
    unsafe { I2C_CMD.write_volatile(CMD_START) }
    wait_idle();
}

/// Generates a STOP condition, releasing the bus. Call at the end of every
/// transaction.
pub fn stop() {
    unsafe { I2C_CMD.write_volatile(CMD_STOP) }
    wait_idle();
}

/// Sends one byte. Returns `true` if the slave ACKed it.
///
/// To send a slave address: `byte = (addr << 1) | rw`, rw = 0 write, 1 read.
pub fn write_byte(byte: u8) -> bool {
    unsafe {
        I2C_DATA.write_volatile(byte as u32);
        I2C_CMD.write_volatile(CMD_WRITE);
    }
    wait_idle();
    let nack = unsafe { (I2C_STATUS.read_volatile() & STATUS_NACK) != 0 };
    !nack
}

/// Receives one byte. `send_ack = true` tells the slave more bytes are
/// wanted; `false` signals this was the last byte (NACK).
pub fn read_byte(send_ack: bool) -> u8 {
    let cmd = if send_ack {
        CMD_READ_ACK
    } else {
        CMD_READ_NACK
    };
    unsafe { I2C_CMD.write_volatile(cmd) }
    wait_idle();
    unsafe { I2C_DATA.read_volatile() as u8 }
}

/// Writes a buffer to the slave at 7-bit address `addr`.
/// Sequence: START -> addr+W -> data... -> STOP.
/// Returns `true` if every byte was ACKed.
pub fn write_bytes(addr: u8, data: &[u8]) -> bool {
    start();
    if !write_byte((addr << 1) | 0) {
        stop();
        return false;
    }
    for &b in data {
        if !write_byte(b) {
            stop();
            return false;
        }
    }
    stop();
    true
}

/// Reads `buf.len()` bytes from the slave at 7-bit address `addr`.
/// Sequence: START -> addr+R -> read (ACK all but last) -> STOP.
/// Returns `true` if the address byte was ACKed.
pub fn read_bytes(addr: u8, buf: &mut [u8]) -> bool {
    if buf.is_empty() {
        return true;
    }
    start();
    if !write_byte((addr << 1) | 1) {
        stop();
        return false;
    }
    // Wait ~50 microseconds after the address byte before clocking
    // the first data bit. AM2320-class slaves need time to prepare data
    // after ACKing their address; standard slaves would clock-stretch
    // instead, but some quirky chips do not.
    delay::cycles_precise(5_000);
    let last = buf.len() - 1;
    for (i, slot) in buf.iter_mut().enumerate() {
        *slot = read_byte(i != last);
    }
    stop();
    true
}

/// Write-then-read in one transaction (the "read sensor register" pattern).
/// Sequence: START -> addr+W -> write... -> repeated START -> addr+R ->
/// read... -> STOP.
pub fn write_read(addr: u8, write_data: &[u8], read_buf: &mut [u8]) -> bool {
    start();
    if !write_byte((addr << 1) | 0) {
        stop();
        return false;
    }
    for &b in write_data {
        if !write_byte(b) {
            stop();
            return false;
        }
    }
    start(); // repeated START - new START without STOP first
    if !write_byte((addr << 1) | 1) {
        stop();
        return false;
    }
    // See read_bytes for why this delay exists.
    delay::cycles_precise(5_000);
    if !read_buf.is_empty() {
        let last = read_buf.len() - 1;
        for (i, slot) in read_buf.iter_mut().enumerate() {
            *slot = read_byte(i != last);
        }
    }
    stop();
    true
}

/// Scans the bus for devices. Probes every 7-bit address 0x08..=0x77 and
/// fills `found` with addresses that ACKed. Returns the number found.
pub fn scan(found: &mut [u8]) -> usize {
    let mut count = 0;
    for addr in 0x08u8..=0x77 {
        start();
        let acked = write_byte((addr << 1) | 0);
        stop();
        if acked && count < found.len() {
            found[count] = addr;
            count += 1;
        }
    }
    count
}
