#![no_std]
#![no_main]

use core::arch::global_asm; // to write assembly for the boot sequence
use core::fmt::{self, Write}; // for implementing our own print macros
use core::panic::PanicInfo; // for our custom panic handler

// ── 1. Hardware-adresser (Memory Mapped I/O) ────────────────────────────────
const UART_STATUS: *const u32 = 0xF000_0000 as *const u32;
const UART_DATA: *mut u32 = 0xF000_0004 as *mut u32;
const LED_REG: *mut u32 = 0xF010_0000 as *mut u32;
const BTN_REG: *const u32 = 0xF020_0000 as *const u32;
const ADC_BASE: *const u32 = 0xF030_0000 as *const u32;
const PWM_Base: *mut u32 = 0xF040_0000 as *mut u32;

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

// ── 7. HAL: LED helper + BTN helper + ADC helper ─────────────────────────────────────────────────────
fn led_write(val: u16) { // LED = 1 on, LED = 0 off, bitmask for 16 LEDs
    unsafe {
        LED_REG.write_volatile(val as u32);
    }
}

fn btn_read() -> u32 {
    unsafe {
        BTN_REG.read_volatile()
    }
}

fn adc_read_all() -> [u32; 4] {
    unsafe {
        [
            ADC_BASE.offset(0).read_volatile(), // 0xF030_0000
            ADC_BASE.offset(1).read_volatile(), // 0xF030_0004
            ADC_BASE.offset(2).read_volatile(), // 0xF030_0008
            ADC_BASE.offset(3).read_volatile()  // 0xF030_000C
        ]
    }
}

// Enables PWM mode for specific LEDs.
// Each bit in 'mask' corresponds to one LED (bit 0 = LED 0, etc.)
// When enabled, that LED is controlled by its duty cycle instead of led_write().
fn pwm_enable(mask: u8) {
    unsafe {
        PWM.BASE.write_volatile(mask as u32)
    }
}

// Sets the brightness of a PWM enabled LED.
// 'channel' : LED number (0 - 6)
// 'percent' : brightness from 0 (off) to 100 (full)
fn pwn_set(channel: u8, percent: u8) {
    let perceent = if percent > 100 { 100 } else { percent };
    let duty = (percent as u32 * 255) / 100
    unsafe {
        PWM_BASE.offset((channel as isize) + 1).write_volatile(duty);
    }
}

// ── 8. APP ────────────────────────────────────────────────────────
fn main() {
    
    // Use safe HAL for writing to UART
    println!("=== DTU MCU Booted ===");
    println!("SRAM Size: {} bytes", 4096);
    println!("Status: PASS");

    loop {
        // 1. Read hardware peripherals
        let adc_val = adc_read_all(); // Returns 0 to 4095 for all four inputs
        let btn_val = btn_read(); // Returns 4-bit button state

        // 2. Logic: Map ADC to Onboard LEDs (Bits 0 to 6) like a volume bar graph
        let mut onboard_leds = 0;
        if adc_val[0] > 500  { onboard_leds |= 0b0000001; } // LED 0
        if adc_val[0] > 1000 { onboard_leds |= 0b0000011; } // LED 1
        if adc_val[0] > 1500 { onboard_leds |= 0b0000111; } // LED 2
        if adc_val[0] > 2000 { onboard_leds |= 0b0001111; } // LED 3
        if adc_val[0] > 2500 { onboard_leds |= 0b0011111; } // LED 4
        if adc_val[0] > 3000 { onboard_leds |= 0b0111111; } // LED 5
        if adc_val[0] > 3500 { onboard_leds |= 0b1111111; } // LED 6

        // 3. Logic: Map Buttons to PMOD LEDs (Bits 8, 9, 10)
        // BTN[0] -> LED[8], BTN[1] -> LED[9], BTN[2] -> LED[10]
        // We isolate the lowest 3 buttons (0b111) and shift them left by 8
        let pmod_leds = (btn_val & 0b111) << 8;

        // 4. Combine and write to LED register
        // Note: LED[7] is ignored by hardware, so we can leave it 0
        let final_led_output = onboard_leds | pmod_leds;
        led_write(final_led_output as u16);

        // 5. Small delay to prevent spamming and flickering
        for _ in 0..500_000 {
            unsafe { core::arch::asm!("nop"); }
        }
    }
}

// ── 9. Panic Handler ────────────────────────────────────────────────────────
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    // freeze the system and print panic info to UART
    println!("\n[CPU PANIC]: {}", info);
    loop {}
}