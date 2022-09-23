`include "memA_tc.svh"
module memA_tb();
  
localparam BITS_AB=8;
localparam DIM=8;
localparam TESTS = 10;

logic clk,rst_n,en, WrEn;
logic signed [BITS_AB-1:0] A [DIM-1:0][DIM-1:0];
logic signed [BITS_AB-1:0] Aexp [DIM*2-2:0][DIM-1:0];
logic signed [BITS_AB-1:0] Arec [DIM*2-2:0][DIM-1:0];
logic signed [BITS_AB-1:0] Ain [DIM-1:0];
logic [$clog2(DIM)-1:0] Arow;
logic signed [BITS_AB-1:0] Aout [DIM-1:0];

always #5 clk = ~clk; 

integer errors, mycycle;

   memA #(.BITS_AB(BITS_AB), .DIM(DIM)) DUT (.*);
   memA_tc #(.BITS_AB(BITS_AB), .DIM(DIM)) satc;
   
   initial begin
      clk = 1'b0; 
      rst_n = 1'b1;
      en = 1'b0;
      errors = 0;
      
      //reset
      @(posedge clk) begin end
      rst_n = 1'b0; // active low reset
      @(posedge clk) begin end
      rst_n = 1'b1; // reset finished
      @(posedge clk) begin end

      for(int test=0;test<TESTS;++test) begin

         errors = 0;

         // instantiate test case
         satc = new();
         A = satc.get_A();
         Aexp = satc.get_Aexp();

         @(posedge clk) begin end
	 WrEn = 1'b1;
	 Arow = 3'b0;
	 en = 1'b0;

         // DIM cycles to fill
         for(int cyc=0; cyc<DIM; ++cyc) begin
            // set A, B values from the testcase
	    Arow = cyc;
            Ain = A[cyc];
            @(posedge clk) begin end
            if (Aout[cyc] !== 0) begin
                errors++;
            end
         end
         WrEn = 1'b0;

	en = 1'b1;
	@(posedge clk) begin end


         //DIM*2 cycles to drain
        for(int r=0; r<(DIM*2) - 1; ++r) begin
             for(int c=0; c<DIM; ++c) begin
                  Arec[r][c] = Aout[c];
                  if(Aexp[r][c] !== Aout[c]) begin
                      errors++;
                  end
             end
             @(posedge clk) begin end
         end
          
         if(errors > 0) begin
             satc.dump_A();
             satc.dump_Aexp();
             $display("Arec :");
             for(int r =0; r<DIM*2 -1; r++) begin
                for(int c=0; c<DIM; c++) begin
                    $write("%4d ", Arec[r][c]);
                end
                $write("\n");
             end
          end else begin
             $display("YAHOO! Test %d Passed!", test+1);
          end 
      end	
      $stop; 
   end // initial begin

endmodule // 