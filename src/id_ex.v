`include "defines.v"

module id_ex(

	input wire clk,
	input wire rst,
	
	//从译码阶段传递的信息
	input wire[`OpBus] id_aluop,
	input wire[`RegBus] id_op1,
	input wire[`RegBus] id_op2,
	input wire[`RegAddrBus] id_waddr,
	input wire id_wreg,
	input wire[2:0] id_ld_type,
	input wire[`RegBus] id_read_addr,

	input wire id_ram_wreg,
	input wire[`RegBus] id_ram_waddr,

	//传递到执行阶段的信息
	output reg[`OpBus]         ex_aluop,
	output reg[`RegBus]           ex_op1,
	output reg[`RegBus]           ex_op2,
	output reg[`RegAddrBus]       ex_waddr,
	output reg                    ex_wreg,

	output reg ex_ram_wreg,
	output reg[`RegBus] ex_ram_waddr,
	output reg[2:0] ex_ld_type,
	output reg[`RegBus] ex_read_addr
	
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ex_aluop <= `ALU_NO_OP;
			ex_op1 <= `ZeroWord;
			ex_op2 <= `ZeroWord;
			ex_waddr <= `NOPRegAddr;
			ex_wreg <= `WriteDisable;
			ex_ram_waddr <= `ZeroWord;
			ex_ram_wreg <= `WriteDisable;
			ex_ld_type <= 3'b111;
			ex_read_addr <= `ZeroWord;
		end else begin		
			ex_aluop <= id_aluop;
			ex_op1 <= id_op1;
			ex_op2 <= id_op2;
			ex_waddr <= id_waddr;
			ex_wreg <= id_wreg;	
			ex_ram_wreg <= id_ram_wreg;
			ex_ram_waddr <= id_ram_waddr;
			ex_ld_type <= id_ld_type;
			ex_read_addr <= id_read_addr;
		end
	end
	
endmodule