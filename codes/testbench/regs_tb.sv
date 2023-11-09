
module regs_tb;

parameter n = 8;

logic clk, w;
logic [n-1:0] Wdata;
logic [3:0] Raddr2;
logic [n-1:0]  Raddr1;
logic [n-1:0] Rdata1, Rdata2;

// create regs object
regs #(.n(n)) u_reg (.*);
//------------------------------------------------
initial
begin // for 50ns
  clk = 1'b0;
  forever #5ns clk = ~clk;
end

initial
begin
  w = 1'b0;
  Wdata = 8'b00000111;
  Raddr1 = 8'b00000001; Raddr2 = 4'b0000;

  #10ns Raddr1 = 8'b00000000; Raddr2 = 4'b0010;

  // test write 0 to dest reg (Raddr2)
  #10ns w = 1'b1;
  @(posedge clk);
  #10ns w = 1'b1; Wdata = 8'b00000000;
  @(posedge clk);
  
  $stop;
end

endmodule // end of module regs_tb