//! ADC helpers for the four analog input channels.

use crate::mmio::ADC_BASE;

/// Maximum expected ADC sample value for the current 12-bit ADC path.
pub const MAX_VALUE: u32 = 4095;

/// Reads all four ADC channels.
pub fn read_all() -> [u32; 4] {
    unsafe {
        [
            ADC_BASE.offset(0).read_volatile(),
            ADC_BASE.offset(1).read_volatile(),
            ADC_BASE.offset(2).read_volatile(),
            ADC_BASE.offset(3).read_volatile(),
        ]
    }
}

/// Reads one ADC channel.
///
/// Returns `None` if `channel` is outside the available range.
pub fn read(channel: usize) -> Option<u32> {
    read_all().get(channel).copied()
}
