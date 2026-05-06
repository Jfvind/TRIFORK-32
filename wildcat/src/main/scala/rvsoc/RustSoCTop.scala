package rvsoc

import chisel3._
import chisel3.util._
import chisel.lib.uart._
import wildcat.pipeline._
import Bootloader._
import soc._
import chisel3.experimental.Analog
import chisel3.experimental.attach

// ====================================
// Tri-State Buffer BlackBox
// ====================================
// Chisel cannot natively generate 'Z' (high-impedance) states.
// inline Verilog blackbox is used to create the bidirectional physical buffers.
class TriStateBuffer8 extends HasBlackBoxInline {
  val io = IO(new Bundle {
    val pad = Analog(8.W)
    val dir = Input(UInt(8.W))
    val out = Input(UInt(8.W))
    val in  = Output(UInt(8.W))
  })
  setInline("TriStateBuffer8.v",
    """module TriStateBuffer8(
      |  inout  [7:0] pad,
      |  input  [7:0] dir,
      |  input  [7:0] out,
      |  output [7:0] in
      |);
      |  genvar i;
      |  generate
      |    for (i = 0; i < 8; i = i + 1) begin : b
      |      assign pad[i] = dir[i] ? out[i] : 1'bz;
      |    end
      |  endgenerate
      |  assign in = pad;
      |endmodule
      |""".stripMargin)
}

/**
 * RustSoCTop — Top-level SoC for running Rust programs on the Wildcat RISC-V processor.
 *
 * Key differences from WildcatTop:
 *   - Uses writable ScratchPadMem for instruction memory (not a ROM).
 *   - Integrates the BootloaderTop so programs can be loaded at runtime via UART,
 *     rather than at synthesis time.
 *   - Holds the CPU stalled while the bootloader is active (by ack deassertion).
 *   - Enable on-board button inputs
 *   - Reads Analog values from JXADC inputs
 *   - JA, JB, JC are used as GPIOs.
 *
 * Boot sequence:
 *   1. After FPGA is programmed, the bootloader is active and the CPU is stalled.
 *   2. Host sends start magic 0xB00710AD over UART (little-endian).
 *   3. Host sends (address, data) word pairs. The top-level routes each word
 *      to IMEM or DMEM based on its address range.
 *   4. Host sends a "done" word with address = 0 and data = 0xD0000000
 *      which releases the CPU.
 *   5. CPU begins executing from address 0.
 *
 * Reset (for autonomous re-upload without pressing the FPGA button):
 *   - At any time, the host can send 0xDEADBEEF (little-endian) over UART.
 *   - A monitor detects this magic and resets the CPU + bootloader
 *     back to boot mode, ready for a fresh upload.
 *
 * Memory map:
 *   0x0000_0000 – 0x0000_1FFF : Instruction scratchpad (IMEM, 8 KB default)
 *   0x0000_2000 – 0x0000_3FFF : Data scratchpad (DMEM, 8 KB default)
 *   0xF000_0000               : UART status  (bit 0 = TX ready, bit 1 = RX data available)
 *   0xF000_0004               : UART data    (read = RX byte, write = TX byte)
 *   0xF010_0000               : on-board LEDs (lower 7 bits drive LEDs)
 *   0xF020_0000               : debounced on-board Buttons (bit 0-3 = btnU, btnL, btnR, btnD)
 *   0xF030_000X               : ADC (0=Ch1, 4=Ch2, 8=Ch3, C=Ch4)
 *   0xF040_000X               : PWM (0=Enable, 4-40=Duty cycles)
 *   0xF050_000X               : PMOD JA (0=DIR, 4=OUT, 8=IN, C=PWM_EN, 10=IN_DEBOUNCED)
 *   0xF060_000X               : PMOD JB (0=DIR, 4=OUT, 8=IN, C=PWM_EN, 10=IN_DEBOUNCED)
 *   0xF070_000X               : PMOD JC (0=DIR, 4=OUT, 8=IN, C=PWM_EN, 10=IN_DEBOUNCED)
 *                               Note: JC[2]=SDA and JC[3]=SCL are reserved for I2C and not usable as GPIO
 *   0xF080_000X               : I2C (0=CMD, 4=DATA, 8=STATUS, C=CLKDIV)
 *
 * @param frequ     system clock frequency in Hz (default 100 MHz for Basys3)
 * @param baudRate  UART baud rate (default 115200)
 * @param memBytes  scratchpad memory size in bytes (default 8192)
 */
class RustSoCTop(frequ: Int = 100000000, baudRate: Int = 115200, memBytes: Int = 8192) extends Module {

  val io = IO(new Bundle {
    val gpioJA      = Analog(8.W)
    val gpioJB      = Analog(8.W)
    val gpioJC      = Analog(8.W)
    val tx          = Output(UInt(1.W))
    val rx          = Input(UInt(1.W))
    val led         = Output(UInt(8.W))
    val btn         = Input(UInt(4.W))

    val vauxp6      = Input(Bool())
    val vauxn6      = Input(Bool())
    val vauxp14     = Input(Bool())
    val vauxn14     = Input(Bool())
    val vauxp7      = Input(Bool())
    val vauxn7      = Input(Bool())
    val vauxp15     = Input(Bool())
    val vauxn15     = Input(Bool())
  })

  // ====================================
  // Reset monitor
  // ====================================
  // An always-on Rx that watches for a 4-byte reset magic (0xDEADBEEF) on
  // the UART line. This runs under the normal hardware reset only — NOT
  // the combined reset — so it survives its own soft resets.
  val resetMagic = "hDEADBEEF".U(32.W)
  val resetRx = Module(new Rx(frequ, baudRate))
  resetRx.io.rxd := io.rx
  resetRx.io.channel.ready := true.B // always accept bytes

  val resetShift = RegInit(0.U(32.W))
  when(resetRx.io.channel.valid) {
    resetShift := resetRx.io.channel.bits ## resetShift(31, 8)
  }

  val softReset = WireDefault(false.B)
  when(resetShift === resetMagic) {
    softReset := true.B
    resetShift := 0.U // prevent re-triggering
  }

  // Combined reset: hardware reset OR software reset.
  // All stateful elements below use this so they return to initial state on soft reset.
  val combinedReset = (reset.asBool || softReset)

  // ====================================
  // CPU Running
  // ====================================
  val cpuRunning = withReset(combinedReset) { RegInit(false.B) }
  val doneMagic = "hD0000000".U(32.W)
  val doneAddr = 0.U(32.W)

  // ====================================
  // Bootloader
  // ====================================
  // The bootloader has its own internal Rx module.
  // When booting the bootloader has the Rx line, when cpu is running the bootloader Rx is just constant.
  val bootloader = withReset(combinedReset) { Module(new BootloaderTop(frequ, baudRate)) }
  bootloader.io.rx := Mux(cpuRunning, 1.U, io.rx)

  val bootWrite = !cpuRunning && bootloader.io.wrEnabled === 1.U
  val bootAddr = bootloader.io.instrAddr
  val bootData = bootloader.io.instrData
  val bootDone = bootWrite && bootAddr === doneAddr && bootData === doneMagic

  // Detecting the "done" word to start the CPU.
  when(bootDone) {
    cpuRunning := true.B
  }

  // ====================================
  // CPU (ThreeCats 3-stage pipeline (like WildcatTop))
  // ====================================
  // With combinedReset so PC resets to 0 on software reset.
  val cpu = withReset(combinedReset) { Module(new ThreeCats()) }

  // ====================================
  // Memory
  // ====================================
  // Separate instruction and data scratchpads (like WildcatTop).
  // Both are writable so the bootloader can load code + data at runtime.
  // Initialized with NOPs to control CPU execution.
  val nopProgram = Array.fill(memBytes / 4)(0x00000013) // addi x0, x0, 0

  val imem = Module(new ScratchPadMem(nopProgram, nrBytes = memBytes))
  val dmem = Module(new ScratchPadMem(nopProgram, nrBytes = memBytes))

  // ====================================
  // Default connections: CPU <-> memories
  // ====================================
  // Bulk-connect first. Some wires are overwritten below.
  cpu.io.imem <> imem.io
  cpu.io.dmem <> dmem.io

  // ====================================
  // Bootloader memory writes
  // ====================================
  // When the bootloader asserts wrEnabled with a valid (non-done) word,
  // route it by address range:
  //   0x0000_0000 - 0x0000_0FFF -> IMEM
  //   0x0000_1000 - 0x0000_1FFF -> DMEM
  // This overwrites the CPU lines when it is true.
  val imemLimit = memBytes.U(32.W)
  val dmemBase = memBytes.U(32.W)
  val dmemLimit = (memBytes * 2).U(32.W)

  when(bootWrite && !bootDone) {
    imem.io.address := 0.U
    imem.io.wr      := false.B
    imem.io.wrData  := 0.U
    imem.io.wrMask  := 0.U
    imem.io.rd      := false.B

    dmem.io.address := 0.U
    dmem.io.wr      := false.B
    dmem.io.wrData  := 0.U
    dmem.io.wrMask  := 0.U
    dmem.io.rd      := false.B

    when(bootAddr < imemLimit) {
      // Instruction memory write
      imem.io.address := bootAddr
      imem.io.wr      := true.B
      imem.io.wrData  := bootData
      imem.io.wrMask  := "b1111".U
      imem.io.rd      := false.B
    } .elsewhen(bootAddr >= dmemBase && bootAddr < dmemLimit) {
      // Data memory write. DMEM is physically addressed from 0.
      dmem.io.address := bootAddr - dmemBase
      dmem.io.wr      := true.B
      dmem.io.wrData  := bootData
      dmem.io.wrMask  := "b1111".U
      dmem.io.rd      := false.B
    }
  }

  // ====================================
  // CPU stall when booting
  // ====================================
  // Deassert ack on both memory ports so the CPU stays stalled.
  // The ThreeCats pipeline treats !ack as "instruction not ready" and inserts NOPs.
  when(!cpuRunning) {
    cpu.io.imem.rdData := 0x00000033.U // NOP (add x0, x0, x0)
    cpu.io.imem.ack    := false.B
    cpu.io.dmem.rdData := 0.U
    cpu.io.dmem.ack    := false.B
  }

  // ====================================
  // ADC Converter
  // ====================================
  val adc = withReset(combinedReset) { Module(new AdcController())}
  adc.io.vauxp6   := io.vauxp6
  adc.io.vauxn6   := io.vauxn6
  adc.io.vauxp14  := io.vauxp14
  adc.io.vauxn14  := io.vauxn14
  adc.io.vauxp7   := io.vauxp7
  adc.io.vauxn7   := io.vauxn7
  adc.io.vauxp15  := io.vauxp15
  adc.io.vauxn15  := io.vauxn15

  // ====================================
  // PWM Controller
  // ====================================
  val pwm = withReset(combinedReset) { Module(new PwmController()) }
  val pwmEnable = withReset(combinedReset) { RegInit(0.U(16.W)) } // Bitmask to enable pwm signal for respective LED
  val pwmDutyRegs = withReset(combinedReset) { RegInit(VecInit(Seq.fill(24)(0.U(8.W)))) } // Registers that holds respective duty cycle value for comparison in PWM module to control perceived brightness

  // Connect duty registers to PWM module
  for (i <- 0 until 24) {
    pwm.io.duty(i) := pwmDutyRegs(i)
  }

  // ====================================
  // I2C Controller
  // ====================================
  // Single-master I2C controller. Drives JC[2] (SDA) and JC[3] (SCL).
  // The CPU writes commands to memory-mapped registers at 0xF080_xxxx
  // the controller handles bit-level timing, START/STOP conditions, ACK/NACK, and clock stretching.
  val i2c = withReset(combinedReset) { Module(new I2cController()) }

  // CPU-facing registers (set deafaults; actual writes hapen in the MMIO decoder below)
  val i2cDataReg = withReset(combinedReset) { RegInit(0.U(8.W)) } // Byte to transmit (DATA register)
  val i2cClkDivReg = withReset(combinedReset) { RegInit(0.U(16.W)) } // Clock divider (0 = use deafault)
  val i2cCmdValid = WireDefault(false.B) // Pulses high for one cycle on CMD write

  // Default CPU side wiring
  i2c.io.cmd := 0.U // Will be overriden by MMIO decoder when cmd is written
  i2c.io.cmdValid := i2cCmdValid
  i2c.io.dataIn := i2cDataReg
  i2c.io.clkDiv := i2cClkDivReg

  // Bus-side: SDA and SCL inputs come from the JC tristate buffer.
  // We assign these later, after bufJC is instantiatied. 

  // ====================================
  // UART for CPU
  // ====================================
  // With combinedReset so any Tx/Rx is aborted on software reset.
  val uartTx = withReset(combinedReset) { Module(new BufferedTx(frequ, baudRate)) }
  val uartRx = withReset(combinedReset) { Module(new Rx(frequ, baudRate)) }

  // Tx: Opposite of bootloaderTx. It runs when CPU is running.
  io.tx := Mux(cpuRunning, uartTx.io.txd, 1.U)
  // Rx: Same as Tx
  uartRx.io.rxd := Mux(cpuRunning, io.rx, 1.U)

  // Default UART state: no activity
  uartTx.io.channel.bits  := cpu.io.dmem.wrData(7, 0)
  uartTx.io.channel.valid := false.B
  uartRx.io.channel.ready := false.B

  // ====================================
  // Input debouncing
  // ====================================
  val debounceCycles = scala.math.max(1, frequ / 100)

  val btnDebouncer = withReset(combinedReset) { Module(new ButtonDebouncer(4, debounceCycles)) }
  btnDebouncer.io.in := io.btn

  // ====================================
  // GPIO tri-state buffer registers
  // ====================================
  // JA - PWM channels 0-7
  val gpioJADirReg = withReset(combinedReset) { RegInit(0.U(8.W)) } // 0xF050_0000
  val gpioJAOutReg = withReset(combinedReset) { RegInit(0.U(8.W)) } // 0xF050_0004
  val gpioJAIn     = Wire(UInt(8.W))                                      // 0xF050_0008
  val gpioJAPwmEn  = withReset(combinedReset) { RegInit(0.U(8.W)) } // 0xF050_000C
  val gpioJADebounced = Wire(UInt(8.W))                            // 0xF050_0010
  val bufJA = Module(new TriStateBuffer8)
  attach(io.gpioJA, bufJA.io.pad)
  bufJA.io.dir := gpioJADirReg
  val finalJAOut = Wire(Vec(8, Bool()))
  for (i <- 0 until 8) {
    finalJAOut(i) := Mux(gpioJAPwmEn(i), pwm.io.pwmOut(i), gpioJAOutReg(i))
  }
  bufJA.io.out := finalJAOut.asUInt
  gpioJAIn  := bufJA.io.in
  val gpioJADebouncer = withReset(combinedReset) { Module(new ButtonDebouncer(8, debounceCycles, initialValue = 0xff)) }
  gpioJADebouncer.io.in := gpioJAIn
  gpioJADebounced := gpioJADebouncer.io.out

  // JB - PWM channels 8-15
  val gpioJBDirReg = withReset(combinedReset) { RegInit(0.U(8.W)) } // 0xF060_0000
  val gpioJBOutReg = withReset(combinedReset) { RegInit(0.U(8.W)) } // 0xF060_0004
  val gpioJBIn     = Wire(UInt(8.W))                                // 0xF060_0008
  val gpioJBPwmEn  = withReset(combinedReset) { RegInit(0.U(8.W)) } // 0xF060_000C
  val gpioJBDebounced = Wire(UInt(8.W))                              // 0xF060_0010
  val bufJB = Module(new TriStateBuffer8)
  attach(io.gpioJB, bufJB.io.pad)
  bufJB.io.dir := gpioJBDirReg
  val finalJBOut = Wire(Vec(8, Bool()))
  for (i <- 0 until 8) {
    finalJBOut(i) := Mux(gpioJBPwmEn(i), pwm.io.pwmOut(i + 8), gpioJBOutReg(i))
  }
  bufJB.io.out := finalJBOut.asUInt
  gpioJBIn  := bufJB.io.in
  val gpioJBDebouncer = withReset(combinedReset) { Module(new ButtonDebouncer(8, debounceCycles, initialValue = 0xff)) }
  gpioJBDebouncer.io.in := gpioJBIn
  gpioJBDebounced := gpioJBDebouncer.io.out

  // JC - PWM channels 16-23 (with I2C overlay on JC[2]=SDA, JC[3]=SCL)
  val gpioJCDirReg = withReset(combinedReset) { RegInit(0.U(8.W)) } // 0xF070_0000
  val gpioJCOutReg = withReset(combinedReset) { RegInit(0.U(8.W)) } // 0xF070_0004
  val gpioJCIn     = Wire(UInt(8.W))                                // 0xF070_0008
  val gpioJCPwmEn  = withReset(combinedReset) { RegInit(0.U(8.W)) } // 0xF070_000C
  val gpioJCDebounced = Wire(UInt(8.W))                              // 0xF070_0010
  val bufJC = Module(new TriStateBuffer8)
  attach(io.gpioJC, bufJC.io.pad)

  // Build per-bit DIR and OUT vectors. For each pin we choose between
  // I2C (bit 2 = SDA, bit 3 = SCL) and the normal GPIO/PWM behaviour.
  val finalJCDir = Wire(Vec(8, Bool()))
  val finalJCOut = Wire(Vec(8, Bool()))
  for (i <- 0 until 8) {
    if (i == 2) {
      // JC[2] = SDA: I2C controller drives both DIR and OUT
      finalJCDir(i) := i2c.io.sdaOe
      finalJCOut(i) := i2c.io.sdaOut
    } else if (i == 3) {
      // JC[3] = SCL: I2C controller drives both DIR and OUT
      finalJCDir(i) := i2c.io.sclOe
      finalJCOut(i) := i2c.io.sclOut
    } else {
      // Normal GPIO/PWM behaviour for the other pins
      finalJCDir(i) := gpioJCDirReg(i)
      finalJCOut(i) := Mux(gpioJCPwmEn(i), pwm.io.pwmOut(i + 16), gpioJCOutReg(i))
    }
  }
  bufJC.io.dir := finalJCDir.asUInt
  bufJC.io.out := finalJCOut.asUInt

  // Read pin states back
  gpioJCIn  := bufJC.io.in

  // Feed the actual SDA/SCL pin states back into the I2C controller
  // This is needed for clock stretching detection and ACK reading
  i2c.io.sdaIn := bufJC.io.in(2)
  i2c.io.sclIn := bufJC.io.in(3)

  val gpioJCDebouncer = withReset(combinedReset) { Module(new ButtonDebouncer(8, debounceCycles, initialValue = 0xff)) }
  gpioJCDebouncer.io.in := gpioJCIn
  gpioJCDebounced := gpioJCDebouncer.io.out

  // ====================================
  // Memory-mapped IO Decoder
  // ====================================
  val ledReg = withReset(combinedReset) { RegInit(0.U(7.W)) }

  // --- Immediate writes (Using current cycle values 'address' and 'wr')
  val isMMIOWrite = cpuRunning && (cpu.io.dmem.address(31, 28) === 0xf.U) && cpu.io.dmem.wr
  when(isMMIOWrite) {
    val modSel = cpu.io.dmem.address(23, 20)
    val offset = cpu.io.dmem.address(7, 0)

    switch(modSel) {
      is(0.U) { // UART (0xF000)
        when(offset === 4.U) { uartTx.io.channel.valid := true.B }
      }
      is(1.U) { // on-board LEDs (0xF010)
        when(offset === 0.U) { ledReg := cpu.io.dmem.wrData(6, 0) }
      }
      is(4.U) { // PWM (0xF040)
        when(offset === 0.U) { pwmEnable := cpu.io.dmem.wrData(15, 0) }
        for (i <- 0 until 24) {
          when(offset === ((i + 1) * 4).U) { pwmDutyRegs(i) := cpu.io.dmem.wrData(7, 0) }
        }
      }
      is(5.U) { // JA (0xF050)
        when(offset === 0.U) { gpioJADirReg := cpu.io.dmem.wrData(7, 0) }
        .elsewhen(offset === 4.U) { gpioJAOutReg := cpu.io.dmem.wrData(7, 0) }
        .elsewhen(offset === 12.U) { gpioJAPwmEn := cpu.io.dmem.wrData(7, 0) }
      }
      is(6.U) { // JB (0xF060)
        when(offset === 0.U) { gpioJBDirReg := cpu.io.dmem.wrData(7, 0) }
        .elsewhen(offset === 4.U) { gpioJBOutReg := cpu.io.dmem.wrData(7, 0) }
        .elsewhen(offset === 12.U) { gpioJBPwmEn := cpu.io.dmem.wrData(7, 0) }
      }
      is(7.U) { // JC (0xF070)
        when(offset === 0.U) { gpioJCDirReg := cpu.io.dmem.wrData(7, 0) }
        .elsewhen(offset === 4.U) { gpioJCOutReg := cpu.io.dmem.wrData(7, 0) }
        .elsewhen(offset === 12.U) { gpioJCPwmEn := cpu.io.dmem.wrData(7, 0) }
      }
      is(8.U) { // I2C (0xF080)
        when (offset === 0.U) {
          // Write to CMD register: latch the command and pulse cmdValid
          i2c.io.cmd := cpu.io.dmem.wrData(7, 0)
          i2cCmdValid := true.B
        }
        .elsewhen(offset === 4.U) {
          // Write to DATA register: store byte to transmit
          i2cDataReg := cpu.io.dmem.wrData(7, 0)
        }
        .elsewhen(offset === 12.U) {
          // Write to CLKDIV register: change I2C clock speed
          i2cClkDivReg := cpu.io.dmem.wrData(15, 0)
        }
        // Note: STATUS register (offset 8) is read-only, writes are ignored

      }
    }
    dmem.io.wr := false.B // prevent IO writes from currupting RAM
  }

  // --- Delayed reads (Using 'RegNext(address)')
  val memAddressReg = RegNext(cpu.io.dmem.address)
  val isMMIORead = cpuRunning && (memAddressReg(31, 28) === 0xf.U)

  when(isMMIORead) {
    val modSel = memAddressReg(23, 20)
    val offset = memAddressReg(7, 0)

    switch(modSel) {
      is(0.U) { // UART (0xF000)
        when(offset === 0.U) { cpu.io.dmem.rdData := RegNext(uartRx.io.channel.valid ## uartTx.io.channel.ready) }
        .elsewhen(offset === 4.U) { cpu.io.dmem.rdData := uartRx.io.channel.bits }
      }
      is(2.U) { cpu.io.dmem.rdData := btnDebouncer.io.out } // debounced on-board BTN (0xF020)
      is(3.U) { // ADC (0xF030)
        when(offset === 0.U)       { cpu.io.dmem.rdData := adc.io.adcData0 }
        .elsewhen(offset === 4.U)  { cpu.io.dmem.rdData := adc.io.adcData1 }
        .elsewhen(offset === 8.U)  { cpu.io.dmem.rdData := adc.io.adcData2 }
        .elsewhen(offset === 12.U) { cpu.io.dmem.rdData := adc.io.adcData3 }
      }
      is(4.U) { // PWM (0xF040)
        when(offset === 0.U) { cpu.io.dmem.rdData := pwmEnable }
        for (i <- 0 until 24) {
          when(offset === ((i + 1) * 4).U) { cpu.io.dmem.rdData := pwmDutyRegs(i) }
        }
      }
      is(5.U) { // JA (0xF050)
        when(offset === 0.U)       { cpu.io.dmem.rdData := gpioJADirReg }
        .elsewhen(offset === 4.U)  { cpu.io.dmem.rdData := gpioJAOutReg }
        .elsewhen(offset === 8.U)  { cpu.io.dmem.rdData := gpioJAIn }
        .elsewhen(offset === 12.U) { cpu.io.dmem.rdData := gpioJAPwmEn }
        .elsewhen(offset === 16.U) { cpu.io.dmem.rdData := gpioJADebounced }
      }
      is(6.U) { // JB (0xF060)
        when(offset === 0.U)       { cpu.io.dmem.rdData := gpioJBDirReg }
        .elsewhen(offset === 4.U)  { cpu.io.dmem.rdData := gpioJBOutReg }
        .elsewhen(offset === 8.U)  { cpu.io.dmem.rdData := gpioJBIn }
        .elsewhen(offset === 12.U) { cpu.io.dmem.rdData := gpioJBPwmEn }
        .elsewhen(offset === 16.U) { cpu.io.dmem.rdData := gpioJBDebounced }
      }
      is(7.U) { // JC (0xF070)
        when(offset === 0.U)       { cpu.io.dmem.rdData := gpioJCDirReg }
        .elsewhen(offset === 4.U)  { cpu.io.dmem.rdData := gpioJCOutReg }
        .elsewhen(offset === 8.U)  { cpu.io.dmem.rdData := gpioJCIn }
        .elsewhen(offset === 12.U) { cpu.io.dmem.rdData := gpioJCPwmEn }
        .elsewhen(offset === 16.U) { cpu.io.dmem.rdData := gpioJCDebounced }
      }
      is(8.U) {
        when(offset === 4.U) {
          // Read Data register: byte received from last READ operation
          cpu.io.dmem.rdData := i2c.io.dataOut
        }
        .elsewhen(offset === 8.U) {
          // Read STATUS register: BUST/NACK/BUS_ERR flags
          cpu.io.dmem.rdData := i2c.io.status
        }
        .elsewhen(offset === 12.U) {
          // Read CLKDIV register: current clock divider value
          cpu.io.dmem.rdData := i2cClkDivReg
        }
        // Note:  CMD register (offset 0) is write-only, reads return default 0
      }
    }
  }

  // --- UART ready read logic ---
  uartRx.io.channel.ready := cpuRunning && (cpu.io.dmem.address(31, 28) === 0xf.U) && (cpu.io.dmem.address(23, 20) === 0.U) && (cpu.io.dmem.address(7, 0)   === 4.U) && cpu.io.dmem.rd

  // --- LED ---
  io.led := cpuRunning ## ledReg
}

/**
 * Verilog generation.
 * Usage: sbt "runMain rvsoc.RustSoCTopGen"
 */
object RustSoCTopGen extends App {
  emitVerilog(new RustSoCTop(), Array("--target-dir", "generated"))
}
