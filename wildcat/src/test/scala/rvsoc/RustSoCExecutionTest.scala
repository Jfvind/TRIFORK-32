package rvsoc

import chisel3._
import chisel3.util.experimental.BoringUtils
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

/**
 * Test harness around the real RustSoCTop (sim = true), exposing the CPU
 * register file and the cpuRunning flag via BoringUtils — the same technique
 * WildcatTestTop uses. Lets a test load a program over the UART bootloader and
 * then inspect what the soft-core actually computed.
 */
class RustSoCTestTop(frequ: Int, baudRate: Int = 115200) extends Module {
  val io = IO(new Bundle {
    val rx         = Input(UInt(1.W))
    val tx         = Output(UInt(1.W))
    val led        = Output(UInt(16.W))
    val btn        = Input(UInt(4.W))
    val regFile    = Output(Vec(32, UInt(32.W)))
    val cpuRunning = Output(Bool())
  })

  val soc = Module(new RustSoCTop(frequ, baudRate, sim = true))
  soc.io.rx  := io.rx
  io.tx      := soc.io.tx
  io.led     := soc.io.led
  soc.io.btn := io.btn

  // The ADC analog inputs are still ports (only the XADC IP is stubbed); tie off.
  soc.io.vauxp6  := false.B
  soc.io.vauxn6  := false.B
  soc.io.vauxp14 := false.B
  soc.io.vauxn14 := false.B
  soc.io.vauxp7  := false.B
  soc.io.vauxn7  := false.B
  soc.io.vauxp15 := false.B
  soc.io.vauxn15 := false.B

  io.regFile := DontCare
  BoringUtils.bore(soc.cpu.debugRegs, Seq(io.regFile))
  io.cpuRunning := DontCare
  BoringUtils.bore(soc.cpuRunning, Seq(io.cpuRunning))
}

/**
 * End-to-end instruction-execution fidelity test.
 *
 * Uploads a tiny program through the real UART bootloader (using the exact wire
 * framing the host `uploader` emits), releases the CPU, and verifies the
 * register file holds the values the program computes. This proves the full
 * path: bytes on the wire -> bootloader -> IMEM -> CPU fetch/execute, i.e. the
 * instructions sent to the soft-core are the ones it actually runs.
 *
 * Runs on the default (Treadle) backend — the sim-model SoC has no BlackBox or
 * Analog, so no Verilator is required.
 */
class RustSoCExecutionTest extends AnyFlatSpec with ChiselScalatestTester {

  // Low clock frequency keeps the UART bit period (BIT_CNT) short so the whole
  // program loads in a few thousand simulated cycles. 3 MHz -> BIT_CNT = 25;
  // below ~20 the Rx's sync/START_CNT overhead corrupts sampling, so 25 keeps
  // a safe margin while staying fast on the (slow) full-SoC Treadle sim.
  val frequ   = 3000000
  val baud    = 115200
  val BIT_CNT = (frequ + baud / 2) / baud - 1

  val START_MAGIC = 0xB00710ADL
  val DONE_MAGIC  = 0xD0000000L

  // Program loaded into IMEM (address, instruction):
  //   addi x1, x0, 0x111   -> x1 = 0x111
  //   addi x2, x0, 0x222   -> x2 = 0x222
  //   add  x3, x1, x2      -> x3 = 0x333
  //   jal  x0, 0           -> spin forever
  val program = Seq(
    (0x00000000L, 0x11100093L),
    (0x00000004L, 0x22200113L),
    (0x00000008L, 0x002081B3L),
    (0x0000000CL, 0x0000006FL)
  )

  "RustSoCTop" should "execute a program uploaded over the UART bootloader" in {
    test(new RustSoCTestTop(frequ, baud)) { dut =>
      def sendByte(b: Int): Unit = {
        dut.io.rx.poke(1.U)
        dut.clock.step(BIT_CNT)
        dut.io.rx.poke(0.U) // start bit
        dut.clock.step(BIT_CNT)
        for (i <- 0 until 8) {
          dut.io.rx.poke(((b >> i) & 1).U)
          dut.clock.step(BIT_CNT)
        }
        dut.io.rx.poke(1.U) // stop bit
        dut.clock.step(BIT_CNT)
      }

      def send32LE(v: Long): Unit =
        for (i <- 0 until 4) sendByte(((v >> (i * 8)) & 0xff).toInt)

      dut.io.btn.poke(0.U)
      dut.io.rx.poke(1.U)
      dut.clock.step(BIT_CNT)

      // Boot protocol: magic, then each instruction as [address LE][data LE],
      // then the done word (address 0, data DONE_MAGIC) to release the CPU.
      send32LE(START_MAGIC)
      for ((addr, instr) <- program) {
        send32LE(addr)
        send32LE(instr)
      }
      send32LE(0x00000000L) // done address
      send32LE(DONE_MAGIC)  // done data -> starts the CPU

      // Let the done word propagate (Rx -> bootloader -> cpuRunning) and the
      // 3-stage pipeline execute the straight-line code into its spin loop.
      dut.clock.step(200)

      assert(dut.io.cpuRunning.peekBoolean(), "CPU was not released after the done word")

      assert(dut.io.regFile(1).peekInt() == BigInt(0x111), "x1 mismatch")
      assert(dut.io.regFile(2).peekInt() == BigInt(0x222), "x2 mismatch")
      assert(
        dut.io.regFile(3).peekInt() == BigInt(0x333),
        s"x3 mismatch: the core did not compute 0x111 + 0x222 (got 0x${dut.io.regFile(3).peekInt().toString(16)})"
      )
    }
  }
}
