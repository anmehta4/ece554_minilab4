// fifo.sv
// Implements delay buffer (fifo)
// On reset all entries are set to 0
// Shift causes fifo to shift out oldest entry to q, shift in d

module fifo
  #(
  parameter DEPTH=8,
  parameter BITS=64
  )
  (
  input clk,rst_n,en,
  input [BITS-1:0] d,
  output logic [BITS-1:0] q
  );

  logic [(DEPTH*BITS) - 1:0] buffer;

  always_ff @ (posedge clk, negedge rst_n) begin
  	if (~rst_n) begin
		buffer <= 0;
	end else if (en) begin
		//q <= buffer[(BITS*DEPTH) -1 : (BITS*(DEPTH-1))];
		buffer <= buffer << BITS;
		buffer[BITS-1:0] <= d;
	end
  end		

  assign q = buffer[(BITS*DEPTH) -1 : (BITS*(DEPTH-1))];
  
endmodule // fifo
