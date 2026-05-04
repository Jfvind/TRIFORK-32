#![no_std]
#![no_main]

use core::arch::global_asm; // to write assembly for the boot sequence
use core::fmt::{self, Write}; // for implementing our own print macros
use core::panic::PanicInfo; // for our custom panic handler

// ── 1. Hardware-adresser (Memory Mapped I/O) ────────────────────────────────
const UART_STATUS: *const u32 = 0xF000_0000 as *const u32;
const UART_DATA:   *mut u32   = 0xF000_0004 as *mut u32;
const LED_REG:     *mut u32   = 0xF010_0000 as *mut u32;
const BTN_REG:     *const u32 = 0xF020_0000 as *const u32;
const ADC_BASE:    *const u32 = 0xF030_0000 as *const u32;
const PWM_DUTY:    *mut u32   = 0xF040_0000 as *mut u32;

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

// ── 7. HAL: GPIOs ─────────────────────────────────────────────────────
#[derive(Clone, Copy)]
#[repr(usize)]
pub enum Pmod {
    JA = 0xF050_0000,
    JB = 0xF060_0000,
    JC = 0xF070_0000,
}

// offsets: 0=DIR, 4=OUT, 8=IN, 12=PWM_EN, 16=IN_DEBOUNCED
impl Pmod {
    pub fn set_dir(self, mask: u8) {
        unsafe { (self as usize as *mut u32).offset(0).write_volatile(mask as u32); }
    }
    pub fn set_out(self, mask: u8) {
        unsafe { (self as usize as *mut u32).offset(1).write_volatile(mask as u32); }
    }
    pub fn read_in(self) -> u8 {
        unsafe { (self as usize as *const u32).offset(2).read_volatile() as u8 }
    }
    pub fn read_debounced(self) -> u8 {
        unsafe { (self as usize as *const u32).offset(4).read_volatile() as u8 }
    }
    pub fn set_pwm_en(self, mask: u8) {
        unsafe { (self as usize as *mut u32).offset(3).write_volatile(mask as u32); }
    }
    pub fn button_pressed(self, bit: u8) -> bool {
        if bit >= 8 {
            return false;
        }
        (self.read_debounced() & (1u8 << bit)) == 0
    }
}

// ── 8. HAL: LED helper + BTN helper + ADC helper ─────────────────────────────────────────────────────
fn led_write(val: u8) { // LED = 1 on, LED = 0 off, bitmask for 8 LEDs
    unsafe {
        LED_REG.write_volatile(val as u32);
    }
}

fn btn_read() -> u8 {
    unsafe {
        (BTN_REG.read_volatile() & 0xF) as u8 // only four lowest bits
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

// Sets the brightness of a PWM enabled LED.
// 'channel' : GPIO number (0 - 24). (JA = 0-7) (JB = 8-15) (JC = 16-23)
// 'percent' : brightness from 0 (off) to 100 (full)
fn pwm_set_duty(channel: u8, percent: u8) {
    let percent = if percent > 100 { 100 } else { percent };
    let duty = (percent as u32 * 255) / 100;
    unsafe {
        PWM_DUTY.offset((channel as isize) + 1).write_volatile(duty);
    }
}

fn rgb_set(r: u8, g: u8, b: u8) {
    // Common-anode RGB: lower duty means brighter, so invert brightness.
    pwm_set_duty(4, 100 - r); // JA7
    pwm_set_duty(5, 100 - g); // JA8
    pwm_set_duty(6, 100 - b); // JA9
}

// ── 9. APP ────────────────────────────────────────────────────────
fn main() {
    
    // Use safe HAL for writing to UART
    println!("=== DTU MCU Booted ===");
    println!("SRAM Size: {} bytes", 4096);
    println!("Status: PASS");

    // set JA LEDs as output
    Pmod::JA.set_dir(0b0111_0111);

    // Enable PWM on RGB LED pins
    Pmod::JA.set_pwm_en(0b_0111_0000);

    // Simple PWM fade state for RGB test.
    let mut fade: u8 = 0;
    let mut fade_up = true;
    let mut color_phase: u8 = 0; // 0 = red, 1 = green, 2 = blue

    loop {
        // 1) Read peripherals
        let adc_val = adc_read_all(); // Returns 0 to 4095 for all four inputs
        let btn_val = btn_read(); // Use buttons 0..2 for io_led[8..10]

        // 2) ADC bargraph on io_led[0..6] using direct thresholds.
        let mut adc_leds: u8 = 0;
        if adc_val[0] > 512  { adc_leds |= 0b0000001; }
        if adc_val[0] > 1024 { adc_leds |= 0b0000011; }
        if adc_val[0] > 1536 { adc_leds |= 0b0000111; }
        if adc_val[0] > 2048 { adc_leds |= 0b0001111; }
        if adc_val[0] > 2560 { adc_leds |= 0b0011111; }
        if adc_val[0] > 3072 { adc_leds |= 0b0111111; }
        if adc_val[0] > 3584 { adc_leds |= 0b1111111; }
        led_write(adc_leds);

        // 3) Button mirror on JA[1..3].
        Pmod::JA.set_out(btn_val);

        // 4) RGB PWM fade test on JA[7..9].
        // Fade red, then green, then blue, one channel at a time.
        match color_phase {
            0 => rgb_set(fade, 0, 0),
            1 => rgb_set(0, fade, 0),
            _ => rgb_set(0, 0, fade),
        }

        if fade_up {
            if fade >= 100 {
                fade_up = false;
            } else {
                fade += 1;
            }
        } else {
            if fade == 0 {
                fade_up = true;
                color_phase = (color_phase + 1) % 3;
            } else {
                fade -= 1;
            }
        }

        // 5) Small delay to set animation speed.
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
