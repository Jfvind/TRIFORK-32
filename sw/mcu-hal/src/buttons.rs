use crate::mmio::BTN_REG;

/// Reads the four onboard buttons as a raw bit mask.
pub fn read() -> u8 {
    unsafe { (BTN_REG.read_volatile() & 0xF) as u8 }
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
