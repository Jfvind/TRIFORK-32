package rvsoc

import chisel3._
import chisel3.util._
import chisel.lib.uart._
import wildcat.pipeline._
import Bootloader._
import soc._

/**
 * RustSoCTop — Top-level SoC for running Rust programs on the Wildcat RISC-V processor.
 *
 * Key differences from WildcatTop:
 *   - Uses writable ScratchPadMem for instruction memory (not a ROM).
 *   - Integrates the BootloaderTop so programs can be loaded at runtime via UART,
 *     rather than at synthesis time.
 *   - Holds the CPU stalled while the bootloader is active (by ack deassertion).
 *
 * Boot sequence:
 *   1. After FPGA is programmed, the bootloader is active and the CPU is stalled.
 *   2. Host sends start magic 0xB00710AD over UART (little-endian).
 *   3. Host sends (address, data) word pairs. The bootloader writes each word
 *      into both instruction and data scratchpad memories.
 *   4. Host sends a "done" word with data = 0xD0000000 which releases the CPU.
 *   5. CPU begins executing from address 0.
 *
 * Reset (for autonomous re-upload without pressing the FPGA button):
 *   - At any time, the host can send 0xDEADBEEF (little-endian) over UART.
 *   - A monitor detects this magic and resets the CPU + bootloader
 *     back to boot mode, ready for a fresh upload.
 *
 * Memory map (same as WildcatTop):
 *   0x0000_0000 – 0x0000_0FFF : Instruction/data scratchpad (4 KB default)
 *   0xF000_0000               : UART status  (bit 0 = TX ready, bit 1 = RX data available)
 *   0xF000_0004               : UART data    (read = RX byte, write = TX byte)
 *   0xF010_0000               : LED register  (lower 8 bits drive LEDs)
 *
 * @param frequ     system clock frequency in Hz (default 100 MHz for Basys3)
 * @param baudRate  UART baud rate (default 115200)
 * @param memBytes  scratchpad memory size in bytes (default 4096)
 */
class RustSoCTop(frequ: Int = 100000000, baudRate: Int = 115200, memBytes: Int = 4096) extends Module {

  val io = IO(new Bundle {
    val led = Output(UInt(24.W))
    val tx  = Output(UInt(1.W))
    val rx  = Input(UInt(1.W))
  })

  // ---- Reset monitor ----
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

  // ---- CPU Running ----
  val cpuRunning = withReset(combinedReset) { RegInit(false.B) }
  val doneMagic = "hD0000000".U

  // ---- Bootloader ----
  // The bootloader has its own internal Rx module.
  // When booting the bootloader has the Rx line, when cpu is running the bootloader Rx is just constant.
  val bootloader = withReset(combinedReset) { Module(new BootloaderTop(frequ, baudRate)) }
  bootloader.io.rx := Mux(cpuRunning, 1.U, io.rx)

  // Detecting the "done" word to start the CPU.
  when(!cpuRunning && bootloader.io.wrEnabled === 1.U && bootloader.io.instrData === doneMagic) {
    cpuRunning := true.B
  }

  // ---- CPU (ThreeCats 3-stage pipeline (like WildcatTop)) ----
  // With combinedReset so PC resets to 0 on software reset.
  val cpu = withReset(combinedReset) { Module(new ThreeCats()) }

  // ---- Memory ----
  // Separate instruction and data scratchpads (like WildcatTop).
  // Both are writable so the bootloader can load code + data at runtime.
  // Initialized with NOPs to control CPU execution.
  val nopProgram = Array.fill(memBytes / 4)(0x00000013) // addi x0, x0, 0

  val imem = Module(new ScratchPadMem(nopProgram, nrBytes = memBytes))
  val dmem = Module(new ScratchPadMem(nopProgram, nrBytes = memBytes))

  // ---- Default connections: CPU <-> memories ----
  // Bulk-connect first. Some wires are overwritten below.
  cpu.io.imem <> imem.io
  cpu.io.dmem <> dmem.io

  // ---- Bootloader memory writes ----
  // When the bootloader asserts wrEnabled with a valid (non-done) word,
  // write it into imem and dmem.
  // This overwrites the CPU lines when it is true.
  when(!cpuRunning && bootloader.io.wrEnabled === 1.U && bootloader.io.instrData =/= doneMagic) {
    // Instruction memory write
    imem.io.address := bootloader.io.instrAddr
    imem.io.wr      := true.B
    imem.io.wrData  := bootloader.io.instrData
    imem.io.wrMask  := "b1111".U
    imem.io.rd      := false.B

    // Data memory write (same content)
    dmem.io.address := bootloader.io.instrAddr
    dmem.io.wr      := true.B
    dmem.io.wrData  := bootloader.io.instrData
    dmem.io.wrMask  := "b1111".U
    dmem.io.rd      := false.B
  }

  // ---- CPU stall when booting ----
  // Deassert ack on both memory ports so the CPU stays stalled.
  // The ThreeCats pipeline treats !ack as "instruction not ready" and inserts NOPs.
  when(!cpuRunning) {
    cpu.io.imem.rdData := 0x00000033.U // NOP (add x0, x0, x0)
    cpu.io.imem.ack    := false.B
    cpu.io.dmem.rdData := 0.U
    cpu.io.dmem.ack    := false.B
  }

  // ---- UART for CPU ----
  // With combinedReset so any Tx/Rx is aborted on software reset.
  val uartTx = withReset(combinedReset) { Module(new BufferedTx(frequ, baudRate)) }
  val uartRx = withReset(combinedReset) { Module(new Rx(frequ, baudRate)) }

  // Tx: Opposite of bootloaderTx. It rund when CPU is running.
  io.tx := Mux(cpuRunning, uartTx.io.txd, 1.U)
  // Rx: Same as Tx
  uartRx.io.rxd := Mux(cpuRunning, io.rx, 1.U)

  // Default UART state: no activity
  uartTx.io.channel.bits  := cpu.io.dmem.wrData(7, 0)
  uartTx.io.channel.valid := false.B
  uartRx.io.channel.ready := false.B

  // ---- Memory-mapped IO (like WildcatTop) ----
  val uartStatusReg = RegNext(uartRx.io.channel.valid ## uartTx.io.channel.ready)
  val memAddressReg = RegNext(cpu.io.dmem.address)

  // UART read: status at 0xF000_0000, data at 0xF000_0004.
  when(cpuRunning && memAddressReg(31, 28) === 0xf.U && memAddressReg(23, 20) === 0.U) {
    when(memAddressReg(3, 0) === 0.U) {
      cpu.io.dmem.rdData := uartStatusReg
    }.elsewhen(memAddressReg(3, 0) === 4.U) {
      cpu.io.dmem.rdData := uartRx.io.channel.bits
      uartRx.io.channel.ready := cpu.io.dmem.rd
    }
  }

  // LED register at 0xF010_0000.
  val ledReg = withReset(combinedReset) { RegInit(0.U(16.W)) }
  when(cpuRunning && (cpu.io.dmem.address(31, 28) === 0xf.U) && cpu.io.dmem.wr) {
    when(cpu.io.dmem.address(23, 20) === 0.U && cpu.io.dmem.address(3, 0) === 4.U) {
      // UART Tx data write
      uartTx.io.channel.valid := true.B
    }.elsewhen(cpu.io.dmem.address(23, 20) === 1.U) {
      // LED register write
      ledReg := cpu.io.dmem.wrData(15, 0)
    }
    // Prevent IO-mapped writes from reaching the scratchpad memory.
    dmem.io.wr := false.B
  }

  // LED output: MSB = cpuRunning indicator, lower 8 bits = ledReg, bit 15 downto 8 are GPIO LED
  io.led := RegNext(ledReg(15, 8)) ## cpuRunning ## 0.U(7.W) ## RegNext(ledReg(7, 0))
}

/**
 * Verilog generation.
 * Usage: sbt "runMain rvsoc.RustSoCTopGen"
 */
object RustSoCTopGen extends App {
  emitVerilog(new RustSoCTop(), Array("--target-dir", "generated"))
}
