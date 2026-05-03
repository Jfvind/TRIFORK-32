module TriStateBuffer8(
  inout  [7:0] pad,
  input  [7:0] dir,
  input  [7:0] out,
  output [7:0] in
);
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : b
      assign pad[i] = dir[i] ? out[i] : 1'bz;
    end
  endgenerate
  assign in = pad;
endmodule
