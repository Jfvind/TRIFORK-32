package rvsoc

import chisel3._
import chisel3.util._

// 1. The BlackBox: Tells Chisel about the Xilinx XADC IP (Build.tcl generates the xadc_wiz_0 component in Vivado)
class xadc_wiz_0 extends BlackBox {
  val io = IO(new Bundle {
    val dclk_in         = Input(Clock())
    val reset_in        = Input(Bool())
    
    // Analog input pins (Basys3 JXADC header) (Positive(above) and Negative(below))
    val vauxp6          = Input(Bool()) 
    val vauxn6          = Input(Bool())
    val vauxp14         = Input(Bool())
    val vauxn14         = Input(Bool())
    val vauxp7          = Input(Bool())
    val vauxn7          = Input(Bool())
    val vauxp15         = Input(Bool())
    val vauxn15         = Input(Bool())
    
    // Dynamic Reconfiguration Port (DRP) to read data
    val daddr_in        = Input(UInt(7.W))   // Address to internal register
    val den_in          = Input(Bool())      // Enable (We wan't to read/write)
    val di_in           = Input(UInt(16.W))  // Input data
    val dwe_in          = Input(Bool())      // Write enable
    val do_out          = Output(UInt(16.W)) // Output data
    val drdy_out        = Output(Bool())     // Ready data
    
    // Default
    val vp_in           = Input(Bool()) // Hardwired ports to XADC module in Artix7
    val vn_in           = Input(Bool())
  })
}

// 2. The Chisel Controller: Fetches data via the DRP and exposes it to Rust
class AdcController extends Module {
  val io = IO(new Bundle {
    val vauxp6          = Input(Bool())
    val vauxn6          = Input(Bool())
    val vauxp14         = Input(Bool())
    val vauxn14         = Input(Bool())
    val vauxp7          = Input(Bool())
    val vauxn7          = Input(Bool())
    val vauxp15         = Input(Bool())
    val vauxn15         = Input(Bool())

    val adcData0        = Output(UInt(16.W)) // VAUX6
    val adcData1        = Output(UInt(16.W)) // VAUX14
    val adcData2        = Output(UInt(16.W)) // VAUX7
    val adcData3        = Output(UInt(16.W)) // VAUX15
  })

  // Instantiate the BlackBox
  val xadc = Module(new xadc_wiz_0())
  
  // Wire clocks and static defaults
  xadc.io.dclk_in  := clock
  xadc.io.reset_in := reset.asBool
  xadc.io.vp_in    := false.B
  xadc.io.vn_in    := false.B

  // Wire analog inputs
  xadc.io.vauxp6   := io.vauxp6
  xadc.io.vauxn6   := io.vauxn6
  xadc.io.vauxp14  := io.vauxp14
  xadc.io.vauxn14  := io.vauxn14
  xadc.io.vauxp7   := io.vauxp7
  xadc.io.vauxn7   := io.vauxn7
  xadc.io.vauxp15  := io.vauxp15
  xadc.io.vauxn15  := io.vauxn15

  // DRP adresses for VAUX 6, 14, 7, 15
  val drpAddrs = VecInit("h16".U(7.W), "h1E".U(7.W), "h17".U(7.W), "h1F".U(7.W))
  
  // Registers to hold output digital data
  val dataReg = RegInit(VecInit(Seq.fill(4)(0.U(16.W))))

  // State Machine for DRP Bus
  val request :: wait :: Nil = Enum(2)
  val state = RegInit(request)
  val auxIdx = RegInit(0.U(2.W))

  xadc.io.daddr_in := drpAddrs(auxIdx)
  xadc.io.di_in    := 0.U     // Not used (We only read, not write)
  xadc.io.dwe_in   := false.B // Read only, never write
  xadc.io.den_in   := (state === request)


  switch(state) {
    is(request) {
      state := wait // DRP Enable high for 1 cycle
    }
    is(wait) {
      // drdy_out pulses high when the DRP spits out the data
      when(xadc.io.drdy_out) {
        dataReg(auxIdx) := xadc.io.do_out // Capture the 16-bit analog value
        auxIdx := auxIdx + 1.U // Next channel
        state := request
      }
    }
  }

  // Only the upper 12 bits of the XADC output contain the actual analog data.
  // We shift it right by 4 so it's a clean 0 to 4095 value for the Rust code.
  io.adcData0 := dataReg(0) >> 4
  io.adcData1 := dataReg(1) >> 4
  io.adcData2 := dataReg(2) >> 4
  io.adcData3 := dataReg(3) >> 4 
}