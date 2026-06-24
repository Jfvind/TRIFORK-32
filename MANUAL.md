# Manual: TRIFORK-32 - RISC-V MCU for embedded systems programming 02112 at DTU
![TRIFORK](docs/diagrams/trifork.png)
## Introduction - what the system is and can do
TRIFORK-32 is an MCU (Microcontroller Unit) that, by implementing a softcore (Wildcat) 3-stage pipelined RISC-V processor on a Digilent Basys 3 Artix-7 FPGA, lets you program that same processor and its peripherals in Rust.
Peripherals such as LEDs, buttons, UART, analog input (ADC), I2C, and the bidirectional PMOD ports (JA/JB/JC) are accessed through predefined Memory-Mapped I/O. To simplify the system, an accompanying abstraction layer has been built on top of this Memory-Mapped I/O, providing ready-made helper functions that make programming it easier.

With this MCU you can control LEDs, read buttons, dim outputs with PWM (e.g. an RGB LED), read analog signals via the ADC, communicate with external sensors over I2C, and send data over serial communication (UART) - all from Rust programs you write yourself and upload to the board.

This manual guides you through setting up the system, explains the underlying architecture, and gives you a complete reference of the available helper functions, with examples.

## Concepts and Terminology **(Recommended reading before the next section)**
### What is a softcore
A normal processor is a physical silicon chip where fixed transistors make up the processor's internal logic. A "softcore" is a processor described in code and then flashed onto an FPGA. The FPGA uses configurable logic blocks that can implement the logic the softcore's code describes, and thereby behaves like a real processor. That is why you must first flash the softcore this project describes - it configures the FPGA to be a Wildcat processor (this project's specific softcore).

### What is GPIO (General Purpose Input/Output)
GPIO refers to the physical pins on the board that can be used to send or receive electrical signals. For example, an LED connected to a GPIO pin can be turned on and off by software, or a button's input can be read. "General Purpose" means these pins are not function-specific, but can be used for whatever you connect to them.

### What is PMOD GPIO
The PMOD ports on this SoC are divided into three 8-bit GPIO banks: JA, JB, and JC. Each bank has five registers:
- `DIR` to choose the direction of each pin
- `OUT` to write output values
- `IN` to read the current pin levels
- `PWM_EN` to route the PWM signal to specific pins
- `IN_DEBOUNCED` to read stable button inputs without bounce

This means you can both control ordinary digital signals and use the same ports for dimmed outputs, e.g. an RGB LED on the PMOD header.

### What is Memory-Mapped I/O (MMIO)
The RISC-V architecture the Wildcat processor is built on has only load/store operations to communicate with whatever exists outside the CPU itself. Memory-mapping is therefore used to map specific I/O devices to specific memory addresses. When the processor needs to interact with various I/O while running a program, it performs either a read or a write operation on one of the specific memory addresses that the I/O device corresponds to. The SoC has logic that understands that, for these specific addresses, it must carry out the operation on the I/O devices rather than in actual memory - for example the LED register.

### What is a HAL (Hardware Abstraction Layer)
To simplify programming this MCU, the interaction with the available Memory-Mapped I/O is raised to a higher level of abstraction. Instead of having to know the specific memory addresses, this is a layer of helper functions where the addresses are hardcoded together with the intended operation in specific functions. Instead of writing `unsafe { (0xF010_0000 as *mut u32).write_volatile(0xFF) }`, you can write `leds::write(0xFF)`.

### What is PWM (Pulse Width Modulation)
PWM is a technique for controlling how much power is delivered to a device - e.g. the brightness of an LED - by turning the signal on and off extremely fast. Instead of sending a "half" voltage (which would require analog electronics), we turn the LED on for a certain percentage of the time and off for the rest. This ratio is called the *duty cycle*: 100% = always on (full brightness), 50% = on half the time (half brightness), 0% = always off.

When the switching happens fast enough (typically above 100 Hz), the human eye cannot distinguish the individual blinks - it is perceived as a steady, dimmed brightness. On this SoC the PWM counter runs at ~390 kHz, far above the flicker threshold, so all dimmed LEDs produce the desired smooth, even effect.

The PWM module in this SoC is implemented directly in hardware. This means the CPU only has to write a single duty cycle value per channel, and the hardware then generates the fast switching itself. The CPU is thus free to do other work in the meantime.

### What is an RGB LED
An RGB LED is three separate single-color LEDs (red, green, blue) packed into one physical component. By controlling the brightness of each of the three channels independently - typically via PWM - you can blend the colors and produce almost any color. This color mixing happens in your eye, not in the LED: when three light sources sit close enough together, the eye cannot distinguish them individually and perceives them as one combined light.

RGB LEDs come in two variants: *common-anode*, where the shared pin is +3.3V and each color channel is turned on by pulling it to ground, and *common-cathode*, where it is the opposite. In common-anode this means that a *low* duty cycle gives *high* brightness - which the HAL function `rgb::set` accounts for automatically.

### What is an ADC (Analog-to-Digital Converter)
Most signals a processor works with are digital - either high (1) or low (0). But many sensors, e.g. potentiometers and light sensors, provide an *analog* signal: a voltage that varies smoothly between 0 V and a reference voltage. An ADC translates this continuous voltage into an integer the CPU can read.

On this SoC the ADC uses the FPGA's built-in XADC and is connected to the JXADC header. It has four channels (index 0-3) and provides a 12-bit value: an integer between 0 and 4095, where 0 corresponds to the lowest voltage and 4095 to the highest. A measurement at half the reference voltage therefore gives roughly 2048.

### What is I2C (Inter-Integrated Circuit)
I2C is a serial data bus that lets the processor communicate with external devices - typically sensors - over just two wires: **SDA** (data) and **SCL** (clock), which all devices on the bus share.

Each device has a 7-bit address. The processor is the **master**: it starts every transfer, sends the address of the device it wants to talk to, and the device replies with either ACK (acknowledge) or NACK (no response). Data is then transferred one byte at a time. On this SoC the I2C controller sits on PMOD JC, where `JC[2]` is SDA and `JC[3]` is SCL; the helper functions themselves are described in the I2C section of the HAL reference.

## Prerequisites and setup
The prerequisites for building and flashing the project's softcore architecture onto a Basys 3 FPGA, and finally uploading and running the Rust program that makes up the logic of your environment-monitoring system, are described in the installation guide you will find in the project's `README.md` file.

![Workflow for uploading Rust code to TRIFORK-32 on the FPGA (Basys 3)](docs/diagrams/trifork32-manual.svg)

Below is an explanation of what each tool is used for.

### **Prerequisites:** Tools that must be installed
| Tool | Purpose |
|---|---|
| Vivado | Xilinx's development environment for FPGAs. It takes the SoC design's hardware description (generated Verilog code), synthesizes it down to a bitstream, and flashes the bitstream onto the FPGA. Once the SoC is flashed, it resides in the FPGA's non-volatile memory and survives both restart and power-off. You only need Vivado once - unless the hardware design itself changes. |
| Rust toolchain | The compiler that translates your Rust programs into RISC-V machine code. The compiler is configured with the target `riscv32i-unknown-none-elf`, which tells it to produce code for a 32-bit RISC-V processor without an operating system - exactly what the Wildcat processor is. |

Make sure you have installed the above by following the project's `README.md` file under the section **"Prerequisites & Installation"** before moving on to flashing the SoC onto your board.

If you want to change the hardware itself - that is, the SoC in Chisel, not just your Rust programs - see the section **"Developing on the CPU"** in `README.md`. This manual covers development *for* the MCU; changes *to* it belong in the README.

### **Setup part 1:** Flash the SoC onto the board
Once the tools are installed and the repo is cloned, the SoC must be flashed onto the FPGA. The SoC's logic is flashed to the FPGA's non-volatile memory, which ensures the logic survives restart and power-off of the board. The only scenario in which you would have to re-flash the SoC is if changes have been made to the SoC's logic itself.

**Flash the SoC by:**
1. Connect the Basys 3 board via USB and turn it on
2. In your terminal, navigate to the root of the repo so you are in the folder `.../rust-riscv-soc`
3. Now run the command `cargo xtask flash` in the terminal
4. The SoC is flashed: wait for the process to finish (this can take several minutes)
5. Press the PROG button on the FPGA (red button in the top-right corner of the board)
6. After 5-10 seconds the SoC is configured on the FPGA and ready: the bootloader is active and waiting for a program, while the CPU is stalled until you upload your first program

### **Setup part 2:** Upload your first program
Once the SoC is flashed, you can upload Rust programs (again and again) over UART **without** having to re-flash the SoC onto the FPGA. This is a deliberate design choice meant to reduce the time it takes to iterate on program design, and thereby reduce friction in the workflow for students of 02112.

**Upload your first program by:**
1. Find your serial port:
    - **Windows:** `Get-PnpDevice -Class Ports -PresentOnly`
    - **Linux:** `ls /dev/ttyUSB* /dev/ttyACM*`
2. Upload the program by running the command `cargo xtask upload <your_port>` in the terminal
3. The program compiles automatically, is uploaded, and starts running. Output from the program is shown in the terminal.

**Iterate on your program design:**
Subsequent changes to the Rust code can be uploaded by running `cargo xtask upload <your_port>` again. It is not necessary to re-flash the SoC to upload new programs.

The test circuit below is the hardware setup used by the code currently running in [sw/program/src/app.rs](sw/program/src/app.rs).

![Test circuit for app.rs](docs/diagrams/Test-circuit.png)

## System architecture - CPU, memory, boot flow, and memory map

### CPU: Wildcat ThreeCats
The project implements a softcore processor on a Basys 3 FPGA - the specific processor the softcore implements is a "Wildcat ThreeCat" CPU, built on the RISC-V architecture and implementing the RV32I instruction set. This means the processor's architecture is in a 32-bit format: instructions are 32-bit, registers are 32-bit, and we are limited to integer operations (no floating point - floating point belongs to a separate RISC-V extension, "F", which this processor does not implement).

The processor runs one clock tick at a time, through its 3-stage pipeline - fetch (fetch the instruction from memory), decode (interpret the instruction and load registers), and execute (carry out the computation).
### Memory
In this project the SoC is implemented with 16 KB of scratchpad memory, which Vivado recognizes and implements in the on-chip BRAM found on a Basys 3 board.

The SoC has two separate physical memories - both implemented as 16 KB scratchpad memories:
- **IMEM (Instruction Memory):** the CPU fetches instructions from here
- **DMEM (Data Memory):** the CPU reads and writes data here (variables, stack, arrays, etc.)

The two memories are on separate buses, which means the CPU can fetch an instruction and access data on the same clock cycle (more efficient).

**NOTE:** During upload, each `(address, data)` word is routed by its address. Addresses in `0x0000_0000 – 0x0000_3FFF` are written only to IMEM, and addresses in `0x0000_4000 – 0x0000_7FFF` are written only to DMEM. The raw binary may still contain padding between the two regions, but the hardware stores each word in the relevant memory. The program can therefore use up to 16 KB of instructions in IMEM and up to 16 KB of data/stack in DMEM.

### Boot flow: what happens when the board is powered on
**When the board is powered on, the system goes through the following sequence:**
1. **Basys 3 starts with the softcore flashed:** the FPGA starts with the bootloader active and the CPU stalled - it cannot execute instructions yet

**The upload script then goes through the following sequence:**

2. **Reset:** the upload script sends the reset signal `0xDEADBEEF` over UART. The SoC constantly listens for this sequence and resets the CPU and bootloader to their initial state (bootloader active, CPU stalled).

   This ensures the system is ready to receive a new program - whether the board has just been powered on, or a program from a previous upload is already running.
3. **Activation:** the upload script sends the magic word `0xB00710AD`, which activates the bootloader.
4. **Upload:** the upload script sends the Rust program as (address, data) pairs. The bootloader receives each word over UART, and the SoC top writes the word to IMEM or DMEM based on the address.
5. **Start execution:** the upload script sends the done signal `0xD0000000`, which releases the CPU and starts program execution from address `0x0000_0000`.

The bootloader is implemented in hardware as a state machine - it is not software running on the CPU. It listens on the UART line, receives bytes, and writes them into memory.

#### Soft reset
To enable faster iteration during development, it is possible to re-upload programs without having to re-flash the entire softcore. The upload script automatically sends the reset signal `0xDEADBEEF` over UART before every upload. A dedicated monitor component in the SoC constantly listens for this sequence and resets the CPU and bootloader back to the boot state when it is detected. In the sequence above, this corresponds to going through steps 2 - 5 again.

#### Hardware reset (BTNC)
The center button on the board (BTNC, FPGA pin U18) is wired to the SoC's hardware reset. Pressing it resets the CPU, bootloader, and peripherals to their initial state - exactly as at startup: the bootloader becomes active again, and the CPU is stalled, ready for a new upload without re-flashing. It is the physical counterpart to the soft reset (`0xDEADBEEF`) above. Note that the center button is therefore *not* one of the four readable GPIO buttons (btnU/L/R/D) - it controls the reset.

### Memory Map: which components correspond to which addresses?
The address space is divided into three regions: IMEM for instructions, DMEM for data and stack, and I/O devices at addresses starting with `0xF`. For I/O devices, it is bits 23-20 of the address that specify which device is accessed.
| Address | Device | Read/Write |
|---|---|---|
| `0x0000_0000 – 0x0000_3FFF` | IMEM: instruction scratchpad (16 KB) | Read |
| `0x0000_4000 – 0x0000_7FFF` | DMEM: data scratchpad (16 KB) | Read + Write |
| `0xF000_0000` | UART status (bit 0 = TX ready, bit 1 = RX data available) | Read |
| `0xF000_0004` | UART data (read = receive byte, write = send byte) | Read + Write |
| `0xF010_0000` | LED register (bit 0-15 = the 16 onboard LEDs LD0-LD15) | Write |
| `0xF020_0000` | Debounced button register (bit 0-3 = btnU, btnL, btnR, btnD) | Read |
| `0xF030_000X` | ADC: four analog JXADC channels (offset 0x0/0x4/0x8/0xC = channel 0-3), 12-bit value 0-4095 | Read |
| `0xF040_0000` | PWM enable register (not connected in hardware - PWM routing is controlled per PMOD bank via PWM_EN) | Read + Write |
| `0xF040_0004 – 0xF040_0060` | PWM duty cycle for channels 0-23 (8-bit value 0-255, 4 bytes per channel from 0xF040_0004). Channels 0-7 = PMOD JA pins, 8-15 = JB, 16-23 = JC | Read + Write |
| `0xF050_0000` | PMOD JA DIR (bit 0-7 = direction per pin) | Read + Write |
| `0xF050_0004` | PMOD JA OUT (bit 0-7 = output value per pin) | Read + Write |
| `0xF050_0008` | PMOD JA IN (bit 0-7 = input value per pin) | Read |
| `0xF050_000C` | PMOD JA PWM_EN (bit 0-7 = PWM routing per pin) | Read + Write |
| `0xF050_0010` | PMOD JA IN_DEBOUNCED (bit 0-7 = debounced input value per pin) | Read |
| `0xF060_0000` | PMOD JB DIR / OUT / IN / PWM_EN / IN_DEBOUNCED (same layout as JA, offset 0x0/0x4/0x8/0xC/0x10) | Read + Write |
| `0xF070_0000` | PMOD JC DIR / OUT / IN / PWM_EN / IN_DEBOUNCED (same layout as JA). Note: JC[2]=SDA and JC[3]=SCL are reserved for I2C and cannot be used as GPIO | Read + Write |
| `0xF080_0000 – 0xF080_000C` | I2C controller: CMD (0x0, write-only) / DATA (0x4) / STATUS (0x8, read-only) / CLKDIV (0xC) | Write + Read |

## Workflow - from Rust code to running program
When you develop programs for this MCU, your workflow is:
1. Write or edit your Rust program in the file `sw/program/src/app.rs`
2. Run the command `cargo xtask upload <your_port>` from the root of the repo (`.../rust-riscv-soc`)
3. Your program is compiled, uploaded, and starts executing automatically.

### What happens on your PC?
The command `cargo xtask upload` automates the following chain of actions:
1. **Compilation:** Cargo (Rust's build system) compiles your Rust program into a RISC-V ELF file. The ELF format contains machine code plus metadata about the program's structure (where code and data start, symbol names, etc.)
2. **Conversion:** `cargo objcopy` converts this ELF file into a raw binary (`program.bin`). The file contains bytes from both the IMEM and DMEM regions and may contain padding between the regions.
3. **Upload:** the Rust crate `uploader` sends the binary over USB/UART to the FPGA. The script handles reset, activation of the bootloader, and transfer of the program data. The hardware uses the addresses to write instructions to IMEM and data to DMEM.
4. **Execution:** when the upload is finished, the bootloader releases the CPU and your program executes from address `0x0000_0000`.

### File structure

Your Rust program is written in the file `sw/program/src/app.rs`. It is the only file you need to edit under normal use.

**Note:** If you run into memory limits (16 KB of instructions or 16 KB of data/stack), it is possible to expand the memory by changing the size in `sw/program/linker.ld` and `wildcat/src/main/scala/rvsoc/RustSoCTop.scala`, followed by a `cargo xtask flash`. Contact an instructor before doing this.

## HAL reference: available functions and addresses

The following functions make up the Hardware Abstraction Layer (HAL), implemented as modules under `sw/trifork32-hal/src/` (`leds`, `buttons`, `adc`, `pwm`, `rgb`, `delay`, `pmod`, `uart`, `i2c`) and used from `sw/program/src/app.rs`. They abstract away the underlying Memory-Mapped I/O, so you do not have to work directly with memory addresses.

The API is module-based: each peripheral is accessed through its module, e.g. `leds::write(...)`, `buttons::read()`, `adc::read(...)`, `pwm::set_duty(...)`, `rgb::set(...)`, and `delay::cycles(...)`. The full, generated API reference can be opened locally with `cargo xtask docs`.

### LED: `leds::write(bits: u16)`

Writes a value to the LED register. Each bit corresponds to one of the 16 onboard LEDs (LD0-LD15) - set a bit to 1 to turn it on, 0 to turn it off.
```rust
leds::write(0b0000_0101); // Turns on LED 0 and LED 2
leds::write(0xFF);        // Turns on LED 0-7
leds::write(0x00);        // Turns off all LEDs
```

All 16 bits (0-15) each control their own onboard LED.

The module also has a couple of helper functions:

- `leds::all_off()` and `leds::all_on()` turn all LEDs off or on at once.
- `leds::write_bar(value, max)` shows `value` as a bar graph across the 16 LEDs, where `0` turns all off and `value >= max` turns all on. Handy for showing an ADC reading, for example:
```rust
leds::write_bar(adc::read(0).unwrap_or(0), adc::MAX_VALUE);
```

### Buttons: `buttons::read() -> u8`

Returns the debounced state of the four directional buttons as a bitmask. Bits 0-3 correspond to the four buttons - 1 means pressed, 0 means not pressed.
```rust
let state = buttons::read();
if state & 0x1 != 0 {
    // Button 0 (btnU) is pressed
}
```

If you just want to know whether one specific button is pressed, `buttons::is_pressed(index)` is more direct (valid indices are 0-3):
```rust
if buttons::is_pressed(2) {
    // Button 2 (btnR) is pressed
}
```

| Bit | Button |
|-----|------|
| 0   | btnU (up) |
| 1   | btnL (left) |
| 2   | btnR (right) |
| 3   | btnD (down) |

### ADC (Analog Input): `adc::read_all() -> [u32; 4]` and `adc::read(channel) -> Option<u32>`

Reads the current digital value from the four analog JXADC channels (index 0-3) on the Basys 3 board. The voltage is converted by the ADC controller and returned as a 12-bit value: an integer between 0 and 4095. This is especially useful for reading analog sensors (e.g. a potentiometer or a light sensor).

`adc::read_all()` returns all four channels at once, while `adc::read(channel)` reads a single channel and returns `None` if the index is outside 0-3. The constant `adc::MAX_VALUE` (4095) is the maximum value and is handy for scaling.
```rust
let values = adc::read_all();
println!("Channel 0: {}", values[0]);

if let Some(v) = adc::read(0) {
    if v > adc::MAX_VALUE / 2 {
        // The voltage on channel 0 is above 50%
        println!("ADC channel 0 is high: {}", v);
    }
}
```

### PMOD GPIO: `Pmod::JA`, `Pmod::JB`, `Pmod::JC`

The three PMOD ports can be used as ordinary GPIO banks from Rust. Each port supports direction, output, input, and PWM routing.

```rust
Pmod::JA.set_dir(0b1111_0000);      // Lower 4 pins as input, upper 4 as output
Pmod::JA.set_out(0b1010_0000);      // Write output on the pins set as output
let input = Pmod::JA.read_in();     // Read current levels
let stable = Pmod::JA.read_debounced(); // Read debounced levels
Pmod::JA.set_pwm_en(0b0111_0000);   // Route PWM to pins 4-6
```

For PWM-driven PMOD pins, the corresponding software typically uses `pwm::set_duty(...)` or a wrapper like `rgb::set(...)` to choose the duty cycle, while `set_pwm_en(...)` determines which pins actually listen to the PWM signal.

For buttons on PMOD, the pin is set as input. All PMOD GPIO pins have internal pullups, so a simple button can be connected between the PMOD pin and GND. Use `button_pressed(bit)` for active-low button logic:

```rust
Pmod::JA.set_dir(0b0000_0000); // JA as input

if Pmod::JA.button_pressed(0) {
    println!("JA[0] button is pressed");
}
```

`read_in()` is raw input and can bounce. `read_debounced()` and `button_pressed()` are intended for buttons.

**Note:** On `Pmod::JC`, pins 2 and 3 are reserved for I2C (SDA and SCL) and are controlled directly by the I2C controller. They cannot be used as GPIO or PWM - writes to JC's DIR/OUT register for those two bits are ignored by the hardware. JC's other pins (0, 1, 4-7) are free GPIO/PWM as usual.

### PWM: `pwm::set_duty(channel: u8, percent: u8)`

Sets the duty cycle of a PWM channel as a percentage. There are 24 PWM channels (0-23), and each channel controls one PMOD pin - not the built-in LEDs. The channels are distributed across the three PMOD ports:

| Channel | PMOD pin |
|-------|----------|
| 0-7   | JA[0]-JA[7] |
| 8-15  | JB[0]-JB[7] |
| 16-23 | JC[0]-JC[7] |

(JC[2] and JC[3] are reserved for I2C - see PMOD GPIO above - so channels 18 and 19 cannot be used.)

`percent` ranges from 0 (off) to 100 (full). Values above 100 are clamped to 100. Internally the percentage is converted to an 8-bit duty cycle (0-255).

```rust
Pmod::JA.set_dir(0b0000_1111);    // JA[0]-JA[3] as output
Pmod::JA.set_pwm_en(0b0000_1111); // Route PWM to JA[0]-JA[3]
pwm::set_duty(0, 100); // JA[0]: full
pwm::set_duty(1, 50);  // JA[1]: half
pwm::set_duty(2, 10);  // JA[2]: faint
pwm::set_duty(3, 0);   // JA[3]: off
```

For a `set_duty` write to reach the pin, the pin must be set as output with `set_dir` *and* PWM-routed with `set_pwm_en` on the corresponding PMOD bank. Without the PWM routing, the pin is driven by the bank's output register instead; without the output direction, the pin is high-Z and drives nothing.

### RGB LED: `rgb::set(r: u8, g: u8, b: u8)`

Sets the color of an RGB LED connected to JA[4], JA[5], and JA[6] (PWM channels 4, 5, and 6 - red, green, blue). Each color channel is given as a percentage (0-100); values above 100 are clamped to 100. The function inverts the values internally (`100 - value`), because the RGB LED is common-anode - so a high `r` value really does give high red brightness, as expected.

```rust
rgb::set(100, 0, 0);   // Full red
rgb::set(0, 100, 0);   // Full green
rgb::set(0, 0, 100);   // Full blue
rgb::set(100, 100, 0); // Yellow (red + green)
rgb::set(50, 0, 50);   // Purple (half red + half blue)
rgb::set(0, 0, 0);     // Off
```

**Prerequisite:** the three RGB pins must be set as output and PWM-routed before `rgb::set` works:

```rust
Pmod::JA.set_dir(0b0111_0000);    // JA[4]-JA[6] as output
Pmod::JA.set_pwm_en(0b0111_0000); // Route PWM to JA[4]-JA[6]
```

### UART: `print!()` and `println!()`

Sends text over the serial connection (UART) - works just like standard Rust and supports formatting with `{}`. The macros use a `Uart` writer that implements `core::fmt::Write`: for each byte it waits for TX to be ready (status bit 0) and then writes to the UART's data register.

```rust
println!("Hello from Rust!");
println!("The number is: {}", 42);
println!("Buttons: 0x{:X}", buttons::read());
```

Output can be seen in the terminal after `cargo xtask upload <your_port>`, or with a serial terminal program (115200 baud, 8N1).

**Receiving (RX):** the HAL has only TX - there is no receive function among the macros. The UART hardware *can* receive, but this is done via raw MMIO: poll the status register (bit 1 = byte available) and read the data register at `0xF000_0004`.

### I2C: `i2c::start()`, `i2c::write_bytes(...)`, `i2c::read_bytes(...)`

I2C is a serial two-wire bus for communicating with external devices such as sensors. On this SoC the I2C controller sits on **PMOD JC**: pin `JC[2]` is SDA (data) and `JC[3]` is SCL (clock). Connect the sensor's SDA/SCL to these two pins. I2C requires pull-up resistors on both lines; the FPGA's internal pull-ups are too weak to be reliable, so in practice you must add external ones - 4.7 kΩ to 3.3V is generally recommended (10 kΩ also works). The functions live in the `i2c` module (`sw/trifork32-hal/src/i2c.rs`) and are used as `i2c::start()`, etc.

Each device on the bus has a 7-bit address. The master (your MCU) starts each transfer, sends the address, and the device replies with ACK (acknowledge) or NACK (no response).

**Setup - bus speed:**
```rust
i2c::set_clkdiv(500); // 100 kHz (standard mode)
i2c::set_clkdiv(125); // 400 kHz (fast mode)
```
The divider is `system_clock / (i2c_hz * 2)`; at 100 MHz, 500 → 100 kHz. Write 0 for the hardware default (100 kHz).

**High-level helpers (most programs use these):**

- `write_bytes(addr, data) -> bool` sends a whole buffer to the device at 7-bit address `addr` (START → address+W → data → STOP). Returns `true` if every byte was ACKed.
- `read_bytes(addr, buf) -> bool` reads `buf.len()` bytes from the device (START → address+R → read → STOP). Returns `true` if the address byte was ACKed.
- `write_read(addr, write_data, read_buf) -> bool` writes-then-reads in a single transfer with a repeated START - the typical "read a sensor register" pattern.
- `scan(found) -> usize` probes all addresses `0x08..=0x77` and fills `found` with those that respond; returns the number found. Useful for finding out which address your sensor has.

```rust
// Find devices on the bus
let mut found = [0u8; 8];
let n = i2c::scan(&mut found);
println!("Found {} I2C device(s)", n);

// Write a command to the device at address 0x5C and read a 4-byte response
let cmd = [0x03, 0x00, 0x04];
if i2c::write_bytes(0x5C, &cmd) {
    let mut resp = [0u8; 4];
    i2c::read_bytes(0x5C, &mut resp);
}
```

**Low-level primitives (for full control over a transfer):**

- `start()` / `stop()` - generate START at the beginning and STOP at the end of each transfer.
- `write_byte(byte) -> bool` - send one byte, returns `true` on ACK. An address byte is built as `(addr << 1) | rw`, where `rw` = 0 for write, 1 for read.
- `read_byte(send_ack) -> u8` - receive one byte. `send_ack = true` means "send me more"; `false` signals that it was the last byte (NACK).

```rust
i2c::start();
let acked = i2c::write_byte((0x5C << 1) | 0); // address 0x5C, write
i2c::write_byte(0x03);                         // send a data byte
i2c::stop();
```

**Status helpers:** `wait_idle()` blocks until the controller has finished the current command, and `status() -> u32` reads the raw status register (BUSY/NACK/BUS_ERR bits) - primarily for debugging.

### delay: `delay::cycles(...)`, `delay::cycles_precise(...)`, `delay::read_cycles()`

Three helpers for waiting and for measuring time, all based on the CPU's clock cycles. The CPU runs at 100 MHz, so 100 cycles = 1 µs and 100,000 cycles = 1 ms.

`delay::cycles(count)` waits by running `count` `nop` instructions in a loop. It is **not precise**: the loop itself also costs instructions per iteration, and how many cycles each `nop` actually takes depends on the pipeline. The number is therefore only a rough guide - good enough for simple demos like a visible LED blink.

`delay::read_cycles()` reads the free-running 64-bit cycle counter directly from the CPU via the RISC-V instructions `rdcycle`/`rdcycleh`. The counter increments once per clock cycle and is not reset along the way, so you can take two readings and subtract them to measure how many cycles a piece of work took.

`delay::cycles_precise(count)` waits **exactly** `count` cycles by reading the same counter and waiting until enough have passed. Unlike `cycles`, it is independent of the pipeline, and it is the one you should use when timing actually matters - for example the wait times an I2C sensor requires between steps.

```rust
delay::cycles(1_000_000);          // rough pause - fine for a visible blink
delay::cycles_precise(100_000);    // exactly 1 ms (100,000 cycles at 100 MHz)

let start = delay::read_cycles();
// ... some work ...
let elapsed = delay::read_cycles() - start; // number of cycles used
```

### Advanced: Direct MMIO

If you need to access hardware directly without the HAL functions, you can use the raw addresses. This requires `unsafe` blocks in Rust because the compiler cannot guarantee that the addresses are valid.
```rust
// Read UART status
let status = unsafe { (0xF000_0000 as *const u32).read_volatile() };

// Write to the LED register
unsafe { (0xF010_0000 as *mut u32).write_volatile(0xFF) };

// Read the buttons
let buttons = unsafe { (0xF020_0000 as *const u32).read_volatile() };
```

The table below is a lookup reference for the raw addresses. The names in the left column are the HAL's own internal constants (`mmio.rs`); they are private (`pub(crate)` in a private module) and **cannot** be imported from your program. You therefore write the address directly as in the example above - the names are included only to show what each address is.

| Internal constant | Address | Type | Description |
|----------|---------|------|-------------|
| `UART_STATUS` | `0xF000_0000` | `*const u32` | UART status register |
| `UART_DATA` | `0xF000_0004` | `*mut u32` | UART data (send/receive) |
| `LED_REG` | `0xF010_0000` | `*mut u32` | LED register |
| `BTN_REG` | `0xF020_0000` | `*const u32` | Button register |
| `ADC_BASE` | `0xF030_0000` | `*const u32` | ADC base (4 channels, offset 0-12) |
| `PWM_DUTY` | `0xF040_0000` | `*mut u32` | PWM base: offset 0 = global enable register, offset (N+1)*4 = duty for channel N (0-23) |
| `PMOD_JA_BASE` | `0xF050_0000` | GPIO bank | DIR/OUT/IN/PWM_EN/IN_DEBOUNCED |
| `PMOD_JB_BASE` | `0xF060_0000` | GPIO bank | Same layout as JA |
| `PMOD_JC_BASE` | `0xF070_0000` | GPIO bank | Same layout as JA |
| `I2C_CMD` … `I2C_CLKDIV` | `0xF080_0000 – 0xF080_000C` | I2C controller | Command / data / status / clock-divider (offset 0x0/0x4/0x8/0xC) |

## Programming examples

### Complete example: all peripherals

The following program is the project's demo (`sw/program/src/app.rs`) and uses almost all of the peripherals. At startup it prints a few lines over UART and runs a self-test of the I2C NACK detection. It then runs in an infinite loop that simultaneously:

- shows ADC channel 0 as a bar graph across all 16 onboard LEDs
- mirrors button presses (btnU/L/R) on Pmod JA[0], JA[1], and JA[2]
- fades an RGB LED on JA[4]-JA[6] through red, green, and blue
- reads an AM2320 temperature/humidity sensor over I2C roughly every 2 seconds and prints the result over UART

Note the signature `pub fn main() -> !`: `main` never returns (`!`), because it runs an infinite loop - there is no operating system to return to.

```rust
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
```

**Expected behavior:**
- At startup, "=== TRIFORK-32 Booted ===", "SRAM Size: 16384 bytes", "Status: PASS", and "NACK detection: PASS" are shown in the terminal
- Change the light falling on the photoresistor connected to ADC channel 0 (e.g. cover it with your hand) → more or fewer LEDs light up as a bar graph across the 16 onboard LEDs
- Press btnU → JA[0] goes high, btnL → JA[1], btnR → JA[2] (visible if you have LEDs on those pins)
- The RGB LED on JA[4]-JA[6] slowly fades up to full red, down to off, on to green, then blue, and repeats
- Roughly every 2 seconds a line like "AM2320: 23.4 C, 45.6 %RH" is printed. If the sensor is not connected, you instead see "AM2320: command failed (no ACK)" or "AM2320: read failed"

**Note:** The RGB LED is assumed to be common-anode, so `rgb::set` inverts the values (`100 - r`, etc.). If your RGB LED is common-cathode instead, you must change `rgb::set` in `sw/trifork32-hal/src/rgb.rs` so it does not invert - remove `100 -` in front of `r`, `g`, and `b` in the three `pwm::set_duty` calls (channels 4, 5, and 6).

## Troubleshooting

### "cargo xtask upload" fails with "Could not open port"

The serial port is either specified incorrectly or in use by another program. Check that you specified the correct port with `cargo xtask upload <your_port>`. Close any other programs using the port (serial terminals, other upload scripts).

### No output in the terminal after upload

Check that your serial port is correct. Check that the board is powered on and that the SoC is flashed. Press the PROG button and wait 5-10 seconds before running `cargo xtask upload <your_port>` again.

### The program does not work after changes to the code

Make sure you save the file before running `cargo xtask upload <your_port>`. Check the terminal output for compilation errors - the Rust compiler usually gives precise error messages with line numbers.

### "cargo xtask flash" fails

Check the following:
- **Is Vivado installed?** Follow the installation guide in the README
- **Can the terminal find Vivado?** Vivado must be added to your system PATH - an environment variable that tells your terminal where to find programs. If you type `vivado -version` in the terminal and get an error, PATH is not set correctly. See the README under "Xilinx Vivado" for how to add the correct path to PATH for your operating system
- **Is the board connected?** The board must be connected via USB and powered on
- **Is only one board connected?** Vivado can only auto-detect one board at a time

### The program compiles but does nothing on the board

Your program may be larger than the available memory. Run `rust-size -A target/riscv32i-unknown-none-elf/release/program` from the repo root and check that `.text` stays under 16384 bytes, and that the data sections plus the stack fit in the DMEM region.

### LEDs do not respond

Check that you are using the right bit positions in `leds::write()` - bit 0 is LD0, bit 15 is LD15, and all 16 onboard LEDs are software-controlled. Note that `leds::write` writes all 16 bits at once, so an LED you do not set in the same call is turned off.

### A PWM pin does not respond even though `pwm::set_duty` is called

A duty write only reaches a PMOD pin if two things are in place: the pin must be set as **output** with `set_dir`, and the channel must be **PWM-routed** with `set_pwm_en` on the corresponding bank. The duty value is stored in the register regardless, but without both the pin does not drive. Example - to PWM JA[0] (channel 0):

```rust
Pmod::JA.set_dir(0b0000_0001);    // JA[0] as output
Pmod::JA.set_pwm_en(0b0000_0001); // route PWM to JA[0]
pwm::set_duty(0, 50);             // now the duty reaches the pin
```

Also remember that the channel number is the PMOD pin, not an LED: JA = channels 0-7, JB = 8-15, JC = 16-23.

### The RGB LED lights up the opposite of what is expected (high value = dark)

Your RGB LED is probably *common-cathode* instead of *common-anode*. `rgb::set` inverts the values by default (`100 - r`), because it assumes common-anode. For a common-cathode LED you must remove the inversion in `rgb::set` in `sw/trifork32-hal/src/rgb.rs`:

```rust
pub fn set(r: u8, g: u8, b: u8) {
    let r = r.min(100);
    let g = g.min(100);
    let b = b.min(100);

    pwm::set_duty(4, r);  // no inversion (was: 100 - r)
    pwm::set_duty(5, g);
    pwm::set_duty(6, b);
}
```

### I2C/AM2320: the sensor does not respond

First: which message do you get? "command failed (no ACK)" means the controller did not get an ACK on the address - typically a hardware or wake problem. "read failed" means the address was ACKed, but the response was wrong - typically timing or framing.

Check in this order:

- **Wiring:** SDA goes to `JC[2]` (pin N17), SCL to `JC[3]` (pin P18) - see the test circuit and the I2C section. The sensor's GND and 3.3V must also be connected.
- **Pull-ups:** SDA and SCL must have pull-up resistors to 3.3V. The FPGA's internal pull-ups are too weak to be reliable, so add external ones - 4.7 kΩ is recommended (10 kΩ also works). The controller only drives the line low (open-drain); the pull-up pulls it high again.
- **Address:** the AM2320 is at 7-bit address `0x5C`. Use `i2c::scan()` to see which addresses respond on the bus.
- **Wake-up:** the AM2320 sleeps and NACKs the first address. It must be woken by holding SDA low for at least ~800 µs (in the demo this is done by briefly setting `set_clkdiv` low), waiting, and *then* doing the real transaction. If you skip the wake step, you get no ACK.
- **Polling rate:** the sensor must not be read more often than roughly every 2 seconds.

### The terminal shows `[TRIFORK-32 PANIC]: ...`

Your Rust program hit a runtime error (a *panic*). The panic handler catches it, prints `[TRIFORK-32 PANIC]:` followed by the error message and the location (file and line number) over UART, and then enters an infinite loop - so the CPU stands still, and the board "hangs" until you upload again or press reset (BTNC).

The text after the colon tells you exactly what and where. Common causes: an index outside an array's bounds, `.unwrap()` on a `None`/`Err`, integer overflow (caught in debug builds), division by zero, or an explicit `panic!`. Fix the error in the code, and upload again.