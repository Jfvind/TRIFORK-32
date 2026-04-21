package wildcat.pipeline

import chisel3._
import chisel3.util._
import wildcat.CSR._

/**
 * Control and Status Registers
 *
 * If needed, we can pipeline the read access to the CSR.
 * Can be done in the pipeline itself.
 */
class Csr() extends Module {
  val io = IO(new Bundle {
    val address = Input(UInt(12.W))
    val data = Output(UInt(32.W))
  })

  // 64-bit cycle counter that increments every clock cycle.
  // Used by Rust code via rdcycle/rdcycleh for precise timing
  // /(e.g. I2C bit timing, delay_us, delay_ms).
  val cycleCounter = RegInit(0.U(64.W))
  cycleCounter := cycleCounter + 1.U

  val data = WireDefault(0.U(32.W))


  switch(io.address) {
    is(CYCLE.U) {
      data := cycleCounter(31, 0)
    }
    is(CYCLEH.U) {
      data := cycleCounter(63, 32)
    }
    is(TIME.U) {
      data := cycleCounter(31, 0)
    }
    is(TIMEH.U) {
      data := cycleCounter(63, 32)
    }
    is(MCYCLE.U) {
      data := 0.U
    }
    is(MCYCLEH.U) {
      data := 0.U
    }
    is(MTIME.U) {
      data := 0.U
    }
    is(MTIMEH.U) {
      data := 0.U
    }
    is(MARCHID.U) {
      data := WILDCAT_MARCHID.U
    }
  }

  io.data := data
}
