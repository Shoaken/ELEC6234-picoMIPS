
module pc_tb;

parameter Psize = 5;

logic clk;
logic reset;
logic PCincr, PCabsbranch, PCrelbranch;
logic [Psize-1:0] Branchaddr;
logic [Psize-1:0] Rbranch;
logic [Psize-1:0] PCout;

// create pc object 
pc #(.Psize(Psize)) pc (
	.clk(clk), 
	.reset(reset), 
	.PCincr(PCincr), 
	.PCabsbranch(PCabsbranch),
	//.PCRbranch(Rbranch),
   .PCrelbranch(PCrelbranch),
	.Branchaddr(Branchaddr),
	.PCout(PCout));
//------------------------------------------------
initial 
begin 
	clk = 1'b0;
	forever #5ns clk = ~clk;
end

initial 
begin // for 50ns
	reset = 1'b1; 
	PCincr = 1'b0; 
	PCabsbranch = 1'b0; 
	PCrelbranch = 1'b0;
	//PCout = 5'b00000;
	Branchaddr = 5'b00000;

	// test pc increment
	#10ns 
	reset = 1'b0;
	PCincr = 1'b1;
	
	// test pc absolute branch
	#10ns PCrelbranch = 1'b0;
	PCabsbranch = 1'b1; 
	Branchaddr = 5'b00010;	
	
	// test pc relative branch
	#10ns PCincr = 1'b0; 
	PCrelbranch = 1'b1; 
	Branchaddr = 5'b00011;



	// reset
	#10ns reset = 1'b1; 
	
   // reset
	#10ns reset = 1'b0;  
	PCincr = 1'b1; 
	PCabsbranch = 1'b0; 
	PCrelbranch = 1'b0;
	Branchaddr = 5'b00000;
	
	$stop;
	
end 


endmodule // end of module pc_tb
