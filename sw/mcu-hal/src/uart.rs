//! UART formatting support and print macros.

use core::fmt::{self, Write};

use crate::mmio::{UART_DATA, UART_STATUS};

/// UART transmitter used by the `print!` and `println!` macros.
pub struct Uart;

impl Uart {
    /// Creates a UART writer.
    ///
    /// The UART has no runtime state; this just gives Rust's formatting code
    /// something that implements [`core::fmt::Write`].
    pub fn new() -> Self {
        Uart
    }
}

impl Write for Uart {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        for b in s.bytes() {
            unsafe {
                while (UART_STATUS.read_volatile() & 0x1) == 0 {}
                UART_DATA.write_volatile(b as u32);
            }
        }
        Ok(())
    }
}

/// Prints formatted text over the memory-mapped UART.
#[macro_export]
macro_rules! print {
    ($($arg:tt)*) => {{
        use core::fmt::Write;
        let _ = $crate::Uart::new().write_fmt(format_args!($($arg)*));
    }};
}

/// Prints formatted text over the memory-mapped UART, followed by a newline.
#[macro_export]
macro_rules! println {
    () => {
        $crate::print!("\n")
    };
    ($($arg:tt)*) => {
        $crate::print!("{}\n", format_args!($($arg)*))
    };
}
