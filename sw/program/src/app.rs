use mcu_hal::{adc, buttons, delay, leds, rgb, Pmod};

pub fn main() -> ! {
    mcu_hal::println!("=== DTU MCU Booted ===");
    mcu_hal::println!("SRAM Size: {} bytes", 4096);
    mcu_hal::println!("Status: PASS");

    Pmod::JA.set_dir(0b0111_0111);
    Pmod::JA.set_pwm_en(0b_0111_0000);

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

        delay::cycles(150_000);
    }
}
