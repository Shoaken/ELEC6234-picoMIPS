// No operation 
`define NOP    4'b1111
// ADD %d, %s;  %d = %d + %s
`define ADD    4'b0000
// ADDI %d, %s, imm;  %d = %s + imm
`define ADDI   4'b0001
// SUB %d, %s;  %d = %d - %s
`define SUB    4'b0010
// SUBI %d, %s, imm;  %d = %s - imm
`define SUBI   4'b0011
// MUL %d, %s;  %d = %d * %s
`define MUL    4'b0100
// MULI %d, %s, imm;  %d = %s * imm
`define MULI   4'b0101
// LDS  %d, %s, imm;  %d = %s + import imm
`define LDS    4'b0110
//branch at specified conditions (Bcon==I[7])
`define BAT    4'b0111
// SHOW %d, %0;  output display <= %d
`define SHOW   4'b1000