
//-------------------------------------------------------------------------------
`include "opcodes.sv"
//------------------------------------------------
module decoder_tb;

logic [3:0] opcode; // top 6 bits of instruction
logic [3:0] flags; // ALU flags V,N,Z,C
logic [2:0] ALUfunc; // ALU function
logic Bcond; // Branch condition
logic Bstus; // Branch status, connected to specified switch
// PC control, imm MUX control, register file control
logic PCincr, PCabsbranch, PCrelbranch, imm, fetch, w;

// create dec object
decoder dec (
        .opcode(opcode),
        .flags(flags),
        .Bcond(Bcond), // Branch condition
        .Bstus(Bstus),  // Branch status
        .PCincr(PCincr),
        .PCabsbranch(PCabsbranch),
        .PCrelbranch(PCrelbranch),
        .ALUfunc(ALUfunc),
        .imm(imm),
        .fetch(fetch),
        .w(w));
//------------------------------------------------
initial 
	begin // for 100ns
    Bcond = 1'b0; Bstus = 1'b1; // if Bstus == Bcond, hold status.
    flags = 4'b0;

		opcode = `NOP;  //opcode: NOP  -> 4'b1111
    #10ns opcode = `ADD;  //opcode: ADD  -> 4'b0000
		#10ns opcode = `ADDI; //opcode: ADDI -> 4'b0001
    #10ns opcode = `LDS; //opcode: LDS -> 4'b0110
    #10ns opcode = `SUB;  //opcode: SUB  -> 4'b0010
    #10ns opcode = `SUBI; //opcode: SUBI -> 4'b0011
    #10ns opcode = `MUL;  //opcode: MUL  -> 4'b0100
		#10ns opcode = `MULI; //opcode: MULI -> 4'b0101
		#10ns opcode = `BAT;  //opcode: BAT  -> 4'b0111
    #10ns Bstus = 1'b0; opcode = `BAT;
	end 

endmodule // end of module decoder_tb