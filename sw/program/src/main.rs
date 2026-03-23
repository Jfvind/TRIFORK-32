#![no_std]
#![no_main]

use core::arch::global_asm; // to write assembly for the boot sequence
use core::fmt::{self, Write}; // for implementing our own print macros
use core::panic::PanicInfo; // for our custom panic handler

// ── 1. Hardware-adresser (Memory Mapped I/O) ────────────────────────────────
const UART_STATUS: *const u32 = 0xF000_0000 as *const u32;
const UART_DATA: *mut u32 = 0xF000_0004 as *mut u32;
const LED_REG: *mut u32 = 0xF010_0000 as *mut u32;

// ── 2. Linker symboler (Fra linker.ld) ──────────────────────────────────────
extern "C" {
    static mut __bss_start: u32;
    static mut __bss_end: u32;
}

// ── 3. Boot sekvens (Assembly) ──────────────────────────────────────────────
global_asm!(
    ".section .text._start",
    ".global _start",
    "_start:",
    "la sp, _stack_top",    // stack pointer defined in linker script
    "j rust_entry"          //jump to rust entry point
);

// ── 4. Boot sekvens (Rust) ──────────────────────────────────────────────────
#[no_mangle]
pub unsafe extern "C" fn rust_entry() -> ! { // our entry point after assembly setup
    // Zero BSS segment to ensure all static variables start at 0 -> SRAM NOISE
    let mut bss_ptr = core::ptr::addr_of_mut!(__bss_start);
    let bss_end = core::ptr::addr_of_mut!(__bss_end);
    
    while bss_ptr < bss_end {
        core::ptr::write_volatile(bss_ptr, 0); // zero out BSS
        bss_ptr = bss_ptr.offset(1); // move to next word
    }

    main();

    // Catch-all if main returns, which it shouldn't. Indicates something went wrong.
    loop {}
}

// ── 5. HAL: Hardware Abstraction Layer (UART) ───────────────────────────────
pub struct Uart;

impl Uart {
    pub fn new() -> Self {
        Uart
    }
}

// Implement Rust standard library's Write trait for our UART, so we can use it with our print macros
impl Write for Uart {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        for b in s.bytes() {
            unsafe {
                // wait until UART is ready to send  | status bit 0 == 1 |
                while (UART_STATUS.read_volatile() & 0x1) == 0 {}
                // Send byte
                UART_DATA.write_volatile(b as u32);
            }
        }
        Ok(())
    }
}

// ── 6. HAL: Macros ─────────────────────────────────────────────────────────
#[macro_export]
macro_rules! print { // This macro allows us to use print! and println! like in standard Rust, but it sends output to our UART
    ($($arg:tt)*) => { // format_args!($($arg)*) allows us to use the same formatting syntax as standard Rust
        #[allow(unused_unsafe)]
        unsafe { // Create a new UART instance and write the formatted string to it
            use core::fmt::Write;
            let _ = $crate::Uart::new().write_fmt(format_args!($($arg)*));
        }
    };
}

#[macro_export]
macro_rules! println {
    () => ($crate::print!("\n"));
    ($($arg:tt)*) => ($crate::print!("{}\n", format_args!($($arg)*)));
}

// ── 7. HAL: LED helper ─────────────────────────────────────────────────────
fn led_write(val: u16) { // LED = 1 on, LED = 0 off, bitmask for 16 LEDs
    unsafe {
        LED_REG.write_volatile(val as u32);
    }
}

// ── 8. APP ────────────────────────────────────────────────────────
fn main() {
    // Tænd den første LED for at vise, at CPU'en lever + BLÅ LED
    led_write(0x401);
    
    // Use safe HAL for writing to UART
    println!("=== DTU MCU Booted ===");
    println!("SRAM Size: {} bytes", 4096);
    println!("Status: PASS");

    // Tænd 7 mest højrestående LEDer på boardet + RØD og GRØN LED
    led_write(0x3FF);
}

// ── 9. Panic Handler ────────────────────────────────────────────────────────
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    // freeze the system and print panic info to UART
    println!("\n[CPU PANIC]: {}", info);
    loop {}
}