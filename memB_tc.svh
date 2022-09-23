// testcase for matrix-multiply systolic array
// provides parallelogram-shaped values for A,B based on cycle
class memB_tc 
#(parameter BITS_AB=8,
  parameter DIM=8
);
   typedef logic signed [BITS_AB-1:0] type_B [DIM-1:0][DIM-1:0];
   typedef logic signed [BITS_AB-1:0] type_Bexp [DIM*2-2:0][DIM-1:0];

   logic signed [BITS_AB-1:0] A [DIM-1:0][DIM-1:0];
   logic signed [BITS_AB-1:0] B [DIM-1:0][DIM-1:0];
   logic signed [BITS_AB-1:0] Bexp [DIM*2-2:0][DIM-1:0];

   function new();
      int Aval, Bval;
      // randomize A and B
      for(int Row=0;Row<DIM;++Row) begin
	     for(int Col=0;Col<DIM;++Col) begin
            Aval = $urandom();
            A[Row][Col] = {Aval[7:0]};
            Bval = $urandom();
            B[Row][Col] = {Bval[7:0]};
         end
      end
      generate_Bexp();
   endfunction: new

   function type_B get_B();
      return B;
   endfunction: get_B

   function type_Bexp get_Bexp();
      return Bexp;
   endfunction: get_Bexp

   function generate_Bexp();
      for(int r=0; r<DIM*2-1;r++) begin
         for(int c=0; c<DIM; c++) begin
             Bexp[r][c] = 8'b0;
         end
      end

      for(int r=0; r<DIM; r++) begin
         int row = r;
         int col = 0;
         for(int c=0; c<=r; c++) begin
            Bexp[r][c] = B[row][col];
            row--;
            col++;
         end
      end

      for(int r = DIM; r<DIM*2-1; r++) begin
         int row = DIM-1;
         int col = r - DIM + 1;
         for(int c=r-DIM + 1; c<DIM; c++) begin
            Bexp[r][c] = B[row][col];
            row--;
            col++;
         end
      end
   endfunction: generate_Bexp
            
      
   function void dump_B();
      // display A,B,C for debugging purposes
      $display("B:");
      for(int Row=0;Row<DIM;++Row) begin
         for(int Col=0;Col<DIM;++Col) begin
            $write("%4d ",B[Row][Col]);
         end
         $write("\n");
      end // for (int Row=0;Row<DIM;++Row)
   endfunction: dump_B // dump

   function void dump_Bexp();
      // display A,B,C for debugging purposes
      $display("Bexp:");
      for(int Row=0;Row<DIM*2 - 1;++Row) begin
         for(int Col=0;Col<DIM;++Col) begin
            $write("%4d ",Bexp[Row][Col]);
         end
         $write("\n");
      end // for (int Row=0;Row<DIM;++Row)
   endfunction: dump_Bexp // dump
   
endclass; // systolic_array_tc
