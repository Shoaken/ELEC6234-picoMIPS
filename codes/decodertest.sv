//---------------------------------------------------------
// File Name   : decodertest.sv
// Function    : testbench for picoMIPS instruction decoder 
// Author: tjk
// ver 1:  // only NOP, ADD, ADDI
// Last revised: 26 Oct 2012
//---------------------------------------------------------

`include "alucodes.sv"
`include "opcodes.sv"
//---------------------------------------------------------
module decodertest;

logic [3:0] opcode; // top 4 bits of instruction
//    PC control, imm MUX control, register file control
logic PCincr,imm,w1,w2;
//    ALU control
   
//------------- code starts here ---------
// instruction decoder
always_comb 
begin
  // default output signal values
   PCincr = 1'b1; // PC increments by default
   ALUfunc = 3'b000; imm=0; w1=0; w2=0; 
  case(opcode)
      `LDS :begin // register-immediate
               w = 1'b1; // write result to dest register
               imm = 1'b1; // set ctrl signal for imm operand MUX
               fetch = 1'b1; // set ctrl signal for fetch import data operand MUX
               ALUfunc = `RADD;
            end
 
  endcase // opcode


end // always_comb


endmodule //module decoder --------------------------------