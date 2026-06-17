use trifork32_hal::{adc, buttons, delay, i2c, leds, rgb, Pmod};

pub fn main() -> ! {
    trifork32_hal::println!("=== TRIFORK-32 Booted ===");
    trifork32_hal::println!("SRAM Size: {} bytes", 16384);
    trifork32_hal::println!("Status: PASS");

    Pmod::JA.set_dir(0b0111_0111);
    Pmod::JA.set_pwm_en(0b_0111_0000);

    // Configure I2C bus to 100 kHz (standard mode).
    i2c::set_clkdiv(500);

    // Sanity check: probe a nonexistent address (0x42). A correct
    // controller must report NACK; an ACK here means NACK detection is
    // broken and all later results are suspect.
    i2c::start();
    let fake_acked = i2c::write_byte((0x42 << 1) | 0);
    i2c::stop();
    if fake_acked {
        trifork32_hal::println!("NACK detection: FAIL (got ACK from nonexistent 0x42)");
    } else {
        trifork32_hal::println!("NACK detection: PASS");
    }

    // AM2320 read scheduling: the sensor must not be polled more often than
    // ~once per 2 s. Scheduled with the cycle counter (100_000_000 cycles =
    // 1 s at 100 MHz) so the interval is independent of loop iteration cost.
    const AM2320_READ_INTERVAL_CYCLES: u64 = 200_000_000; // 2 s
    let mut next_am2320_read: u64 = delay::read_cycles() + AM2320_READ_INTERVAL_CYCLES;

    let mut fade: u8 = 0;
    let mut fade_up = true;
    let mut color_phase: u8 = 0;

    loop {
        let adc0 = adc::read(0).unwrap_or(0); //unwrap_or is needed as reading might throw an error.
        let btn_val = buttons::read();

        leds::write_bar(adc0, adc::MAX_VALUE);

        Pmod::JA.set_out(btn_val);

        match color_phase {
            0 => rgb::set(fade, 0, 0),
            1 => rgb::set(0, fade, 0),
            _ => rgb::set(0, 0, fade),
        }

        if fade_up {
            if fade >= 100 {
                fade_up = false;
            } else {
                fade += 1;
            }
        } else if fade == 0 {
            fade_up = true;
            color_phase = (color_phase + 1) % 3;
        } else {
            fade -= 1;
        }

        // AM2320 temperature/humidity read every ~2 seconds (cycle-timed).
        if delay::read_cycles() >= next_am2320_read {
            next_am2320_read = delay::read_cycles() + AM2320_READ_INTERVAL_CYCLES;

            // Wake-up via clock divider trick: at ~10 kHz the wake address
            // byte holds SDA low for ~900 us, satisfying the AM2320's
            // >=800 us wake requirement without dedicated hardware support.
            i2c::wait_idle();
            i2c::set_clkdiv(5000);
            i2c::start();
            let _ = i2c::write_byte((0x5C << 1) | 0); // NACK expected
            i2c::stop();

            // Back to 100 kHz for the real transaction.
            i2c::wait_idle();
            i2c::set_clkdiv(500);
            delay::cycles_precise(200_000); // 2 ms settle

            // Modbus read: function 0x03, start reg 0x00, length 4
            // (humidity regs 0-1, temperature regs 2-3).
            let cmd = [0x03u8, 0x00, 0x04];
            if i2c::write_bytes(0x5C, &cmd) {
                delay::cycles_precise(500_000); // 5 ms for sensor to prepare

                // Response: [0]=0x03 [1]=0x04 [2-3]=hum [4-5]=temp [6-7]=CRC
                let mut response = [0u8; 8];
                let read_ok = i2c::read_bytes(0x5C, &mut response);

                if read_ok && response[0] == 0x03 && response[1] == 0x04 {
                    let humidity = ((response[2] as u16) << 8) | (response[3] as u16);
                    let temperature = (((response[4] as u16) << 8) | (response[5] as u16)) as i16;
                    let temp_int = temperature / 10;
                    let temp_frac = (temperature % 10).abs();
                    let hum_int = humidity / 10;
                    let hum_frac = humidity % 10;
                    trifork32_hal::println!(
                        "AM2320: {}.{} C, {}.{} %RH",
                        temp_int,
                        temp_frac,
                        hum_int,
                        hum_frac
                    );
                } else {
                    trifork32_hal::println!("AM2320: read failed");
                }
            } else {
                trifork32_hal::println!("AM2320: command failed (no ACK)");
            }
        }

        delay::cycles(150_000);
    }
}
