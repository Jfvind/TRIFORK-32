package rvsoc

import chisel3._
import chisel3.util._

class ButtonDebouncer(width: Int, stableCycles: Int = 1_000_000, initialValue: BigInt = 0) extends Module {
  require(width > 0, "ButtonDebouncer width must be positive")
  require(stableCycles > 0, "ButtonDebouncer stableCycles must be positive")
  require(initialValue >= 0 && initialValue < (BigInt(1) << width), "ButtonDebouncer initialValue must fit width")

  val io = IO(new Bundle {
    val in  = Input(UInt(width.W))
    val out = Output(UInt(width.W))
  })

  val sync0 = RegNext(io.in, initialValue.U(width.W))
  val sync1 = RegNext(sync0, initialValue.U(width.W))

  val counterWidth = log2Ceil(stableCycles + 1).max(1)
  val counters = RegInit(VecInit(Seq.fill(width)(0.U(counterWidth.W))))
  val stable = RegInit(VecInit((0 until width).map { i =>
    if (((initialValue >> i) & 1) == 1) true.B else false.B
  }))

  for (i <- 0 until width) {
    when(sync1(i) === stable(i)) {
      counters(i) := 0.U
    }.elsewhen(counters(i) === (stableCycles - 1).U(counterWidth.W)) {
      stable(i) := sync1(i)
      counters(i) := 0.U
    }.otherwise {
      counters(i) := counters(i) + 1.U
    }
  }

  io.out := stable.asUInt
}
