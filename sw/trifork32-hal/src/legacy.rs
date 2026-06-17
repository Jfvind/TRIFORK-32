//! Compatibility aliases for the original root-level HAL helpers.

pub use crate::adc::read_all as adc_read_all;
pub use crate::buttons::read as btn_read;
pub use crate::leds::write as led_write;
pub use crate::pwm::set_duty as pwm_set_duty;
pub use crate::rgb::set as rgb_set;
