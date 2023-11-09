
//------------------------------------

`include "alucodes.sv"
module cpu #( parameter n = 8) // data bus width
(input logic clk,  
  input reset, // master reset
  input  Bstus, // Branch status
  input  logic[n-1:0] x, // connected to switches
  output logic[n-1:0] outport // need an output port, tentatively this will be the ALU output
);       

// declarations of local signals that connect CPU modules
// ALU
logic [2:0] ALUfunc; // ALU function
logic [3:0] flags; // ALU flags, routed to decoder
logic [n-1:0] Alub; // output from imm MUX

//decoders
logic imm; // immediate operand signal
logic fetch; // fetch operand signal
logic show; // output display control


// registers
logic [n-1:0] Rdata1, Rdata2, Wdata; // Register data
logic w; // register write control
//
// Program Counter 
parameter Psize = 5; // up to 32 instructions
logic PCincr,PCabsbranch,PCrelbranch; // program counter control
logic [Psize-1 : 0]ProgAddress;
// Program Memory
parameter Isize = n+8; // Isize - instruction width
logic [Isize-1:0] I; // I - instruction code

//------------- code starts here ---------
// module instantiations
pc  #(.Psize(Psize)) progCounter (
		   .clk(clk),
		   .reset(reset),
         .PCincr(PCincr),
         .PCabsbranch(PCabsbranch),
         .PCrelbranch(PCrelbranch),
         .Branchaddr(I[Psize-1:0]), 
         .PCout(ProgAddress) );

prog #(.Psize(Psize),.Isize(Isize)) progMemory (
			.address(ProgAddress),
			.I(I));

decoder  D (
			.opcode(I[Isize-1:Isize-4]),
         .PCincr(PCincr),
         .PCabsbranch(PCabsbranch), 
         .PCrelbranch(PCrelbranch),
			.Bcond(I[n-1]), // Branch condition
         .Bstus(Bstus), // Branch status
         .flags(flags), // ALU flags
		   .ALUfunc(ALUfunc),
			.imm(imm),
			.fetch(fetch),  
         .show(show),
			.w(w));

regs   #(.n(n))  gpr(
			.clk(clk),
			.w(w),
         .Wdata(Wdata),
			.Raddr2(I[Isize-5:Isize-8]),  // reg %d number
			.Raddr1(I[Isize-9:0]), // reg %s number
         .Rdata1(Rdata1),
			.Rdata2(Rdata2));

alu    #(.n(n))  iu(
			.a(Rdata2),
			.b(Alub),
         .func(ALUfunc),
			.flags(flags),
			.result(Wdata)); // ALU result -> destination reg

// create MUX for immediate operand
assign Alub = (imm ? (fetch ? x[n-1:0] : I[n-1:0]) : Rdata1);


// connect ALU result to outport
//assign outport = Wdata;
always_ff @(posedge clk or posedge reset)
begin
	if (reset) // sync reset
                outport <= 8'd0;
	else if(show)
                outport <= Wdata;
end

endmodule
