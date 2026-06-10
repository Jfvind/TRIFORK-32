#![no_std]
#![no_main]

use core::arch::global_asm; // to write assembly for the boot sequence
use core::fmt::{self, Write}; // for implementing our own print macros
use core::panic::PanicInfo; // for our custom panic handler

// ── 1. Hardware-adresser (Memory Mapped I/O) ────────────────────────────────
const UART_STATUS: *const u32 = 0xF000_0000 as *const u32;
const UART_DATA:   *mut u32   = 0xF000_0004 as *mut u32;
const LED_REG:     *mut u32   = 0xF010_0000 as *mut u32;
const BTN_REG:     *const u32 = 0xF020_0000 as *const u32;
const ADC_BASE:    *const u32 = 0xF030_0000 as *const u32;
const PWM_DUTY:    *mut u32   = 0xF040_0000 as *mut u32;

// ── 2. Linker symboler (Fra linker.ld) ──────────────────────────────────────
extern "C" {
    static mut __bss_start: u32;
    static mut __bss_end: u32;
}

// ── 3. Boot sekvens (Assembly) ──────────────────────────────────────────────
global_asm!(
    ".section .text._start",
    ".global _start",
    "_start:",
    "la sp, _stack_top",    // stack pointer defined in linker script
    "j rust_entry"          //jump to rust entry point
);

// ── 4. Boot sekvens (Rust) ──────────────────────────────────────────────────
#[no_mangle]
pub unsafe extern "C" fn rust_entry() -> ! { // our entry point after assembly setup
    // Zero BSS segment to ensure all static variables start at 0 -> SRAM NOISE
    let mut bss_ptr = core::ptr::addr_of_mut!(__bss_start);
    let bss_end = core::ptr::addr_of_mut!(__bss_end);
    
    while bss_ptr < bss_end {
        core::ptr::write_volatile(bss_ptr, 0); // zero out BSS
        bss_ptr = bss_ptr.offset(1); // move to next word
    }

    main();

    // Catch-all if main returns, which it shouldn't. Indicates something went wrong.
    loop {}
}

// ── 5. HAL: Hardware Abstraction Layer (UART) ───────────────────────────────
pub struct Uart;

impl Uart {
    pub fn new() -> Self {
        Uart
    }
}

// Implement Rust standard library's Write trait for our UART, so we can use it with our print macros
impl Write for Uart {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        for b in s.bytes() {
            unsafe {
                // wait until UART is ready to send  | status bit 0 == 1 |
                while (UART_STATUS.read_volatile() & 0x1) == 0 {}
                // Send byte
                UART_DATA.write_volatile(b as u32);
            }
        }
        Ok(())
    }
}

// ── 6. HAL: Macros ─────────────────────────────────────────────────────────
#[macro_export]
macro_rules! print { // This macro allows us to use print! and println! like in standard Rust, but it sends output to our UART
    ($($arg:tt)*) => { // format_args!($($arg)*) allows us to use the same formatting syntax as standard Rust
        #[allow(unused_unsafe)]
        unsafe { // Create a new UART instance and write the formatted string to it
            use core::fmt::Write;
            let _ = $crate::Uart::new().write_fmt(format_args!($($arg)*));
        }
    };
}

#[macro_export]
macro_rules! println {
    () => ($crate::print!("\n"));
    ($($arg:tt)*) => ($crate::print!("{}\n", format_args!($($arg)*)));
}

// ── 7. HAL: GPIOs ─────────────────────────────────────────────────────
#[derive(Clone, Copy)]
#[repr(usize)]
pub enum Pmod {
    JA = 0xF050_0000,
    JB = 0xF060_0000,
    JC = 0xF070_0000,
}

// offsets: 0=DIR, 4=OUT, 8=IN, 12=PWM_EN, 16=IN_DEBOUNCED
impl Pmod {
    pub fn set_dir(self, mask: u8) {
        unsafe { (self as usize as *mut u32).offset(0).write_volatile(mask as u32); }
    }
    pub fn set_out(self, mask: u8) {
        unsafe { (self as usize as *mut u32).offset(1).write_volatile(mask as u32); }
    }
    pub fn read_in(self) -> u8 {
        unsafe { (self as usize as *const u32).offset(2).read_volatile() as u8 }
    }
    pub fn read_debounced(self) -> u8 {
        unsafe { (self as usize as *const u32).offset(4).read_volatile() as u8 }
    }
    pub fn set_pwm_en(self, mask: u8) {
        unsafe { (self as usize as *mut u32).offset(3).write_volatile(mask as u32); }
    }
    pub fn button_pressed(self, bit: u8) -> bool {
        if bit >= 8 {
            return false;
        }
        (self.read_debounced() & (1u8 << bit)) == 0
    }
}

// ── 8. HAL: LED helper + BTN helper + ADC helper ─────────────────────────────────────────────────────
fn led_write(val: u8) { // LED = 1 on, LED = 0 off, bitmask for 8 LEDs
    unsafe {
        LED_REG.write_volatile(val as u32);
    }
}

fn btn_read() -> u8 {
    unsafe {
        (BTN_REG.read_volatile() & 0xF) as u8 // only four lowest bits
    }
}

fn adc_read_all() -> [u32; 4] {
    unsafe {
        [
            ADC_BASE.offset(0).read_volatile(), // 0xF030_0000
            ADC_BASE.offset(1).read_volatile(), // 0xF030_0004
            ADC_BASE.offset(2).read_volatile(), // 0xF030_0008
            ADC_BASE.offset(3).read_volatile()  // 0xF030_000C
        ]
    }
}

// Sets the brightness of a PWM enabled LED.
// 'channel' : GPIO number (0 - 24). (JA = 0-7) (JB = 8-15) (JC = 16-23)
// 'percent' : brightness from 0 (off) to 100 (full)
fn pwm_set_duty(channel: u8, percent: u8) {
    let percent = if percent > 100 { 100 } else { percent };
    let duty = (percent as u32 * 255) / 100;
    unsafe {
        PWM_DUTY.offset((channel as isize) + 1).write_volatile(duty);
    }
}

fn rgb_set(r: u8, g: u8, b: u8) {
    // Common-anode RGB: lower duty means brighter, so invert brightness.
    pwm_set_duty(4, 100 - r); // JA7
    pwm_set_duty(5, 100 - g); // JA8
    pwm_set_duty(6, 100 - b); // JA9
}

// ── 9. HAL: I2C ────────────────────────────────────────────────────────
// I2C controller MMIO-adresses --> matches chisel def in I2cController.scala
// & MMIO decoder in RustSoCTop.scala (modSel = 8, base 0xF080_000).
const I2C_CMD:    *mut u32   = 0xF080_0000 as *mut u32;
const I2C_DATA:   *mut u32   = 0xF080_0004 as *mut u32;
const I2C_STATUS: *const u32 = 0xF080_0008 as *const u32;
const I2C_CLKDIV: *mut u32   = 0xF080_000C as *mut u32;

// Commando-codes which can be written to I2C_CMD: matches the object I2c_Cmd
const I2C_CMD_START:     u32 = 0x01;
const I2C_CMD_STOP:      u32 = 0x02;
const I2C_CMD_WRITE:     u32 = 0x04;
const I2C_CMD_READ_ACK:  u32 = 0x08;
const I2C_CMD_READ_NACK: u32 = 0x10;

// Status bits read from I2C_STATUS: matches object I2cStatus 
const I2C_STATUS_BUSY:    u32 = 1 << 0;
const I2C_STATUS_NACK:    u32 = 1 << 1;
const I2C_STATUS_BUS_ERR: u32 = 1 << 2;

// Read a 64-bit cycle counter from CSR (rdcycle + rdcycleh).
// Used for precise timing delays.
fn read_cycles() -> u64 {
    let lo: u32;
    let hi: u32;
    unsafe {
        // rdcycle = csrrs rd, cycle, x0 (CSR-address 0xC00)
        // rdcycleh = csrrs rd, cycleh, c0 (CSR-address 0xC80)
        core::arch::asm!("rdcycle {0}", out(reg) lo);
        core::arch::asm!("rdcycleh {0}", out(reg) hi);
    }
    ((hi as u64) << 32) | (lo as u64)
}

// Dealy for 'cycles' clock cycles: (At 100 MHz) --> 100 cycles = 1 µs, 100_000 cycles = 1 ms.
fn delay_cycles(cycles: u64) {
    let start = read_cycles();
    while read_cycles().wrapping_sub(start) < cycles {}
}

// Configurable SCL-frequency by writing to the clock divider directly.
// 0 = deafault (100 kHz). Other values: divider = systemClockHz / (i2cHz * 2)
// Examples at 100 kHz system clock:
//      500 -> 100 kHz (standard mode)
//      125 -> 400 kHz (fast mode)
fn i2c_set_clkdiv(divider: u16) {
    unsafe { I2C_CLKDIV.write_volatile(divider as u32); }
}

// Wait untill the controller is no longer busy executing a commando.
fn i2c_wait_idle() {
    unsafe {
        while (I2C_STATUS.read_volatile() & I2C_STATUS_BUSY) != 0 {}
    }
}

/// Read raw status register. Useful for debugging - shows BUSY/NACK/BUS_ERR bits.
fn i2c_status() -> u32 {
    unsafe { I2C_STATUS.read_volatile() }
}

// Generate START condition on the BUS. Needs to be called at the start of every transaction.
fn i2c_start() {
    unsafe { I2C_CMD.write_volatile(I2C_CMD_START); }
    i2c_wait_idle();
}

// Generate STOP condition on the BUS. Needs to be called at the end of each transaction to release the BUS.
fn i2c_stop() {
    unsafe { I2C_CMD.write_volatile(I2C_CMD_STOP); }
    i2c_wait_idle();
}

// Send one byte: returns true if the slave responded with ACK, false if NACK.
// To send a slave-adress: byte = (addr << 1) | rw_bit, where rw=0 for write, 1 for read.
fn i2c_write_byte(byte: u8) -> bool {
    unsafe { 
        I2C_DATA.write_volatile(byte as u32);
        I2C_CMD.write_volatile(I2C_CMD_WRITE);
    }
    i2c_wait_idle();
    let nack = unsafe { (I2C_STATUS.read_volatile() & I2C_STATUS_NACK) != 0 };
    !nack
}

// Receive one byte. If send_ack=true, the master signals "send me more bytes".
// If false, the master signals "This was the last byte" (NACK).
fn i2c_read_byte(send_ack: bool) -> u8 {
    let cmd = if send_ack { I2C_CMD_READ_ACK } else { I2C_CMD_READ_NACK };
    unsafe { 
        I2C_CMD.write_volatile(cmd);
    }
    i2c_wait_idle();
    unsafe { I2C_DATA.read_volatile() as u8 }
}

// Write a whole buffer to a slave on the 7-bit adress 'addr'.
// Returns true if the whole transaction was ACK(nowledged).
// Sequence: START --> adress+W --> data pushed out on SDA --> STOP
fn i2c_write_bytes(addr: u8, data: &[u8]) -> bool {
    i2c_start();
    if !i2c_write_byte((addr << 1) | 0) {
        i2c_stop();
        return false;
    }
    for &b in data {
        if !i2c_write_byte(b) {
            i2c_stop();
            return false;
        }
    }
    i2c_stop();
    true
}

// Read a whole buffer from a slave on a 7-bit adress 'addr'.
// Return true if the adress+R was ack'et og the bytes was received.
// Sequence: START --> adress+R --> read byte (ack on all bytes but the last) --> STOP.
fn i2c_read_bytes(addr: u8, buf: &mut [u8]) -> bool {
    if buf.is_empty() {
        return true;
    }
    i2c_start();
    if !i2c_write_byte((addr << 1) | 1) {
        i2c_stop();
        return false;
    }
    // Wait at least 30 microseconds after the address byte before clocking
    // the first data bit. Required by AM2320-class slaves that need time
    // to prepare data after acknowledging their address. Standard slaves
    // would clock-stretch instead, but some quirky chips do not.
    // 5000 cycles at 100 MHz = 50 microseconds, comfortably above the minimum.
    delay_cycles(5_000);
    let last = buf.len() - 1;
    for i in 0..buf.len() {
        let send_ack = i != last;
        buf[i] = i2c_read_byte(send_ack);
    }
    i2c_stop();
    true
}

// Write-then-read on the same transaction: the classic "read sensor-register" pattern.
// Sequence: START --> Adress+W --> write_data... --> REPEATED START --> Adress+R --> Read byte --> STOP.
// Used foir chips where you select a register-number first and the read it's contents.
fn i2c_write_read(addr: u8, write_data: &[u8], read_buf: &mut [u8]) -> bool {
    i2c_start();
    if !i2c_write_byte((addr << 1) | 0) {
        i2c_stop();
        return false;
    }
    for &b in write_data {
        if !i2c_write_byte(b) {
            i2c_stop();
            return false;
        }
    }
    // Repeated START - new START without STOP first
    i2c_start();
    if !i2c_write_byte((addr << 1) | 1) {
        i2c_stop();
        return false;
    }
    // Wait at least 30 microseconds after the read address byte. See
    // i2c_read_bytes for full explanation.
    delay_cycles(5_000);
    if !read_buf.is_empty() {
        let last = read_buf.len() - 1;
        for i in 0..read_buf.len() {
            let send_ack = i != last;
            read_buf[i] = i2c_read_byte(send_ack);
        }
    }
    i2c_stop();
    true
}

// Scan the bus to find connected devices.
// Sends START --> Adress+W to each possible 7-bit adress (0x08-0x77) og looks if any corresponding devices respond with a ACK.
// 'found' is filled with the adresses that answered; returns the amount of devices found.
fn i2c_scan(found: &mut [u8]) -> usize {
    let mut count = 0;
    for addr in 0x08u8..=0x77 {
        i2c_start();
        let acked = i2c_write_byte((addr << 1) | 0);
        i2c_stop();
        if acked && count < found.len() {
            found[count] = addr;
            count += 1;
        }
    }
    count
}  


// ── 10. APP ────────────────────────────────────────────────────────
fn main() {
    
    // Use safe HAL for writing to UART
    println!("=== DTU MCU Booted ===");
    println!("SRAM Size: {} bytes", 4096);
    println!("Status: PASS");

    // Configure I2C bus to 100 kHz (standard mode)
    i2c_set_clkdiv(500);

    // Sanity check: NACK detection.
    // Send a WRITE to address 0x42 (no slave should exist there). If our
    // controller correctly detects the missing ACK, we should get false.
    // If we get true, something is wrong with our controller and any
    // subsequent results are suspect.
    i2c_start();
    let fake_acked = i2c_write_byte((0x42 << 1) | 0);
    i2c_stop();
    if fake_acked {
        println!("NACK detection: FAIL (got ACK from nonexistent 0x42)");
    } else {
        println!("NACK detection: PASS");
    }

    // set JA LEDs as output
    Pmod::JA.set_dir(0b0111_0111);

    // Enable PWM on RGB LED pins
    Pmod::JA.set_pwm_en(0b_0111_0000);

    // Simple PWM fade state for RGB test.
    let mut fade: u8 = 0;
    let mut fade_up = true;
    let mut color_phase: u8 = 0; // 0 = red, 1 = green, 2 = blue

    // AM2320 read-throttle counter. Sensor must not be polled more
    // often than -once per 2 seconds, so we only read every Nth loop.
    let mut am2320_counter: u32 = 0;
    const AM2320_INTERVAL: u32 = 1000;

    loop {
        // 1) Read peripherals
        let adc_val = adc_read_all(); // Returns 0 to 4095 for all four inputs
        let btn_val = btn_read(); // Use buttons 0..2 for io_led[8..10]

        // 2) ADC bargraph on io_led[0..6] using direct thresholds.
        let mut adc_leds: u8 = 0;
        if adc_val[0] > 512  { adc_leds |= 0b0000001; }
        if adc_val[0] > 1024 { adc_leds |= 0b0000011; }
        if adc_val[0] > 1536 { adc_leds |= 0b0000111; }
        if adc_val[0] > 2048 { adc_leds |= 0b0001111; }
        if adc_val[0] > 2560 { adc_leds |= 0b0011111; }
        if adc_val[0] > 3072 { adc_leds |= 0b0111111; }
        if adc_val[0] > 3584 { adc_leds |= 0b1111111; }
        led_write(adc_leds);

        // 3) Button mirror on JA[1..3].
        Pmod::JA.set_out(btn_val);

        // 4) RGB PWM fade test on JA[7..9].
        // Fade red, then green, then blue, one channel at a time.
        match color_phase {
            0 => rgb_set(fade, 0, 0),
            1 => rgb_set(0, fade, 0),
            _ => rgb_set(0, 0, fade),
        }

        if fade_up {
            if fade >= 100 {
                fade_up = false;
            } else {
                fade += 1;
            }
        } else {
            if fade == 0 {
                fade_up = true;
                color_phase = (color_phase + 1) % 3;
            } else {
                fade -= 1;
            }
        }

        // 5) AM2320 temperature/humidity read every AM2320_INTERVAL iterations
        am2320_counter += 1;
        if am2320_counter >= AM2320_INTERVAL {
            am2320_counter = 0;

            println!("--- AM2320 read ---");

            // Wake-up via clock divider trick. Lower the I2C clock to ~10 kHz
            // so the wake address byte takes ~900 microseconds on the bus.
            // The AM2320 datasheet requires SDA to be held low for at least
            // 800 microseconds during the wake transaction; this satisfies
            // that requirement without needing a dedicated hardware state.
            i2c_wait_idle();
            i2c_set_clkdiv(5000);

            i2c_start();
            let wake_acked = i2c_write_byte((0x5C << 1) | 0);
            i2c_stop();
            println!("Wake ACK: {} (expected: false)", wake_acked);

            // Restore standard 100 kHz for the actual read transaction.
            i2c_wait_idle();
            i2c_set_clkdiv(500);

            // Small delay before next transaction to let the sensor settle.
            delay_cycles(200_000); // 2 ms

            // Send Modbus read command: function 0x03, start register 0x00, length 4.
            // This requests humidity (regs 0-1) and temperature (regs 2-3).
            let cmd = [0x03u8, 0x00, 0x04];
            let cmd_ok = i2c_write_bytes(0x5C, &cmd);
            println!("Cmd ACK: {} (expected: true)", cmd_ok);            

            if cmd_ok {
                // Wait at least 1.5 ms for the sensor to prepare its reply.
                delay_cycles(500_000); // 5 ms

                // Read 8-byte response:
                // [0]=0x03 [1]=0x04 [2-3]=humidity [4-5]=temperature [6-7]=CRC
                let mut response = [0u8; 8];
                let read_ok = i2c_read_bytes(0x5C, &mut response);

                if read_ok && response[0] == 0x03 && response[1] == 0x04 {
                    // Combine MSB and LSB into 16-bit values.
                    let humidity = ((response[2] as u16) << 8) | (response[3] as u16);
                    let temperature = (((response[4] as u16) << 8) | (response[5] as u16)) as i16;

                    // Values are in tenths: 234 means 23.4 C.
                    let temp_int = temperature / 10;
                    let temp_frac = (temperature % 10).abs();
                    let hum_int = humidity / 10;
                    let hum_frac = humidity % 10;

                    println!("AM2320: {}.{} C, {}.{} %RH", temp_int, temp_frac, hum_int, hum_frac);
                } else {
                    println!("AM2320: read failed");
                }
            } else {
                println!("AM2320: command failed (no ACK)");
            }
        }

        // 6) Small delay to set animation speed.
        for _ in 0..150_000 {
            unsafe { core::arch::asm!("nop"); }
        }
    }
}

// ── 11. Panic Handler ────────────────────────────────────────────────────────
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    // freeze the system and print panic info to UART
    println!("\n[CPU PANIC]: {}", info);
    loop {}
}
