module memA
#(
  parameter BITS_AB=8,
  parameter DIM=8
)
(
  input clk,rst_n,en,WrEn,
  input signed [BITS_AB-1:0] Ain [DIM-1:0],
  input [$clog2(DIM)-1:0] Arow,
  output signed [BITS_AB-1:0] Aout [DIM-1:0]
);

  
genvar i;
generate
  for (i = 0; i < DIM; i++) begin
    memAfifo #(.DEPTH(DIM+i), .BITS(BITS_AB), .DIM(DIM)) MEM_A_FIFO(.clk(clk), .rst_n(rst_n), .en(en), .d(Ain), .q(Aout), .WrEn((Arow == i) ? WrEn : 1'b0));
  end
endgenerate


endmodule
