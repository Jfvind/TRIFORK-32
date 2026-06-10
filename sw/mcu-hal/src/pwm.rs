use crate::mmio::PWM_DUTY;

/// Sets a PWM channel duty cycle in percent.
///
/// Values above 100 are clamped to 100.
pub fn set_duty(channel: u8, percent: u8) {
    let percent = percent.min(100);
    let duty = (percent as u32 * 255) / 100;

    unsafe {
        PWM_DUTY.offset((channel as isize) + 1).write_volatile(duty);
    }
}
