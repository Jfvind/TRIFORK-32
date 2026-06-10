//! Hardware abstraction layer for the DTU FPGA MCU, TRIFORK-32.
//!
//! This crate exposes small, student-facing helpers for the memory-mapped
//! peripherals in the SoC. The low-level functions are still available, while
//! modules such as [`leds`], [`buttons`], [`adc`], [`delay`], and [`rgb`] provide
//! a more readable API for application code.

#![no_std]

use core::fmt::{self, Write};

const UART_STATUS: *const u32 = 0xF000_0000 as *const u32;
const UART_DATA: *mut u32 = 0xF000_0004 as *mut u32;
const LED_REG: *mut u32 = 0xF010_0000 as *mut u32;
const BTN_REG: *const u32 = 0xF020_0000 as *const u32;
const ADC_BASE: *const u32 = 0xF030_0000 as *const u32;
const PWM_DUTY: *mut u32 = 0xF040_0000 as *mut u32;

/// UART transmitter used by the [`print!`] and [`println!`] macros.
pub struct Uart;

impl Uart {
    /// Creates a UART writer.
    ///
    /// The UART has no runtime state; this just gives Rust's formatting code
    /// something that implements [`core::fmt::Write`].
    pub fn new() -> Self {
        Uart
    }
}

impl Write for Uart {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        for b in s.bytes() {
            unsafe {
                while (UART_STATUS.read_volatile() & 0x1) == 0 {}
                UART_DATA.write_volatile(b as u32);
            }
        }
        Ok(())
    }
}

/// Prints formatted text over the memory-mapped UART.
#[macro_export]
macro_rules! print {
    ($($arg:tt)*) => {{
        use core::fmt::Write;
        let _ = $crate::Uart::new().write_fmt(format_args!($($arg)*));
    }};
}

/// Prints formatted text over the memory-mapped UART, followed by a newline.
#[macro_export]
macro_rules! println {
    () => {
        $crate::print!("\n")
    };
    ($($arg:tt)*) => {
        $crate::print!("{}\n", format_args!($($arg)*))
    };
}

/// PMOD connector banks.
///
/// Each bank exposes direction, output, input, debounced input, and PWM-enable
/// registers through methods on this enum.
#[derive(Clone, Copy)]
#[repr(usize)]
pub enum Pmod {
    /// PMOD connector JA.
    JA = 0xF050_0000,
    /// PMOD connector JB.
    JB = 0xF060_0000,
    /// PMOD connector JC.
    JC = 0xF070_0000,
}

impl Pmod {
    /// Sets the pin direction mask for this PMOD bank.
    ///
    /// A `1` bit configures the matching pin as output. A `0` bit configures it
    /// as input.
    pub fn set_dir(self, mask: u8) {
        unsafe {
            (self as usize as *mut u32)
                .offset(0)
                .write_volatile(mask as u32);
        }
    }

    /// Writes the output mask for this PMOD bank.
    pub fn set_out(self, mask: u8) {
        unsafe {
            (self as usize as *mut u32)
                .offset(1)
                .write_volatile(mask as u32);
        }
    }

    /// Reads the raw input pins for this PMOD bank.
    pub fn read_in(self) -> u8 {
        unsafe { (self as usize as *const u32).offset(2).read_volatile() as u8 }
    }

    /// Reads the debounced input pins for this PMOD bank.
    pub fn read_debounced(self) -> u8 {
        unsafe { (self as usize as *const u32).offset(4).read_volatile() as u8 }
    }

    /// Enables PMOD PWM output routing for pins selected by `mask`.
    pub fn set_pwm_en(self, mask: u8) {
        unsafe {
            (self as usize as *mut u32)
                .offset(3)
                .write_volatile(mask as u32);
        }
    }

    /// Returns whether a debounced PMOD input bit is pressed.
    ///
    /// PMOD button inputs are treated as active-low here.
    pub fn button_pressed(self, bit: u8) -> bool {
        if bit >= 8 {
            return false;
        }
        (self.read_debounced() & (1u8 << bit)) == 0
    }
}

/// Writes all 16 onboard LEDs.
///
/// Bit 15 maps to the most significant LED bit and bit 0 maps to the least
/// significant LED bit.
pub fn led_write(val: u16) {
    unsafe {
        LED_REG.write_volatile(val as u32);
    }
}

/// Reads the four onboard buttons as a raw bit mask.
pub fn btn_read() -> u8 {
    unsafe { (BTN_REG.read_volatile() & 0xF) as u8 }
}

/// Reads all four ADC channels.
pub fn adc_read_all() -> [u32; 4] {
    unsafe {
        [
            ADC_BASE.offset(0).read_volatile(),
            ADC_BASE.offset(1).read_volatile(),
            ADC_BASE.offset(2).read_volatile(),
            ADC_BASE.offset(3).read_volatile(),
        ]
    }
}

/// Sets a PWM channel duty cycle in percent.
///
/// Values above 100 are clamped to 100.
pub fn pwm_set_duty(channel: u8, percent: u8) {
    let percent = if percent > 100 { 100 } else { percent };
    let duty = (percent as u32 * 255) / 100;
    unsafe {
        PWM_DUTY.offset((channel as isize) + 1).write_volatile(duty);
    }
}

/// Sets the onboard RGB LED intensity.
///
/// The input values are percentages. Values above 100 are clamped to 100.
pub fn rgb_set(r: u8, g: u8, b: u8) {
    let r = r.min(100);
    let g = g.min(100);
    let b = b.min(100);

    pwm_set_duty(4, 100 - r);
    pwm_set_duty(5, 100 - g);
    pwm_set_duty(6, 100 - b);
}

/// Helpers for the 16 onboard LEDs.
pub mod leds {
    /// Writes all 16 LEDs as a raw bit mask.
    pub fn write(bits: u16) {
        crate::led_write(bits);
    }

    /// Turns all onboard LEDs off.
    pub fn all_off() {
        write(0);
    }

    /// Turns all onboard LEDs on.
    pub fn all_on() {
        write(0xFFFF);
    }

    /// Displays `value` as a bar graph across the 16 onboard LEDs.
    ///
    /// The bar starts at the most significant LED bit. `value == 0` turns all
    /// LEDs off, while `value >= max` turns all LEDs on.
    pub fn write_bar(value: u32, max: u32) {
        if max == 0 {
            write(0);
            return;
        }

        let scaled = value.saturating_mul(16) / max;
        let count = scaled.min(16);

        let bits = if count == 16 {
            u16::MAX
        } else if count == 0 {
            0
        } else {
            (u16::MAX << (16 - count)) as u16
        };

        write(bits);
    }
}

/// Helpers for the four onboard buttons.
pub mod buttons {
    /// Reads the onboard buttons as a raw bit mask.
    pub fn read() -> u8 {
        crate::btn_read()
    }

    /// Returns whether onboard button `index` is currently pressed.
    ///
    /// Valid button indices are `0..=3`. Out-of-range indices return `false`.
    pub fn is_pressed(index: u8) -> bool {
        if index >= 4 {
            return false;
        }

        (read() & (1u8 << index)) != 0
    }
}

/// Helpers for the four ADC channels.
pub mod adc {
    /// Maximum expected ADC sample value for the current 12-bit ADC path.
    pub const MAX_VALUE: u32 = 4095;

    /// Reads all four ADC channels.
    pub fn read_all() -> [u32; 4] {
        crate::adc_read_all()
    }

    /// Reads one ADC channel.
    ///
    /// Returns `None` if `channel` is outside the available range.
    pub fn read(channel: usize) -> Option<u32> {
        read_all().get(channel).copied()
    }
}

/// Busy-wait delay helpers.
pub mod delay {
    /// Delays for roughly `count` CPU cycles using `nop` instructions.
    ///
    /// This is not a precise timer; it is intended for simple demos.
    pub fn cycles(count: u32) {
        for _ in 0..count {
            unsafe { core::arch::asm!("nop") };
        }
    }
}

/// Helpers for the onboard RGB LED.
pub mod rgb {
    /// Sets the onboard RGB LED intensity.
    ///
    /// Each argument is a percentage. Values above 100 are clamped to 100.
    pub fn set(r: u8, g: u8, b: u8) {
        crate::rgb_set(r, g, b);
    }
}
