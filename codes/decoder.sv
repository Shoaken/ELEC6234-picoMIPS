
//---------------------------------------------------------

`include "alucodes.sv"
`include "opcodes.sv"
//---------------------------------------------------------
module decoder
( input logic [3:0] opcode, // top 4 bits of instruction
input [3:0] flags, // ALU flags
 input logic Bcond, // Branch condition
 input logic Bstus, // Branch status, connected to switch
// output signals
//    PC control
output logic PCincr,PCabsbranch,PCrelbranch,

//    ALU control
output logic [2:0] ALUfunc, 

// imm mux control
output logic imm,

// fetch mux control
output logic fetch,
 
// output display control
output logic show,

//   register file control
output logic w
  );
   
//------------- code starts here ---------
// instruction decoder
logic takeBranch; // temp variable to control conditional branching
always_comb 
begin
  // set default output signal values for NOP instruction
   PCincr = 1'b1; // PC increments by default
	PCabsbranch = 1'b0; 
	PCrelbranch = 1'b0;
   ALUfunc = 3'b111; 
   imm=1'b0; 
	w=1'b0; 
	fetch = 1'b0;
   show = 1'b0;
   takeBranch =  1'b0; 
   case(opcode)
      `NOP : ; // No operation, ADDI %d, %0, 0 => clear %d.
      `ADD :begin // register-register
               w = 1'b1; // write result to dest register
               ALUfunc = `RADD;
            end
      `ADDI:begin // register-immediate
               w = 1'b1; // write result to dest register
               imm = 1'b1; // set ctrl signal for imm operand MUX
               show = 1'b1;
					ALUfunc = `RADD;
            end
      `LDS :begin // register-immediate
               w = 1'b1; // write result to dest register
               imm = 1'b1; // set ctrl signal for imm operand MUX
               fetch = 1'b1; // set ctrl signal for fetch import data operand MUX
					show = 1'b1;
               ALUfunc = `RB;
            end
      `SUB :begin // register-register
               w = 1'b1; // write result to dest register
               ALUfunc = `RSUB;
            end
      `SUBI:begin // register-immediate
               w = 1'b1; // write result to dest register
               imm = 1'b1; // set ctrl signal for imm operand MUX
               ALUfunc = `RSUB;
            end
      `MUL :begin // register-register
					w = 1'b1; // write result to dest register
					ALUfunc = `RMUL;
				end
      `MULI:begin // register-immediate
					w = 1'b1; // write result to dest register
					imm = 1'b1; 
					ALUfunc = `RMUL;
				end
      `SHOW: begin
               show = 1'b1;
               ALUfunc = `RADD;
            end
      // branches
      `BAT :begin
               if(Bstus == Bcond)
                  takeBranch =  1'b1; // branch at specified conditions
            end
    // branches
	//`BEQ: takeBranch = flags[1]; // branch if Z==1
	//`BNE: takeBranch = ~flags[1]; // branch if Z==0
	//`BGE: takeBranch = ~flags[2]; // branch if N==0
	//`BLO: takeBranch = flags[0]; // branch if C==1
	default:
	    $error("unimplemented opcode %h",opcode);
 
  endcase // opcode
  
   if(takeBranch) // branch condition is true;
   begin
      PCincr = 1'b0;
	  PCrelbranch = 1'b1; 
   end


end // always_comb


endmodule //module decoder --------------------------------