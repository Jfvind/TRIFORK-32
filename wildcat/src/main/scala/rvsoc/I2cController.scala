 package rvsoc

import chisel3._
import chisel3.util._

/**
 * I2cController — Single-master I2C controller for the Wildcat RISC-V SoC.
 *
 * Features:
 *   - Single master, 7-bit addressing
 *   - Standard mode (100 kHz) by default, configurable via clock divider
 *   - Clock stretching support (waits for slave to release SCL)
 *   - NACK detection after writes
 *   - Open-drain output emulation via tristate signals
 *
 * The controller exposes a simple command/status/data interface to the CPU.
 * The CPU writes primitive commands (START, STOP, WRITE, READ_ACK, READ_NACK)
 * to the CMD register, polls the BUSY bit in STATUS until clear, and then
 * reads or writes the DATA register as appropriate.
 *
 * A typical write-one-byte-to-register transaction from Rust:
 *   1. CMD = START        → wait BUSY=0
 *   2. DATA = (addr<<1)|0 → CMD = WRITE → wait BUSY=0 → check NACK
 *   3. DATA = reg_addr    → CMD = WRITE → wait BUSY=0
 *   4. DATA = value       → CMD = WRITE → wait BUSY=0
 *   5. CMD = STOP         → wait BUSY=0
 */

// Command codes written to I2C_CMD register. These are one-hot encoded for
// easy decoding in the state machine.
object I2cCmd {
  val START     = 0x01
  val STOP      = 0x02
  val WRITE     = 0x04
  val READ_ACK  = 0x08  // Read byte, master sends ACK (more bytes coming)
  val READ_NACK = 0x10  // Read byte, master sends NACK (last byte)
}

// Status register bit positions (returned when CPU reads I2C_STATUS).
object I2cStatus {
  val BUSY    = 0  // bit 0: controller is executing a command
  val NACK    = 1  // bit 1: last WRITE received NACK from slave
  val BUS_ERR = 2  // bit 2: clock stretching timeout or other bus fault
}

/**
 * I2C controller module.
 *
 * @param systemClockHz  system clock frequency in Hz (default 100 MHz for Basys3)
 * @param defaultI2cHz   default SCL frequency in Hz (default 100 kHz, standard mode)
 */

class I2cController(systemClockHz: Int = 100_000_000,
                    defaultI2cHz: Int = 100_000) extends Module {
    
  val io = IO(new Bundle {
    // ---- CPU-side interface (memory-mapped register access) ----
    val cmd         = Input(UInt(8.W))  // Command code written by CPU
    val cmdValid    = Input(Bool())     // Pulse high for one cycle to start cmd
    val dataIn      = Input(UInt(8.W))  // Byte to transmit (for WRITE)
    val dataOut     = Output(UInt(8.W)) // Byte received (for READ_ACK/READ_NACK)
    val status      = Output(UInt(8.W)) // Status register (BUSY, NACK, BUS_ERR)
    val clkDiv      = Input(UInt(16.W)) // Clock divider (0 = use deafault)

    // ---- Bus-side interface (tristate emulation for open-drain I2C pins) ----
    val sdaOut      = Output(Bool())    // What to drive on SDA when oe=1
    val sdaOe       = Output(Bool())    // Output enable: 1=drive, 0=tristate
    val sdaIn       = Input(Bool())     // Actual SDA line state (read back)

    val sclOut      = Output(Bool())    // What to drive on SCL when oe=1
    val sclOe       = Output(Bool())    // Output enable
    val sclIn       = Input(Bool())     // Actual SCL line state (to register clock stretching from slave)  
  })

  // -------- Internal state definitions for statemachine --------

  object State extends ChiselEnum {
    val sIdle, sStart, sStop, sWrite, sWriteAck, sRead, sReadAck = Value
  }
  import State._ // enables us to write 'sIdle' insted of State.sIdle

  // -------- Internal registers --------

  // Current state of the state machine
  val state = RegInit(sIdle)

  // Clock divider counter: counts system cycles within each phase
  val tickCounter = RegInit(0.U(16.W))

  // Phase within one I2C bit: 0=LOW+setup, 1=HIGH+sample, 2=HIGH+stretch-check, 3=LOW
  val phase = RegInit(0.U(2.W))

  // Bit counter for WRITE/READ: counts from 0 (MSB) to 7 (LSB), then 8 for ACK
  val bitCounter = RegInit(0.U(4.W))

  // Shift register for transmitting a byte (WRITE) or receiving one (READ)
  val shiftReg = RegInit(0.U(8.W))

  // Output driver registers (what we actually put on the bus)
  val sdaOeReg = RegInit(false.B) // false = tristate (line HIGH via pull-up)
  val sclOeReg = RegInit(false.B)

  // Status flag registers
  val busyReg = RegInit(false.B)
  val nackReg = RegInit(false.B)
  val busErrReg = RegInit(false.B)

  // Clock divider value (From CPU, or default if CPU wrote 0)
  val clkDivEffective = Mux(io.clkDiv === 0.U, (systemClockHz / defaultI2cHz / 2).U,
                                               io.clkDiv)
  val phaseTarget = clkDivEffective >> 1 // clkDivEffective / 2

  // -------- Default  assignments (prevent latches) --------

  io.sdaOut := false.B // We never drive HIGH actively
  io.sclOut := false.B // Same for SCL
  io.sdaOe := sdaOeReg
  io.sclOe := sclOeReg
  io.dataOut := shiftReg
  io.status := Cat(0.U(5.W), busErrReg, nackReg, busyReg)
  // Status bit layout: [unused | BUS_ERR | NACK | BUSY]

  // -------- Tick counter and phase advancement --------
  //
  // The tick counter increments every system clock cycle. When it reaches
  // phaseTarget, we advance to the next phase of the I2C bit. Phase cycle
  // 0 -> 1 -> 2 -> 3 - > 0 continously while we're in a bit-transfering state.
  //
  // In sIdle, sStart, and sStop we don't use the full 4-phase cycle, so
  // the state machine may reset these counters directly

  val phaseAdvance = tickCounter === phaseTarget - 1.U

  when(phaseAdvance) {
    tickCounter := 0.U
    phase := phase + 1.U
  }.otherwise {
    tickCounter := tickCounter + 1.U
  }

  // -------- State machine --------
  switch(state) {
    is(sIdle) {
      // Bus state (sdaOeReg, sclOeReg) is preserved from the previous state.
      // Releasing the lines here would let pull-ups raise SDA while SCL is
      // still high after a START or between bytes, which I2C interprets as
      // an unintended STOP condition. Each terminating state (sStop) must
      // explicitly release the lines when the transaction is genuinely done.
      busyReg := false.B

      // Reset counter so new command starts fresh
      tickCounter := 0.U
      phase := 0.U
      bitCounter := 0.U

      // React to new command when cmdValid pulses
      when(io.cmdValid){
        busyReg := true.B
        nackReg := false.B // Clear NACK flag bit at start of new command

        switch(io.cmd) {
          is(I2cCmd.START.U) { state := sStart }
          is (I2cCmd.STOP.U) { state := sStop }
          is (I2cCmd.WRITE.U) {
            shiftReg := io.dataIn // load byte to transmit
            state := sWrite
          }
          is (I2cCmd.READ_ACK.U) { state := sRead }
          is (I2cCmd.READ_NACK.U) { state := sRead }
        }
      }
    }

    // ---- sStart: generate START condition -----
    // Assumes bus is idle (SDA = HIGH, SCL = HIGH) when entering.
    //  Phase 0: pull SDA LOW while SCL is HIGH -> START condition
    //  Phase 1: pull SCL LOW, ready for first bit
    //  Phase 2,3: (unused, go to idle immediately)
    is(sStart) {
      when(phase === 0.U) {
        sdaOeReg := true.B // Drive SDA LOW
        sclOeReg := false.B // SCL stays HIGH
      }.elsewhen(phase === 1.U) {
        sdaOeReg := true.B // stays LOW
        sclOeReg := true.B // pull SCL LOW
      }.otherwise {
        // Phase 2 or 3: START is complete, return to idle
        state := sIdle
      }
    }

    // ---- sStop: generate STOP condition ----
    // Assumes we just finished a byte/ACK, so SCL=LOW and SDA=unkown
    //  Phase 0: drive SDA LOW (make shure it's LOW before SCL rises)
    //  Phase 1: release SCL (goes HIGH via pull-up)
    //  Phase 2: release SDA (goes HIGH while SCL is HIGH  -> STOP condition)
    //  Phase 3: done
    is(sStop) {
      when(phase === 0.U) {
        sdaOeReg := true.B // Drive SDA LOW
        sclOeReg := true.B // Keep SCL LOW
      }.elsewhen(phase === 1.U) {
        sdaOeReg := true.B // SDA stays LOW
        sclOeReg := false.B // Release SCL (goes HIGH)

        // Check for clock stretching
        when (!io.sclIn) {
          // Slave holding SCL LOW - dont advance yet
          phase := phase // stay in this phase
          tickCounter := 0.U
        }
      }.elsewhen(phase === 2.U) {
        sdaOeReg := false.B // Release SDA (goes HIGH -> STOP)
        sclOeReg := false.B // SCL stays HIGH
      }.otherwise {
        // Phase 3: STOP complete, return to idle
        state := sIdle
      }
    }

    // ---- sWrite: shift 8 bits out on SDA ----
    //  Phase 0: SCL LOW, set SDA to MSB of shiftReg
    //  Phase 1: release SCL (goes HIGH), receive samples, check clock stretching
    //  Phase 2: SCL still HIGH
    //  Phase 3: drive SCL LOW, shift to next bit
    is(sWrite) {
      val currentBit = shiftReg(7) // MSB of remaining byte

      when(phase === 0.U) {
        // Set SDA according to the bit we're sending
        sdaOeReg := !currentBit // If currentbit is 1, oe=0 (release) --> SDA goes high and vice versa
        sclOeReg := true.B // SCL LOW
      }.elsewhen(phase === 1.U) {
        sdaOeReg := !currentBit // SDA does not change
        sclOeReg := false.B // release SCL (HIGH) 

        // Check for clock stretching
        when(!io.sclIn) {
          phase := phase
          tickCounter := 0.U
        }
      }.elsewhen(phase === 2.U) {
        sdaOeReg := !currentBit
        sclOeReg := false.B // SCL still HIGH

      }.otherwise {
        // Phase 3: SCL goes LOW, prepare for next bit
        sclOeReg := true.B

        // on the last tick of phase 3, advance to next bit
        when(phaseAdvance) {
          when(bitCounter === 7.U) {
            // All 8 bits sent, go to ACK phase
            bitCounter := 0.U
            state := sWriteAck
          }.otherwise {
            // Shift left to expose next bit as MSB
            shiftReg := Cat(shiftReg(6, 0), 0.U(1.W))
            bitCounter := bitCounter + 1.U
          }
        }
      }
    }

    // ---- sWriteAck: 9th cycle, read ACK from slave ----
    //  Phase 0: release SDA (slave will drive it)
    //  Phase 1: release SCL, sample SDA (0=ACK, 1=NACK), check stretching
    //  Phase 2: SCL still HIGH (hold time)
    //  Phase 3: drive SCL LOW, return to idle
    is(sWriteAck) {
      when(phase === 0.U) {
        sdaOeReg := false.B // Master release SDA (slave takes over)
        sclOeReg := true.B  // SCL LOW
      }.elsewhen(phase === 1.U) {
        sdaOeReg := false.B
        sclOeReg := false.B // Release SCL

        when(!io.sclIn) {
          phase := phase
          tickCounter := 0.U
        }.otherwise {
          // SCL is HIGH, sample the ACK bit
          nackReg := io.sdaIn // 0=ACK (good), 1 NACK (bad)
        }
      }.elsewhen(phase === 2.U) {
        sdaOeReg := false.B
        sclOeReg := false.B
      }.otherwise {
        // Phase 3: SCL LOW, return to idle
        sclOeReg := true.B
        when(phaseAdvance) {
          state := sIdle
        }
      }
    }

    // ---- sRead: shift 8 bits in from SDA ----
    //  Phase 0: release SDA (slave drives it), SCL LOW
    //  Phase 1: release SCL, check for clock stretching, sample SDA into shiftReg
    //  Phase 2: SCL still HIGH (hold time)
    //  Phase 3: drive SCL LOW, prepare for next bit
    is(sRead) {
      when(phase === 0.U) {
        sdaOeReg := false.B // Release SDA
        sclOeReg := true.B // SCL LOW
      }.elsewhen(phase === 1.U) {
        sdaOeReg := false.B
        sclOeReg := false.B // release SCL (HIGH)

        when(!io.sclIn) {
          phase := phase
          tickCounter := 0.U
        }.otherwise {
          // sample SDA and shift into shiftReg
          shiftReg := Cat(shiftReg(6, 0), io.sdaIn)
        }
      }.elsewhen(phase === 2.U) {
        sdaOeReg := false.B
        sclOeReg := false.B
      }.otherwise {
        // Phase 3: SCL LOW
        sclOeReg := true.B
      
        when(phaseAdvance) {
          when(bitCounter === 7.U) {
            bitCounter := 0.U
            state := sReadAck
          }.otherwise {
            bitCounter := bitCounter  + 1.U
          }
        }
      }
    }

    // ---- sReadAck: 9th cycle, send ACK or NACK to slave ----
    // Master decides based on whether cmd was READ_ACK or READ_NACK
    // ACK = drive SDA LOW ("give me more")
    // NACK = release SDA ("that was the last byte")
    is(sReadAck) {
      val sendAck = io.cmd === I2cCmd.READ_ACK.U


      when(phase === 0.U) {
        sdaOeReg := sendAck // ACK=drive LOW, NACK=release
        sclOeReg := true.B //  SCL LOW
      }.elsewhen(phase === 1.U) {
        sdaOeReg := sendAck
        sclOeReg := false.B // Release SCL (HIGH)

        when(!io.sclIn) {
          phase := phase
          tickCounter := 0.U
        }
      }.elsewhen(phase === 2.U) {
        sdaOeReg := sendAck
        sclOeReg := false.B
      }.otherwise {
        // Phase 3: done
        sclOeReg := true.B
        sdaOeReg := false.B // Release SDA

        when(phaseAdvance) {
          state := sIdle
        }

      }
    }
  }
}