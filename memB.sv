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

genvar i;
 
generate 
   for (i = 0; i < DIM; i++) begin
      fifo #(.DEPTH(DIM+i), .BITS(BITS_AB)) FIFO(.clk(clk), .rst_n(rst_n), .en(en), .d(Bin[i]), .q(Bout[i]));
   end
endgenerate

endmodule
