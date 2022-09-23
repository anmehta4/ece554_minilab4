`include "memB_tc.svh"
module memB_tb();
  
localparam BITS_AB=8;
localparam DIM=8;
localparam TESTS = 10;

logic clk,rst_n,en;
logic signed [BITS_AB-1:0] B [DIM-1:0][DIM-1:0];
logic signed [BITS_AB-1:0] Bexp [DIM*2-2:0][DIM-1:0];
logic signed [BITS_AB-1:0] Brec [DIM*2-2:0][DIM-1:0];
logic signed [BITS_AB-1:0] Bin [DIM-1:0];
logic signed [BITS_AB-1:0] Bout [DIM-1:0];

always #5 clk = ~clk; 

integer errors, mycycle;

   memB #(.BITS_AB(BITS_AB), .DIM(DIM)) DUT (.*);
   memB_tc #(.BITS_AB(BITS_AB), .DIM(DIM)) satc;
   
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
         B = satc.get_B();
         Bexp = satc.get_Bexp();

         @(posedge clk) begin end
         en = 1'b1; // enabled throughout following DIM*3 cycles 
     
         // DIM cycles to fill
         for(int cyc=0; cyc<DIM; ++cyc) begin
            // set A, B values from the testcase
            Bin = B[cyc];
            @(posedge clk) begin end
            if (Bout[cyc] !== 0) begin
                errors++;
            end
         end
         
         Bin = '{8{8'b0}};
	@(posedge clk) begin end

         //DIM*2 cycles to drain
         for(int r=0; r<(DIM*2) - 1; ++r) begin
             for(int c=0; c<DIM; ++c) begin
                  Brec[r][c] = Bout[c];
                  if(Bexp[r][c] !== Bout[c]) begin
                      errors++;
                  end
             end
             @(posedge clk) begin end
         end
          
         if(errors > 0) begin
             satc.dump_B();
             satc.dump_Bexp();
             $display("Brec :");
             for(int r =0; r<DIM*2 -1; r++) begin
                for(int c=0; c<DIM; c++) begin
                    $write("%4d ", Brec[r][c]);
                end
                $write("\n");
             end
          end else begin
             $display("YAHOO! Test %d Passed!", test+1);
          end
      end	
      $stop; 
   end // initial begin

endmodule // systolic_array_tb

   
