
//-----------------------------------------------------
module pc #(parameter Psize = 5) // up to 32 instructions
(input logic clk, reset, PCincr,PCabsbranch,PCrelbranch,
 input logic [Psize-1:0] Branchaddr,
 output logic [Psize-1 : 0]PCout
);

//------------- code starts here---------
logic[Psize-1:0] Rbranch; // temp variable for addition operand
always_comb
  if (PCincr)
       Rbranch = { {(Psize-1){1'b0}}, 1'b1};
  else Rbranch =  Branchaddr;


always_ff @ ( posedge clk or posedge reset) // async reset
  if (reset) // sync reset
     PCout <= {Psize{1'b0}};
  else if (PCincr | PCrelbranch) // increment or relative branch
     PCout <= PCout + Rbranch; // 1 adder does both
  else if (PCabsbranch) // absolute branch
     PCout <= Branchaddr;
	 
endmodule // module pc