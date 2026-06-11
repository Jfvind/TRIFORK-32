use crate::mmio::LED_REG;

/// Writes all 16 LEDs as a raw bit mask.
///
/// Bit 15 maps to the most significant LED bit and bit 0 maps to the least
/// significant LED bit.
pub fn write(bits: u16) {
    unsafe {
        LED_REG.write_volatile(bits as u32);
    }
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
/// The bar starts at the most significant LED bit. `value == 0` turns all LEDs
/// off, while `value >= max` turns all LEDs on.
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
        u16::MAX << (16 - count)
    };

    write(bits);
}
