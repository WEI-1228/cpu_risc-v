`include "defines.v"

module dataram(
	input wire clk,
	input wire rst,

	//写入信号
	input wire we,
	input wire[`RegBus] wdata,
	input wire[`RegBus] waddr,

	//读取信号
	input wire[`RegBus] raddr,
	output reg[`RegBus] rdata

);
	
	reg [`RegBus] ram [0:4095];
	wire waddr_valid = ( waddr[31:12]==20'h0 );
	wire raddr_valid = ( raddr[31:12]==20'h0 );

	initial begin
		ram[1] = 32'h00005678;
	end

	always @ (posedge clk) begin
		if ((rst == `RstDisable) && we == `WriteEnable && waddr_valid) begin
			ram[waddr] <= wdata;
		end
	end


	always @ (*) begin
		if (rst == `RstEnable || !raddr_valid) begin
			rdata <= `ZeroWord;
		end else begin
			rdata <= ram[raddr];
		end
	end
	



endmodule