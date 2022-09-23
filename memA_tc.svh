// testcase for matrix-multiply systolic array
// provides parallelogram-shaped values for A,B based on cycle
class memA_tc 
#(parameter BITS_AB=8,
  parameter DIM=8
);
   typedef logic signed [BITS_AB-1:0] type_A [DIM-1:0][DIM-1:0];
   typedef logic signed [BITS_AB-1:0] type_Aexp [DIM*2-2:0][DIM-1:0];

   logic signed [BITS_AB-1:0] A [DIM-1:0][DIM-1:0];
   logic signed [BITS_AB-1:0] B [DIM-1:0][DIM-1:0];
   logic signed [BITS_AB-1:0] Aexp [DIM*2-2:0][DIM-1:0];

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
      generate_Aexp();
   endfunction: new

   function type_A get_A();
      return A;
   endfunction: get_A

   function type_Aexp get_Aexp();
      return Aexp;
   endfunction: get_Aexp

   function generate_Aexp(); // this is different for A
      for(int r=0; r<DIM*2-1;r++) begin
         for(int c=0; c<DIM; c++) begin
             Aexp[r][c] = 8'b0;
         end
      end


      for(int c=0; c<DIM; c++) begin
         int row = c;
         int col = 0;
         for(int r=c; r<DIM+c; r++) begin
            Aexp[r][c] = A[row][col];
            col++;
         end
	 
      end

/*      for(int r = DIM; r<DIM*2-1; r++) begin
         int row = DIM-1;
         int col = r - DIM + 1;
         for(int c=r-DIM + 1; c<DIM; c++) begin
            Aexp[r][c] = A[row][col];
            row--;
            col++;
         end
      end*/
   endfunction: generate_Aexp
            
      
   function void dump_A();
      // display A,B,C for debugging purposes
      $display("A:");
      for(int Row=0;Row<DIM;++Row) begin
         for(int Col=0;Col<DIM;++Col) begin
            $write("%4d ",A[Row][Col]);
         end
         $write("\n");
      end // for (int Row=0;Row<DIM;++Row)
   endfunction: dump_A // dump

   function void dump_Aexp();
      // display A,B,C for debugging purposes
      $display("Aexp:");
      for(int Row=0;Row<DIM*2 - 1;++Row) begin
         for(int Col=0;Col<DIM;++Col) begin
            $write("%4d ",Aexp[Row][Col]);
         end
         $write("\n");
      end // for (int Row=0;Row<DIM;++Row)
   endfunction: dump_Aexp // dump
   
endclass; // systolic_array_tc