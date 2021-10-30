`include "defines.v"

module mem_wb(

	input	wire clk,
	input wire rst,
	

	//来自访存阶段的信息	
	input wire[`RegAddrBus] waddr,
	input wire wreg,
	input wire[`RegBus]	wdata,

	//送到回写阶段的信息
	output reg[`RegAddrBus] waddr_o,
	output reg wreg_o,
	output reg[`RegBus]	wdata_o	       
	
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			waddr_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
		  	wdata_o <= `ZeroWord;	
		end else begin
			waddr_o <= waddr;
			wreg_o <= wreg;
			wdata_o <= wdata;
		end    //if
	end      //always
			

endmodule