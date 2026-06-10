//! Hardware abstraction layer for the DTU FPGA MCU, TRIFORK-32.
//!
//! This crate exposes small, student-facing helpers for the memory-mapped
//! peripherals in the SoC. The low-level root functions are kept as
//! compatibility aliases, while modules such as [`leds`], [`buttons`], [`adc`],
//! [`delay`], and [`rgb`] provide the preferred application API.

#![no_std]

mod legacy;
mod mmio;

pub mod adc;
pub mod buttons;
pub mod delay;
pub mod leds;
pub mod pmod;
pub mod pwm;
pub mod rgb;
pub mod uart;

pub use legacy::{adc_read_all, btn_read, led_write, pwm_set_duty, rgb_set};
pub use pmod::Pmod;
pub use uart::Uart;
