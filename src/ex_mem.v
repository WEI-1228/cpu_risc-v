`include "defines.v"

module ex_mem(

	input wire clk,
	input wire rst,
	
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus] ex_waddr,
	input wire ex_wreg,
	input wire[`RegBus]	ex_wdata,
	input wire[2:0] ex_ld_type,
	input wire[`RegBus] ex_read_addr,
	
	//送到访存阶段的信息
	output reg[`RegAddrBus] mem_waddr,
	output reg mem_wreg,
	output reg[`RegBus] mem_wdata,

	input wire ex_ram_wreg,
	input wire[`RegBus] ex_ram_waddr,
	input wire[`RegBus] ex_ram_wdata,

	output reg mem_ram_wreg,
	output reg[`RegBus] mem_ram_wdata,
	output reg[`RegBus] mem_ram_waddr,
	output reg[2:0] mem_ld_type,
	output reg[`RegBus] mem_read_addr
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_waddr <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		 	mem_wdata <= `ZeroWord;	
		 	mem_ram_waddr <= `ZeroWord;
		 	mem_ram_wdata <= `ZeroWord;
		 	mem_ram_wreg <= `WriteDisable;
		 	mem_ld_type <= 3'b111;
		 	mem_read_addr <= `ZeroWord;
		end else begin
			mem_waddr <= ex_waddr;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;
			mem_ram_waddr <= ex_ram_waddr;
			mem_ram_wdata <= ex_ram_wdata;
			mem_ram_wreg <= ex_ram_wreg;
			mem_ld_type <= ex_ld_type;
			mem_read_addr <= ex_read_addr;
		end    //if
	end      //always
			

endmodule