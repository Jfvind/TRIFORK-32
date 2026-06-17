//! Busy-wait delay helpers for simple demos.

/// Delays for roughly `count` CPU cycles using `nop` instructions.
///
/// This is not a precise timer; it is intended for simple demos.
pub fn cycles(count: u32) {
    for _ in 0..count {
        unsafe { core::arch::asm!("nop") };
    }
}

/// Reads the 64-bit CPU cycle counter (rdcycle/rdcycleh CSRs).
///
/// At 100 MHz: 100 cycles = 1 microsecond, 100_000 cycles = 1 millisecond.
pub fn read_cycles() -> u64 {
    let lo: u32;
    let hi: u32;
    unsafe {
        core::arch::asm!("rdcycle {0}", out(reg) lo);
        core::arch::asm!("rdcycleh {0}", out(reg) hi);
    }
    ((hi as u64) << 32) | (lo as u64)
}

/// Delays for exactly `count` CPU cycles using the cycle counter.
///
/// Unlike [`cycles`], this is precise regardless of pipeline behaviour.
/// Required for protocol timing (e.g. I2C sensor delays).
pub fn cycles_precise(count: u64) {
    let start = read_cycles();
    while read_cycles().wrapping_sub(start) < count {}
}
