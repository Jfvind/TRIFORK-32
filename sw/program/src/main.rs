//! Minimal Rust program for the Wildcat RISC-V SoC.
//!
//! This is a test/example program that your friend's library will eventually replace.
//! It writes "PASS" over UART so the CI test harness can verify the full pipeline:
//!   Rust compile → binary → UART upload → CPU execution → UART output
//!
//! Memory-mapped IO addresses (defined by RustSoCTop):
//!   0xF000_0000 — UART status (bit 0 = TX ready, bit 1 = RX data available)
//!   0xF000_0004 — UART data   (write = send byte, read = receive byte)
//!   0xF010_0000 — LED register (lower 8 bits)

#![no_std]
#![no_main]

use core::panic::PanicInfo;

// ── Memory-mapped IO addresses ──────────────────────────────────────────────

const UART_STATUS: *const u32 = 0xF000_0000 as *const u32;
const UART_DATA: *mut u32 = 0xF000_0004 as *mut u32;
const LED_REG: *mut u32 = 0xF010_0000 as *mut u32;

// ── Panic handler (required for no_std) ─────────────────────────────────────

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    // Write 'E' to UART as error indicator, then hang
    unsafe { UART_DATA.write_volatile(b'E' as u32); }
    loop {}
}

// ── UART helpers ────────────────────────────────────────────────────────────

/// Wait until the UART transmitter is ready, then send one byte.
fn uart_putc(c: u8) {
    unsafe {
        // Poll bit 0 of the status register (TX ready / TDE).
        // MUST use read_volatile — without it, the compiler hoists the load
        // out of the loop and turns this into an infinite spin.
        while (UART_STATUS.read_volatile() & 0x1) == 0 {}
        UART_DATA.write_volatile(c as u32);
    }
}

/// Send a string over UART.
fn uart_print(s: &str) {
    for b in s.bytes() {
        uart_putc(b);
    }
}

// ── LED helper ──────────────────────────────────────────────────────────────

/// Write a value to the LED register (lower 8 bits visible on Basys3).
fn led_write(val: u16) {
    unsafe {
        LED_REG.write_volatile(val as u32);
    }
}

// ── Entry point ─────────────────────────────────────────────────────────────

/// Entry point — called by the bootloader after loading is complete.
/// The linker script places this at address 0x0000.
#[unsafe(no_mangle)]
pub extern "C" fn _start() -> ! {
    // Set up the stack pointer (sp = x2) to top of RAM.
    // The linker script defines _stack_top at ORIGIN(RAM) + LENGTH(RAM).
    unsafe {
        core::arch::asm!(
            "la sp, _stack_top",
            options(nostack)
        );
    }

    // Light up LED 0 to indicate we're alive
    led_write(0x401);

    // Send test output — the CI harness checks for "PASS"
    uart_print("PASS\n");

    // Light up more LEDs to show completion
    led_write(0x3FF);

    // Halt
    loop {}
}
