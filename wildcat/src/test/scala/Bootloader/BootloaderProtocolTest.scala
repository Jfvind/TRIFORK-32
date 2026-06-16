package Bootloader

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

import scala.collection.mutable.ArrayBuffer

/**
 * Drives BootloaderTop with the exact byte framing the host `uploader` produces
 * ([start magic][address LE][data LE] ...) and checks that every 8-byte frame is
 * decoded back into the original (address, data) instruction write.
 *
 * This is the receive-side counterpart to the uploader's `frame_binary` /
 * `word_payload` unit tests: together they verify that the bytes the Rust
 * toolchain emits are exactly the instruction words written into the core's
 * memory — i.e. the user's program is what reaches the soft-core.
 *
 * Runs on the default (Treadle) backend, so no Verilator is required.
 */
class BootloaderProtocolTest extends AnyFlatSpec with ChiselScalatestTester {

  // A low clock frequency keeps the UART bit period short so the whole stream
  // loads in a few thousand simulated cycles (same trick as BootloaderTopTest).
  val frequ   = 3000000
  val baud    = 115200
  val BIT_CNT = (frequ + baud / 2) / baud - 1

  // Magic that moves the bootloader out of Sleep (sent little-endian).
  val START_MAGIC = 0xB00710ADL

  // (address, data) words to load. Mirrors the host-side test: one IMEM
  // instruction word and one DMEM data word across the 0x4000 boundary.
  val words = Seq(
    (0x00000000L, 0x11100093L), // addi x1, x0, 0x111  -> IMEM
    (0x00004000L, 0xDEADBEEFL)  // data word           -> DMEM
  )

  "BootloaderTop" should "decode uploader frames into the original (address, data) writes" in {
    test(new BootloaderTop(frequ, baud)) { dut =>
      // Every write the bootloader asserts (wrEnabled pulse) is captured here.
      val captured = ArrayBuffer[(BigInt, BigInt)]()

      // Step `n` cycles one at a time, recording any one-cycle wrEnabled pulse
      // together with the decoded address/data so no pulse is stepped over.
      def stepWatch(n: Int): Unit = {
        for (_ <- 0 until n) {
          if (dut.io.wrEnabled.peekInt() == 1) {
            captured += ((dut.io.instrAddr.peekInt(), dut.io.instrData.peekInt()))
          }
          dut.clock.step(1)
        }
      }

      // Send one UART byte: idle-high, start bit, 8 data bits LSB-first, stop bit.
      def sendByte(b: Int): Unit = {
        dut.io.rx.poke(1.U)
        stepWatch(BIT_CNT)
        dut.io.rx.poke(0.U) // start bit
        stepWatch(BIT_CNT)
        for (i <- 0 until 8) {
          dut.io.rx.poke(((b >> i) & 1).U)
          stepWatch(BIT_CNT)
        }
        dut.io.rx.poke(1.U) // stop bit
        stepWatch(BIT_CNT)
      }

      // Send a 32-bit value little-endian (low byte first), like the uploader.
      def send32LE(v: Long): Unit =
        for (i <- 0 until 4) sendByte(((v >> (i * 8)) & 0xff).toInt)

      dut.io.rx.poke(1.U)
      dut.clock.step(BIT_CNT)

      // Start magic, then each word as [address LE][data LE].
      send32LE(START_MAGIC)
      for ((addr, data) <- words) {
        send32LE(addr)
        send32LE(data)
      }

      // Flush so the final wrEnabled pulse is observed.
      stepWatch(BIT_CNT * 4)

      val expected = words.map { case (a, d) => (BigInt(a), BigInt(d)) }
      assert(
        captured == expected,
        s"decoded writes did not match frames sent:\n  got      $captured\n  expected $expected"
      )
    }
  }
}
