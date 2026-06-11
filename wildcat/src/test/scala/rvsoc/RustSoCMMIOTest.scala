package rvsoc

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

/**
 * MMIO-decode fidelity test.
 *
 * Uploads a program (over the real UART bootloader) that exercises the SoC's
 * memory-mapped I/O decoder with both writes and reads on two different decode
 * paths, then checks the results on observable signals:
 *
 *   - LED register  (modSel 1, write)  -> observed on io.led
 *   - GPIO JA OUT   (modSel 5, write)  -> read back by the CPU
 *   - GPIO JA OUT   (modSel 5, read)   -> result in the register file
 *
 * Proves the address decode (modSel / offset) and the delayed-read path drive
 * the right registers — through the real CPU executing real load/store
 * instructions. Runs on Treadle (the sim-model SoC has no BlackBox/Analog).
 */
class RustSoCMMIOTest extends AnyFlatSpec with ChiselScalatestTester {

  val frequ   = 3000000
  val baud    = 115200
  val BIT_CNT = (frequ + baud / 2) / baud - 1

  val START_MAGIC = 0xB00710ADL
  val DONE_MAGIC  = 0xD0000000L

  // Program (hand-assembled RV32I):
  //   lui  x1, 0xF0100      ; x1 = LED base   (0xF010_0000)
  //   addi x2, x0, 0x2AB    ; x2 = 0x2AB
  //   sw   x2, 0(x1)        ; LED   <- 0x2AB         (modSel 1 write -> io.led)
  //   lui  x3, 0xF0500      ; x3 = GPIO JA base (0xF050_0000)
  //   sw   x2, 4(x3)        ; JA OUT <- 0xAB         (modSel 5 write, 8-bit reg)
  //   lw   x4, 4(x3)        ; x4 <- JA OUT           (modSel 5 read)
  //   jal  x0, 0            ; spin
  val program = Seq(
    (0x00L, 0xF01000B7L),
    (0x04L, 0x2AB00113L),
    (0x08L, 0x0020A023L),
    (0x0CL, 0xF05001B7L),
    (0x10L, 0x0021A223L),
    (0x14L, 0x0041A203L),
    (0x18L, 0x0000006FL)
  )

  "RustSoCTop MMIO decoder" should "route CPU loads/stores to the right registers" in {
    test(new RustSoCTestTop(frequ, baud)) { dut =>
      def sendByte(b: Int): Unit = {
        dut.io.rx.poke(1.U)
        dut.clock.step(BIT_CNT)
        dut.io.rx.poke(0.U)
        dut.clock.step(BIT_CNT)
        for (i <- 0 until 8) {
          dut.io.rx.poke(((b >> i) & 1).U)
          dut.clock.step(BIT_CNT)
        }
        dut.io.rx.poke(1.U)
        dut.clock.step(BIT_CNT)
      }
      def send32LE(v: Long): Unit =
        for (i <- 0 until 4) sendByte(((v >> (i * 8)) & 0xff).toInt)

      dut.io.btn.poke(0.U)
      dut.io.rx.poke(1.U)
      dut.clock.step(BIT_CNT)

      send32LE(START_MAGIC)
      for ((addr, instr) <- program) {
        send32LE(addr)
        send32LE(instr)
      }
      send32LE(0x00000000L)
      send32LE(DONE_MAGIC)

      dut.clock.step(200)

      assert(dut.io.cpuRunning.peekBoolean(), "CPU was not released after the done word")
      // modSel 1 write reached the LED register and the output pin.
      assert(
        dut.io.led.peekInt() == BigInt(0x2AB),
        s"LED MMIO write/decode failed (io.led = 0x${dut.io.led.peekInt().toString(16)})"
      )
      // modSel 5 write then read round-tripped through the GPIO OUT register
      // (8-bit, so 0x2AB is truncated to 0xAB).
      assert(
        dut.io.regFile(4).peekInt() == BigInt(0xAB),
        s"GPIO MMIO write/read decode failed (x4 = 0x${dut.io.regFile(4).peekInt().toString(16)})"
      )
    }
  }
}
