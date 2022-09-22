module memB
#(
  parameter BITS_AB=8,
  parameter DIM=8
)
(
  input clk,rst_n,en,
  input signed [BITS_AB-1:0] Bin [DIM-1:0],
  output signed [BITS_AB-1:0] Bout [DIM-1:0]
);

endmodule
