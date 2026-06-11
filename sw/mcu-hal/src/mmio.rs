pub(crate) const UART_STATUS: *const u32 = 0xF000_0000 as *const u32;
pub(crate) const UART_DATA: *mut u32 = 0xF000_0004 as *mut u32;

pub(crate) const LED_REG: *mut u32 = 0xF010_0000 as *mut u32;
pub(crate) const BTN_REG: *const u32 = 0xF020_0000 as *const u32;
pub(crate) const ADC_BASE: *const u32 = 0xF030_0000 as *const u32;
pub(crate) const PWM_DUTY: *mut u32 = 0xF040_0000 as *mut u32;

pub(crate) const PMOD_JA_BASE: usize = 0xF050_0000;
pub(crate) const PMOD_JB_BASE: usize = 0xF060_0000;
pub(crate) const PMOD_JC_BASE: usize = 0xF070_0000;
