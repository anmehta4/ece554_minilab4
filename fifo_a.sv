
module fifo_a
  #(
  parameter DEPTH=8,
  parameter DIM=8,
  parameter BITS=64
  )
  (
  input clk,rst_n,en,WrEn,
  input [BITS-1:0] d [DIM-1:0],
  output logic [BITS-1:0] q
  );

  logic [BITS - 1:0] buffer [DEPTH-1:0];

  always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      for(int i = 0; i < DEPTH; i += 1) begin
	buffer[i] <= 0;
      end
    end else if(en || WrEn) begin
      if(en) begin
	if(~WrEn) begin
	  buffer[0] <= 0;
	end
	for(int i = 0; i < DEPTH-1; i += 1) begin
	  buffer[i+1] <= buffer[i];
	end
      end

      if(WrEn) begin
	for(int i = 0; i < DIM; i+= 1) begin
	  buffer[i] <= d[DIM-i-1];
	end
      end
    end
  end

  assign q = buffer[DEPTH-1];

endmodule