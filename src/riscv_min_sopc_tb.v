`include "defines.v"
`timescale 1ns/1ps

module riscv_min_sopc_tb();

	reg CLOCK_50;
	reg rst;
	reg c;

	initial begin
	    CLOCK_50 = 1'b0;
	    c <= 1'b0;
	    forever #10 CLOCK_50 = ~CLOCK_50;
	end

	initial begin
		rst = `RstEnable;
		#195 rst= `RstDisable;
		#1000 $stop;
	end
	
	riscv_min_sopc riscv_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst), .change(c)
	);

endmodule