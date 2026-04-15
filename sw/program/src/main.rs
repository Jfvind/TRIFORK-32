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
const PWM_BASE: *mut u32 = 0xF040_0000 as *mut u32;

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
fn pwm_enable(mask: u16) {
    unsafe {
        PWM_BASE.write_volatile(mask as u32);
    }
}

// Sets the brightness of a PWM enabled LED.
// 'channel' : LED number (0 - 6, 8 - 15)
// 'percent' : brightness from 0 (off) to 100 (full)
fn pwm_set(channel: u8, percent: u8) {
    let percent = if percent > 100 { 100 } else { percent };
    let duty = (percent as u32 * 255) / 100;
    unsafe {
        PWM_BASE.offset((channel as isize) + 1).write_volatile(duty);
    }
}

fn rgb_set(r: u8, g: u8, b: u8) {
    // External RGB LED channels are mapped to io_led[12..14] via JA pins.
    pwm_set(12, r);
    pwm_set(13, g);
    pwm_set(14, b);
}

// ── 8. APP ────────────────────────────────────────────────────────
fn main() {
    
    // Use safe HAL for writing to UART
    println!("=== DTU MCU Booted ===");
    println!("SRAM Size: {} bytes", 4096);
    println!("Status: PASS");

    // Enable PWM only for RGB test outputs on io_led[12..14].
    // io_led[0..6] stay as plain GPIO for ADC bargraph visibility.
    pwm_enable((1u16 << 12) | (1u16 << 13) | (1u16 << 14));

    // Simple PWM fade state for RGB test.
    let mut fade: u8 = 0;
    let mut fade_up = true;

    loop {
        // 1) Read peripherals
        let adc_val = adc_read_all(); // Returns 0 to 4095 for all four inputs
        let btn_val = btn_read() & 0b111; // Use buttons 0..2 for io_led[8..10]

        // 2) ADC bargraph on io_led[0..6] using direct thresholds.
        let mut adc_leds: u16 = 0;
        if adc_val[0] > 512  { adc_leds |= 0b0000001; }
        if adc_val[0] > 1024 { adc_leds |= 0b0000011; }
        if adc_val[0] > 1536 { adc_leds |= 0b0000111; }
        if adc_val[0] > 2048 { adc_leds |= 0b0001111; }
        if adc_val[0] > 2560 { adc_leds |= 0b0011111; }
        if adc_val[0] > 3072 { adc_leds |= 0b0111111; }
        if adc_val[0] > 3584 { adc_leds |= 0b1111111; }

        // 3) Button mirror on io_led[8..10].
        let btn_leds = (btn_val as u16) << 8;

        // 4) Combine GPIO-driven LEDs and write once.
        // bit7 is reserved internally for cpuRunning in hardware.
        led_write(adc_leds | btn_leds);

        // 5) RGB PWM fade test on io_led[12..14].
        // R fades up while B fades down, G runs at half intensity.
        rgb_set(fade, fade / 2, 100 - fade);

        if fade_up {
            if fade >= 100 {
                fade_up = false;
            } else {
                fade += 1;
            }
        } else if fade == 0 {
            fade_up = true;
        } else {
            fade -= 1;
        }

        // 6) Small delay to set animation speed.
        for _ in 0..150_000 {
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