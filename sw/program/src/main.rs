#![no_std]
#![no_main]

use trifork32_rt as _;

mod app;

#[no_mangle]
pub extern "C" fn __trifork32_app_main() -> ! {
    app::main()
}
