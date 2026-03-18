#![no_std]
#![no_main]

use core::arch::global_asm;
use core::panic::PanicInfo;

// 1. HARDWARE ENTRY POINT (ASSEMBLY)
// FPGA turns on and the CPU starts, and the first code that runs is this assembly section.
// It sets up the stack pointer so we can safely run Rust functions.
global_asm!(
    ".section .init",
    ".global _start",
    "_start:",
    "la sp, _stack_start",  //load stack adress from linker script
    "j rust_entry"          // jump to rust entry point -> skipping any C runtime setup, as we dont use it
);

// 2. IMPORT SYMBOLS FROM LINKER SCRIPT
extern "C" {
    static mut _sbss: u32;
    static mut _ebss: u32;
    static mut _sdata: u32;
    static mut _edata: u32;
    static _sidata: u32;
}

// 3. RUST ENTRY POINT (MEMORY SETUP)
#[no_mangle]
pub unsafe extern "C" fn rust_entry() -> ! {
    // restart .bss section to 0, as it may contain random data from the FPGA's SRAM on power-up
    let mut bss_ptr = core::ptr::addr_of_mut!(_sbss);
    let bss_end = core::ptr::addr_of_mut!(_ebss);
    while bss_ptr < bss_end {
        core::ptr::write_volatile(bss_ptr, 0);
        bss_ptr = bss_ptr.offset(1);
    }
    //copy .data section from ROM to RAM, as it may contain random data from the FPGA's SRAM on power-up
    let mut data_ptr = core::ptr::addr_of_mut!(_sdata);
    let data_end = core::ptr::addr_of_mut!(_edata);
    let mut sidata_ptr = core::ptr::addr_of!(_sidata);
    while data_ptr < data_end {
        let value = core::ptr::read_volatile(sidata_ptr);
        core::ptr::write_volatile(data_ptr, value);
        data_ptr = data_ptr.offset(1);
        sidata_ptr = sidata_ptr.offset(1);
    }

    // jmp to app
    main();

    // Fallback if main thows an error or returns, which it shouldn't, but just in case, we don't want to run off into the void.
    loop {}
}

// 4. APPLICATION ENTRY POINT
fn main() {
    // TODO:  UART, læs knapper, tænd LEDs.

    loop {
        // Main loop
    }
}

// 5. PANIC HANDLER required by Rust, called when a panic occurs (e.g. unwrap on None, out of bounds access, etc.)
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    //TODO: Indtil vi har UART print klar, fryser vi bare systemet ved fejl.
    loop {}
}