package rvsoc

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class ButtonDebouncerTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "ButtonDebouncer"

  it should "ignore short pulses" in {
    test(new ButtonDebouncer(width = 1, stableCycles = 3)) { dut =>
      dut.io.in.poke(0.U)
      dut.clock.step(3)
      dut.io.out.expect(0.U)

      dut.io.in.poke(1.U)
      dut.clock.step(2)
      dut.io.in.poke(0.U)
      dut.clock.step(4)

      dut.io.out.expect(0.U)
    }
  }

  it should "accept a stable press after the debounce window" in {
    test(new ButtonDebouncer(width = 1, stableCycles = 3)) { dut =>
      dut.io.in.poke(0.U)
      dut.clock.step(3)

      dut.io.in.poke(1.U)
      dut.clock.step(5)

      dut.io.out.expect(1.U)
    }
  }

  it should "accept a stable release after the debounce window" in {
    test(new ButtonDebouncer(width = 1, stableCycles = 3)) { dut =>
      dut.io.in.poke(1.U)
      dut.clock.step(5)
      dut.io.out.expect(1.U)

      dut.io.in.poke(0.U)
      dut.clock.step(5)

      dut.io.out.expect(0.U)
    }
  }

  it should "debounce bits independently" in {
    test(new ButtonDebouncer(width = 2, stableCycles = 3)) { dut =>
      dut.io.in.poke(0.U)
      dut.clock.step(3)

      dut.io.in.poke("b01".U)
      dut.clock.step(5)
      dut.io.out.expect("b01".U)

      dut.io.in.poke("b11".U)
      dut.clock.step(2)
      dut.io.out.expect("b01".U)

      dut.clock.step(3)
      dut.io.out.expect("b11".U)
    }
  }

  it should "use the configured initial value" in {
    test(new ButtonDebouncer(width = 2, stableCycles = 3, initialValue = 3)) { dut =>
      dut.io.out.expect("b11".U)
    }
  }
}
