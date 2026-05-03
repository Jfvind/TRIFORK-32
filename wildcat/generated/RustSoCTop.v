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
  output [15:0] io_pwmOut // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 18:16]
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
  wire [7:0] io_pwmOut_lo = {pwmBits_7,pwmBits_6,pwmBits_5,pwmBits_4,pwmBits_3,pwmBits_2,pwmBits_1,pwmBits_0}; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 33:26]
  wire [7:0] io_pwmOut_hi = {pwmBits_15,pwmBits_14,pwmBits_13,pwmBits_12,pwmBits_11,pwmBits_10,pwmBits_9,pwmBits_8}; // @[\\src\\main\\scala\\rvsoc\\PwmController.scala 33:26]
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
module RustSoCTop(
  input         clock,
  input         reset,
  output [15:0] io_led, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  output        io_tx, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  input         io_rx, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  input  [3:0]  io_btn, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  input         io_vauxp6, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  input         io_vauxn6, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  input         io_vauxp14, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  input         io_vauxn14, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  input         io_vauxp7, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  input         io_vauxn7, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  input         io_vauxp15, // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
  input         io_vauxn15 // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 53:14]
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
`endif // RANDOMIZE_REG_INIT
  wire  resetRx_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 74:23]
  wire  resetRx_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 74:23]
  wire  resetRx_io_rxd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 74:23]
  wire  resetRx_io_channel_ready; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 74:23]
  wire  resetRx_io_channel_valid; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 74:23]
  wire [7:0] resetRx_io_channel_bits; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 74:23]
  wire  bootloader_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 101:53]
  wire  bootloader_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 101:53]
  wire [31:0] bootloader_io_instrData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 101:53]
  wire [31:0] bootloader_io_instrAddr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 101:53]
  wire  bootloader_io_wrEnabled; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 101:53]
  wire  bootloader_io_rx; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 101:53]
  wire  cpu_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire  cpu_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire [31:0] cpu_io_imem_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire [31:0] cpu_io_imem_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire  cpu_io_imem_ack; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire [31:0] cpu_io_dmem_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire  cpu_io_dmem_rd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire  cpu_io_dmem_wr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire [31:0] cpu_io_dmem_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire [31:0] cpu_io_dmem_wrData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire [3:0] cpu_io_dmem_wrMask; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
  wire  imem_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 124:20]
  wire  imem_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 124:20]
  wire [31:0] imem_io_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 124:20]
  wire  imem_io_rd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 124:20]
  wire  imem_io_wr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 124:20]
  wire [31:0] imem_io_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 124:20]
  wire [31:0] imem_io_wrData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 124:20]
  wire [3:0] imem_io_wrMask; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 124:20]
  wire  imem_io_ack; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 124:20]
  wire  dmem_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:20]
  wire  dmem_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:20]
  wire [31:0] dmem_io_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:20]
  wire  dmem_io_rd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:20]
  wire  dmem_io_wr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:20]
  wire [31:0] dmem_io_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:20]
  wire [31:0] dmem_io_wrData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:20]
  wire [3:0] dmem_io_wrMask; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:20]
  wire  dmem_io_ack; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:20]
  wire  adc_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire  adc_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire  adc_io_vauxp6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire  adc_io_vauxn6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire  adc_io_vauxp14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire  adc_io_vauxn14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire  adc_io_vauxp7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire  adc_io_vauxn7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire  adc_io_vauxp15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire  adc_io_vauxn15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire [15:0] adc_io_adcData0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire [15:0] adc_io_adcData1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire [15:0] adc_io_adcData2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire [15:0] adc_io_adcData3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
  wire  pwm_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire  pwm_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_5; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_11; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_12; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_13; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [7:0] pwm_io_duty_15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire [15:0] pwm_io_pwmOut; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
  wire  uartTx_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 205:49]
  wire  uartTx_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 205:49]
  wire  uartTx_io_txd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 205:49]
  wire  uartTx_io_channel_ready; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 205:49]
  wire  uartTx_io_channel_valid; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 205:49]
  wire [7:0] uartTx_io_channel_bits; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 205:49]
  wire  uartRx_clock; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 206:49]
  wire  uartRx_reset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 206:49]
  wire  uartRx_io_rxd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 206:49]
  wire  uartRx_io_channel_ready; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 206:49]
  wire  uartRx_io_channel_valid; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 206:49]
  wire [7:0] uartRx_io_channel_bits; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 206:49]
  reg [31:0] resetShift; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 78:27]
  wire [31:0] _resetShift_T_1 = {resetRx_io_channel_bits,resetShift[31:8]}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 80:43]
  wire  softReset = resetShift == 32'hdeadbeef; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 84:19]
  wire  combinedReset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 91:37]
  reg  cpuRunning; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 94:54]
  wire  _bootWrite_T = ~cpuRunning; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 104:19]
  wire  bootWrite = ~cpuRunning & bootloader_io_wrEnabled; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 104:31]
  wire  bootDone = bootWrite & bootloader_io_instrAddr == 32'h0 & bootloader_io_instrData == 32'hd0000000; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 107:53]
  wire  _GEN_3 = bootDone | cpuRunning; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 110:18 111:16 94:54]
  wire  _T_3 = bootloader_io_instrAddr < 32'h1000; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 155:19]
  wire  _T_6 = bootloader_io_instrAddr >= 32'h1000 & bootloader_io_instrAddr < 32'h2000; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 162:38]
  wire [31:0] _dmem_io_address_T_1 = bootloader_io_instrAddr - 32'h1000; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 164:35]
  wire [31:0] _GEN_4 = bootloader_io_instrAddr >= 32'h1000 & bootloader_io_instrAddr < 32'h2000 ? _dmem_io_address_T_1
     : 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 149:21 162:63 164:23]
  wire [31:0] _GEN_6 = bootloader_io_instrAddr >= 32'h1000 & bootloader_io_instrAddr < 32'h2000 ?
    bootloader_io_instrData : 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 151:21 162:63 166:23]
  wire [3:0] _GEN_7 = bootloader_io_instrAddr >= 32'h1000 & bootloader_io_instrAddr < 32'h2000 ? 4'hf : 4'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 152:21 162:63 167:23]
  wire [31:0] _GEN_9 = bootloader_io_instrAddr < 32'h1000 ? bootloader_io_instrAddr : 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 143:21 155:32 157:23]
  wire [31:0] _GEN_11 = bootloader_io_instrAddr < 32'h1000 ? bootloader_io_instrData : 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 145:21 155:32 159:23]
  wire [3:0] _GEN_12 = bootloader_io_instrAddr < 32'h1000 ? 4'hf : 4'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 146:21 155:32 160:23]
  wire [31:0] _GEN_14 = bootloader_io_instrAddr < 32'h1000 ? 32'h0 : _GEN_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 149:21 155:32]
  wire  _GEN_15 = bootloader_io_instrAddr < 32'h1000 ? 1'h0 : _T_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 150:21 155:32]
  wire [31:0] _GEN_16 = bootloader_io_instrAddr < 32'h1000 ? 32'h0 : _GEN_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 151:21 155:32]
  wire [3:0] _GEN_17 = bootloader_io_instrAddr < 32'h1000 ? 4'h0 : _GEN_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 152:21 155:32]
  wire  _GEN_25 = bootWrite & ~bootDone ? _GEN_15 : cpu_io_dmem_wr; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:15 142:32]
  wire [31:0] _GEN_31 = _bootWrite_T ? 32'h0 : dmem_io_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:15 175:21 178:24]
  reg [15:0] pwmEnable; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 195:53]
  reg [7:0] pwmDutyRegs_0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_5; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_11; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_12; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_13; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [7:0] pwmDutyRegs_15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
  reg [1:0] uartStatusReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 219:30]
  reg [31:0] memAddressReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 220:30]
  wire  _T_10 = cpuRunning & memAddressReg[31:28] == 4'hf; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 223:19]
  wire  _T_15 = memAddressReg[3:0] == 4'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 224:30]
  wire  _T_17 = memAddressReg[3:0] == 4'h4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 226:36]
  wire [31:0] _GEN_33 = memAddressReg[3:0] == 4'h4 ? {{24'd0}, uartRx_io_channel_bits} : _GEN_31; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 226:45 227:26]
  wire  _GEN_34 = memAddressReg[3:0] == 4'h4 & cpu_io_dmem_rd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 216:27 226:45 228:31]
  wire [31:0] _GEN_35 = memAddressReg[3:0] == 4'h0 ? {{30'd0}, uartStatusReg} : _GEN_33; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 224:39 225:26]
  wire  _GEN_36 = memAddressReg[3:0] == 4'h0 ? 1'h0 : _GEN_34; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 216:27 224:39]
  wire [31:0] _GEN_37 = cpuRunning & memAddressReg[31:28] == 4'hf & memAddressReg[23:20] == 4'h0 ? _GEN_35 : _GEN_31; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 223:88]
  reg [15:0] ledReg; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 233:50]
  wire  _T_26 = cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:46]
  wire [15:0] _GEN_39 = cpu_io_dmem_address[6:2] == 5'h0 ? cpu_io_dmem_wrData[15:0] : pwmEnable; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 243:48 244:19 195:53]
  wire [7:0] _GEN_40 = cpu_io_dmem_address[6:2] == 5'h1 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_41 = cpu_io_dmem_address[6:2] == 5'h2 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_42 = cpu_io_dmem_address[6:2] == 5'h3 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_43 = cpu_io_dmem_address[6:2] == 5'h4 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_44 = cpu_io_dmem_address[6:2] == 5'h5 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_45 = cpu_io_dmem_address[6:2] == 5'h6 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_5; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_46 = cpu_io_dmem_address[6:2] == 5'h7 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_47 = cpu_io_dmem_address[6:2] == 5'h8 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_48 = cpu_io_dmem_address[6:2] == 5'h9 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_49 = cpu_io_dmem_address[6:2] == 5'ha ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_50 = cpu_io_dmem_address[6:2] == 5'hb ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_51 = cpu_io_dmem_address[6:2] == 5'hc ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_11; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_52 = cpu_io_dmem_address[6:2] == 5'hd ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_12; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_53 = cpu_io_dmem_address[6:2] == 5'he ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_13; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_54 = cpu_io_dmem_address[6:2] == 5'hf ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [7:0] _GEN_55 = cpu_io_dmem_address[6:2] == 5'h10 ? cpu_io_dmem_wrData[7:0] : pwmDutyRegs_15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 247:56 248:26 196:55]
  wire [15:0] _GEN_56 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_39 : pwmEnable; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 195:53 241:54]
  wire [7:0] _GEN_57 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_40 : pwmDutyRegs_0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_58 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_41 : pwmDutyRegs_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_59 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_42 : pwmDutyRegs_2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_60 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_43 : pwmDutyRegs_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_61 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_44 : pwmDutyRegs_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_62 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_45 : pwmDutyRegs_5; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_63 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_46 : pwmDutyRegs_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_64 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_47 : pwmDutyRegs_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_65 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_48 : pwmDutyRegs_8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_66 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_49 : pwmDutyRegs_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_67 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_50 : pwmDutyRegs_10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_68 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_51 : pwmDutyRegs_11; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_69 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_52 : pwmDutyRegs_12; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_70 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_53 : pwmDutyRegs_13; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_71 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_54 : pwmDutyRegs_14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire [7:0] _GEN_72 = cpu_io_dmem_address[23:20] == 4'h4 ? _GEN_55 : pwmDutyRegs_15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 241:54 196:55]
  wire  pwmLedBits_0 = pwmEnable[0] ? pwm_io_pwmOut[0] : ledReg[0]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_1 = pwmEnable[1] ? pwm_io_pwmOut[1] : ledReg[1]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_2 = pwmEnable[2] ? pwm_io_pwmOut[2] : ledReg[2]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_3 = pwmEnable[3] ? pwm_io_pwmOut[3] : ledReg[3]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_4 = pwmEnable[4] ? pwm_io_pwmOut[4] : ledReg[4]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_5 = pwmEnable[5] ? pwm_io_pwmOut[5] : ledReg[5]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_6 = pwmEnable[6] ? pwm_io_pwmOut[6] : ledReg[6]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_7 = pwmEnable[7] ? pwm_io_pwmOut[7] : ledReg[7]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_8 = pwmEnable[8] ? pwm_io_pwmOut[8] : ledReg[8]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_9 = pwmEnable[9] ? pwm_io_pwmOut[9] : ledReg[9]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_10 = pwmEnable[10] ? pwm_io_pwmOut[10] : ledReg[10]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_11 = pwmEnable[11] ? pwm_io_pwmOut[11] : ledReg[11]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_12 = pwmEnable[12] ? pwm_io_pwmOut[12] : ledReg[12]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_13 = pwmEnable[13] ? pwm_io_pwmOut[13] : ledReg[13]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_14 = pwmEnable[14] ? pwm_io_pwmOut[14] : ledReg[14]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire  pwmLedBits_15 = pwmEnable[15] ? pwm_io_pwmOut[15] : ledReg[15]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 259:25]
  wire [7:0] io_led_lo = {pwmLedBits_7,pwmLedBits_6,pwmLedBits_5,pwmLedBits_4,pwmLedBits_3,pwmLedBits_2,pwmLedBits_1,
    pwmLedBits_0}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 262:32]
  wire [15:0] _io_led_T = {pwmLedBits_15,pwmLedBits_14,pwmLedBits_13,pwmLedBits_12,pwmLedBits_11,pwmLedBits_10,
    pwmLedBits_9,pwmLedBits_8,io_led_lo}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 262:32]
  reg [7:0] io_led_REG; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 262:20]
  wire [8:0] _io_led_T_2 = {io_led_REG,cpuRunning}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 262:47]
  reg [6:0] io_led_REG_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 262:71]
  wire [31:0] _GEN_130 = _T_10 & memAddressReg[23:20] == 4'h2 ? {{28'd0}, io_btn} : _GEN_37; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 266:90 267:24]
  wire [31:0] _GEN_131 = memAddressReg[3:0] == 4'hc ? {{16'd0}, adc_io_adcData3} : _GEN_130; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 275:{45,66}]
  wire [31:0] _GEN_132 = memAddressReg[3:0] == 4'h8 ? {{16'd0}, adc_io_adcData2} : _GEN_131; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 274:{45,66}]
  wire [31:0] _GEN_133 = _T_17 ? {{16'd0}, adc_io_adcData1} : _GEN_132; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 273:{45,66}]
  wire [31:0] _GEN_134 = _T_15 ? {{16'd0}, adc_io_adcData0} : _GEN_133; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 272:{45,66}]
  wire [31:0] _GEN_135 = _T_10 & memAddressReg[23:20] == 4'h3 ? _GEN_134 : _GEN_130; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 271:92]
  wire [31:0] _GEN_136 = memAddressReg[6:2] == 5'h0 ? {{16'd0}, pwmEnable} : _GEN_135; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 280:{39,60}]
  wire [31:0] _GEN_137 = memAddressReg[6:2] == 5'h1 ? {{24'd0}, pwmDutyRegs_0} : _GEN_136; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_138 = memAddressReg[6:2] == 5'h2 ? {{24'd0}, pwmDutyRegs_1} : _GEN_137; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_139 = memAddressReg[6:2] == 5'h3 ? {{24'd0}, pwmDutyRegs_2} : _GEN_138; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_140 = memAddressReg[6:2] == 5'h4 ? {{24'd0}, pwmDutyRegs_3} : _GEN_139; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_141 = memAddressReg[6:2] == 5'h5 ? {{24'd0}, pwmDutyRegs_4} : _GEN_140; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_142 = memAddressReg[6:2] == 5'h6 ? {{24'd0}, pwmDutyRegs_5} : _GEN_141; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_143 = memAddressReg[6:2] == 5'h7 ? {{24'd0}, pwmDutyRegs_6} : _GEN_142; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_144 = memAddressReg[6:2] == 5'h8 ? {{24'd0}, pwmDutyRegs_7} : _GEN_143; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_145 = memAddressReg[6:2] == 5'h9 ? {{24'd0}, pwmDutyRegs_8} : _GEN_144; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_146 = memAddressReg[6:2] == 5'ha ? {{24'd0}, pwmDutyRegs_9} : _GEN_145; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_147 = memAddressReg[6:2] == 5'hb ? {{24'd0}, pwmDutyRegs_10} : _GEN_146; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_148 = memAddressReg[6:2] == 5'hc ? {{24'd0}, pwmDutyRegs_11} : _GEN_147; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_149 = memAddressReg[6:2] == 5'hd ? {{24'd0}, pwmDutyRegs_12} : _GEN_148; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_150 = memAddressReg[6:2] == 5'he ? {{24'd0}, pwmDutyRegs_13} : _GEN_149; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_151 = memAddressReg[6:2] == 5'hf ? {{24'd0}, pwmDutyRegs_14} : _GEN_150; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  wire [31:0] _GEN_152 = memAddressReg[6:2] == 5'h10 ? {{24'd0}, pwmDutyRegs_15} : _GEN_151; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 282:{47,68}]
  Rx resetRx ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 74:23]
    .clock(resetRx_clock),
    .reset(resetRx_reset),
    .io_rxd(resetRx_io_rxd),
    .io_channel_ready(resetRx_io_channel_ready),
    .io_channel_valid(resetRx_io_channel_valid),
    .io_channel_bits(resetRx_io_channel_bits)
  );
  BootloaderTop bootloader ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 101:53]
    .clock(bootloader_clock),
    .reset(bootloader_reset),
    .io_instrData(bootloader_io_instrData),
    .io_instrAddr(bootloader_io_instrAddr),
    .io_wrEnabled(bootloader_io_wrEnabled),
    .io_rx(bootloader_io_rx)
  );
  ThreeCats cpu ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 116:46]
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
  ScratchPadMem imem ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 124:20]
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
  ScratchPadMem dmem ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 125:20]
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
  AdcController adc ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 183:46]
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
  PwmController pwm ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 194:46]
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
    .io_pwmOut(pwm_io_pwmOut)
  );
  BufferedTx uartTx ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 205:49]
    .clock(uartTx_clock),
    .reset(uartTx_reset),
    .io_txd(uartTx_io_txd),
    .io_channel_ready(uartTx_io_channel_ready),
    .io_channel_valid(uartTx_io_channel_valid),
    .io_channel_bits(uartTx_io_channel_bits)
  );
  Rx uartRx ( // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 206:49]
    .clock(uartRx_clock),
    .reset(uartRx_reset),
    .io_rxd(uartRx_io_rxd),
    .io_channel_ready(uartRx_io_channel_ready),
    .io_channel_valid(uartRx_io_channel_valid),
    .io_channel_bits(uartRx_io_channel_bits)
  );
  assign io_led = {_io_led_T_2,io_led_REG_1}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 262:61]
  assign io_tx = cpuRunning ? uartTx_io_txd : 1'h1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 209:15]
  assign resetRx_clock = clock;
  assign resetRx_reset = reset;
  assign resetRx_io_rxd = io_rx; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 75:18]
  assign resetRx_io_channel_ready = 1'h1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 76:28]
  assign bootloader_clock = clock;
  assign bootloader_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 91:37]
  assign bootloader_io_rx = cpuRunning | io_rx; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 102:26]
  assign cpu_clock = clock;
  assign cpu_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 91:37]
  assign cpu_io_imem_rdData = _bootWrite_T ? 32'h33 : imem_io_rdData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 129:15 175:21 176:24]
  assign cpu_io_imem_ack = _bootWrite_T ? 1'h0 : imem_io_ack; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 129:15 175:21 177:24]
  assign cpu_io_dmem_rdData = _T_10 & memAddressReg[23:20] == 4'h4 ? _GEN_152 : _GEN_135; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 279:91]
  assign imem_clock = clock;
  assign imem_reset = reset;
  assign imem_io_address = bootWrite & ~bootDone ? _GEN_9 : cpu_io_imem_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 129:15 142:32]
  assign imem_io_rd = bootWrite & ~bootDone ? 1'h0 : 1'h1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 129:15 142:32]
  assign imem_io_wr = bootWrite & ~bootDone & _T_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 129:15 142:32]
  assign imem_io_wrData = bootWrite & ~bootDone ? _GEN_11 : 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 129:15 142:32]
  assign imem_io_wrMask = bootWrite & ~bootDone ? _GEN_12 : 4'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 129:15 142:32]
  assign dmem_clock = clock;
  assign dmem_reset = reset;
  assign dmem_io_address = bootWrite & ~bootDone ? _GEN_14 : cpu_io_dmem_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:15 142:32]
  assign dmem_io_rd = bootWrite & ~bootDone ? 1'h0 : cpu_io_dmem_rd; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:15 142:32]
  assign dmem_io_wr = cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr ? 1'h0 : _GEN_25; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81 253:16]
  assign dmem_io_wrData = bootWrite & ~bootDone ? _GEN_16 : cpu_io_dmem_wrData; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:15 142:32]
  assign dmem_io_wrMask = bootWrite & ~bootDone ? _GEN_17 : cpu_io_dmem_wrMask; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 130:15 142:32]
  assign adc_clock = clock;
  assign adc_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 91:37]
  assign adc_io_vauxp6 = io_vauxp6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 184:19]
  assign adc_io_vauxn6 = io_vauxn6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 185:19]
  assign adc_io_vauxp14 = io_vauxp14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 186:19]
  assign adc_io_vauxn14 = io_vauxn14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 187:19]
  assign adc_io_vauxp7 = io_vauxp7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 188:19]
  assign adc_io_vauxn7 = io_vauxn7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 189:19]
  assign adc_io_vauxp15 = io_vauxp15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 190:19]
  assign adc_io_vauxn15 = io_vauxn15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 191:19]
  assign pwm_clock = clock;
  assign pwm_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 91:37]
  assign pwm_io_duty_0 = pwmDutyRegs_0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_1 = pwmDutyRegs_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_2 = pwmDutyRegs_2; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_3 = pwmDutyRegs_3; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_4 = pwmDutyRegs_4; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_5 = pwmDutyRegs_5; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_6 = pwmDutyRegs_6; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_7 = pwmDutyRegs_7; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_8 = pwmDutyRegs_8; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_9 = pwmDutyRegs_9; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_10 = pwmDutyRegs_10; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_11 = pwmDutyRegs_11; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_12 = pwmDutyRegs_12; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_13 = pwmDutyRegs_13; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_14 = pwmDutyRegs_14; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign pwm_io_duty_15 = pwmDutyRegs_15; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 200:20]
  assign uartTx_clock = clock;
  assign uartTx_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 91:37]
  assign uartTx_io_channel_valid = cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr & _T_26; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 215:27 234:81]
  assign uartTx_io_channel_bits = cpu_io_dmem_wrData[7:0]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 214:48]
  assign uartRx_clock = clock;
  assign uartRx_reset = reset | softReset; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 91:37]
  assign uartRx_io_rxd = cpuRunning ? io_rx : 1'h1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 211:23]
  assign uartRx_io_channel_ready = cpuRunning & memAddressReg[31:28] == 4'hf & memAddressReg[23:20] == 4'h0 & _GEN_36; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 216:27 223:88]
  always @(posedge clock) begin
    if (reset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 78:27]
      resetShift <= 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 78:27]
    end else if (softReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 84:35]
      resetShift <= 32'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 86:16]
    end else if (resetRx_io_channel_valid) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 79:34]
      resetShift <= _resetShift_T_1; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 80:16]
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 94:54]
      cpuRunning <= 1'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 94:54]
    end else begin
      cpuRunning <= _GEN_3;
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 195:53]
      pwmEnable <= 16'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 195:53]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmEnable <= _GEN_56;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_0 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_0 <= _GEN_57;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_1 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_1 <= _GEN_58;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_2 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_2 <= _GEN_59;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_3 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_3 <= _GEN_60;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_4 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_4 <= _GEN_61;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_5 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_5 <= _GEN_62;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_6 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_6 <= _GEN_63;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_7 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_7 <= _GEN_64;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_8 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_8 <= _GEN_65;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_9 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_9 <= _GEN_66;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_10 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_10 <= _GEN_67;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_11 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_11 <= _GEN_68;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_12 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_12 <= _GEN_69;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_13 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_13 <= _GEN_70;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_14 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_14 <= _GEN_71;
        end
      end
    end
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
      pwmDutyRegs_15 <= 8'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 196:55]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (!(cpu_io_dmem_address[23:20] == 4'h1)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          pwmDutyRegs_15 <= _GEN_72;
        end
      end
    end
    uartStatusReg <= {uartRx_io_channel_valid,uartTx_io_channel_ready}; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 219:55]
    memAddressReg <= cpu_io_dmem_address; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 220:30]
    if (combinedReset) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 233:50]
      ledReg <= 16'h0; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 233:50]
    end else if (cpuRunning & cpu_io_dmem_address[31:28] == 4'hf & cpu_io_dmem_wr) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 234:81]
      if (!(cpu_io_dmem_address[23:20] == 4'h0 & cpu_io_dmem_address[3:0] == 4'h4)) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 235:84]
        if (cpu_io_dmem_address[23:20] == 4'h1) begin // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 238:53]
          ledReg <= cpu_io_dmem_wrData[15:0]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 240:14]
        end
      end
    end
    io_led_REG <= _io_led_T[15:8]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 262:38]
    io_led_REG_1 <= _io_led_T[6:0]; // @[\\src\\main\\scala\\rvsoc\\RustSoCTop.scala 262:89]
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
  uartStatusReg = _RAND_19[1:0];
  _RAND_20 = {1{`RANDOM}};
  memAddressReg = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  ledReg = _RAND_21[15:0];
  _RAND_22 = {1{`RANDOM}};
  io_led_REG = _RAND_22[7:0];
  _RAND_23 = {1{`RANDOM}};
  io_led_REG_1 = _RAND_23[6:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
