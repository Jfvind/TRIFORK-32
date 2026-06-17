# TRIFORK-32
Allows you to run Rust code on TRIFORK-32, a Wildcat RISC-V based MCU implemented on an FPGA.


## :shopping_cart: Prerequisites & Installation

### :rocket: Running Rust on the CPU
_Everything you need to write Rust programs and execute them on the FPGA._

#### 1. Xilinx Vivado (WebPACK Edition) !!Only needed if softcore is not already flashed to board!!
Required for synthesizing the hardware and flashing the FPGA. Only needed once to program the non-volatile flash.

**Check if installed:**
```bash
vivado -version
```
If you see a version 2019.1 or later; a compatible version of Vivado is already installed and in your PATH — skip to the next tool. If the command is not found (or the version is older than 2019.1), proceed with installation:

- **Download:** [AMD Vivado™ Design Suite](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html)
- **Install:** Select "Vivado Standard" or "WebPACK" (Free).
- **Important:** During installation, ensure you install the Cable Drivers.
- **System PATH:** After installation, add the Vivado bin folder to your system PATH so the terminal can find the *vivado* command.
    - *Windows:* Add `C:\Xilinx\Vivado\20xx.x\bin` to Environment Variables → Path.
    - *Linux:* Add `source /tools/Xilinx/Vivado/20xx.x/settings64.sh` to your `.bashrc` or `.zshrc`.
Now check, with the version command in a new terminal.

#### 2. Rust Toolchain
Required to compile the Rust program that runs on the FPGA.

**Check if installed:**
```bash
rustc --version
cargo --version
```
If both commands show version **1.85 or later**, Rust is already installed. If Rust is not installed or the version is older than 1.85, proceed with installation:

- **Install rustup:** 
    - *Windows:* [rustup.rs](https://rustup.rs/)
    - *Linux:* `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

- **Add the RISC-V 32-bit target:**
Verify the RISC-V target is added by running `rustc --print sysroot` and search the folder `<sysroot>/lib/rustlib/` for `riscv32i-unknown-none-elf`. If it is not found proceed with installation:
    ```bash
    rustup target add riscv32i-unknown-none-elf
    ```

- **Install cargo-binutils** (for `cargo objcopy`):
    Check if already installed:
    ```bash
    cargo objcopy --version
    ```
    If not found, install:
    ```bash
    cargo install cargo-binutils
    rustup component add llvm-tools
    ```
---

> [!IMPORTANT]
> If you are **NOT** changing the hardware Framework - skip to [Getting started](#rocket-getting-started)

### :wrench: Developing on the CPU
_Additional tools needed to modify the CPU hardware (Chisel) and run simulation tests._

#### 3. Java 17+ (JDK)
Required by sbt and the Chisel hardware generator.

**Check if installed:**
```bash
java -version
```
If you see a version number that is 17 or higher (e.g., `17.0.x`, `21.0.x`), Java is installed — skip to the next tool. If not found or version is lower than 17, proceed with installation:

- Windows/Linux: Download from [Adoptium](https://adoptium.net/) (Eclipse Temurin 17+).
- Linux (Ubuntu): ```sudo apt install openjdk-17-jdk```
- Verify: ```java -version```

#### 4. sbt (Scala Build Tool)
Required to compile Chisel (`cargo xtask build-hw`) and run simulation tests (`cargo xtask sim-test`).

**Check if installed:**
```bash
sbt --version
```
If you see a version number, sbt is already installed — skip to the next tool. If not found, proceed with installation:

- All platforms: Follow the install guide at [scala-sbt.org](https://www.scala-sbt.org/download.html).
- Linux (Ubuntu): ```sudo apt install sbt``` (after adding the sbt apt repository).
- Verify: ```sbt --version```

#### 5. RISC-V Assembler/Linker
Required to assemble the simulation test programs (`cargo xtask sim-test`). Not needed for building or flashing the FPGA.

**Check if installed:**

- **Windows (inside WSL):**
    ```bash
    wsl riscv64-linux-gnu-as --version
    ```
- **Linux:**
  ```bash
  riscv64-unknown-elf-as --version  # or
  riscv64-linux-gnu-as --version
  ```
If you see version information, the RISC-V tools are installed — skip to the next section. If not found, proceed with installation:

- **Windows:** WSL (Windows Subsystem for Linux) with the linux-gnu binutils:
    1. Install WSL (from an admin PowerShell): `wsl --install`
    2. Inside WSL: `sudo apt-get install -y make binutils-riscv64-linux-gnu`
- **Linux (Ubuntu 24.04+):** `sudo apt-get install -y binutils-riscv64-linux-gnu`
- **Linux (Ubuntu 22.04 and earlier):** `sudo apt-get install -y gcc-riscv64-unknown-elf`

#### 6. Make (Build Tool)
Required for the legacy `make` workflow and for some older instructions in the project history.

**Check if installed:**
```bash
make --version
```
If you see a version number, Make is already installed. This project now uses `cargo xtask` instead of `make` for the normal workflow, so you only need Make if you are following an older script or comparing against the legacy setup.

- Windows:
    - Option A (Recommended): Install via Chocolatey. Open PowerShell as Admin and run: `choco install make`
    - Option B: Download GnuWin32 Make, install it, and add `C:\Program Files (x86)\GnuWin32\bin` to your PATH.
- Linux:
    - Ubuntu/Debian: `sudo apt install make`
    - Fedora: `sudo dnf install make`

## :rocket: Getting started
### GPIO overview
The hardware exposes three software-controlled PMOD GPIO connectors in addition to the onboard LEDs, buttons, and ADC:
- Each PMOD pin has direction, output, input, and PWM-enable registers.
- Each PMOD pin also has a debounced input register for external button reads.
- GPIOs can be driven directly from Rust through the MMIO helpers. Student code lives in `sw/program/src/app.rs`.
- PMOD buttons can be wired from a GPIO pin to GND; internal pullups keep the idle state high.

The test circuit below is the hardware setup used by the code currently running in [sw/program/src/app.rs](sw/program/src/app.rs).
**Build the breadboard setup and power on the FPGA.**

![Test circuit for app.rs](docs/diagrams/Test-circuit.png)

![Quick workflow for running a program on TRIFORK-32](docs/diagrams/trifork32-quickguide.svg)
See the detailed steps below

### 1. Clone repo (requires git) OR [download release zip](https://github.com/Jfvind/rust-riscv-soc/releases/latest)
```bash
git clone https://github.com/Jfvind/rust-riscv-soc
cd rust-riscv-soc
```
### 2. Flash
Build RustSoCTop.bin from wildcat/src/main/scala/rvsoc/RustSoCTop.scala and flash to Basys 3
- **Dependency:** Make sure Basys 3 is connected and turned on (And 'Prerequisites & Installation' is completed) and your terminal is in /rust-riscv-soc
```bash
cargo xtask flash
```
- **Duration:** 3 minutes to a lifetime :skull:
- **Output:** 
    - Makes a Vivado project at hw/vivado
    - Generates .jou and .log in root
    - Generates /.Xil in root
- *Note*: it is possible to only build the `.bin` and `.bit` files using `cargo xtask build-hw`, this doesn't flash the FPGA memory.

### :arrow_forward: 3. PROG
Press the red button in top right corner of the Basys 3.
After 5-10 seconds the CPU should be running on the FPGA, stored in the non-volatile memory.

### 🔌 4. Upload Rust
**1.** locate the COM-port you FPGA uses to connect to the pc:
*Windows:* 
```powershell
Get-PnpDevice -Class Ports -PresentOnly | Select-Object -Property FriendlyName
```
Look for something like "USB Serial Port (COM5)". Port name is COM5.

*Linux:*
```bash
ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null
```
Look for something like /dev/ttyUSB0 or /dev/ttyUSB1.

**Note:** If you don't know which port is your FPGA, then unplug it, run the command, and plug it in again and run the command once more.

**2.** Upload rust code
```bash
cargo xtask upload <your_COM_port>
```
The board now runs TRIFORK-32 as a microcontroller executing RISC-V32I instructions.

**Note:** You can re-upload anytime after changing the rust file and then running the upload command again.

**HAL API docs:** To browse the generated Rust documentation for the TRIFORK-32 HAL, run:
```bash
cargo xtask docs
```

### 5. Verify functionality
After upload, the program prints boot info and "PASS" over UART, then continuously demonstrates all peripherals and prints AM2320 sensor readings every ~2 seconds:
- **ADC bar-graph:** Onboard LEDs 0-15 light up as a bar-graph based on the first PMOD-pin-pairs analog input in JXADC.
- **Buttons:** btnU, btnL, btnR, light up Pmod connector JA LEDs 1, 2, 3 respectively.
- **RGB LED (PWM):** Pmod pins 12-14 drive a common-anode RGB LED that fades through red, green, and blue
- **I2C (AM2320 sensor):** The demo probes a nonexistent address to verify NACK detection, then reads an AM2320 temperature/humidity sensor over I2C on the JC connector every ~2 seconds, printing readings like `AM2320: 25.0 C, 41.0 %RH` over UART.
- **PMOD GPIO:** JA, JB, and JC are bidirectional GPIO connectors. In this demo JA drives outputs and PWM while JC is used as the I2C bus (SDA/SCL); the Rust `Pmod` helper handles direction, output, input, and PWM routing.

### :broom: 6. Clean up (Optional)
Since the CPU is stored in the flash memory, the generated files are not necessary.
**Note:** if making changes to the CPU and the hw/vivado is cleaned away, then `cargo xtask flash` will take longer.

## Changes to schoeberl/wildcat
Static version from feb-2026.

- Added top module instantiating bootloader at src/main/scala/rvsoc.
- Added WSL detection in src/main/scala/Util.scala for running tests in powershell.
- Updated the imported Wildcat repo to work with the local PowerShell-based workflow (SimulatorTest, SingleCycleTest, WildcatTest, WildcatTestUart).
- Added WSL detection in Makefile for binary compilation (riscv64 toolchain).
- Implemented a real 64-bit cycle counter in src/main/scala/wildcat/pipeline/Csr.scala. Previously CYCLE/CYCLEH/TIME/TIMEH returned hardcoded stub values (1/2/3/4); they now return the low/high 32 bits of a counter that increments every clock cycle. This enables precise timing via `rdcycle` from Rust, which is needed for the I2C HAL.
