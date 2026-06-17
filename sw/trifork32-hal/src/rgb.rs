//! Helpers for RGB LEDs driven through PWM channels.

use crate::pwm;

/// Sets the onboard RGB LED intensity.
///
/// Each argument is a percentage. Values above 100 are clamped to 100.
pub fn set(r: u8, g: u8, b: u8) {
    let r = r.min(100);
    let g = g.min(100);
    let b = b.min(100);

    pwm::set_duty(4, 100 - r);
    pwm::set_duty(5, 100 - g);
    pwm::set_duty(6, 100 - b);
}
