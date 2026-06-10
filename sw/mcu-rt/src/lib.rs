#![no_std]

use core::arch::global_asm;
use core::panic::PanicInfo;

extern "C" {
    static mut __bss_start: u32;
    static mut __bss_end: u32;

    fn __mcu_app_main() -> !;
}

global_asm!(
    ".section .text._start",
    ".global _start",
    "_start:",
    "la sp, _stack_top",
    "j rust_entry"
);

#[no_mangle]
pub unsafe extern "C" fn rust_entry() -> ! {
    let mut bss_ptr = core::ptr::addr_of_mut!(__bss_start);
    let bss_end = core::ptr::addr_of_mut!(__bss_end);

    while bss_ptr < bss_end {
        core::ptr::write_volatile(bss_ptr, 0);
        bss_ptr = bss_ptr.offset(1);
    }

    __mcu_app_main()
}

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    mcu_hal::println!("\n[CPU PANIC]: {}", info);
    loop {}
}
