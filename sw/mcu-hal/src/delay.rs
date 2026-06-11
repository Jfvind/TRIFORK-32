/// Delays for roughly `count` CPU cycles using `nop` instructions.
///
/// This is not a precise timer; it is intended for simple demos.
pub fn cycles(count: u32) {
    for _ in 0..count {
        unsafe { core::arch::asm!("nop") };
    }
}
