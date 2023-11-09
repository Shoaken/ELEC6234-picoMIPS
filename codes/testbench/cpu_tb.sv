
//-------------------------------------------------------------------------------
`include "alucodes.sv"
//------------------------------------------------
module cpu_tb;

logic clk, reset, Bstus;  // clock signal
logic [7:0] SW; // Switches SW0..SW9
logic [7:0] LED; // LEDs

// create object
cpu cpu(.clk(clk), .reset(reset), .Bstus(Bstus), .x(SW[7:0]), .outport(LED));
//------------------------------------------------
initial 
begin 
	clk = 1'b0;
	forever #10ns clk = ~clk;
end

initial    
begin // for 500ns
	Bstus = 1'b0;
	reset = 1'b1;
	@(posedge clk); reset = 1'b0;

	//clear
	@(posedge clk);

	// wait 0
	@(posedge clk);
	Bstus = 1'b0;
	// wait 1
	@(posedge clk);
	Bstus = 1'b1;
	// input x1 twice
	@(posedge clk);
	SW[7:0] = 8'b00000001;
	@(posedge clk);

	// wait 0
	@(posedge clk);
	Bstus = 1'b0;
	// wait 1
	@(posedge clk);
	Bstus = 1'b1;
	// input y1 twice
	@(posedge clk);
	SW[7:0] = 8'b00000010;
	@(posedge clk);

	// wait 0
	@(posedge clk);
	Bstus = 1'b0;
	// calculate
	@(posedge clk); // MULT-1
	@(posedge clk); // MULT-2
	@(posedge clk); // MULT-3
	@(posedge clk); // MULT-4
	@(posedge clk); // ADD-1
	@(posedge clk); // ADD-2

	// display x2
	@(posedge clk);
	// wait 1
	@(posedge clk);
	Bstus = 1'b1;
	// display y2
	@(posedge clk);

	// wait 0
	@(posedge clk);
	Bstus = 1'b0;
	// repeat
	@(posedge clk);

	$stop;
end
endmodule // end of module 