use crate::mmio::{PMOD_JA_BASE, PMOD_JB_BASE, PMOD_JC_BASE};

/// PMOD connector banks.
///
/// Each bank exposes direction, output, input, debounced input, and PWM-enable
/// registers through methods on this enum.
#[derive(Clone, Copy)]
#[repr(usize)]
pub enum Pmod {
    /// PMOD connector JA.
    JA = PMOD_JA_BASE,
    /// PMOD connector JB.
    JB = PMOD_JB_BASE,
    /// PMOD connector JC.
    JC = PMOD_JC_BASE,
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
