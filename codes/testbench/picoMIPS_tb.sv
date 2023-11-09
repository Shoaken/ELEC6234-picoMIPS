
`include "alucodes.sv"
//------------------------------------------------
`timescale 1ns/1ps
//------------------------------------------------
module picoMIPS_tb;
logic fastclk;  // clock signal
logic reset; // nreset
logic Bstus; // Connect to SW[8]
logic [7:0] SW; // Switches SW0..SW7
logic [7:0] LED; // LEDs
//------------------------------------------------
// create object
//picoMIPS4test #(.n(2)) p0 (
picoMIPS4test p0 (
	.fastclk(fastclk), 
	.reset(reset), 
	.Bstus(Bstus), 
	.SW(SW), 
	.LED(LED)
	);
//------------------------------------------------
initial 
begin 
	fastclk = 1'b0;
	forever #10 fastclk = ~fastclk; // 50MHz Altera DE0 clock
end

initial    
begin
	Bstus = 1'b0;
	reset = 1'b1;
	#100 reset = 1'b0;
	
	// clear
	// wait 0, wait 1 and input x1 twice
	#100 Bstus = 1'b0;
	SW[7:0] = 8'b00000100;
	#200 Bstus = 1'b1;
	

	// wait 0, wait 1 and input y1 twice
	#100 Bstus = 1'b0;
	SW[7:0] = 8'b00001000;
	#200 Bstus = 1'b1;

	// wait 0, calculate and display x2
	#200 Bstus = 1'b0;
	
	// wait 1 and display y2
	#600 Bstus = 1'b1;

	// wait 0
	#100 Bstus = 1'b0;
	// repeat
	$stop;

end
endmodule // end of module picoMIPS_tb