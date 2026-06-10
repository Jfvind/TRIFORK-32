#![no_std]
#![no_main]

use mcu_rt as _;

mod app;

#[no_mangle]
pub extern "C" fn __mcu_app_main() -> ! {
    app::main()
}
