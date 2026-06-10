package rvsoc

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

import scala.collection.mutable

/**
 * Test suite for I2cController.
 *
 * Models a simple I2C bus with one slave (default address 0x5C).
 * Bus is open-drain: line is HIGH unless someone drives it LOW.
 *
 * Debug flags below let you turn on per-cycle tracing for slave events,
 * harness signals, or the slave's ACK driving. Set to true when debugging
 * a specific test failure, false otherwise.
 */
class I2cControllerTest extends AnyFlatSpec with ChiselScalatestTester {

  // ============================================================
  // Debug flags — set to true to enable verbose logging
  // ============================================================
  // Logs slave events: START detected, bit samples, address match, etc.
  val DEBUG_SLAVE_EVENTS = false

  // Logs slave ACK driving cycle-by-cycle (very verbose, use only for
  // debugging slave timing issues).
  val DEBUG_SLAVE_ACK = false

  // Logs harness bus state every cycle: controller drive, slave drive,
  // final SDA/SCL, DUT status. EXTREMELY verbose - only enable when
  // debugging a specific timeout or sample-window issue.
  val DEBUG_HARNESS = false

  // I2C clock divider for fast simulation. Production = 500 (100 kHz at
  // 100 MHz system clock). For tests we use 4 -> phaseTarget = 2 cycles
  // per phase, so a full bit takes ~8 cycles.
  val TEST_CLKDIV = 4

  // ============================================================
  // Slave model
  // ============================================================
  class I2cSlave(val address: Int, val responseBytes: Seq[Int]) {
    val receivedBytes = mutable.ArrayBuffer[Int]()

    private object S extends Enumeration {
      val Idle, AddrShift, AddrAckPending, AddrAck, RxByte, RxAckPending, RxAck, TxByte, TxAck, Done = Value
    }
    private var state = S.Idle
    private var bitCount = 0
    private var shiftIn = 0
    private var shiftOut = 0
    private var responseIdx = 0
    private var isReading = false
    private var cycleCount = 0

    private var prevSda = true
    private var prevScl = true

    def step(currentSda: Boolean, currentScl: Boolean): Boolean = {
      cycleCount += 1
      val sdaFell = prevSda && !currentSda
      val sdaRose = !prevSda && currentSda
      val sclRose = !prevScl && currentScl
      val sclFell = prevScl && !currentScl
      val sclHigh = currentScl

      // Slave event logging
      if (DEBUG_SLAVE_EVENTS) {
        if (sdaFell && sclHigh) {
          println(s"[$cycleCount] SLAVE: START detected (was state=$state), -> AddrShift")
        }
        if (sclRose && state == S.AddrShift) {
          println(s"[$cycleCount] SLAVE: AddrShift sample SDA=$currentSda bit=$bitCount shiftIn=0x${shiftIn.toHexString}")
        }
        if (sclFell && state == S.AddrAck) {
          println(s"[$cycleCount] SLAVE: AddrAck SCL fell, transition out")
        }
      }

      // START / STOP detection
      if (sclHigh && sdaFell) {
        state = S.AddrShift
        bitCount = 0
        shiftIn = 0
      } else if (sclHigh && sdaRose && (state == S.RxByte || state == S.RxAck || state == S.Done)) {
        state = S.Idle
        if (DEBUG_SLAVE_EVENTS) println(s"[$cycleCount] SLAVE: STOP detected")
      }

      val drive = state match {
        case S.Idle => false

        case S.AddrShift =>
          if (sclRose) {
            shiftIn = (shiftIn << 1) | (if (currentSda) 1 else 0)
            bitCount += 1
            if (bitCount == 8) {
              val rxAddr = (shiftIn >> 1) & 0x7f
              isReading = (shiftIn & 1) == 1
              if (DEBUG_SLAVE_EVENTS) {
                println(s"[$cycleCount] SLAVE: full byte received shiftIn=0x${shiftIn.toHexString} addr=0x${rxAddr.toHexString} R/W=${if(isReading) "R" else "W"}")
              }
              if (rxAddr == address) {
                state = S.AddrAckPending
                if (DEBUG_SLAVE_EVENTS) println(s"[$cycleCount] SLAVE: address match, will ACK after SCL falls")
              } else {
                state = S.Done
                if (DEBUG_SLAVE_EVENTS) println(s"[$cycleCount] SLAVE: address mismatch (expected 0x${address.toHexString}), going silent")
              }
            }
          }
          false

        case S.AddrAckPending =>
          if (sclFell) {
            state = S.AddrAck
            if (DEBUG_SLAVE_EVENTS) println(s"[$cycleCount] SLAVE: SCL fell after bit 8, now driving ACK")
          }
          false

        case S.AddrAck =>
          if (DEBUG_SLAVE_ACK) println(s"[$cycleCount] SLAVE: AddrAck driving SDA LOW")
          if (sclFell) {
            if (isReading) {
              state = S.TxByte
              bitCount = 0
              shiftOut = if (responseIdx < responseBytes.length) {
                val b = responseBytes(responseIdx); responseIdx += 1; b
              } else 0xff
            } else {
              state = S.RxByte
              bitCount = 0
              shiftIn = 0
            }
          }
          true

        case S.RxByte =>
          if (sclRose) {
            shiftIn = (shiftIn << 1) | (if (currentSda) 1 else 0)
            bitCount += 1
            if (bitCount == 8) {
              receivedBytes += shiftIn
              state = S.RxAckPending
              if (DEBUG_SLAVE_EVENTS) println(s"[$cycleCount] SLAVE: data byte received 0x${shiftIn.toHexString}, will ACK after SCL falls")
            }
          }
          false

        case S.RxAckPending =>
          if (sclFell) {
            state = S.RxAck
            if (DEBUG_SLAVE_EVENTS) println(s"[$cycleCount] SLAVE: SCL fell, now driving data ACK")
          }
          false

        case S.RxAck =>
          if (DEBUG_SLAVE_ACK) println(s"[$cycleCount] SLAVE: RxAck driving SDA LOW")
          if (sclFell) {
            state = S.RxByte
            bitCount = 0
            shiftIn = 0
          }
          true

        case S.TxByte =>
          val bit = (shiftOut >> (7 - bitCount)) & 1
          val driveLow = bit == 0
          if (sclFell) {
            bitCount += 1
            if (bitCount == 8) {
              state = S.TxAck
            }
          }
          driveLow

        case S.TxAck =>
          if (sclRose) {
            val masterNack = currentSda
            if (masterNack) {
              state = S.Done
            }
          }
          if (sclFell && state == S.TxAck) {
            state = S.TxByte
            bitCount = 0
            shiftOut = if (responseIdx < responseBytes.length) {
              val b = responseBytes(responseIdx); responseIdx += 1; b
            } else 0xff
          }
          false

        case S.Done => false
      }

      prevSda = currentSda
      prevScl = currentScl
      drive
    }
  }

  // ============================================================
  // Test harness
  // ============================================================
  class TestHarness(dut: I2cController, slave: I2cSlave) {
    private var slaveDrivesSda = false
    private var cycleCount = 0

    def configure(): Unit = {
      dut.io.clkDiv.poke(TEST_CLKDIV.U)
      dut.io.cmd.poke(0.U)
      dut.io.cmdValid.poke(false.B)
      dut.io.dataIn.poke(0.U)
      dut.io.sdaIn.poke(true.B)
      dut.io.sclIn.poke(true.B)
      dut.clock.step(1)
    }

    def stepBus(): Unit = {
      cycleCount += 1
      val ctrlSdaDrive = dut.io.sdaOe.peekBoolean() && !dut.io.sdaOut.peekBoolean()
      val ctrlSclDrive = dut.io.sclOe.peekBoolean() && !dut.io.sclOut.peekBoolean()

      val sclLine = !ctrlSclDrive
      val sdaProvisional = !ctrlSdaDrive && !slaveDrivesSda

      slaveDrivesSda = slave.step(sdaProvisional, sclLine)

      val sdaFinal = !ctrlSdaDrive && !slaveDrivesSda

      dut.io.sdaIn.poke(sdaFinal.B)
      dut.io.sclIn.poke(sclLine.B)

      if (DEBUG_HARNESS) {
        val status = dut.io.status.peekInt().toInt
        val sdaOe = dut.io.sdaOe.peekBoolean()
        val sclOe = dut.io.sclOe.peekBoolean()
        println(f"[$cycleCount] HARNESS: ctrlSdaDrive=$ctrlSdaDrive ctrlSclDrive=$ctrlSclDrive sdaFinal=$sdaFinal sclLine=$sclLine | DUT: sdaOe=$sdaOe sclOe=$sclOe status=0x$status%02X")
      }

      dut.clock.step(1)
    }

    def sendCmd(cmd: Int, data: Int = 0): Unit = {
      dut.io.cmd.poke(cmd.U)
      dut.io.dataIn.poke(data.U)
      dut.io.cmdValid.poke(true.B)
      stepBus()
      dut.io.cmdValid.poke(false.B)
      stepBus()
      var timeout = 5000
      while ((dut.io.status.peekInt().toInt & 1) != 0 && timeout > 0) {
        stepBus()
        timeout -= 1
      }
      assert(timeout > 0, s"Command 0x${cmd.toHexString} timed out (still BUSY)")
    }

    def start(): Unit = sendCmd(0x01)
    def stop(): Unit = sendCmd(0x02)
    def writeByte(b: Int): Boolean = {
      sendCmd(0x04, b)
      val nack = (dut.io.status.peekInt().toInt & 0x02) != 0
      !nack
    }
    def readByteAck(): Int = {
      sendCmd(0x08)
      dut.io.dataOut.peekInt().toInt
    }
    def readByteNack(): Int = {
      sendCmd(0x10)
      dut.io.dataOut.peekInt().toInt
    }
  }

  // ============================================================
  // TRIN 1: Basics
  // ============================================================
  behavior of "I2cController"

  it should "complete a single-byte write transaction with ACK" in {
    test(new I2cController(100_000_000, 100_000))
        .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val slave = new I2cSlave(0x5C, Seq.empty)
      val h = new TestHarness(dut, slave)
      h.configure()

      h.start()
      assert(h.writeByte((0x5C << 1) | 0), "Slave should ACK its address")
      assert(h.writeByte(0x42), "Slave should ACK data byte")
      h.stop()

      assert(slave.receivedBytes.toSeq == Seq(0x42),
        s"Got ${slave.receivedBytes.toSeq.map(b => f"0x$b%02X")}")
    }
  }

  it should "detect NACK from absent slave" in {
    test(new I2cController(100_000_000, 100_000))
        .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val slave = new I2cSlave(0x5C, Seq.empty)
      val h = new TestHarness(dut, slave)
      h.configure()

      h.start()
      assert(!h.writeByte((0x42 << 1) | 0), "Should NACK from wrong address")
      h.stop()
    }
  }

  it should "read a single byte and NACK it" in {
    test(new I2cController(100_000_000, 100_000))
        .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val slave = new I2cSlave(0x5C, Seq(0xA5))
      val h = new TestHarness(dut, slave)
      h.configure()

      h.start()
      assert(h.writeByte((0x5C << 1) | 1), "Address+R should ACK")
      val b = h.readByteNack()
      assert(b == 0xA5, f"Expected 0xA5, got 0x$b%02X")
      h.stop()
    }
  }

  it should "read multiple bytes with ACK on all but last" in {
    test(new I2cController(100_000_000, 100_000))
        .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val expected = Seq(0x03, 0x04, 0x01, 0x48, 0x00, 0xE4, 0x70, 0x49)
      val slave = new I2cSlave(0x5C, expected)
      val h = new TestHarness(dut, slave)
      h.configure()

      h.start()
      assert(h.writeByte((0x5C << 1) | 1), "Address+R should ACK")

      val received = mutable.ArrayBuffer[Int]()
      for (_ <- 0 until expected.length - 1) received += h.readByteAck()
      received += h.readByteNack()
      h.stop()

      for (i <- expected.indices) {
        assert(received(i) == expected(i),
          f"Byte $i: expected 0x${expected(i)}%02X, got 0x${received(i)}%02X. " +
          f"Full: ${received.toSeq.map(b => f"0x$b%02X").mkString(" ")}")
      }
    }
  }

  // ============================================================
  // TRIN 2: Repeated START
  // ============================================================

  it should "support repeated START after a write (write-then-read pattern)" in {
    test(new I2cController(100_000_000, 100_000))
        .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val slave = new I2cSlave(0x5C, Seq(0xDE, 0xAD))
      val h = new TestHarness(dut, slave)
      h.configure()

      h.start()
      assert(h.writeByte((0x5C << 1) | 0), "Address+W should ACK")
      assert(h.writeByte(0x10), "Register byte should ACK")

      h.start()
      assert(h.writeByte((0x5C << 1) | 1), "Address+R after repeated START should ACK")

      val b0 = h.readByteAck()
      val b1 = h.readByteNack()
      h.stop()

      assert(b0 == 0xDE, f"Byte 0: expected 0xDE, got 0x$b0%02X")
      assert(b1 == 0xAD, f"Byte 1: expected 0xAD, got 0x$b1%02X")
      assert(slave.receivedBytes.toSeq == Seq(0x10))
    }
  }

  it should "support repeated START after a read (liveness test pattern)" in {
    // Note: per I2C protocol, master must NACK the last read byte before
    // a repeated START so the slave releases SDA. The earlier hardware
    // liveness test used ACK followed by repeated START, which is a
    // protocol violation that some chips tolerate but others don't.
    test(new I2cController(100_000_000, 100_000))
        .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val slave = new I2cSlave(0x5C, Seq(0x03, 0x04))
      val h = new TestHarness(dut, slave)
      h.configure()

      h.start()
      assert(h.writeByte((0x5C << 1) | 1), "First Addr+R should ACK")
      val b0 = h.readByteNack()  // NACK to release slave's SDA
      assert(b0 == 0x03, f"Byte 0: expected 0x03, got 0x$b0%02X")

      h.start()  // Repeated START
      assert(h.writeByte((0x5C << 1) | 1), "Re-addr after repeated START should ACK")
      h.stop()
    }
  }

  // ============================================================
  // TRIN 3: Edge cases
  // ============================================================

  it should "handle multi-byte write and verify all bytes arrive" in {
    test(new I2cController(100_000_000, 100_000))
        .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val slave = new I2cSlave(0x5C, Seq.empty)
      val h = new TestHarness(dut, slave)
      h.configure()

      val payload = Seq(0x03, 0x00, 0x04)
      h.start()
      assert(h.writeByte((0x5C << 1) | 0), "Address should ACK")
      for (b <- payload) assert(h.writeByte(b), f"Byte 0x$b%02X should ACK")
      h.stop()

      assert(slave.receivedBytes.toSeq == payload,
        s"Got ${slave.receivedBytes.toSeq.map(b => f"0x$b%02X")}")
    }
  }

  it should "handle rapid back-to-back transactions" in {
    test(new I2cController(100_000_000, 100_000))
        .withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val slave = new I2cSlave(0x5C, Seq(0xCC))
      val h = new TestHarness(dut, slave)
      h.configure()

      h.start()
      assert(h.writeByte((0x5C << 1) | 0))
      assert(h.writeByte(0xAA))
      h.stop()

      h.start()
      assert(h.writeByte((0x5C << 1) | 1))
      val b = h.readByteNack()
      h.stop()

      assert(b == 0xCC, f"Expected 0xCC, got 0x$b%02X")
      assert(slave.receivedBytes.toSeq == Seq(0xAA))
    }
  }
}