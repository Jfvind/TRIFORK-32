module Rx(
  input        clock,
  input        reset,
  input        io_rxd, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 66:14]
  input        io_channel_ready, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 66:14]
  output       io_channel_valid, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 66:14]
  output [7:0] io_channel_bits // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 66:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  reg  rxReg_REG; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 75:30]
  reg  rxReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 75:22]
  reg  falling_REG; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 76:35]
  wire  falling = ~rxReg & falling_REG; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 76:24]
  reg [7:0] shiftReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 78:25]
  reg [19:0] cntReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 79:23]
  reg [3:0] bitsReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 80:24]
  reg  valReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 81:23]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 84:22]
  wire [7:0] _shiftReg_T_1 = {rxReg,shiftReg[7:1]}; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 87:20]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 88:24]
  wire  _GEN_0 = bitsReg == 4'h1 | valReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 90:27 91:14 81:23]
  assign io_channel_valid = valReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 103:20]
  assign io_channel_bits = shiftReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 102:19]
  always @(posedge clock) begin
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 75:30]
      rxReg_REG <= 1'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 75:30]
    end else begin
      rxReg_REG <= io_rxd; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 75:30]
    end
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 75:22]
      rxReg <= 1'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 75:22]
    end else begin
      rxReg <= rxReg_REG; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 75:22]
    end
    falling_REG <= rxReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 76:35]
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 78:25]
      shiftReg <= 8'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 78:25]
    end else if (!(cntReg != 20'h0)) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 83:24]
      if (bitsReg != 4'h0) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 85:31]
        shiftReg <= _shiftReg_T_1; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 87:14]
      end
    end
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 79:23]
      cntReg <= 20'h363; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 79:23]
    end else if (cntReg != 20'h0) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 83:24]
      cntReg <= _cntReg_T_1; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 84:12]
    end else if (bitsReg != 4'h0) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 85:31]
      cntReg <= 20'h363; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 86:12]
    end else if (falling) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 93:23]
      cntReg <= 20'h514; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 94:12]
    end
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 80:24]
      bitsReg <= 4'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 80:24]
    end else if (!(cntReg != 20'h0)) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 83:24]
      if (bitsReg != 4'h0) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 85:31]
        bitsReg <= _bitsReg_T_1; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 88:13]
      end else if (falling) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 93:23]
        bitsReg <= 4'h8; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 95:13]
      end
    end
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 81:23]
      valReg <= 1'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 81:23]
    end else if (valReg & io_channel_ready) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 98:36]
      valReg <= 1'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 99:12]
    end else if (!(cntReg != 20'h0)) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 83:24]
      if (bitsReg != 4'h0) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 85:31]
        valReg <= _GEN_0;
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  rxReg_REG = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  rxReg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  falling_REG = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  shiftReg = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  cntReg = _RAND_4[19:0];
  _RAND_5 = {1{`RANDOM}};
  bitsReg = _RAND_5[3:0];
  _RAND_6 = {1{`RANDOM}};
  valReg = _RAND_6[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BootBuffer(
  input         clock,
  input         reset,
  input         io_saveCtrl, // @[\\src\\main\\scala\\Bootloader\\BootBuffer.scala 14:14]
  input  [7:0]  io_dataIn, // @[\\src\\main\\scala\\Bootloader\\BootBuffer.scala 14:14]
  output [63:0] io_dataOut // @[\\src\\main\\scala\\Bootloader\\BootBuffer.scala 14:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] buffer; // @[\\src\\main\\scala\\Bootloader\\BootBuffer.scala 20:23]
  wire [63:0] _buffer_T_1 = {io_dataIn,buffer[63:8]}; // @[\\src\\main\\scala\\Bootloader\\BootBuffer.scala 23:25]
  assign io_dataOut = buffer; // @[\\src\\main\\scala\\Bootloader\\BootBuffer.scala 26:14]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\Bootloader\\BootBuffer.scala 20:23]
      buffer <= 64'h0; // @[\\src\\main\\scala\\Bootloader\\BootBuffer.scala 20:23]
    end else if (io_saveCtrl) begin // @[\\src\\main\\scala\\Bootloader\\BootBuffer.scala 22:28]
      buffer <= _buffer_T_1; // @[\\src\\main\\scala\\Bootloader\\BootBuffer.scala 23:12]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  buffer = _RAND_0[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BootloaderTop(
  input         clock,
  input         reset,
  output [31:0] io_instrData, // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 21:14]
  output [31:0] io_instrAddr, // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 21:14]
  output        io_wrEnabled, // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 21:14]
  input         io_rx // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 21:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire  rx_clock; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 29:18]
  wire  rx_reset; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 29:18]
  wire  rx_io_rxd; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 29:18]
  wire  rx_io_channel_ready; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 29:18]
  wire  rx_io_channel_valid; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 29:18]
  wire [7:0] rx_io_channel_bits; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 29:18]
  wire  buffer_clock; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 30:22]
  wire  buffer_reset; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 30:22]
  wire  buffer_io_saveCtrl; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 30:22]
  wire [7:0] buffer_io_dataIn; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 30:22]
  wire [63:0] buffer_io_dataOut; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 30:22]
  reg  stateReg; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 37:25]
  reg  incr; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 39:21]
  reg  save; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 40:21]
  reg  wrEnabled; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 41:26]
  reg [3:0] byteCount; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 42:26]
  wire [3:0] _byteCount_T_1 = byteCount + 4'h1; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 45:28]
  wire [3:0] _GEN_0 = incr ? _byteCount_T_1 : byteCount; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 44:21 45:15 42:26]
  wire  _GEN_2 = rx_io_channel_valid; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 51:23 61:39 62:29]
  wire  _GEN_4 = io_instrData == 32'hb00710ad ? 1'h0 : 1'h1; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 59:43 60:18]
  wire  _GEN_5 = io_instrData == 32'hb00710ad ? 1'h0 : _GEN_2; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 51:23 59:43]
  wire  _T_8 = byteCount == 4'h8; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 70:21]
  wire  _GEN_11 = byteCount == 4'h8 ? 1'h0 : _GEN_2; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 70:30 52:8]
  wire  _GEN_14 = ~stateReg ? 1'h0 : stateReg; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 57:19 37:25]
  wire  _GEN_15 = ~stateReg & _GEN_11; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 57:19 52:8]
  wire  _GEN_16 = stateReg ? _GEN_4 : _GEN_14; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 57:19]
  Rx rx ( // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 29:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  BootBuffer buffer ( // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 30:22]
    .clock(buffer_clock),
    .reset(buffer_reset),
    .io_saveCtrl(buffer_io_saveCtrl),
    .io_dataIn(buffer_io_dataIn),
    .io_dataOut(buffer_io_dataOut)
  );
  assign io_instrData = buffer_io_dataOut[63:32]; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 86:36]
  assign io_instrAddr = buffer_io_dataOut[31:0]; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 87:36]
  assign io_wrEnabled = wrEnabled; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 85:16]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rx; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 88:13]
  assign rx_io_channel_ready = stateReg ? _GEN_5 : _GEN_15; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 57:19]
  assign buffer_clock = clock;
  assign buffer_reset = reset;
  assign buffer_io_saveCtrl = save; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 48:22]
  assign buffer_io_dataIn = rx_io_channel_bits; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 49:20]
  always @(posedge clock) begin
    stateReg <= reset | _GEN_16; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 37:{25,25}]
    if (reset) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 39:21]
      incr <= 1'h0; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 39:21]
    end else if (stateReg) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 57:19]
      incr <= 1'h0; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 52:8]
    end else begin
      incr <= ~stateReg & _GEN_11;
    end
    if (reset) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 40:21]
      save <= 1'h0; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 40:21]
    end else if (stateReg) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 57:19]
      if (io_instrData == 32'hb00710ad) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 59:43]
        save <= 1'h0; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 51:23]
      end else begin
        save <= _GEN_2;
      end
    end else begin
      save <= _GEN_15;
    end
    if (reset) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 41:26]
      wrEnabled <= 1'h0; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 41:26]
    end else if (stateReg) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 57:19]
      wrEnabled <= 1'h0; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 54:13]
    end else begin
      wrEnabled <= ~stateReg & _T_8;
    end
    if (reset) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 42:26]
      byteCount <= 4'h0; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 42:26]
    end else if (stateReg) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 57:19]
      byteCount <= _GEN_0;
    end else if (~stateReg) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 57:19]
      if (byteCount == 4'h8) begin // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 70:30]
        byteCount <= 4'h0; // @[\\src\\main\\scala\\Bootloader\\BootloaderTop.scala 72:18]
      end else begin
        byteCount <= _GEN_0;
      end
    end else begin
      byteCount <= _GEN_0;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  stateReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  incr = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  save = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  wrEnabled = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  byteCount = _RAND_4[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Csr(
  input  [11:0] io_address, // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 14:14]
  output [31:0] io_data // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 14:14]
);
  wire [31:0] _GEN_0 = 12'hf12 == io_address ? 32'h2f : 32'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 22:22 48:12 19:25]
  wire [31:0] _GEN_1 = 12'hb81 == io_address ? 32'h0 : _GEN_0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 22:22 45:12]
  wire [31:0] _GEN_2 = 12'hb01 == io_address ? 32'h0 : _GEN_1; // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 22:22 42:12]
  wire [31:0] _GEN_3 = 12'hb80 == io_address ? 32'h0 : _GEN_2; // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 22:22 39:12]
  wire [31:0] _GEN_4 = 12'hb00 == io_address ? 32'h0 : _GEN_3; // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 22:22 36:12]
  wire [31:0] _GEN_5 = 12'hc81 == io_address ? 32'h4 : _GEN_4; // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 22:22 33:12]
  wire [31:0] _GEN_6 = 12'hc01 == io_address ? 32'h3 : _GEN_5; // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 22:22 30:12]
  wire [31:0] _GEN_7 = 12'hc80 == io_address ? 32'h2 : _GEN_6; // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 22:22 27:12]
  assign io_data = 12'hc00 == io_address ? 32'h1 : _GEN_7; // @[\\src\\main\\scala\\wildcat\\pipeline\\Csr.scala 22:22 24:12]
endmodule
module ThreeCats(
  input         clock,
  input         reset,
  output [31:0] io_imem_address, // @[\\src\\main\\scala\\wildcat\\pipeline\\Wildcat.scala 18:14]
  input  [31:0] io_imem_rdData, // @[\\src\\main\\scala\\wildcat\\pipeline\\Wildcat.scala 18:14]
  input         io_imem_ack, // @[\\src\\main\\scala\\wildcat\\pipeline\\Wildcat.scala 18:14]
  output [31:0] io_dmem_address, // @[\\src\\main\\scala\\wildcat\\pipeline\\Wildcat.scala 18:14]
  output        io_dmem_rd, // @[\\src\\main\\scala\\wildcat\\pipeline\\Wildcat.scala 18:14]
  output        io_dmem_wr, // @[\\src\\main\\scala\\wildcat\\pipeline\\Wildcat.scala 18:14]
  input  [31:0] io_dmem_rdData, // @[\\src\\main\\scala\\wildcat\\pipeline\\Wildcat.scala 18:14]
  output [31:0] io_dmem_wrData, // @[\\src\\main\\scala\\wildcat\\pipeline\\Wildcat.scala 18:14]
  output [3:0]  io_dmem_wrMask // @[\\src\\main\\scala\\wildcat\\pipeline\\Wildcat.scala 18:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] regs [0:31]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  wire  regs_rs1Val_MPORT_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  wire [4:0] regs_rs1Val_MPORT_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  wire [31:0] regs_rs1Val_MPORT_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  wire  regs_rs2Val_MPORT_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  wire [4:0] regs_rs2Val_MPORT_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  wire [31:0] regs_rs2Val_MPORT_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  wire [31:0] regs_MPORT_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  wire [4:0] regs_MPORT_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  wire  regs_MPORT_mask; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  wire  regs_MPORT_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  reg  regs_rs1Val_MPORT_en_pipe_0;
  reg [4:0] regs_rs1Val_MPORT_addr_pipe_0;
  reg  regs_rs2Val_MPORT_en_pipe_0;
  reg [4:0] regs_rs2Val_MPORT_addr_pipe_0;
  wire [11:0] csr_io_address; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 64:19]
  wire [31:0] csr_io_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 64:19]
  reg  exFwdReg_valid; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 36:25]
  reg [4:0] exFwdReg_wbDest; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 36:25]
  reg [31:0] exFwdReg_wbData; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 36:25]
  reg [31:0] pcReg; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 39:22]
  wire [31:0] _pcNext_T_1 = pcReg + 32'h4; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 40:62]
  reg [2:0] decExReg_func3; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  wire  _doBranch_T = 3'h0 == decExReg_func3; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 155:20]
  reg [4:0] decExReg_rs1; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg [31:0] decExReg_rs1Val; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  wire [31:0] v1 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs1 ? exFwdReg_wbData : decExReg_rs1Val; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 122:15]
  reg [4:0] decExReg_rs2; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg [31:0] decExReg_rs2Val; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  wire [31:0] v2 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs2 ? exFwdReg_wbData : decExReg_rs2Val; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 123:15]
  wire  _doBranch_T_1 = 3'h1 == decExReg_func3; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 155:20]
  wire  _doBranch_T_2 = 3'h4 == decExReg_func3; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 155:20]
  wire [31:0] _doBranch_res_T_2 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs1 ? exFwdReg_wbData : decExReg_rs1Val; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 163:20]
  wire [31:0] _doBranch_res_T_3 = exFwdReg_valid & exFwdReg_wbDest == decExReg_rs2 ? exFwdReg_wbData : decExReg_rs2Val; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 163:33]
  wire  _doBranch_T_3 = 3'h5 == decExReg_func3; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 155:20]
  wire  _GEN_247 = 3'h7 == decExReg_func3 & v1 >= v2; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 155:20 172:13 154:9]
  wire  _GEN_248 = 3'h6 == decExReg_func3 ? v1 < v2 : _GEN_247; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 155:20 169:13]
  wire  _GEN_249 = 3'h5 == decExReg_func3 ? $signed(_doBranch_res_T_2) >= $signed(_doBranch_res_T_3) : _GEN_248; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 155:20 166:13]
  wire  _GEN_250 = 3'h4 == decExReg_func3 ? $signed(_doBranch_res_T_2) < $signed(_doBranch_res_T_3) : _GEN_249; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 155:20 163:13]
  wire  _GEN_251 = 3'h1 == decExReg_func3 ? v1 != v2 : _GEN_250; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 155:20 160:13]
  wire  doBranch_res = 3'h0 == decExReg_func3 ? v1 == v2 : _GEN_251; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 155:20 157:13]
  reg  decExReg_decOut_isBranch; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg  decExReg_decOut_isJal; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg  decExReg_decOut_isJalr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg  decExReg_valid; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  wire  doBranch = (doBranch_res & decExReg_decOut_isBranch | decExReg_decOut_isJal | decExReg_decOut_isJalr) &
    decExReg_valid; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 148:130]
  reg  decExReg_decOut_isLoad; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  wire  _T_14 = ~doBranch; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 152:34]
  reg [1:0] decExReg_memLow; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  wire  _res_T_7 = 2'h0 == decExReg_memLow; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 288:24]
  wire [23:0] _res_res_T_1 = io_dmem_rdData[7] ? 24'hffffff : 24'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 290:24]
  wire [31:0] _res_res_T_3 = {_res_res_T_1,io_dmem_rdData[7:0]}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 290:38]
  wire  _res_T_8 = 2'h1 == decExReg_memLow; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 288:24]
  wire [23:0] _res_res_T_5 = io_dmem_rdData[15] ? 24'hffffff : 24'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 293:24]
  wire [31:0] _res_res_T_7 = {_res_res_T_5,io_dmem_rdData[15:8]}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 293:39]
  wire  _res_T_9 = 2'h2 == decExReg_memLow; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 288:24]
  wire [23:0] _res_res_T_9 = io_dmem_rdData[23] ? 24'hffffff : 24'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 296:24]
  wire [31:0] _res_res_T_11 = {_res_res_T_9,io_dmem_rdData[23:16]}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 296:39]
  wire  _res_T_10 = 2'h3 == decExReg_memLow; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 288:24]
  wire [23:0] _res_res_T_13 = io_dmem_rdData[31] ? 24'hffffff : 24'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 300:24]
  wire [31:0] _res_res_T_15 = {_res_res_T_13,io_dmem_rdData[31:24]}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 300:39]
  wire [31:0] _GEN_253 = 2'h3 == decExReg_memLow ? _res_res_T_15 : io_dmem_rdData; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 288:24 300:17 285:9]
  wire [31:0] _GEN_254 = 2'h2 == decExReg_memLow ? _res_res_T_11 : _GEN_253; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 288:24 296:17]
  wire [31:0] _GEN_255 = 2'h1 == decExReg_memLow ? _res_res_T_7 : _GEN_254; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 288:24 293:17]
  wire [31:0] _GEN_256 = 2'h0 == decExReg_memLow ? _res_res_T_3 : _GEN_255; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 288:24 290:17]
  wire [15:0] _res_res_T_17 = io_dmem_rdData[15] ? 16'hffff : 16'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 307:24]
  wire [31:0] _res_res_T_19 = {_res_res_T_17,io_dmem_rdData[15:0]}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 307:39]
  wire [15:0] _res_res_T_21 = io_dmem_rdData[31] ? 16'hffff : 16'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 310:24]
  wire [31:0] _res_res_T_23 = {_res_res_T_21,io_dmem_rdData[31:16]}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 310:39]
  wire [31:0] _GEN_257 = _res_T_9 ? _res_res_T_23 : io_dmem_rdData; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 305:24 310:17 285:9]
  wire [31:0] _GEN_258 = _res_T_7 ? _res_res_T_19 : _GEN_257; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 305:24 307:17]
  wire [31:0] _GEN_259 = _res_T_10 ? {{24'd0}, io_dmem_rdData[31:24]} : io_dmem_rdData; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 315:24 326:17 285:9]
  wire [31:0] _GEN_260 = _res_T_9 ? {{24'd0}, io_dmem_rdData[23:16]} : _GEN_259; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 315:24 323:17]
  wire [31:0] _GEN_261 = _res_T_8 ? {{24'd0}, io_dmem_rdData[15:8]} : _GEN_260; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 315:24 320:17]
  wire [31:0] _GEN_262 = _res_T_7 ? {{24'd0}, io_dmem_rdData[7:0]} : _GEN_261; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 315:24 317:17]
  wire [31:0] _GEN_263 = _res_T_9 ? {{16'd0}, io_dmem_rdData[31:16]} : io_dmem_rdData; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 331:24 336:17 285:9]
  wire [31:0] _GEN_264 = _res_T_7 ? {{16'd0}, io_dmem_rdData[15:0]} : _GEN_263; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 331:24 333:17]
  wire [31:0] _GEN_265 = _doBranch_T_3 ? _GEN_264 : io_dmem_rdData; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 286:19 285:9]
  wire [31:0] _GEN_266 = _doBranch_T_2 ? _GEN_262 : _GEN_265; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 286:19]
  wire [31:0] _GEN_267 = _doBranch_T_1 ? _GEN_258 : _GEN_266; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 286:19]
  wire [31:0] res_res_1 = _doBranch_T ? _GEN_256 : _GEN_267; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 286:19]
  reg  decExReg_decOut_isCssrw; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg [31:0] decExReg_csrVal; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg  decExReg_decOut_isAuiPc; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg [31:0] decExReg_pc; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg [31:0] decExReg_decOut_imm; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  wire [31:0] _res_T_5 = $signed(decExReg_pc) + $signed(decExReg_decOut_imm); // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 132:55]
  reg  decExReg_decOut_isLui; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg [3:0] decExReg_decOut_aluOp; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  reg  decExReg_decOut_isImm; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  wire [31:0] val2 = decExReg_decOut_isImm ? decExReg_decOut_imm : v2; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 126:17]
  wire [31:0] res_res__9 = v1 & val2; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 271:24]
  wire [31:0] res_res__8 = v1 | val2; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 272:23]
  wire [31:0] res_res__7 = $signed(_doBranch_res_T_2) >>> val2[4:0]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 276:44]
  wire [31:0] res_res__6 = v1 >> val2[4:0]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 275:24]
  wire [31:0] res_res__5 = v1 ^ val2; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 273:24]
  wire [31:0] res_res__4 = {{31'd0}, v1 < val2}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 268:19 278:20]
  wire [31:0] _res_res_3_T_1 = decExReg_decOut_isImm ? decExReg_decOut_imm : v2; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 277:36]
  wire [31:0] res_res__3 = {{31'd0}, $signed(_doBranch_res_T_2) < $signed(_res_res_3_T_1)}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 268:19 277:19]
  wire [62:0] _GEN_0 = {{31'd0}, v1}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 274:25]
  wire [62:0] _res_res_2_T_1 = _GEN_0 << val2[4:0]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 274:25]
  wire [31:0] res_res__2 = _res_res_2_T_1[31:0]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 268:19 274:19]
  wire [31:0] res_res__1 = v1 - val2; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 270:24]
  wire [31:0] res_res__0 = v1 + val2; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 269:24]
  wire [31:0] _GEN_233 = 4'h1 == decExReg_decOut_aluOp ? res_res__1 : res_res__0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_234 = 4'h2 == decExReg_decOut_aluOp ? res_res__2 : _GEN_233; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_235 = 4'h3 == decExReg_decOut_aluOp ? res_res__3 : _GEN_234; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_236 = 4'h4 == decExReg_decOut_aluOp ? res_res__4 : _GEN_235; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_237 = 4'h5 == decExReg_decOut_aluOp ? res_res__5 : _GEN_236; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_238 = 4'h6 == decExReg_decOut_aluOp ? res_res__6 : _GEN_237; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_239 = 4'h7 == decExReg_decOut_aluOp ? res_res__7 : _GEN_238; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_240 = 4'h8 == decExReg_decOut_aluOp ? res_res__8 : _GEN_239; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_241 = 4'h9 == decExReg_decOut_aluOp ? res_res__9 : _GEN_240; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 127:{7,7}]
  wire [31:0] _GEN_242 = decExReg_decOut_isLui ? decExReg_decOut_imm : _GEN_241; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 128:31 127:7 129:9]
  wire [31:0] _GEN_243 = decExReg_decOut_isAuiPc ? _res_T_5 : _GEN_242; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 131:33 132:9]
  wire [31:0] _GEN_244 = decExReg_decOut_isCssrw ? decExReg_csrVal : _GEN_243; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 134:33 135:9]
  wire [31:0] res = decExReg_decOut_isLoad & ~doBranch ? res_res_1 : _GEN_244; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 152:45 153:9]
  wire [31:0] branchTarget = decExReg_decOut_isJalr ? res : _res_T_5; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 144:16 145:32 146:18]
  wire [31:0] _pcNext_T_2 = doBranch ? branchTarget : _pcNext_T_1; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 40:31]
  wire [31:0] instr = ~io_imem_ack ? 32'h33 : io_imem_rdData; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 50:23 51:11 49:26]
  reg [31:0] pcRegReg; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 56:25]
  reg [31:0] instrReg; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 57:25]
  reg [4:0] rs1Val_REG; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 208:31]
  wire [31:0] rs1Val = rs1Val_REG == 5'h0 ? 32'h0 : regs_rs1Val_MPORT_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 208:23]
  reg [4:0] rs2Val_REG; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 209:31]
  wire [31:0] rs2Val = rs2Val_REG == 5'h0 ? 32'h0 : regs_rs2Val_MPORT_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 209:23]
  reg [4:0] decExReg_rd; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  wire  _T_1 = decExReg_rd != 5'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 210:24]
  reg  decExReg_decOut_rfWrite; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
  wire  wrEna = decExReg_valid & decExReg_decOut_rfWrite; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 149:27]
  wire  _T_2 = wrEna & decExReg_rd != 5'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 210:18]
  wire  _T_13 = decExReg_decOut_isJal | decExReg_decOut_isJalr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 140:30]
  wire [31:0] _wbData_T_1 = decExReg_pc + 32'h4; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 141:27]
  wire [31:0] wbData = decExReg_decOut_isJal | decExReg_decOut_isJalr ? _wbData_T_1 : res; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 139:10 140:57 141:12]
  wire [6:0] decOut_opcode = instrReg[6:0]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 17:29]
  wire [2:0] decOut_func3 = instrReg[14:12]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 18:28]
  wire  _GEN_78 = decOut_func3 == 3'h0 ? 1'h0 : 1'h1; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 31:20 87:30 90:26]
  wire  _GEN_87 = 7'h73 == decOut_opcode ? _GEN_78 : 7'h2f == decOut_opcode; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
  wire  _GEN_90 = 7'h67 == decOut_opcode | 7'h73 == decOut_opcode; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 80:26]
  wire  _GEN_92 = 7'h67 == decOut_opcode | _GEN_87; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 82:24]
  wire  _GEN_94 = 7'h67 == decOut_opcode ? 1'h0 : 7'h73 == decOut_opcode & _GEN_78; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 31:20 37:20]
  wire [2:0] _GEN_97 = 7'h6f == decOut_opcode ? 3'h5 : {{2'd0}, _GEN_90}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 75:26]
  wire  _GEN_98 = 7'h6f == decOut_opcode | _GEN_92; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 76:24]
  wire  _GEN_100 = 7'h6f == decOut_opcode ? 1'h0 : 7'h67 == decOut_opcode; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 21:18 37:20]
  wire  _GEN_102 = 7'h6f == decOut_opcode ? 1'h0 : _GEN_94; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 31:20 37:20]
  wire [2:0] _GEN_105 = 7'h17 == decOut_opcode ? 3'h4 : _GEN_97; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 70:26]
  wire  _GEN_106 = 7'h17 == decOut_opcode | _GEN_98; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 71:24]
  wire  _GEN_108 = 7'h17 == decOut_opcode ? 1'h0 : 7'h6f == decOut_opcode; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 27:18 37:20]
  wire  _GEN_109 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_100; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 21:18 37:20]
  wire  _GEN_111 = 7'h17 == decOut_opcode ? 1'h0 : _GEN_102; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 31:20 37:20]
  wire [2:0] _GEN_114 = 7'h37 == decOut_opcode ? 3'h4 : _GEN_105; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 65:26]
  wire  _GEN_115 = 7'h37 == decOut_opcode | _GEN_106; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 66:24]
  wire  _GEN_117 = 7'h37 == decOut_opcode ? 1'h0 : 7'h17 == decOut_opcode; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 23:20 37:20]
  wire  _GEN_118 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_108; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 27:18 37:20]
  wire  _GEN_119 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_109; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 21:18 37:20]
  wire  _GEN_121 = 7'h37 == decOut_opcode ? 1'h0 : _GEN_111; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 31:20 37:20]
  wire [2:0] _GEN_124 = 7'h23 == decOut_opcode ? 3'h2 : _GEN_114; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 61:26]
  wire  _GEN_126 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_115; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 29:20 37:20]
  wire  _GEN_127 = 7'h23 == decOut_opcode ? 1'h0 : 7'h37 == decOut_opcode; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 22:18 37:20]
  wire  _GEN_128 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_117; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 23:20 37:20]
  wire  _GEN_129 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_118; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 27:18 37:20]
  wire  _GEN_130 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_119; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 21:18 37:20]
  wire  _GEN_132 = 7'h23 == decOut_opcode ? 1'h0 : _GEN_121; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 31:20 37:20]
  wire [2:0] _GEN_135 = 7'h3 == decOut_opcode ? 3'h1 : _GEN_124; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 56:26]
  wire  _GEN_136 = 7'h3 == decOut_opcode | _GEN_126; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 57:24]
  wire  _GEN_138 = 7'h3 == decOut_opcode ? 1'h0 : 7'h23 == decOut_opcode; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 25:20 37:20]
  wire  _GEN_139 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_127; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 22:18 37:20]
  wire  _GEN_140 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_128; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 23:20 37:20]
  wire  _GEN_141 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_129; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 27:18 37:20]
  wire  _GEN_142 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_130; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 21:18 37:20]
  wire  _GEN_144 = 7'h3 == decOut_opcode ? 1'h0 : _GEN_132; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 31:20 37:20]
  wire [2:0] _GEN_147 = 7'h63 == decOut_opcode ? 3'h3 : _GEN_135; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 51:26]
  wire  _GEN_148 = 7'h63 == decOut_opcode | _GEN_142; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 52:22]
  wire  _GEN_150 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_136; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 29:20 37:20]
  wire  _GEN_151 = 7'h63 == decOut_opcode ? 1'h0 : 7'h3 == decOut_opcode; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 24:19 37:20]
  wire  _GEN_152 = 7'h63 == decOut_opcode ? 1'h0 : _GEN_138; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 25:20 37:20]
  wire [2:0] _GEN_161 = 7'h33 == decOut_opcode ? 3'h0 : _GEN_147; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 45:26]
  wire  _GEN_162 = 7'h33 == decOut_opcode | _GEN_150; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 46:24]
  wire  _GEN_164 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_148; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 21:18 37:20]
  wire  _GEN_166 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_151; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 24:19 37:20]
  wire  _GEN_167 = 7'h33 == decOut_opcode ? 1'h0 : _GEN_152; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 25:20 37:20]
  wire [2:0] decOut_instrType = 7'h13 == decOut_opcode ? 3'h1 : _GEN_161; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 39:26]
  wire  decOut_isImm = 7'h13 == decOut_opcode | _GEN_164; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 40:22]
  wire  decOut_rfWrite = 7'h13 == decOut_opcode | _GEN_162; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20 41:24]
  wire  decOut_isLoad = 7'h13 == decOut_opcode ? 1'h0 : _GEN_166; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 24:19 37:20]
  wire  decOut_isStore = 7'h13 == decOut_opcode ? 1'h0 : _GEN_167; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 25:20 37:20]
  wire [6:0] decOut_decOut_aluOp_func7 = instrReg[31:25]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 113:28]
  wire  _decOut_decOut_aluOp_T = 3'h0 == decOut_func3; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19]
  wire  _decOut_decOut_aluOp_T_5 = decOut_opcode != 7'h13 & decOut_opcode != 7'h67 & decOut_decOut_aluOp_func7 != 7'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 119:55]
  wire  _decOut_decOut_aluOp_T_6 = 3'h1 == decOut_func3; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19]
  wire  _decOut_decOut_aluOp_T_7 = 3'h2 == decOut_func3; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19]
  wire [2:0] _GEN_193 = decOut_decOut_aluOp_func7 == 7'h0 ? 3'h6 : 3'h7; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 136:29 137:17 139:17]
  wire [3:0] _GEN_194 = 3'h7 == decOut_func3 ? 4'h9 : 4'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19 146:15 115:28]
  wire [3:0] _GEN_195 = 3'h6 == decOut_func3 ? 4'h8 : _GEN_194; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19 143:15]
  wire [3:0] _GEN_196 = 3'h5 == decOut_func3 ? {{1'd0}, _GEN_193} : _GEN_195; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19]
  wire [3:0] _GEN_197 = 3'h4 == decOut_func3 ? 4'h5 : _GEN_196; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19 133:15]
  wire [3:0] _GEN_198 = 3'h3 == decOut_func3 ? 4'h4 : _GEN_197; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19 130:15]
  wire [11:0] _decOut_decOut_imm_imm_T_1 = instrReg[31:20]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 181:32]
  wire [19:0] _decOut_decOut_imm_imm_T_3 = instrReg[31] ? 20'hfffff : 20'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 184:21]
  wire [31:0] _decOut_decOut_imm_imm_T_6 = {_decOut_decOut_imm_imm_T_3,instrReg[31:20]}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 184:67]
  wire [31:0] _decOut_decOut_imm_imm_T_13 = {_decOut_decOut_imm_imm_T_3,decOut_decOut_aluOp_func7,instrReg[11:7]}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 187:89]
  wire [18:0] _decOut_decOut_imm_imm_T_15 = instrReg[31] ? 19'h7ffff : 19'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 190:21]
  wire [30:0] _decOut_decOut_imm_imm_T_23 = {_decOut_decOut_imm_imm_T_15,instrReg[7],instrReg[30:25],instrReg[11:8],1'h0
    }; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 190:119]
  wire [31:0] _decOut_decOut_imm_imm_T_27 = {instrReg[31:12],12'h0}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 193:55]
  wire [10:0] _decOut_decOut_imm_imm_T_29 = instrReg[31] ? 11'h7ff : 11'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 196:21]
  wire [30:0] _decOut_decOut_imm_imm_T_37 = {_decOut_decOut_imm_imm_T_29,instrReg[19:12],instrReg[20],instrReg[30:21],1'h0
    }; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 196:121]
  wire [30:0] _GEN_202 = 3'h5 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_37) : $signed({{19{
    _decOut_decOut_imm_imm_T_1[11]}},_decOut_decOut_imm_imm_T_1}); // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 182:23 196:13 181:9]
  wire [31:0] _GEN_203 = 3'h4 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_27) : $signed({{1{_GEN_202[30]}},
    _GEN_202}); // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 182:23 193:13]
  wire [31:0] _GEN_204 = 3'h3 == decOut_instrType ? $signed({{1{_decOut_decOut_imm_imm_T_23[30]}},
    _decOut_decOut_imm_imm_T_23}) : $signed(_GEN_203); // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 182:23 190:13]
  wire [31:0] _GEN_205 = 3'h2 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_13) : $signed(_GEN_204); // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 182:23 187:13]
  wire [31:0] decOut_decOut_imm_imm = 3'h1 == decOut_instrType ? $signed(_decOut_decOut_imm_imm_T_6) : $signed(_GEN_205)
    ; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 182:23 184:13]
  wire [4:0] decEx_rs1 = instrReg[19:15]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 86:24]
  wire [4:0] decEx_rs2 = instrReg[24:20]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 87:24]
  wire [31:0] data = _T_2 & decExReg_rd == decEx_rs2 ? wbData : rs2Val; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 96:17]
  wire [31:0] _memAddress_T = _T_2 & decExReg_rd == decEx_rs1 ? wbData : rs1Val; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 98:29]
  wire [31:0] memAddress = $signed(_memAddress_T) + $signed(decOut_decOut_imm_imm); // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 98:50]
  wire [1:0] decEx_memLow = memAddress[1:0]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 99:29]
  wire [31:0] _wrData_T_6 = {data[7:0],data[7:0],data[7:0],data[7:0]}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 349:58]
  wire  _GEN_208 = 2'h0 == decEx_memLow; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 350:{24,24} 346:25]
  wire  _GEN_209 = 2'h1 == decEx_memLow; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 350:{24,24} 346:25]
  wire  _GEN_210 = 2'h2 == decEx_memLow; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 350:{24,24} 346:25]
  wire  _GEN_211 = 2'h3 == decEx_memLow; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 350:{24,24} 346:25]
  wire [31:0] _wrData_T_9 = {data[15:0],data[15:0]}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 353:31]
  wire  _GEN_214 = _GEN_208 ? 1'h0 : _GEN_210; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 354:24 346:25]
  wire [31:0] _GEN_219 = _decOut_decOut_aluOp_T_6 ? _wrData_T_9 : data; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 347:19 353:16 345:29]
  wire  _GEN_220 = _decOut_decOut_aluOp_T_6 ? _GEN_208 : _decOut_decOut_aluOp_T_7; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 347:19]
  wire  _GEN_222 = _decOut_decOut_aluOp_T_6 ? _GEN_214 : _decOut_decOut_aluOp_T_7; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 347:19]
  wire [31:0] wrData = _decOut_decOut_aluOp_T ? _wrData_T_6 : _GEN_219; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 347:19 349:16]
  wire  wrMask_0 = _decOut_decOut_aluOp_T ? _GEN_208 : _GEN_220; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 347:19]
  wire  wrMask_1 = _decOut_decOut_aluOp_T ? _GEN_209 : _GEN_220; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 347:19]
  wire  wrMask_2 = _decOut_decOut_aluOp_T ? _GEN_210 : _GEN_222; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 347:19]
  wire  wrMask_3 = _decOut_decOut_aluOp_T ? _GEN_211 : _GEN_222; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 347:19]
  wire [3:0] _wr_T = {wrMask_3,wrMask_2,wrMask_1,wrMask_0}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 369:21]
  wire  wr = |_wr_T; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 369:28]
  wire [31:0] decEx_csrVal = csr_io_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 70:19 91:16]
  Csr csr ( // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 64:19]
    .io_address(csr_io_address),
    .io_data(csr_io_data)
  );
  assign regs_rs1Val_MPORT_en = regs_rs1Val_MPORT_en_pipe_0;
  assign regs_rs1Val_MPORT_addr = regs_rs1Val_MPORT_addr_pipe_0;
  assign regs_rs1Val_MPORT_data = regs[regs_rs1Val_MPORT_addr]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  assign regs_rs2Val_MPORT_en = regs_rs2Val_MPORT_en_pipe_0;
  assign regs_rs2Val_MPORT_addr = regs_rs2Val_MPORT_addr_pipe_0;
  assign regs_rs2Val_MPORT_data = regs[regs_rs2Val_MPORT_addr]; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
  assign regs_MPORT_data = _T_13 ? _wbData_T_1 : res;
  assign regs_MPORT_addr = decExReg_rd;
  assign regs_MPORT_mask = 1'h1;
  assign regs_MPORT_en = wrEna & _T_1;
  assign io_imem_address = ~io_imem_ack ? pcReg : _pcNext_T_2; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 50:23 52:12 40:27]
  assign io_dmem_address = $signed(_memAddress_T) + $signed(decOut_decOut_imm_imm); // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 98:50]
  assign io_dmem_rd = decOut_isLoad & _T_14; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 106:22]
  assign io_dmem_wr = decOut_isStore & _T_14 & wr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 104:14 109:37 112:16]
  assign io_dmem_wrData = decOut_isStore & _T_14 ? wrData : data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 103:18 109:37 111:20]
  assign io_dmem_wrMask = decOut_isStore & _T_14 ? _wr_T : 4'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 105:18 109:37 113:20]
  assign csr_io_address = instrReg[31:20]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 65:29]
  always @(posedge clock) begin
    if (regs_MPORT_en & regs_MPORT_mask) begin
      regs[regs_MPORT_addr] <= regs_MPORT_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 206:29]
    end
    regs_rs1Val_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      regs_rs1Val_MPORT_addr_pipe_0 <= instr[19:15];
    end
    regs_rs2Val_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      regs_rs2Val_MPORT_addr_pipe_0 <= instr[24:20];
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 36:25]
      exFwdReg_valid <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 36:25]
    end else begin
      exFwdReg_valid <= _T_2; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 158:18]
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 36:25]
      exFwdReg_wbDest <= 5'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 36:25]
    end else begin
      exFwdReg_wbDest <= decExReg_rd; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 159:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 36:25]
      exFwdReg_wbData <= 32'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 36:25]
    end else if (decExReg_decOut_isJal | decExReg_decOut_isJalr) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 140:57]
      exFwdReg_wbData <= _wbData_T_1; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 141:12]
    end else if (decExReg_decOut_isLoad & ~doBranch) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 152:45]
      if (_doBranch_T) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 286:19]
        exFwdReg_wbData <= _GEN_256;
      end else begin
        exFwdReg_wbData <= _GEN_267;
      end
    end else if (decExReg_decOut_isCssrw) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 134:33]
      exFwdReg_wbData <= decExReg_csrVal; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 135:9]
    end else begin
      exFwdReg_wbData <= _GEN_243;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 39:22]
      pcReg <= 32'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 39:22]
    end else if (!(~io_imem_ack)) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 50:23]
      if (doBranch) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 40:31]
        if (decExReg_decOut_isJalr) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 145:32]
          pcReg <= res; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 146:18]
        end else begin
          pcReg <= _res_T_5; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 144:16]
        end
      end else begin
        pcReg <= _pcNext_T_1;
      end
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_func3 <= 3'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else begin
      decExReg_func3 <= decOut_func3; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 119:12]
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_rs1 <= 5'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else begin
      decExReg_rs1 <= decEx_rs1; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 119:12]
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_rs1Val <= 32'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (rs1Val_REG == 5'h0) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 208:23]
      decExReg_rs1Val <= 32'h0;
    end else begin
      decExReg_rs1Val <= regs_rs1Val_MPORT_data;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_rs2 <= 5'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else begin
      decExReg_rs2 <= decEx_rs2; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 119:12]
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_rs2Val <= 32'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (rs2Val_REG == 5'h0) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 209:23]
      decExReg_rs2Val <= 32'h0;
    end else begin
      decExReg_rs2Val <= regs_rs2Val_MPORT_data;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_isBranch <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isBranch <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 26:21]
    end else if (7'h33 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isBranch <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 26:21]
    end else begin
      decExReg_decOut_isBranch <= 7'h63 == decOut_opcode;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_isJal <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isJal <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 27:18]
    end else if (7'h33 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isJal <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 27:18]
    end else if (7'h63 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isJal <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 27:18]
    end else begin
      decExReg_decOut_isJal <= _GEN_141;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_isJalr <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isJalr <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 28:19]
    end else if (7'h33 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isJalr <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 28:19]
    end else if (7'h63 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isJalr <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 28:19]
    end else begin
      decExReg_decOut_isJalr <= _GEN_142;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_valid <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else begin
      decExReg_valid <= _T_14; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 119:12]
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_isLoad <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isLoad <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 24:19]
    end else if (7'h33 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isLoad <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 24:19]
    end else if (7'h63 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isLoad <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 24:19]
    end else begin
      decExReg_decOut_isLoad <= 7'h3 == decOut_opcode;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_memLow <= 2'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else begin
      decExReg_memLow <= decEx_memLow; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 119:12]
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_isCssrw <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isCssrw <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 31:20]
    end else if (7'h33 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isCssrw <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 31:20]
    end else if (7'h63 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isCssrw <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 31:20]
    end else begin
      decExReg_decOut_isCssrw <= _GEN_144;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_csrVal <= 32'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else begin
      decExReg_csrVal <= decEx_csrVal; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 119:12]
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_isAuiPc <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isAuiPc <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 23:20]
    end else if (7'h33 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isAuiPc <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 23:20]
    end else if (7'h63 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isAuiPc <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 23:20]
    end else begin
      decExReg_decOut_isAuiPc <= _GEN_140;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_pc <= 32'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else begin
      decExReg_pc <= pcRegReg; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 119:12]
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_imm <= 32'sh0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (3'h1 == decOut_instrType) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 182:23]
      decExReg_decOut_imm <= _decOut_decOut_imm_imm_T_6; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 184:13]
    end else if (3'h2 == decOut_instrType) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 182:23]
      decExReg_decOut_imm <= _decOut_decOut_imm_imm_T_13; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 187:13]
    end else if (3'h3 == decOut_instrType) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 182:23]
      decExReg_decOut_imm <= {{1{_decOut_decOut_imm_imm_T_23[30]}},_decOut_decOut_imm_imm_T_23}; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 190:13]
    end else begin
      decExReg_decOut_imm <= _GEN_203;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_isLui <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (7'h13 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isLui <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 22:18]
    end else if (7'h33 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isLui <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 22:18]
    end else if (7'h63 == decOut_opcode) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 37:20]
      decExReg_decOut_isLui <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 22:18]
    end else begin
      decExReg_decOut_isLui <= _GEN_139;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_aluOp <= 4'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else if (3'h0 == decOut_func3) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19]
      decExReg_decOut_aluOp <= {{3'd0}, _decOut_decOut_aluOp_T_5};
    end else if (3'h1 == decOut_func3) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19]
      decExReg_decOut_aluOp <= 4'h2; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 124:15]
    end else if (3'h2 == decOut_func3) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 116:19]
      decExReg_decOut_aluOp <= 4'h3; // @[\\src\\main\\scala\\wildcat\\pipeline\\Functions.scala 127:15]
    end else begin
      decExReg_decOut_aluOp <= _GEN_198;
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_isImm <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else begin
      decExReg_decOut_isImm <= decOut_isImm; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 119:12]
    end
    pcRegReg <= pcReg; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 56:25]
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 57:25]
      instrReg <= 32'h33; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 57:25]
    end else if (doBranch) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 58:18]
      instrReg <= 32'h33;
    end else if (~io_imem_ack) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 50:23]
      instrReg <= 32'h33; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 51:11]
    end else begin
      instrReg <= io_imem_rdData; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 49:26]
    end
    rs1Val_REG <= instr[19:15]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 59:18]
    rs2Val_REG <= instr[24:20]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 60:18]
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_rd <= 5'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else begin
      decExReg_rd <= instrReg[11:7]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 119:12]
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
      decExReg_decOut_rfWrite <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 118:25]
    end else begin
      decExReg_decOut_rfWrite <= decOut_rfWrite; // @[\\src\\main\\scala\\wildcat\\pipeline\\ThreeCats.scala 119:12]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    regs[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  regs_rs1Val_MPORT_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  regs_rs1Val_MPORT_addr_pipe_0 = _RAND_2[4:0];
  _RAND_3 = {1{`RANDOM}};
  regs_rs2Val_MPORT_en_pipe_0 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  regs_rs2Val_MPORT_addr_pipe_0 = _RAND_4[4:0];
  _RAND_5 = {1{`RANDOM}};
  exFwdReg_valid = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  exFwdReg_wbDest = _RAND_6[4:0];
  _RAND_7 = {1{`RANDOM}};
  exFwdReg_wbData = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  pcReg = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  decExReg_func3 = _RAND_9[2:0];
  _RAND_10 = {1{`RANDOM}};
  decExReg_rs1 = _RAND_10[4:0];
  _RAND_11 = {1{`RANDOM}};
  decExReg_rs1Val = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  decExReg_rs2 = _RAND_12[4:0];
  _RAND_13 = {1{`RANDOM}};
  decExReg_rs2Val = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  decExReg_decOut_isBranch = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  decExReg_decOut_isJal = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  decExReg_decOut_isJalr = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  decExReg_valid = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  decExReg_decOut_isLoad = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  decExReg_memLow = _RAND_19[1:0];
  _RAND_20 = {1{`RANDOM}};
  decExReg_decOut_isCssrw = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  decExReg_csrVal = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  decExReg_decOut_isAuiPc = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  decExReg_pc = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  decExReg_decOut_imm = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  decExReg_decOut_isLui = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  decExReg_decOut_aluOp = _RAND_26[3:0];
  _RAND_27 = {1{`RANDOM}};
  decExReg_decOut_isImm = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  pcRegReg = _RAND_28[31:0];
  _RAND_29 = {1{`RANDOM}};
  instrReg = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  rs1Val_REG = _RAND_30[4:0];
  _RAND_31 = {1{`RANDOM}};
  rs2Val_REG = _RAND_31[4:0];
  _RAND_32 = {1{`RANDOM}};
  decExReg_rd = _RAND_32[4:0];
  _RAND_33 = {1{`RANDOM}};
  decExReg_decOut_rfWrite = _RAND_33[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ScratchPadMem(
  input         clock,
  input         reset,
  input  [31:0] io_address, // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 13:14]
  input         io_rd, // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 13:14]
  input         io_wr, // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 13:14]
  output [31:0] io_rdData, // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 13:14]
  input  [31:0] io_wrData, // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 13:14]
  input  [3:0]  io_wrMask, // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 13:14]
  output        io_ack // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 13:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] MEM [0:1023]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 16:16]
  wire  MEM_io_rdData_MPORT_3_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 16:16]
  wire [9:0] MEM_io_rdData_MPORT_3_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 16:16]
  wire [7:0] MEM_io_rdData_MPORT_3_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 16:16]
  wire [7:0] MEM_MPORT_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 16:16]
  wire [9:0] MEM_MPORT_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 16:16]
  wire  MEM_MPORT_mask; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 16:16]
  wire  MEM_MPORT_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 16:16]
  reg  MEM_io_rdData_MPORT_3_en_pipe_0;
  reg [9:0] MEM_io_rdData_MPORT_3_addr_pipe_0;
  reg [7:0] MEM_1 [0:1023]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 17:16]
  wire  MEM_1_io_rdData_MPORT_2_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 17:16]
  wire [9:0] MEM_1_io_rdData_MPORT_2_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 17:16]
  wire [7:0] MEM_1_io_rdData_MPORT_2_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 17:16]
  wire [7:0] MEM_1_MPORT_1_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 17:16]
  wire [9:0] MEM_1_MPORT_1_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 17:16]
  wire  MEM_1_MPORT_1_mask; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 17:16]
  wire  MEM_1_MPORT_1_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 17:16]
  reg  MEM_1_io_rdData_MPORT_2_en_pipe_0;
  reg [9:0] MEM_1_io_rdData_MPORT_2_addr_pipe_0;
  reg [7:0] MEM_2 [0:1023]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 18:16]
  wire  MEM_2_io_rdData_MPORT_1_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 18:16]
  wire [9:0] MEM_2_io_rdData_MPORT_1_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 18:16]
  wire [7:0] MEM_2_io_rdData_MPORT_1_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 18:16]
  wire [7:0] MEM_2_MPORT_2_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 18:16]
  wire [9:0] MEM_2_MPORT_2_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 18:16]
  wire  MEM_2_MPORT_2_mask; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 18:16]
  wire  MEM_2_MPORT_2_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 18:16]
  reg  MEM_2_io_rdData_MPORT_1_en_pipe_0;
  reg [9:0] MEM_2_io_rdData_MPORT_1_addr_pipe_0;
  reg [7:0] MEM_3 [0:1023]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 19:16]
  wire  MEM_3_io_rdData_MPORT_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 19:16]
  wire [9:0] MEM_3_io_rdData_MPORT_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 19:16]
  wire [7:0] MEM_3_io_rdData_MPORT_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 19:16]
  wire [7:0] MEM_3_MPORT_3_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 19:16]
  wire [9:0] MEM_3_MPORT_3_addr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 19:16]
  wire  MEM_3_MPORT_3_mask; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 19:16]
  wire  MEM_3_MPORT_3_en; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 19:16]
  reg  MEM_3_io_rdData_MPORT_en_pipe_0;
  reg [9:0] MEM_3_io_rdData_MPORT_addr_pipe_0;
  wire [23:0] _io_rdData_T_10 = {MEM_3_io_rdData_MPORT_data,MEM_2_io_rdData_MPORT_1_data,MEM_1_io_rdData_MPORT_2_data}; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 60:40]
  reg  io_ack_REG; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 75:20]
  assign MEM_io_rdData_MPORT_3_en = MEM_io_rdData_MPORT_3_en_pipe_0;
  assign MEM_io_rdData_MPORT_3_addr = MEM_io_rdData_MPORT_3_addr_pipe_0;
  assign MEM_io_rdData_MPORT_3_data = MEM[MEM_io_rdData_MPORT_3_addr]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 16:16]
  assign MEM_MPORT_data = io_wrData[7:0];
  assign MEM_MPORT_addr = io_address[11:2];
  assign MEM_MPORT_mask = 1'h1;
  assign MEM_MPORT_en = io_wrMask[0] & io_wr;
  assign MEM_1_io_rdData_MPORT_2_en = MEM_1_io_rdData_MPORT_2_en_pipe_0;
  assign MEM_1_io_rdData_MPORT_2_addr = MEM_1_io_rdData_MPORT_2_addr_pipe_0;
  assign MEM_1_io_rdData_MPORT_2_data = MEM_1[MEM_1_io_rdData_MPORT_2_addr]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 17:16]
  assign MEM_1_MPORT_1_data = io_wrData[15:8];
  assign MEM_1_MPORT_1_addr = io_address[11:2];
  assign MEM_1_MPORT_1_mask = 1'h1;
  assign MEM_1_MPORT_1_en = io_wrMask[1] & io_wr;
  assign MEM_2_io_rdData_MPORT_1_en = MEM_2_io_rdData_MPORT_1_en_pipe_0;
  assign MEM_2_io_rdData_MPORT_1_addr = MEM_2_io_rdData_MPORT_1_addr_pipe_0;
  assign MEM_2_io_rdData_MPORT_1_data = MEM_2[MEM_2_io_rdData_MPORT_1_addr]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 18:16]
  assign MEM_2_MPORT_2_data = io_wrData[23:16];
  assign MEM_2_MPORT_2_addr = io_address[11:2];
  assign MEM_2_MPORT_2_mask = 1'h1;
  assign MEM_2_MPORT_2_en = io_wrMask[2] & io_wr;
  assign MEM_3_io_rdData_MPORT_en = MEM_3_io_rdData_MPORT_en_pipe_0;
  assign MEM_3_io_rdData_MPORT_addr = MEM_3_io_rdData_MPORT_addr_pipe_0;
  assign MEM_3_io_rdData_MPORT_data = MEM_3[MEM_3_io_rdData_MPORT_addr]; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 19:16]
  assign MEM_3_MPORT_3_data = io_wrData[31:24];
  assign MEM_3_MPORT_3_addr = io_address[11:2];
  assign MEM_3_MPORT_3_mask = 1'h1;
  assign MEM_3_MPORT_3_en = io_wrMask[3] & io_wr;
  assign io_rdData = {_io_rdData_T_10,MEM_io_rdData_MPORT_3_data}; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 61:40]
  assign io_ack = io_ack_REG; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 75:10]
  always @(posedge clock) begin
    if (MEM_MPORT_en & MEM_MPORT_mask) begin
      MEM[MEM_MPORT_addr] <= MEM_MPORT_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 16:16]
    end
    MEM_io_rdData_MPORT_3_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_io_rdData_MPORT_3_addr_pipe_0 <= io_address[11:2];
    end
    if (MEM_1_MPORT_1_en & MEM_1_MPORT_1_mask) begin
      MEM_1[MEM_1_MPORT_1_addr] <= MEM_1_MPORT_1_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 17:16]
    end
    MEM_1_io_rdData_MPORT_2_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_1_io_rdData_MPORT_2_addr_pipe_0 <= io_address[11:2];
    end
    if (MEM_2_MPORT_2_en & MEM_2_MPORT_2_mask) begin
      MEM_2[MEM_2_MPORT_2_addr] <= MEM_2_MPORT_2_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 18:16]
    end
    MEM_2_io_rdData_MPORT_1_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_2_io_rdData_MPORT_1_addr_pipe_0 <= io_address[11:2];
    end
    if (MEM_3_MPORT_3_en & MEM_3_MPORT_3_mask) begin
      MEM_3[MEM_3_MPORT_3_addr] <= MEM_3_MPORT_3_data; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 19:16]
    end
    MEM_3_io_rdData_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      MEM_3_io_rdData_MPORT_addr_pipe_0 <= io_address[11:2];
    end
    if (reset) begin // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 75:20]
      io_ack_REG <= 1'h0; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 75:20]
    end else begin
      io_ack_REG <= io_rd | io_wr; // @[\\src\\main\\scala\\wildcat\\pipeline\\ScratchPadMem.scala 75:20]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    MEM[initvar] = _RAND_0[7:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    MEM_1[initvar] = _RAND_3[7:0];
  _RAND_6 = {1{`RANDOM}};
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    MEM_2[initvar] = _RAND_6[7:0];
  _RAND_9 = {1{`RANDOM}};
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    MEM_3[initvar] = _RAND_9[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  MEM_io_rdData_MPORT_3_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  MEM_io_rdData_MPORT_3_addr_pipe_0 = _RAND_2[9:0];
  _RAND_4 = {1{`RANDOM}};
  MEM_1_io_rdData_MPORT_2_en_pipe_0 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  MEM_1_io_rdData_MPORT_2_addr_pipe_0 = _RAND_5[9:0];
  _RAND_7 = {1{`RANDOM}};
  MEM_2_io_rdData_MPORT_1_en_pipe_0 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  MEM_2_io_rdData_MPORT_1_addr_pipe_0 = _RAND_8[9:0];
  _RAND_10 = {1{`RANDOM}};
  MEM_3_io_rdData_MPORT_en_pipe_0 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  MEM_3_io_rdData_MPORT_addr_pipe_0 = _RAND_11[9:0];
  _RAND_12 = {1{`RANDOM}};
  io_ack_REG = _RAND_12[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module AdcController(
  input         clock,
  input         reset,
  input         io_vauxp6, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  input         io_vauxn6, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  input         io_vauxp14, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  input         io_vauxn14, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  input         io_vauxp7, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  input         io_vauxn7, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  input         io_vauxp15, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  input         io_vauxn15, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  output [15:0] io_adcData0, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  output [15:0] io_adcData1, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  output [15:0] io_adcData2, // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
  output [15:0] io_adcData3 // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 38:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  wire  xadc_dclk_in; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_reset_in; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_vauxp6; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_vauxn6; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_vauxp14; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_vauxn14; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_vauxp7; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_vauxn7; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_vauxp15; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_vauxn15; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire [6:0] xadc_daddr_in; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_den_in; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire [15:0] xadc_di_in; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_dwe_in; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire [15:0] xadc_do_out; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_drdy_out; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_vp_in; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  wire  xadc_vn_in; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
  reg [15:0] dataReg_0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
  reg [15:0] dataReg_1; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
  reg [15:0] dataReg_2; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
  reg [15:0] dataReg_3; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
  reg  state; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 81:22]
  reg [1:0] auxIdx; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 82:23]
  wire [6:0] _GEN_1 = 2'h1 == auxIdx ? 7'h1e : 7'h16; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 84:{20,20}]
  wire [6:0] _GEN_2 = 2'h2 == auxIdx ? 7'h17 : _GEN_1; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 84:{20,20}]
  wire  _xadc_io_den_in_T = ~state; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 87:30]
  wire [15:0] _dataReg_auxIdx = xadc_do_out; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 97:{25,25}]
  wire [15:0] _GEN_4 = 2'h0 == auxIdx ? _dataReg_auxIdx : dataReg_0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24 97:{25,25}]
  wire [15:0] _GEN_5 = 2'h1 == auxIdx ? _dataReg_auxIdx : dataReg_1; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24 97:{25,25}]
  wire [15:0] _GEN_6 = 2'h2 == auxIdx ? _dataReg_auxIdx : dataReg_2; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24 97:{25,25}]
  wire [15:0] _GEN_7 = 2'h3 == auxIdx ? _dataReg_auxIdx : dataReg_3; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24 97:{25,25}]
  wire [1:0] _auxIdx_T_1 = auxIdx + 2'h1; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 98:26]
  wire  _GEN_13 = xadc_drdy_out ? 1'h0 : state; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 96:30 99:15 81:22]
  wire  _GEN_19 = state ? _GEN_13 : state; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17 81:22]
  wire  _GEN_20 = _xadc_io_den_in_T | _GEN_19; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17 92:13]
  xadc_wiz_0 xadc ( // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 55:20]
    .dclk_in(xadc_dclk_in),
    .reset_in(xadc_reset_in),
    .vauxp6(xadc_vauxp6),
    .vauxn6(xadc_vauxn6),
    .vauxp14(xadc_vauxp14),
    .vauxn14(xadc_vauxn14),
    .vauxp7(xadc_vauxp7),
    .vauxn7(xadc_vauxn7),
    .vauxp15(xadc_vauxp15),
    .vauxn15(xadc_vauxn15),
    .daddr_in(xadc_daddr_in),
    .den_in(xadc_den_in),
    .di_in(xadc_di_in),
    .dwe_in(xadc_dwe_in),
    .do_out(xadc_do_out),
    .drdy_out(xadc_drdy_out),
    .vp_in(xadc_vp_in),
    .vn_in(xadc_vn_in)
  );
  assign io_adcData0 = {{4'd0}, dataReg_0[15:4]}; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 106:15]
  assign io_adcData1 = {{4'd0}, dataReg_1[15:4]}; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 107:15]
  assign io_adcData2 = {{4'd0}, dataReg_2[15:4]}; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 108:15]
  assign io_adcData3 = {{4'd0}, dataReg_3[15:4]}; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 109:15]
  assign xadc_dclk_in = clock; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 58:20]
  assign xadc_reset_in = reset; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 59:29]
  assign xadc_vauxp6 = io_vauxp6; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 64:20]
  assign xadc_vauxn6 = io_vauxn6; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 65:20]
  assign xadc_vauxp14 = io_vauxp14; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 66:20]
  assign xadc_vauxn14 = io_vauxn14; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 67:20]
  assign xadc_vauxp7 = io_vauxp7; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 68:20]
  assign xadc_vauxn7 = io_vauxn7; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 69:20]
  assign xadc_vauxp15 = io_vauxp15; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 70:20]
  assign xadc_vauxn15 = io_vauxn15; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 71:20]
  assign xadc_daddr_in = 2'h3 == auxIdx ? 7'h1f : _GEN_2; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 84:{20,20}]
  assign xadc_den_in = ~state; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 87:30]
  assign xadc_di_in = 16'h0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 85:20]
  assign xadc_dwe_in = 1'h0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 86:20]
  assign xadc_vp_in = 1'h0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 60:20]
  assign xadc_vn_in = 1'h0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 61:20]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
      dataReg_0 <= 16'h0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
    end else if (!(_xadc_io_den_in_T)) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17]
      if (state) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17]
        if (xadc_drdy_out) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 96:30]
          dataReg_0 <= _GEN_4;
        end
      end
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
      dataReg_1 <= 16'h0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
    end else if (!(_xadc_io_den_in_T)) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17]
      if (state) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17]
        if (xadc_drdy_out) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 96:30]
          dataReg_1 <= _GEN_5;
        end
      end
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
      dataReg_2 <= 16'h0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
    end else if (!(_xadc_io_den_in_T)) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17]
      if (state) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17]
        if (xadc_drdy_out) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 96:30]
          dataReg_2 <= _GEN_6;
        end
      end
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
      dataReg_3 <= 16'h0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 77:24]
    end else if (!(_xadc_io_den_in_T)) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17]
      if (state) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17]
        if (xadc_drdy_out) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 96:30]
          dataReg_3 <= _GEN_7;
        end
      end
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 81:22]
      state <= 1'h0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 81:22]
    end else begin
      state <= _GEN_20;
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 82:23]
      auxIdx <= 2'h0; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 82:23]
    end else if (!(_xadc_io_den_in_T)) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17]
      if (state) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 90:17]
        if (xadc_drdy_out) begin // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 96:30]
          auxIdx <= _auxIdx_T_1; // @[\\src\\main\\scala\\rvsoc\\AdcController.scala 98:16]
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  dataReg_0 = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  dataReg_1 = _RAND_1[15:0];
  _RAND_2 = {1{`RANDOM}};
  dataReg_2 = _RAND_2[15:0];
  _RAND_3 = {1{`RANDOM}};
  dataReg_3 = _RAND_3[15:0];
  _RAND_4 = {1{`RANDOM}};
  state = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  auxIdx = _RAND_5[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module PwmController(
  input         clock,
  input         reset,
  input  [7:0]  io_duty_0, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_1, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_2, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_3, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_4, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_5, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_6, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_7, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_8, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_9, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_10, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_11, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_12, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_13, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_14, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_15, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_16, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_17, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_18, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_19, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_20, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_21, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_22, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  input  [7:0]  io_duty_23, // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
  output [23:0] io_pwmOut // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] counter; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 24:26]
  wire [7:0] _counter_T_1 = counter + 8'h1; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 25:24]
  wire  pwmBits_0 = counter < io_duty_0; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_1 = counter < io_duty_1; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_2 = counter < io_duty_2; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_3 = counter < io_duty_3; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_4 = counter < io_duty_4; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_5 = counter < io_duty_5; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_6 = counter < io_duty_6; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_7 = counter < io_duty_7; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_8 = counter < io_duty_8; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_9 = counter < io_duty_9; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_10 = counter < io_duty_10; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_11 = counter < io_duty_11; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_12 = counter < io_duty_12; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_13 = counter < io_duty_13; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_14 = counter < io_duty_14; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_15 = counter < io_duty_15; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_16 = counter < io_duty_16; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_17 = counter < io_duty_17; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_18 = counter < io_duty_18; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_19 = counter < io_duty_19; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_20 = counter < io_duty_20; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_21 = counter < io_duty_21; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_22 = counter < io_duty_22; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire  pwmBits_23 = counter < io_duty_23; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 30:31]
  wire [5:0] io_pwmOut_lo_lo = {pwmBits_5,pwmBits_4,pwmBits_3,pwmBits_2,pwmBits_1,pwmBits_0}; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 33:26]
  wire [11:0] io_pwmOut_lo = {pwmBits_11,pwmBits_10,pwmBits_9,pwmBits_8,pwmBits_7,pwmBits_6,io_pwmOut_lo_lo}; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 33:26]
  wire [5:0] io_pwmOut_hi_lo = {pwmBits_17,pwmBits_16,pwmBits_15,pwmBits_14,pwmBits_13,pwmBits_12}; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 33:26]
  wire [11:0] io_pwmOut_hi = {pwmBits_23,pwmBits_22,pwmBits_21,pwmBits_20,pwmBits_19,pwmBits_18,io_pwmOut_hi_lo}; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 33:26]
  assign io_pwmOut = {io_pwmOut_hi,io_pwmOut_lo}; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 33:26]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 24:26]
      counter <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 24:26]
    end else begin
      counter <= _counter_T_1; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 25:13]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  counter = _RAND_0[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Tx(
  input        clock,
  input        reset,
  output       io_txd, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 22:14]
  output       io_channel_ready, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 22:14]
  input        io_channel_valid, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 22:14]
  input  [7:0] io_channel_bits // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 22:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [10:0] shiftReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 29:25]
  reg [19:0] cntReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 30:23]
  reg [3:0] bitsReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 31:24]
  wire  _io_channel_ready_T = cntReg == 20'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 33:31]
  wire [9:0] shift = shiftReg[10:1]; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 40:28]
  wire [10:0] _shiftReg_T_1 = {1'h1,shift}; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 41:22]
  wire [3:0] _bitsReg_T_1 = bitsReg - 4'h1; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 42:26]
  wire [10:0] _shiftReg_T_3 = {2'h3,io_channel_bits,1'h0}; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 45:24]
  wire [19:0] _cntReg_T_1 = cntReg - 20'h1; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 53:22]
  assign io_txd = shiftReg[0]; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 34:21]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 33:40]
  always @(posedge clock) begin
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 29:25]
      shiftReg <= 11'h7ff; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 29:25]
    end else if (_io_channel_ready_T) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 36:24]
      if (bitsReg != 4'h0) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 39:27]
        shiftReg <= _shiftReg_T_1; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 41:16]
      end else if (io_channel_valid) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 44:30]
        shiftReg <= _shiftReg_T_3; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 45:18]
      end else begin
        shiftReg <= 11'h7ff; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 48:18]
      end
    end
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 30:23]
      cntReg <= 20'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 30:23]
    end else if (_io_channel_ready_T) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 36:24]
      cntReg <= 20'h363; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 38:12]
    end else begin
      cntReg <= _cntReg_T_1; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 53:12]
    end
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 31:24]
      bitsReg <= 4'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 31:24]
    end else if (_io_channel_ready_T) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 36:24]
      if (bitsReg != 4'h0) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 39:27]
        bitsReg <= _bitsReg_T_1; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 42:15]
      end else if (io_channel_valid) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 44:30]
        bitsReg <= 4'hb; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 46:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  shiftReg = _RAND_0[10:0];
  _RAND_1 = {1{`RANDOM}};
  cntReg = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  bitsReg = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Buffer(
  input        clock,
  input        reset,
  output       io_in_ready, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 110:14]
  input        io_in_valid, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 110:14]
  input  [7:0] io_in_bits, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 110:14]
  input        io_out_ready, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 110:14]
  output       io_out_valid, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 110:14]
  output [7:0] io_out_bits // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 110:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  stateReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 116:25]
  reg [7:0] dataReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 117:24]
  wire  _io_in_ready_T = ~stateReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 119:27]
  wire  _GEN_1 = io_in_valid | stateReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 123:23 125:16 116:25]
  assign io_in_ready = ~stateReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 119:27]
  assign io_out_valid = stateReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 120:28]
  assign io_out_bits = dataReg; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 132:15]
  always @(posedge clock) begin
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 116:25]
      stateReg <= 1'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 116:25]
    end else if (_io_in_ready_T) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 122:28]
      stateReg <= _GEN_1;
    end else if (io_out_ready) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 128:24]
      stateReg <= 1'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 129:16]
    end
    if (reset) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 117:24]
      dataReg <= 8'h0; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 117:24]
    end else if (_io_in_ready_T) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 122:28]
      if (io_in_valid) begin // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 123:23]
        dataReg <= io_in_bits; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 124:15]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  stateReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  dataReg = _RAND_1[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BufferedTx(
  input        clock,
  input        reset,
  output       io_txd, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 139:14]
  output       io_channel_ready, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 139:14]
  input        io_channel_valid, // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 139:14]
  input  [7:0] io_channel_bits // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 139:14]
);
  wire  tx_clock; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 143:18]
  wire  tx_reset; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 143:18]
  wire  tx_io_txd; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 143:18]
  wire  tx_io_channel_ready; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 143:18]
  wire  tx_io_channel_valid; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 143:18]
  wire [7:0] tx_io_channel_bits; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 143:18]
  wire  buf__clock; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 144:19]
  wire  buf__reset; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 144:19]
  wire  buf__io_in_ready; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 144:19]
  wire  buf__io_in_valid; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 144:19]
  wire [7:0] buf__io_in_bits; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 144:19]
  wire  buf__io_out_ready; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 144:19]
  wire  buf__io_out_valid; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 144:19]
  wire [7:0] buf__io_out_bits; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 144:19]
  Tx tx ( // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 143:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Buffer buf_ ( // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 144:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_ready(buf__io_in_ready),
    .io_in_valid(buf__io_in_valid),
    .io_in_bits(buf__io_in_bits),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid),
    .io_out_bits(buf__io_out_bits)
  );
  assign io_txd = tx_io_txd; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 148:10]
  assign io_channel_ready = buf__io_in_ready; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 146:13]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 147:17]
  assign tx_io_channel_bits = buf__io_out_bits; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 147:17]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = io_channel_valid; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 146:13]
  assign buf__io_in_bits = io_channel_bits; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 146:13]
  assign buf__io_out_ready = tx_io_channel_ready; // @[\\ip-contributions\\src\\main\\scala\\chisel\\lib\\uart\\Uart.scala 147:17]
endmodule
module ButtonDebouncer(
  input        clock,
  input        reset,
  input  [3:0] io_in, // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 11:14]
  output [3:0] io_out // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 11:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] sync0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 16:22]
  reg [3:0] sync1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 17:22]
  reg [19:0] counters_0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg [19:0] counters_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg [19:0] counters_2; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg [19:0] counters_3; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg  stable_0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  reg  stable_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  reg  stable_2; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  reg  stable_3; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  wire [19:0] _counters_0_T_1 = counters_0 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire [19:0] _counters_1_T_1 = counters_1 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire [19:0] _counters_2_T_1 = counters_2 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire [19:0] _counters_3_T_1 = counters_3 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire [1:0] io_out_lo = {stable_1,stable_0}; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 36:20]
  wire [1:0] io_out_hi = {stable_3,stable_2}; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 36:20]
  assign io_out = {io_out_hi,io_out_lo}; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 36:20]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 16:22]
      sync0 <= 4'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 16:22]
    end else begin
      sync0 <= io_in; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 16:22]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 17:22]
      sync1 <= 4'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 17:22]
    end else begin
      sync1 <= sync0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 17:22]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_0 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[0] == stable_0) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_0 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_0 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_0 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_0 <= _counters_0_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_1 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[1] == stable_1) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_1 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_1 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_1 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_1 <= _counters_1_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_2 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[2] == stable_2) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_2 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_2 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_2 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_2 <= _counters_2_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_3 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[3] == stable_3) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_3 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_3 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_3 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_3 <= _counters_3_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
      stable_0 <= 1'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
    end else if (!(sync1[0] == stable_0)) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      if (counters_0 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
        stable_0 <= sync1[0]; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 29:17]
      end
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
      stable_1 <= 1'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
    end else if (!(sync1[1] == stable_1)) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      if (counters_1 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
        stable_1 <= sync1[1]; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 29:17]
      end
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
      stable_2 <= 1'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
    end else if (!(sync1[2] == stable_2)) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      if (counters_2 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
        stable_2 <= sync1[2]; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 29:17]
      end
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
      stable_3 <= 1'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
    end else if (!(sync1[3] == stable_3)) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      if (counters_3 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
        stable_3 <= sync1[3]; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 29:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  sync0 = _RAND_0[3:0];
  _RAND_1 = {1{`RANDOM}};
  sync1 = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  counters_0 = _RAND_2[19:0];
  _RAND_3 = {1{`RANDOM}};
  counters_1 = _RAND_3[19:0];
  _RAND_4 = {1{`RANDOM}};
  counters_2 = _RAND_4[19:0];
  _RAND_5 = {1{`RANDOM}};
  counters_3 = _RAND_5[19:0];
  _RAND_6 = {1{`RANDOM}};
  stable_0 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  stable_1 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  stable_2 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  stable_3 = _RAND_9[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ButtonDebouncer_1(
  input        clock,
  input        reset,
  input  [7:0] io_in, // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 11:14]
  output [7:0] io_out // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 11:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] sync0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 16:22]
  reg [7:0] sync1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 17:22]
  reg [19:0] counters_0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg [19:0] counters_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg [19:0] counters_2; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg [19:0] counters_3; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg [19:0] counters_4; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg [19:0] counters_5; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg [19:0] counters_6; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg [19:0] counters_7; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
  reg  stable_0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  reg  stable_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  reg  stable_2; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  reg  stable_3; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  reg  stable_4; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  reg  stable_5; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  reg  stable_6; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  reg  stable_7; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23]
  wire [19:0] _counters_0_T_1 = counters_0 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire  _GEN_0 = counters_0 == 20'hf423f ? sync1[0] : stable_0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70 29:17 21:23]
  wire  _GEN_3 = sync1[0] == stable_0 ? stable_0 : _GEN_0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23 26:34]
  wire [19:0] _counters_1_T_1 = counters_1 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire  _GEN_4 = counters_1 == 20'hf423f ? sync1[1] : stable_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70 29:17 21:23]
  wire  _GEN_7 = sync1[1] == stable_1 ? stable_1 : _GEN_4; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23 26:34]
  wire [19:0] _counters_2_T_1 = counters_2 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire  _GEN_8 = counters_2 == 20'hf423f ? sync1[2] : stable_2; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70 29:17 21:23]
  wire  _GEN_11 = sync1[2] == stable_2 ? stable_2 : _GEN_8; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23 26:34]
  wire [19:0] _counters_3_T_1 = counters_3 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire  _GEN_12 = counters_3 == 20'hf423f ? sync1[3] : stable_3; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70 29:17 21:23]
  wire  _GEN_15 = sync1[3] == stable_3 ? stable_3 : _GEN_12; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23 26:34]
  wire [19:0] _counters_4_T_1 = counters_4 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire  _GEN_16 = counters_4 == 20'hf423f ? sync1[4] : stable_4; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70 29:17 21:23]
  wire  _GEN_19 = sync1[4] == stable_4 ? stable_4 : _GEN_16; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23 26:34]
  wire [19:0] _counters_5_T_1 = counters_5 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire  _GEN_20 = counters_5 == 20'hf423f ? sync1[5] : stable_5; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70 29:17 21:23]
  wire  _GEN_23 = sync1[5] == stable_5 ? stable_5 : _GEN_20; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23 26:34]
  wire [19:0] _counters_6_T_1 = counters_6 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire  _GEN_24 = counters_6 == 20'hf423f ? sync1[6] : stable_6; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70 29:17 21:23]
  wire  _GEN_27 = sync1[6] == stable_6 ? stable_6 : _GEN_24; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23 26:34]
  wire [19:0] _counters_7_T_1 = counters_7 + 20'h1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:34]
  wire  _GEN_28 = counters_7 == 20'hf423f ? sync1[7] : stable_7; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70 29:17 21:23]
  wire  _GEN_31 = sync1[7] == stable_7 ? stable_7 : _GEN_28; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:23 26:34]
  wire [3:0] io_out_lo = {stable_3,stable_2,stable_1,stable_0}; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 36:20]
  wire [3:0] io_out_hi = {stable_7,stable_6,stable_5,stable_4}; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 36:20]
  assign io_out = {io_out_hi,io_out_lo}; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 36:20]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 16:22]
      sync0 <= 8'hff; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 16:22]
    end else begin
      sync0 <= io_in; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 16:22]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 17:22]
      sync1 <= 8'hff; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 17:22]
    end else begin
      sync1 <= sync0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 17:22]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_0 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[0] == stable_0) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_0 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_0 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_0 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_0 <= _counters_0_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_1 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[1] == stable_1) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_1 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_1 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_1 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_1 <= _counters_1_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_2 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[2] == stable_2) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_2 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_2 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_2 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_2 <= _counters_2_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_3 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[3] == stable_3) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_3 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_3 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_3 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_3 <= _counters_3_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_4 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[4] == stable_4) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_4 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_4 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_4 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_4 <= _counters_4_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_5 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[5] == stable_5) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_5 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_5 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_5 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_5 <= _counters_5_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_6 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[6] == stable_6) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_6 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_6 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_6 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_6 <= _counters_6_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
      counters_7 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 20:25]
    end else if (sync1[7] == stable_7) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 26:34]
      counters_7 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 27:19]
    end else if (counters_7 == 20'hf423f) begin // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 28:70]
      counters_7 <= 20'h0; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 30:19]
    end else begin
      counters_7 <= _counters_7_T_1; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 32:19]
    end
    stable_0 <= reset | _GEN_3; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:{23,23}]
    stable_1 <= reset | _GEN_7; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:{23,23}]
    stable_2 <= reset | _GEN_11; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:{23,23}]
    stable_3 <= reset | _GEN_15; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:{23,23}]
    stable_4 <= reset | _GEN_19; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:{23,23}]
    stable_5 <= reset | _GEN_23; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:{23,23}]
    stable_6 <= reset | _GEN_27; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:{23,23}]
    stable_7 <= reset | _GEN_31; // @[\\src\\main\\scala\\rvsoc\\ButtonDebouncer.scala 21:{23,23}]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  sync0 = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  sync1 = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  counters_0 = _RAND_2[19:0];
  _RAND_3 = {1{`RANDOM}};
  counters_1 = _RAND_3[19:0];
  _RAND_4 = {1{`RANDOM}};
  counters_2 = _RAND_4[19:0];
  _RAND_5 = {1{`RANDOM}};
  counters_3 = _RAND_5[19:0];
  _RAND_6 = {1{`RANDOM}};
  counters_4 = _RAND_6[19:0];
  _RAND_7 = {1{`RANDOM}};
  counters_5 = _RAND_7[19:0];
  _RAND_8 = {1{`RANDOM}};
  counters_6 = _RAND_8[19:0];
  _RAND_9 = {1{`RANDOM}};
  counters_7 = _RAND_9[19:0];
  _RAND_10 = {1{`RANDOM}};
  stable_0 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  stable_1 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  stable_2 = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  stable_3 = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  stable_4 = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  stable_5 = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  stable_6 = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  stable_7 = _RAND_17[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module RustSoCTop(
  input        clock,
  input        reset,
  inout  [7:0] io_gpioJA, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  inout  [7:0] io_gpioJB, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  inout  [7:0] io_gpioJC, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  output       io_tx, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  input        io_rx, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  output [7:0] io_led, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  input  [3:0] io_btn, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  input        io_vauxp6, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  input        io_vauxn6, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  input        io_vauxp14, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  input        io_vauxn14, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  input        io_vauxp7, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  input        io_vauxn7, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  input        io_vauxp15, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
  input        io_vauxn15 // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 87:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
`endif // RANDOMIZE_REG_INIT
  wire  resetRx_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 113:23]
  wire  resetRx_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 113:23]
  wire  resetRx_io_rxd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 113:23]
  wire  resetRx_io_channel_ready; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 113:23]
  wire  resetRx_io_channel_valid; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 113:23]
  wire [7:0] resetRx_io_channel_bits; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 113:23]
  wire  bootloader_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 144:53]
  wire  bootloader_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 144:53]
  wire [31:0] bootloader_io_instrData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 144:53]
  wire [31:0] bootloader_io_instrAddr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 144:53]
  wire  bootloader_io_wrEnabled; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 144:53]
  wire  bootloader_io_rx; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 144:53]
  wire  cpu_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire  cpu_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire [31:0] cpu_io_imem_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire [31:0] cpu_io_imem_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire  cpu_io_imem_ack; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire [31:0] cpu_io_dmem_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire  cpu_io_dmem_rd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire  cpu_io_dmem_wr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire [31:0] cpu_io_dmem_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire [31:0] cpu_io_dmem_wrData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire [3:0] cpu_io_dmem_wrMask; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
  wire  imem_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 171:20]
  wire  imem_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 171:20]
  wire [31:0] imem_io_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 171:20]
  wire  imem_io_rd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 171:20]
  wire  imem_io_wr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 171:20]
  wire [31:0] imem_io_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 171:20]
  wire [31:0] imem_io_wrData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 171:20]
  wire [3:0] imem_io_wrMask; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 171:20]
  wire  imem_io_ack; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 171:20]
  wire  dmem_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 172:20]
  wire  dmem_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 172:20]
  wire [31:0] dmem_io_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 172:20]
  wire  dmem_io_rd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 172:20]
  wire  dmem_io_wr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 172:20]
  wire [31:0] dmem_io_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 172:20]
  wire [31:0] dmem_io_wrData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 172:20]
  wire [3:0] dmem_io_wrMask; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 172:20]
  wire  dmem_io_ack; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 172:20]
  wire  adc_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire  adc_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire  adc_io_vauxp6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire  adc_io_vauxn6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire  adc_io_vauxp14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire  adc_io_vauxn14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire  adc_io_vauxp7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire  adc_io_vauxn7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire  adc_io_vauxp15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire  adc_io_vauxn15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire [15:0] adc_io_adcData0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire [15:0] adc_io_adcData1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire [15:0] adc_io_adcData2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire [15:0] adc_io_adcData3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
  wire  pwm_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire  pwm_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_5; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_11; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_12; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_13; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_16; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_17; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_18; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_19; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_20; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_21; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_22; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [7:0] pwm_io_duty_23; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire [23:0] pwm_io_pwmOut; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
  wire  uartTx_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 264:49]
  wire  uartTx_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 264:49]
  wire  uartTx_io_txd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 264:49]
  wire  uartTx_io_channel_ready; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 264:49]
  wire  uartTx_io_channel_valid; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 264:49]
  wire [7:0] uartTx_io_channel_bits; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 264:49]
  wire  uartRx_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 265:49]
  wire  uartRx_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 265:49]
  wire  uartRx_io_rxd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 265:49]
  wire  uartRx_io_channel_ready; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 265:49]
  wire  uartRx_io_channel_valid; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 265:49]
  wire [7:0] uartRx_io_channel_bits; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 265:49]
  wire  btnDebouncer_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:55]
  wire  btnDebouncer_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:55]
  wire [3:0] btnDebouncer_io_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:55]
  wire [3:0] btnDebouncer_io_out; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:55]
  wire [7:0] bufJA_dir; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 294:21]
  wire [7:0] bufJA_out; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 294:21]
  wire [7:0] bufJA_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 294:21]
  wire  gpioJADebouncer_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 303:58]
  wire  gpioJADebouncer_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 303:58]
  wire [7:0] gpioJADebouncer_io_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 303:58]
  wire [7:0] gpioJADebouncer_io_out; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 303:58]
  wire [7:0] bufJB_dir; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 313:21]
  wire [7:0] bufJB_out; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 313:21]
  wire [7:0] bufJB_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 313:21]
  wire  gpioJBDebouncer_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 322:58]
  wire  gpioJBDebouncer_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 322:58]
  wire [7:0] gpioJBDebouncer_io_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 322:58]
  wire [7:0] gpioJBDebouncer_io_out; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 322:58]
  wire [7:0] bufJC_dir; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 332:21]
  wire [7:0] bufJC_out; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 332:21]
  wire [7:0] bufJC_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 332:21]
  wire  gpioJCDebouncer_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 341:58]
  wire  gpioJCDebouncer_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 341:58]
  wire [7:0] gpioJCDebouncer_io_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 341:58]
  wire [7:0] gpioJCDebouncer_io_out; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 341:58]
  reg [31:0] resetShift; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 117:27]
  wire [31:0] _resetShift_T_1 = {resetRx_io_channel_bits,resetShift[31:8]}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 119:43]
  wire  softReset = resetShift == 32'hdeadbeef; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 123:19]
  wire  combinedReset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  reg  cpuRunning; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 135:54]
  wire  _bootWrite_T = ~cpuRunning; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 147:19]
  wire  bootWrite = ~cpuRunning & bootloader_io_wrEnabled; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 147:31]
  wire  bootDone = bootWrite & bootloader_io_instrAddr == 32'h0 & bootloader_io_instrData == 32'hd0000000; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 150:53]
  wire  _GEN_3 = bootDone | cpuRunning; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 153:18 154:16 135:54]
  wire  _T_3 = bootloader_io_instrAddr < 32'h1000; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 206:19]
  wire  _T_6 = bootloader_io_instrAddr >= 32'h1000 & bootloader_io_instrAddr < 32'h2000; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 213:38]
  wire [31:0] _dmem_io_address_T_1 = bootloader_io_instrAddr - 32'h1000; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 215:35]
  wire [31:0] _GEN_4 = bootloader_io_instrAddr >= 32'h1000 & bootloader_io_instrAddr < 32'h2000 ? _dmem_io_address_T_1
     : 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:21 213:63 215:23]
  wire [31:0] _GEN_6 = bootloader_io_instrAddr >= 32'h1000 & bootloader_io_instrAddr < 32'h2000 ?
    bootloader_io_instrData : 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 202:21 213:63 217:23]
  wire [3:0] _GEN_7 = bootloader_io_instrAddr >= 32'h1000 & bootloader_io_instrAddr < 32'h2000 ? 4'hf : 4'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 203:21 213:63 218:23]
  wire [31:0] _GEN_9 = bootloader_io_instrAddr < 32'h1000 ? bootloader_io_instrAddr : 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:21 206:32 208:23]
  wire [31:0] _GEN_11 = bootloader_io_instrAddr < 32'h1000 ? bootloader_io_instrData : 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:21 206:32 210:23]
  wire [3:0] _GEN_12 = bootloader_io_instrAddr < 32'h1000 ? 4'hf : 4'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 197:21 206:32 211:23]
  wire [31:0] _GEN_14 = bootloader_io_instrAddr < 32'h1000 ? 32'h0 : _GEN_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:21 206:32]
  wire  _GEN_15 = bootloader_io_instrAddr < 32'h1000 ? 1'h0 : _T_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 201:21 206:32]
  wire [31:0] _GEN_16 = bootloader_io_instrAddr < 32'h1000 ? 32'h0 : _GEN_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 202:21 206:32]
  wire [3:0] _GEN_17 = bootloader_io_instrAddr < 32'h1000 ? 4'h0 : _GEN_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 203:21 206:32]
  wire  _GEN_25 = bootWrite & ~bootDone ? _GEN_15 : cpu_io_dmem_wr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 179:15 193:32]
  wire [31:0] _GEN_31 = _bootWrite_T ? 32'h0 : dmem_io_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 179:15 228:21 231:24]
  reg [15:0] pwmEnable; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 252:53]
  reg [7:0] pwmDutyRegs_0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_5; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_11; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_12; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_13; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_16; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_17; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_18; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_19; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_20; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_21; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_22; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] pwmDutyRegs_23; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
  reg [7:0] gpioJADirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 289:56]
  reg [7:0] gpioJAOutReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 290:56]
  reg [7:0] gpioJAPwmEn; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 292:56]
  wire  finalJAOut_0 = gpioJAPwmEn[0] ? pwm_io_pwmOut[0] : gpioJAOutReg[0]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 299:25]
  wire  finalJAOut_1 = gpioJAPwmEn[1] ? pwm_io_pwmOut[1] : gpioJAOutReg[1]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 299:25]
  wire  finalJAOut_2 = gpioJAPwmEn[2] ? pwm_io_pwmOut[2] : gpioJAOutReg[2]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 299:25]
  wire  finalJAOut_3 = gpioJAPwmEn[3] ? pwm_io_pwmOut[3] : gpioJAOutReg[3]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 299:25]
  wire  finalJAOut_4 = gpioJAPwmEn[4] ? pwm_io_pwmOut[4] : gpioJAOutReg[4]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 299:25]
  wire  finalJAOut_5 = gpioJAPwmEn[5] ? pwm_io_pwmOut[5] : gpioJAOutReg[5]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 299:25]
  wire  finalJAOut_6 = gpioJAPwmEn[6] ? pwm_io_pwmOut[6] : gpioJAOutReg[6]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 299:25]
  wire  finalJAOut_7 = gpioJAPwmEn[7] ? pwm_io_pwmOut[7] : gpioJAOutReg[7]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 299:25]
  wire [3:0] bufJA_io_out_lo = {finalJAOut_3,finalJAOut_2,finalJAOut_1,finalJAOut_0}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 301:30]
  wire [3:0] bufJA_io_out_hi = {finalJAOut_7,finalJAOut_6,finalJAOut_5,finalJAOut_4}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 301:30]
  reg [7:0] gpioJBDirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 308:56]
  reg [7:0] gpioJBOutReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 309:56]
  reg [7:0] gpioJBPwmEn; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 311:56]
  wire  finalJBOut_0 = gpioJBPwmEn[0] ? pwm_io_pwmOut[8] : gpioJBOutReg[0]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 318:25]
  wire  finalJBOut_1 = gpioJBPwmEn[1] ? pwm_io_pwmOut[9] : gpioJBOutReg[1]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 318:25]
  wire  finalJBOut_2 = gpioJBPwmEn[2] ? pwm_io_pwmOut[10] : gpioJBOutReg[2]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 318:25]
  wire  finalJBOut_3 = gpioJBPwmEn[3] ? pwm_io_pwmOut[11] : gpioJBOutReg[3]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 318:25]
  wire  finalJBOut_4 = gpioJBPwmEn[4] ? pwm_io_pwmOut[12] : gpioJBOutReg[4]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 318:25]
  wire  finalJBOut_5 = gpioJBPwmEn[5] ? pwm_io_pwmOut[13] : gpioJBOutReg[5]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 318:25]
  wire  finalJBOut_6 = gpioJBPwmEn[6] ? pwm_io_pwmOut[14] : gpioJBOutReg[6]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 318:25]
  wire  finalJBOut_7 = gpioJBPwmEn[7] ? pwm_io_pwmOut[15] : gpioJBOutReg[7]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 318:25]
  wire [3:0] bufJB_io_out_lo = {finalJBOut_3,finalJBOut_2,finalJBOut_1,finalJBOut_0}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 320:30]
  wire [3:0] bufJB_io_out_hi = {finalJBOut_7,finalJBOut_6,finalJBOut_5,finalJBOut_4}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 320:30]
  reg [7:0] gpioJCDirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 327:56]
  reg [7:0] gpioJCOutReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 328:56]
  reg [7:0] gpioJCPwmEn; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 330:56]
  wire  finalJCOut_0 = gpioJCPwmEn[0] ? pwm_io_pwmOut[16] : gpioJCOutReg[0]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 337:25]
  wire  finalJCOut_1 = gpioJCPwmEn[1] ? pwm_io_pwmOut[17] : gpioJCOutReg[1]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 337:25]
  wire  finalJCOut_2 = gpioJCPwmEn[2] ? pwm_io_pwmOut[18] : gpioJCOutReg[2]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 337:25]
  wire  finalJCOut_3 = gpioJCPwmEn[3] ? pwm_io_pwmOut[19] : gpioJCOutReg[3]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 337:25]
  wire  finalJCOut_4 = gpioJCPwmEn[4] ? pwm_io_pwmOut[20] : gpioJCOutReg[4]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 337:25]
  wire  finalJCOut_5 = gpioJCPwmEn[5] ? pwm_io_pwmOut[21] : gpioJCOutReg[5]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 337:25]
  wire  finalJCOut_6 = gpioJCPwmEn[6] ? pwm_io_pwmOut[22] : gpioJCOutReg[6]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 337:25]
  wire  finalJCOut_7 = gpioJCPwmEn[7] ? pwm_io_pwmOut[23] : gpioJCOutReg[7]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 337:25]
  wire [3:0] bufJC_io_out_lo = {finalJCOut_3,finalJCOut_2,finalJCOut_1,finalJCOut_0}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 339:30]
  wire [3:0] bufJC_io_out_hi = {finalJCOut_7,finalJCOut_6,finalJCOut_5,finalJCOut_4}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 339:30]
  reg [6:0] ledReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 348:50]
  wire  _isMMIOWrite_T_2 = cpuRunning & cpu_io_dmem_address[31:28] == 4'hf; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 351:32]
  wire  isMMIOWrite = cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 351:75]
  wire [3:0] modSel = cpu_io_dmem_address[23:20]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 353:37]
  wire [7:0] offset = cpu_io_dmem_address[7:0]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 354:37]
  wire  _T_9 = offset == 8'h4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 358:21]
  wire  _T_11 = offset == 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 361:21]
  wire [6:0] _GEN_34 = offset == 8'h0 ? cpu_io_dmem_wrData[6:0] : ledReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 361:{30,39} 348:50]
  wire [15:0] _GEN_35 = _T_11 ? cpu_io_dmem_wrData[15:0] : pwmEnable; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 364:{30,42} 252:53]
  wire [7:0] _GEN_36 = _T_9 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_37 = offset == 8'h8 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire  _T_16 = offset == 8'hc; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:23]
  wire [7:0] _GEN_38 = offset == 8'hc ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_39 = offset == 8'h10 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_40 = offset == 8'h14 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_41 = offset == 8'h18 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_5; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_42 = offset == 8'h1c ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_43 = offset == 8'h20 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_44 = offset == 8'h24 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_45 = offset == 8'h28 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_46 = offset == 8'h2c ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_47 = offset == 8'h30 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_11; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_48 = offset == 8'h34 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_12; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_49 = offset == 8'h38 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_13; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_50 = offset == 8'h3c ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_51 = offset == 8'h40 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_52 = offset == 8'h44 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_16; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_53 = offset == 8'h48 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_17; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_54 = offset == 8'h4c ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_18; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_55 = offset == 8'h50 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_19; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_56 = offset == 8'h54 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_20; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_57 = offset == 8'h58 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_21; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_58 = offset == 8'h5c ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_22; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_59 = offset == 8'h60 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_23; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 366:44 253:55 366:61]
  wire [7:0] _GEN_60 = _T_16 ? cpu_io_dmem_wrData[7:0] : gpioJAPwmEn; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 372:{36,50} 292:56]
  wire [7:0] _GEN_61 = _T_9 ? cpu_io_dmem_wrData[7:0] : gpioJAOutReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 371:{35,50} 290:56]
  wire [7:0] _GEN_62 = _T_9 ? gpioJAPwmEn : _GEN_60; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 371:35 292:56]
  wire [7:0] _GEN_63 = _T_11 ? cpu_io_dmem_wrData[7:0] : gpioJADirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 370:{30,45} 289:56]
  wire [7:0] _GEN_64 = _T_11 ? gpioJAOutReg : _GEN_61; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 370:30 290:56]
  wire [7:0] _GEN_65 = _T_11 ? gpioJAPwmEn : _GEN_62; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 370:30 292:56]
  wire [7:0] _GEN_66 = _T_16 ? cpu_io_dmem_wrData[7:0] : gpioJBPwmEn; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 377:{36,50} 311:56]
  wire [7:0] _GEN_67 = _T_9 ? cpu_io_dmem_wrData[7:0] : gpioJBOutReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 376:{35,50} 309:56]
  wire [7:0] _GEN_68 = _T_9 ? gpioJBPwmEn : _GEN_66; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 376:35 311:56]
  wire [7:0] _GEN_69 = _T_11 ? cpu_io_dmem_wrData[7:0] : gpioJBDirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 375:{30,45} 308:56]
  wire [7:0] _GEN_70 = _T_11 ? gpioJBOutReg : _GEN_67; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 375:30 309:56]
  wire [7:0] _GEN_71 = _T_11 ? gpioJBPwmEn : _GEN_68; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 375:30 311:56]
  wire [7:0] _GEN_72 = _T_16 ? cpu_io_dmem_wrData[7:0] : gpioJCPwmEn; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 382:{36,50} 330:56]
  wire [7:0] _GEN_73 = _T_9 ? cpu_io_dmem_wrData[7:0] : gpioJCOutReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 381:{35,50} 328:56]
  wire [7:0] _GEN_74 = _T_9 ? gpioJCPwmEn : _GEN_72; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 381:35 330:56]
  wire [7:0] _GEN_75 = _T_11 ? cpu_io_dmem_wrData[7:0] : gpioJCDirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 380:{30,45} 327:56]
  wire [7:0] _GEN_76 = _T_11 ? gpioJCOutReg : _GEN_73; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 380:30 328:56]
  wire [7:0] _GEN_77 = _T_11 ? gpioJCPwmEn : _GEN_74; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 380:30 330:56]
  wire [7:0] _GEN_78 = 4'h7 == modSel ? _GEN_75 : gpioJCDirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 327:56]
  wire [7:0] _GEN_79 = 4'h7 == modSel ? _GEN_76 : gpioJCOutReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 328:56]
  wire [7:0] _GEN_80 = 4'h7 == modSel ? _GEN_77 : gpioJCPwmEn; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 330:56]
  wire [7:0] _GEN_81 = 4'h6 == modSel ? _GEN_69 : gpioJBDirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 308:56]
  wire [7:0] _GEN_82 = 4'h6 == modSel ? _GEN_70 : gpioJBOutReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 309:56]
  wire [7:0] _GEN_83 = 4'h6 == modSel ? _GEN_71 : gpioJBPwmEn; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 311:56]
  wire [7:0] _GEN_84 = 4'h6 == modSel ? gpioJCDirReg : _GEN_78; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 327:56]
  wire [7:0] _GEN_85 = 4'h6 == modSel ? gpioJCOutReg : _GEN_79; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 328:56]
  wire [7:0] _GEN_86 = 4'h6 == modSel ? gpioJCPwmEn : _GEN_80; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 330:56]
  wire [7:0] _GEN_87 = 4'h5 == modSel ? _GEN_63 : gpioJADirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 289:56]
  wire [7:0] _GEN_88 = 4'h5 == modSel ? _GEN_64 : gpioJAOutReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 290:56]
  wire [7:0] _GEN_89 = 4'h5 == modSel ? _GEN_65 : gpioJAPwmEn; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 292:56]
  wire [7:0] _GEN_90 = 4'h5 == modSel ? gpioJBDirReg : _GEN_81; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 308:56]
  wire [7:0] _GEN_91 = 4'h5 == modSel ? gpioJBOutReg : _GEN_82; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 309:56]
  wire [7:0] _GEN_92 = 4'h5 == modSel ? gpioJBPwmEn : _GEN_83; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 311:56]
  wire [7:0] _GEN_93 = 4'h5 == modSel ? gpioJCDirReg : _GEN_84; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 327:56]
  wire [7:0] _GEN_94 = 4'h5 == modSel ? gpioJCOutReg : _GEN_85; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 328:56]
  wire [7:0] _GEN_95 = 4'h5 == modSel ? gpioJCPwmEn : _GEN_86; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 330:56]
  wire [15:0] _GEN_96 = 4'h4 == modSel ? _GEN_35 : pwmEnable; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 252:53]
  wire [7:0] _GEN_97 = 4'h4 == modSel ? _GEN_36 : pwmDutyRegs_0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_98 = 4'h4 == modSel ? _GEN_37 : pwmDutyRegs_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_99 = 4'h4 == modSel ? _GEN_38 : pwmDutyRegs_2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_100 = 4'h4 == modSel ? _GEN_39 : pwmDutyRegs_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_101 = 4'h4 == modSel ? _GEN_40 : pwmDutyRegs_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_102 = 4'h4 == modSel ? _GEN_41 : pwmDutyRegs_5; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_103 = 4'h4 == modSel ? _GEN_42 : pwmDutyRegs_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_104 = 4'h4 == modSel ? _GEN_43 : pwmDutyRegs_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_105 = 4'h4 == modSel ? _GEN_44 : pwmDutyRegs_8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_106 = 4'h4 == modSel ? _GEN_45 : pwmDutyRegs_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_107 = 4'h4 == modSel ? _GEN_46 : pwmDutyRegs_10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_108 = 4'h4 == modSel ? _GEN_47 : pwmDutyRegs_11; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_109 = 4'h4 == modSel ? _GEN_48 : pwmDutyRegs_12; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_110 = 4'h4 == modSel ? _GEN_49 : pwmDutyRegs_13; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_111 = 4'h4 == modSel ? _GEN_50 : pwmDutyRegs_14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_112 = 4'h4 == modSel ? _GEN_51 : pwmDutyRegs_15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_113 = 4'h4 == modSel ? _GEN_52 : pwmDutyRegs_16; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_114 = 4'h4 == modSel ? _GEN_53 : pwmDutyRegs_17; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_115 = 4'h4 == modSel ? _GEN_54 : pwmDutyRegs_18; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_116 = 4'h4 == modSel ? _GEN_55 : pwmDutyRegs_19; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_117 = 4'h4 == modSel ? _GEN_56 : pwmDutyRegs_20; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_118 = 4'h4 == modSel ? _GEN_57 : pwmDutyRegs_21; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_119 = 4'h4 == modSel ? _GEN_58 : pwmDutyRegs_22; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_120 = 4'h4 == modSel ? _GEN_59 : pwmDutyRegs_23; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 253:55]
  wire [7:0] _GEN_121 = 4'h4 == modSel ? gpioJADirReg : _GEN_87; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 289:56]
  wire [7:0] _GEN_122 = 4'h4 == modSel ? gpioJAOutReg : _GEN_88; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 290:56]
  wire [7:0] _GEN_123 = 4'h4 == modSel ? gpioJAPwmEn : _GEN_89; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 292:56]
  wire [7:0] _GEN_124 = 4'h4 == modSel ? gpioJBDirReg : _GEN_90; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 308:56]
  wire [7:0] _GEN_125 = 4'h4 == modSel ? gpioJBOutReg : _GEN_91; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 309:56]
  wire [7:0] _GEN_126 = 4'h4 == modSel ? gpioJBPwmEn : _GEN_92; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 311:56]
  wire [7:0] _GEN_127 = 4'h4 == modSel ? gpioJCDirReg : _GEN_93; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 327:56]
  wire [7:0] _GEN_128 = 4'h4 == modSel ? gpioJCOutReg : _GEN_94; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 328:56]
  wire [7:0] _GEN_129 = 4'h4 == modSel ? gpioJCPwmEn : _GEN_95; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 330:56]
  wire  _GEN_165 = 4'h0 == modSel & _T_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20 274:27]
  reg [31:0] memAddressReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 389:30]
  wire  isMMIORead = cpuRunning & memAddressReg[31:28] == 4'hf; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 390:31]
  wire [3:0] modSel_1 = memAddressReg[23:20]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 393:31]
  wire [7:0] offset_1 = memAddressReg[7:0]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 394:31]
  wire  _T_51 = offset_1 == 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 398:21]
  reg [1:0] cpu_io_dmem_rdData_REG; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 398:61]
  wire  _T_52 = offset_1 == 8'h4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 399:26]
  wire [31:0] _GEN_238 = offset_1 == 8'h4 ? {{24'd0}, uartRx_io_channel_bits} : _GEN_31; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 399:{35,56}]
  wire [31:0] _GEN_239 = offset_1 == 8'h0 ? {{30'd0}, cpu_io_dmem_rdData_REG} : _GEN_238; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 398:{30,51}]
  wire  _T_57 = offset_1 == 8'h8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 405:26]
  wire  _T_58 = offset_1 == 8'hc; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 406:26]
  wire [31:0] _GEN_240 = offset_1 == 8'hc ? {{16'd0}, adc_io_adcData3} : _GEN_31; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 406:{36,57}]
  wire [31:0] _GEN_241 = offset_1 == 8'h8 ? {{16'd0}, adc_io_adcData2} : _GEN_240; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 405:{36,57}]
  wire [31:0] _GEN_242 = _T_52 ? {{16'd0}, adc_io_adcData1} : _GEN_241; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 404:{36,57}]
  wire [31:0] _GEN_243 = _T_51 ? {{16'd0}, adc_io_adcData0} : _GEN_242; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 403:{36,57}]
  wire [31:0] _GEN_244 = _T_51 ? {{16'd0}, pwmEnable} : _GEN_31; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 409:{30,51}]
  wire [31:0] _GEN_245 = _T_52 ? {{24'd0}, pwmDutyRegs_0} : _GEN_244; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_246 = _T_57 ? {{24'd0}, pwmDutyRegs_1} : _GEN_245; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_247 = _T_58 ? {{24'd0}, pwmDutyRegs_2} : _GEN_246; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire  _T_64 = offset_1 == 8'h10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:23]
  wire [31:0] _GEN_248 = offset_1 == 8'h10 ? {{24'd0}, pwmDutyRegs_3} : _GEN_247; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_249 = offset_1 == 8'h14 ? {{24'd0}, pwmDutyRegs_4} : _GEN_248; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_250 = offset_1 == 8'h18 ? {{24'd0}, pwmDutyRegs_5} : _GEN_249; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_251 = offset_1 == 8'h1c ? {{24'd0}, pwmDutyRegs_6} : _GEN_250; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_252 = offset_1 == 8'h20 ? {{24'd0}, pwmDutyRegs_7} : _GEN_251; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_253 = offset_1 == 8'h24 ? {{24'd0}, pwmDutyRegs_8} : _GEN_252; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_254 = offset_1 == 8'h28 ? {{24'd0}, pwmDutyRegs_9} : _GEN_253; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_255 = offset_1 == 8'h2c ? {{24'd0}, pwmDutyRegs_10} : _GEN_254; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_256 = offset_1 == 8'h30 ? {{24'd0}, pwmDutyRegs_11} : _GEN_255; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_257 = offset_1 == 8'h34 ? {{24'd0}, pwmDutyRegs_12} : _GEN_256; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_258 = offset_1 == 8'h38 ? {{24'd0}, pwmDutyRegs_13} : _GEN_257; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_259 = offset_1 == 8'h3c ? {{24'd0}, pwmDutyRegs_14} : _GEN_258; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_260 = offset_1 == 8'h40 ? {{24'd0}, pwmDutyRegs_15} : _GEN_259; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_261 = offset_1 == 8'h44 ? {{24'd0}, pwmDutyRegs_16} : _GEN_260; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_262 = offset_1 == 8'h48 ? {{24'd0}, pwmDutyRegs_17} : _GEN_261; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_263 = offset_1 == 8'h4c ? {{24'd0}, pwmDutyRegs_18} : _GEN_262; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_264 = offset_1 == 8'h50 ? {{24'd0}, pwmDutyRegs_19} : _GEN_263; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_265 = offset_1 == 8'h54 ? {{24'd0}, pwmDutyRegs_20} : _GEN_264; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_266 = offset_1 == 8'h58 ? {{24'd0}, pwmDutyRegs_21} : _GEN_265; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_267 = offset_1 == 8'h5c ? {{24'd0}, pwmDutyRegs_22} : _GEN_266; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [31:0] _GEN_268 = offset_1 == 8'h60 ? {{24'd0}, pwmDutyRegs_23} : _GEN_267; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 411:{44,65}]
  wire [7:0] gpioJADebounced = gpioJADebouncer_io_out; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 293:29 305:19]
  wire [31:0] _GEN_269 = _T_64 ? {{24'd0}, gpioJADebounced} : _GEN_31; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 419:{36,57}]
  wire [31:0] _GEN_270 = _T_58 ? {{24'd0}, gpioJAPwmEn} : _GEN_269; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 418:{36,57}]
  wire [7:0] gpioJAIn = bufJA_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 291:26 302:13]
  wire [31:0] _GEN_271 = _T_57 ? {{24'd0}, gpioJAIn} : _GEN_270; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 417:{36,57}]
  wire [31:0] _GEN_272 = _T_52 ? {{24'd0}, gpioJAOutReg} : _GEN_271; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 416:{36,57}]
  wire [31:0] _GEN_273 = _T_51 ? {{24'd0}, gpioJADirReg} : _GEN_272; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 415:{36,57}]
  wire [7:0] gpioJBDebounced = gpioJBDebouncer_io_out; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 312:29 324:19]
  wire [31:0] _GEN_274 = _T_64 ? {{24'd0}, gpioJBDebounced} : _GEN_31; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 426:{36,57}]
  wire [31:0] _GEN_275 = _T_58 ? {{24'd0}, gpioJBPwmEn} : _GEN_274; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 425:{36,57}]
  wire [7:0] gpioJBIn = bufJB_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 310:26 321:13]
  wire [31:0] _GEN_276 = _T_57 ? {{24'd0}, gpioJBIn} : _GEN_275; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 424:{36,57}]
  wire [31:0] _GEN_277 = _T_52 ? {{24'd0}, gpioJBOutReg} : _GEN_276; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 423:{36,57}]
  wire [31:0] _GEN_278 = _T_51 ? {{24'd0}, gpioJBDirReg} : _GEN_277; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 422:{36,57}]
  wire [7:0] gpioJCDebounced = gpioJCDebouncer_io_out; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 331:29 343:19]
  wire [31:0] _GEN_279 = _T_64 ? {{24'd0}, gpioJCDebounced} : _GEN_31; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 433:{36,57}]
  wire [31:0] _GEN_280 = _T_58 ? {{24'd0}, gpioJCPwmEn} : _GEN_279; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 432:{36,57}]
  wire [7:0] gpioJCIn = bufJC_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 329:26 340:13]
  wire [31:0] _GEN_281 = _T_57 ? {{24'd0}, gpioJCIn} : _GEN_280; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 431:{36,57}]
  wire [31:0] _GEN_282 = _T_52 ? {{24'd0}, gpioJCOutReg} : _GEN_281; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 430:{36,57}]
  wire [31:0] _GEN_283 = _T_51 ? {{24'd0}, gpioJCDirReg} : _GEN_282; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 429:{36,57}]
  wire [31:0] _GEN_284 = 4'h7 == modSel_1 ? _GEN_283 : _GEN_31; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 396:20]
  wire [31:0] _GEN_285 = 4'h6 == modSel_1 ? _GEN_278 : _GEN_284; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 396:20]
  wire [31:0] _GEN_286 = 4'h5 == modSel_1 ? _GEN_273 : _GEN_285; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 396:20]
  wire [31:0] _GEN_287 = 4'h4 == modSel_1 ? _GEN_268 : _GEN_286; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 396:20]
  wire [31:0] _GEN_288 = 4'h3 == modSel_1 ? _GEN_243 : _GEN_287; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 396:20]
  wire [31:0] _GEN_289 = 4'h2 == modSel_1 ? {{28'd0}, btnDebouncer_io_out} : _GEN_288; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 396:20 401:36]
  wire [31:0] _GEN_290 = 4'h0 == modSel_1 ? _GEN_239 : _GEN_289; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 396:20]
  Rx resetRx ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 113:23]
    .clock(resetRx_clock),
    .reset(resetRx_reset),
    .io_rxd(resetRx_io_rxd),
    .io_channel_ready(resetRx_io_channel_ready),
    .io_channel_valid(resetRx_io_channel_valid),
    .io_channel_bits(resetRx_io_channel_bits)
  );
  BootloaderTop bootloader ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 144:53]
    .clock(bootloader_clock),
    .reset(bootloader_reset),
    .io_instrData(bootloader_io_instrData),
    .io_instrAddr(bootloader_io_instrAddr),
    .io_wrEnabled(bootloader_io_wrEnabled),
    .io_rx(bootloader_io_rx)
  );
  ThreeCats cpu ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 161:46]
    .clock(cpu_clock),
    .reset(cpu_reset),
    .io_imem_address(cpu_io_imem_address),
    .io_imem_rdData(cpu_io_imem_rdData),
    .io_imem_ack(cpu_io_imem_ack),
    .io_dmem_address(cpu_io_dmem_address),
    .io_dmem_rd(cpu_io_dmem_rd),
    .io_dmem_wr(cpu_io_dmem_wr),
    .io_dmem_rdData(cpu_io_dmem_rdData),
    .io_dmem_wrData(cpu_io_dmem_wrData),
    .io_dmem_wrMask(cpu_io_dmem_wrMask)
  );
  ScratchPadMem imem ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 171:20]
    .clock(imem_clock),
    .reset(imem_reset),
    .io_address(imem_io_address),
    .io_rd(imem_io_rd),
    .io_wr(imem_io_wr),
    .io_rdData(imem_io_rdData),
    .io_wrData(imem_io_wrData),
    .io_wrMask(imem_io_wrMask),
    .io_ack(imem_io_ack)
  );
  ScratchPadMem dmem ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 172:20]
    .clock(dmem_clock),
    .reset(dmem_reset),
    .io_address(dmem_io_address),
    .io_rd(dmem_io_rd),
    .io_wr(dmem_io_wr),
    .io_rdData(dmem_io_rdData),
    .io_wrData(dmem_io_wrData),
    .io_wrMask(dmem_io_wrMask),
    .io_ack(dmem_io_ack)
  );
  AdcController adc ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:46]
    .clock(adc_clock),
    .reset(adc_reset),
    .io_vauxp6(adc_io_vauxp6),
    .io_vauxn6(adc_io_vauxn6),
    .io_vauxp14(adc_io_vauxp14),
    .io_vauxn14(adc_io_vauxn14),
    .io_vauxp7(adc_io_vauxp7),
    .io_vauxn7(adc_io_vauxn7),
    .io_vauxp15(adc_io_vauxp15),
    .io_vauxn15(adc_io_vauxn15),
    .io_adcData0(adc_io_adcData0),
    .io_adcData1(adc_io_adcData1),
    .io_adcData2(adc_io_adcData2),
    .io_adcData3(adc_io_adcData3)
  );
  PwmController pwm ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 251:46]
    .clock(pwm_clock),
    .reset(pwm_reset),
    .io_duty_0(pwm_io_duty_0),
    .io_duty_1(pwm_io_duty_1),
    .io_duty_2(pwm_io_duty_2),
    .io_duty_3(pwm_io_duty_3),
    .io_duty_4(pwm_io_duty_4),
    .io_duty_5(pwm_io_duty_5),
    .io_duty_6(pwm_io_duty_6),
    .io_duty_7(pwm_io_duty_7),
    .io_duty_8(pwm_io_duty_8),
    .io_duty_9(pwm_io_duty_9),
    .io_duty_10(pwm_io_duty_10),
    .io_duty_11(pwm_io_duty_11),
    .io_duty_12(pwm_io_duty_12),
    .io_duty_13(pwm_io_duty_13),
    .io_duty_14(pwm_io_duty_14),
    .io_duty_15(pwm_io_duty_15),
    .io_duty_16(pwm_io_duty_16),
    .io_duty_17(pwm_io_duty_17),
    .io_duty_18(pwm_io_duty_18),
    .io_duty_19(pwm_io_duty_19),
    .io_duty_20(pwm_io_duty_20),
    .io_duty_21(pwm_io_duty_21),
    .io_duty_22(pwm_io_duty_22),
    .io_duty_23(pwm_io_duty_23),
    .io_pwmOut(pwm_io_pwmOut)
  );
  BufferedTx uartTx ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 264:49]
    .clock(uartTx_clock),
    .reset(uartTx_reset),
    .io_txd(uartTx_io_txd),
    .io_channel_ready(uartTx_io_channel_ready),
    .io_channel_valid(uartTx_io_channel_valid),
    .io_channel_bits(uartTx_io_channel_bits)
  );
  Rx uartRx ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 265:49]
    .clock(uartRx_clock),
    .reset(uartRx_reset),
    .io_rxd(uartRx_io_rxd),
    .io_channel_ready(uartRx_io_channel_ready),
    .io_channel_valid(uartRx_io_channel_valid),
    .io_channel_bits(uartRx_io_channel_bits)
  );
  ButtonDebouncer btnDebouncer ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:55]
    .clock(btnDebouncer_clock),
    .reset(btnDebouncer_reset),
    .io_in(btnDebouncer_io_in),
    .io_out(btnDebouncer_io_out)
  );
  TriStateBuffer8 bufJA ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 294:21]
    .pad(io_gpioJA),
    .dir(bufJA_dir),
    .out(bufJA_out),
    .in(bufJA_in)
  );
  ButtonDebouncer_1 gpioJADebouncer ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 303:58]
    .clock(gpioJADebouncer_clock),
    .reset(gpioJADebouncer_reset),
    .io_in(gpioJADebouncer_io_in),
    .io_out(gpioJADebouncer_io_out)
  );
  TriStateBuffer8 bufJB ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 313:21]
    .pad(io_gpioJB),
    .dir(bufJB_dir),
    .out(bufJB_out),
    .in(bufJB_in)
  );
  ButtonDebouncer_1 gpioJBDebouncer ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 322:58]
    .clock(gpioJBDebouncer_clock),
    .reset(gpioJBDebouncer_reset),
    .io_in(gpioJBDebouncer_io_in),
    .io_out(gpioJBDebouncer_io_out)
  );
  TriStateBuffer8 bufJC ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 332:21]
    .pad(io_gpioJC),
    .dir(bufJC_dir),
    .out(bufJC_out),
    .in(bufJC_in)
  );
  ButtonDebouncer_1 gpioJCDebouncer ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 341:58]
    .clock(gpioJCDebouncer_clock),
    .reset(gpioJCDebouncer_reset),
    .io_in(gpioJCDebouncer_io_in),
    .io_out(gpioJCDebouncer_io_out)
  );
  assign io_tx = cpuRunning ? uartTx_io_txd : 1'h1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 268:15]
  assign io_led = {cpuRunning,ledReg}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 442:24]
  assign resetRx_clock = clock;
  assign resetRx_reset = reset;
  assign resetRx_io_rxd = io_rx; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 114:18]
  assign resetRx_io_channel_ready = 1'h1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 115:28]
  assign bootloader_clock = clock;
  assign bootloader_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  assign bootloader_io_rx = cpuRunning | io_rx; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 145:26]
  assign cpu_clock = clock;
  assign cpu_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  assign cpu_io_imem_rdData = _bootWrite_T ? 32'h33 : imem_io_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 178:15 228:21 229:24]
  assign cpu_io_imem_ack = _bootWrite_T ? 1'h0 : imem_io_ack; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 178:15 228:21 230:24]
  assign cpu_io_dmem_rdData = isMMIORead ? _GEN_290 : _GEN_31; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 392:20]
  assign imem_clock = clock;
  assign imem_reset = reset;
  assign imem_io_address = bootWrite & ~bootDone ? _GEN_9 : cpu_io_imem_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 178:15 193:32]
  assign imem_io_rd = bootWrite & ~bootDone ? 1'h0 : 1'h1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 178:15 193:32]
  assign imem_io_wr = bootWrite & ~bootDone & _T_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 178:15 193:32]
  assign imem_io_wrData = bootWrite & ~bootDone ? _GEN_11 : 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 178:15 193:32]
  assign imem_io_wrMask = bootWrite & ~bootDone ? _GEN_12 : 4'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 178:15 193:32]
  assign dmem_clock = clock;
  assign dmem_reset = reset;
  assign dmem_io_address = bootWrite & ~bootDone ? _GEN_14 : cpu_io_dmem_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 179:15 193:32]
  assign dmem_io_rd = bootWrite & ~bootDone ? 1'h0 : cpu_io_dmem_rd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 179:15 193:32]
  assign dmem_io_wr = isMMIOWrite ? 1'h0 : _GEN_25; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21 385:16]
  assign dmem_io_wrData = bootWrite & ~bootDone ? _GEN_16 : cpu_io_dmem_wrData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 179:15 193:32]
  assign dmem_io_wrMask = bootWrite & ~bootDone ? _GEN_17 : cpu_io_dmem_wrMask; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 179:15 193:32]
  assign adc_clock = clock;
  assign adc_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  assign adc_io_vauxp6 = io_vauxp6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 239:19]
  assign adc_io_vauxn6 = io_vauxn6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 240:19]
  assign adc_io_vauxp14 = io_vauxp14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:19]
  assign adc_io_vauxn14 = io_vauxn14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 242:19]
  assign adc_io_vauxp7 = io_vauxp7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 243:19]
  assign adc_io_vauxn7 = io_vauxn7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 244:19]
  assign adc_io_vauxp15 = io_vauxp15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 245:19]
  assign adc_io_vauxn15 = io_vauxn15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 246:19]
  assign pwm_clock = clock;
  assign pwm_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  assign pwm_io_duty_0 = pwmDutyRegs_0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_1 = pwmDutyRegs_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_2 = pwmDutyRegs_2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_3 = pwmDutyRegs_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_4 = pwmDutyRegs_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_5 = pwmDutyRegs_5; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_6 = pwmDutyRegs_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_7 = pwmDutyRegs_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_8 = pwmDutyRegs_8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_9 = pwmDutyRegs_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_10 = pwmDutyRegs_10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_11 = pwmDutyRegs_11; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_12 = pwmDutyRegs_12; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_13 = pwmDutyRegs_13; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_14 = pwmDutyRegs_14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_15 = pwmDutyRegs_15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_16 = pwmDutyRegs_16; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_17 = pwmDutyRegs_17; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_18 = pwmDutyRegs_18; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_19 = pwmDutyRegs_19; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_20 = pwmDutyRegs_20; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_21 = pwmDutyRegs_21; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_22 = pwmDutyRegs_22; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign pwm_io_duty_23 = pwmDutyRegs_23; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 257:20]
  assign uartTx_clock = clock;
  assign uartTx_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  assign uartTx_io_channel_valid = isMMIOWrite & _GEN_165; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21 274:27]
  assign uartTx_io_channel_bits = cpu_io_dmem_wrData[7:0]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 273:48]
  assign uartRx_clock = clock;
  assign uartRx_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  assign uartRx_io_rxd = cpuRunning ? io_rx : 1'h1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 270:23]
  assign uartRx_io_channel_ready = _isMMIOWrite_T_2 & modSel == 4'h0 & _T_9 & cpu_io_dmem_rd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 439:166]
  assign btnDebouncer_clock = clock;
  assign btnDebouncer_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  assign btnDebouncer_io_in = io_btn; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 283:22]
  assign bufJA_dir = gpioJADirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 296:16]
  assign bufJA_out = {bufJA_io_out_hi,bufJA_io_out_lo}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 301:30]
  assign gpioJADebouncer_clock = clock;
  assign gpioJADebouncer_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  assign gpioJADebouncer_io_in = bufJA_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 291:26 302:13]
  assign bufJB_dir = gpioJBDirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 315:16]
  assign bufJB_out = {bufJB_io_out_hi,bufJB_io_out_lo}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 320:30]
  assign gpioJBDebouncer_clock = clock;
  assign gpioJBDebouncer_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  assign gpioJBDebouncer_io_in = bufJB_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 310:26 321:13]
  assign bufJC_dir = gpioJCDirReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 334:16]
  assign bufJC_out = {bufJC_io_out_hi,bufJC_io_out_lo}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 339:30]
  assign gpioJCDebouncer_clock = clock;
  assign gpioJCDebouncer_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:37]
  assign gpioJCDebouncer_io_in = bufJC_in; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 329:26 340:13]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 117:27]
      resetShift <= 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 117:27]
    end else if (softReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 123:35]
      resetShift <= 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:16]
    end else if (resetRx_io_channel_valid) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 118:34]
      resetShift <= _resetShift_T_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 119:16]
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 135:54]
      cpuRunning <= 1'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 135:54]
    end else begin
      cpuRunning <= _GEN_3;
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 252:53]
      pwmEnable <= 16'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 252:53]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmEnable <= _GEN_96;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_0 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_0 <= _GEN_97;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_1 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_1 <= _GEN_98;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_2 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_2 <= _GEN_99;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_3 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_3 <= _GEN_100;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_4 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_4 <= _GEN_101;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_5 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_5 <= _GEN_102;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_6 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_6 <= _GEN_103;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_7 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_7 <= _GEN_104;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_8 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_8 <= _GEN_105;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_9 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_9 <= _GEN_106;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_10 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_10 <= _GEN_107;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_11 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_11 <= _GEN_108;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_12 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_12 <= _GEN_109;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_13 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_13 <= _GEN_110;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_14 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_14 <= _GEN_111;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_15 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_15 <= _GEN_112;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_16 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_16 <= _GEN_113;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_17 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_17 <= _GEN_114;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_18 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_18 <= _GEN_115;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_19 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_19 <= _GEN_116;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_20 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_20 <= _GEN_117;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_21 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_21 <= _GEN_118;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_22 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_22 <= _GEN_119;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
      pwmDutyRegs_23 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 253:55]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          pwmDutyRegs_23 <= _GEN_120;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 289:56]
      gpioJADirReg <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 289:56]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          gpioJADirReg <= _GEN_121;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 290:56]
      gpioJAOutReg <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 290:56]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          gpioJAOutReg <= _GEN_122;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 292:56]
      gpioJAPwmEn <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 292:56]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          gpioJAPwmEn <= _GEN_123;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 308:56]
      gpioJBDirReg <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 308:56]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          gpioJBDirReg <= _GEN_124;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 309:56]
      gpioJBOutReg <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 309:56]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          gpioJBOutReg <= _GEN_125;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 311:56]
      gpioJBPwmEn <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 311:56]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          gpioJBPwmEn <= _GEN_126;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 327:56]
      gpioJCDirReg <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 327:56]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          gpioJCDirReg <= _GEN_127;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 328:56]
      gpioJCOutReg <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 328:56]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          gpioJCOutReg <= _GEN_128;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 330:56]
      gpioJCPwmEn <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 330:56]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (!(4'h1 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          gpioJCPwmEn <= _GEN_129;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 348:50]
      ledReg <= 7'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 348:50]
    end else if (isMMIOWrite) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 352:21]
      if (!(4'h0 == modSel)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
        if (4'h1 == modSel) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 356:20]
          ledReg <= _GEN_34;
        end
      end
    end
    memAddressReg <= cpu_io_dmem_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 389:30]
    cpu_io_dmem_rdData_REG <= {uartRx_io_channel_valid,uartTx_io_channel_ready}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 398:86]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  resetShift = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  cpuRunning = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  pwmEnable = _RAND_2[15:0];
  _RAND_3 = {1{`RANDOM}};
  pwmDutyRegs_0 = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  pwmDutyRegs_1 = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  pwmDutyRegs_2 = _RAND_5[7:0];
  _RAND_6 = {1{`RANDOM}};
  pwmDutyRegs_3 = _RAND_6[7:0];
  _RAND_7 = {1{`RANDOM}};
  pwmDutyRegs_4 = _RAND_7[7:0];
  _RAND_8 = {1{`RANDOM}};
  pwmDutyRegs_5 = _RAND_8[7:0];
  _RAND_9 = {1{`RANDOM}};
  pwmDutyRegs_6 = _RAND_9[7:0];
  _RAND_10 = {1{`RANDOM}};
  pwmDutyRegs_7 = _RAND_10[7:0];
  _RAND_11 = {1{`RANDOM}};
  pwmDutyRegs_8 = _RAND_11[7:0];
  _RAND_12 = {1{`RANDOM}};
  pwmDutyRegs_9 = _RAND_12[7:0];
  _RAND_13 = {1{`RANDOM}};
  pwmDutyRegs_10 = _RAND_13[7:0];
  _RAND_14 = {1{`RANDOM}};
  pwmDutyRegs_11 = _RAND_14[7:0];
  _RAND_15 = {1{`RANDOM}};
  pwmDutyRegs_12 = _RAND_15[7:0];
  _RAND_16 = {1{`RANDOM}};
  pwmDutyRegs_13 = _RAND_16[7:0];
  _RAND_17 = {1{`RANDOM}};
  pwmDutyRegs_14 = _RAND_17[7:0];
  _RAND_18 = {1{`RANDOM}};
  pwmDutyRegs_15 = _RAND_18[7:0];
  _RAND_19 = {1{`RANDOM}};
  pwmDutyRegs_16 = _RAND_19[7:0];
  _RAND_20 = {1{`RANDOM}};
  pwmDutyRegs_17 = _RAND_20[7:0];
  _RAND_21 = {1{`RANDOM}};
  pwmDutyRegs_18 = _RAND_21[7:0];
  _RAND_22 = {1{`RANDOM}};
  pwmDutyRegs_19 = _RAND_22[7:0];
  _RAND_23 = {1{`RANDOM}};
  pwmDutyRegs_20 = _RAND_23[7:0];
  _RAND_24 = {1{`RANDOM}};
  pwmDutyRegs_21 = _RAND_24[7:0];
  _RAND_25 = {1{`RANDOM}};
  pwmDutyRegs_22 = _RAND_25[7:0];
  _RAND_26 = {1{`RANDOM}};
  pwmDutyRegs_23 = _RAND_26[7:0];
  _RAND_27 = {1{`RANDOM}};
  gpioJADirReg = _RAND_27[7:0];
  _RAND_28 = {1{`RANDOM}};
  gpioJAOutReg = _RAND_28[7:0];
  _RAND_29 = {1{`RANDOM}};
  gpioJAPwmEn = _RAND_29[7:0];
  _RAND_30 = {1{`RANDOM}};
  gpioJBDirReg = _RAND_30[7:0];
  _RAND_31 = {1{`RANDOM}};
  gpioJBOutReg = _RAND_31[7:0];
  _RAND_32 = {1{`RANDOM}};
  gpioJBPwmEn = _RAND_32[7:0];
  _RAND_33 = {1{`RANDOM}};
  gpioJCDirReg = _RAND_33[7:0];
  _RAND_34 = {1{`RANDOM}};
  gpioJCOutReg = _RAND_34[7:0];
  _RAND_35 = {1{`RANDOM}};
  gpioJCPwmEn = _RAND_35[7:0];
  _RAND_36 = {1{`RANDOM}};
  ledReg = _RAND_36[6:0];
  _RAND_37 = {1{`RANDOM}};
  memAddressReg = _RAND_37[31:0];
  _RAND_38 = {1{`RANDOM}};
  cpu_io_dmem_rdData_REG = _RAND_38[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
