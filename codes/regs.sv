
//-----------------------------------------------------
module regs #(parameter n = 8) // n - data bus width
(input logic clk, w, // clk and write control
 input logic [n-1:0] Wdata,
 input logic [3:0] Raddr2, //Raddr1,
 input logic [n-1:0]  Raddr1,
 output logic [n-1:0] Rdata1, Rdata2);

 	// Declare 32 n-bit registers 
	logic [n-1:0] gpr [31:0];

	
	// write process, dest reg is Raddr2
	always_ff @ (posedge clk)
	begin
		if (w)
            gpr[Raddr2] <= Wdata;

	end

	// read process %0 = 0
//	always_comb
//	begin
//	Rdata1 = gpr[Raddr1];
//	Rdata2 = gpr[Raddr2];
//	end
	always_comb
	begin
	   if (Raddr1==8'd0)
	         Rdata1 =  {n{1'b0}};
      else  Rdata1 = gpr[Raddr1];
	 
       if (Raddr2==4'd0)
	        Rdata2 =  {n{1'b0}};
	  else  Rdata2 = gpr[Raddr2];
	end	
	

endmodule // module regs