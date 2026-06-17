//! Hardware abstraction layer for TRIFORK-32.
//!
//! This crate exposes small, student-facing helpers for the memory-mapped
//! peripherals in the SoC. Student applications should normally use the module
//! APIs: [`adc`], [`buttons`], [`leds`], [`rgb`], [`delay`], and [`Pmod`].
//!
//! The older root-level helper names such as [`led_write`], [`btn_read`],
//! [`adc_read_all`], [`pwm_set_duty`], and [`rgb_set`] are still available as
//! compatibility aliases, but the module APIs are preferred for new code.
//! Low-level MMIO addresses are kept in private/internal modules so application
//! code does not need to use raw pointers.
//!
//! ```rust,no_run
//! use trifork32_hal::{adc, buttons, delay, leds, rgb, Pmod};
//!
//! let adc0 = adc::read(0).unwrap_or(0);
//! leds::write_bar(adc0, adc::MAX_VALUE);
//! Pmod::JA.set_out(buttons::read());
//! rgb::set(50, 0, 0);
//! delay::cycles(150_000);
//! ```

#![no_std]

mod legacy;
mod mmio;

pub mod adc;
pub mod buttons;
pub mod delay;
pub mod i2c;
pub mod leds;
pub mod pmod;
pub mod pwm;
pub mod rgb;
pub mod uart;

pub use legacy::{adc_read_all, btn_read, led_write, pwm_set_duty, rgb_set};
pub use pmod::Pmod;
pub use uart::Uart;
