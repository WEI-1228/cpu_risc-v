`include "defines.v"

module mem(

	input wire rst,
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]waddr,
	input wire wreg,
	input wire[`RegBus]	wdata,
	input wire[2:0] ld_type,
	input wire[`RegBus] read_addr,


	//ram读取到的数据
	input wire[`RegBus] rdata,

	//ram写回的数据
	input wire[`RegBus] ram_wdata_i,
	input wire[`RegBus] ram_waddr_i,
	input wire ram_wreg_i,
	
	//送到回写阶段的信息
	output reg[`RegAddrBus] waddr_o,
	output reg wreg_o,
	output reg[`RegBus]	wdata_o,

	//写回ram
	output reg[`RegBus] ram_waddr,
	output reg[`RegBus] ram_wdata,
	output reg ram_wreg,

	//读取ram的地址
	output reg[`RegBus] raddr
	
);

	
	always @ (*) begin
		if(rst == `RstEnable) begin
			waddr_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
		  	wdata_o <= `ZeroWord;

		  	ram_waddr <= `ZeroWord;
		  	ram_wdata <= `ZeroWord;
		  	ram_wreg <= `WriteDisable;
		end else begin
			raddr <= read_addr;
		  	waddr_o <= waddr;
			wreg_o <= wreg;
			case (ld_type)
				`LB: wdata_o <= { {25{rdata[7]}},rdata[6:0] };
				`LW: wdata_o <= rdata;
				`LH: wdata_o <= { {17{rdata[15]}},rdata[14:0] };
				`LBU: wdata_o <= { 24'h0,rdata[7:0] };
				`LHU: wdata_o <= { 16'h0,rdata[15:0] };
				default: wdata_o <= wdata;
			endcase
			ram_waddr <= ram_waddr_i;
			ram_wdata <= ram_wdata_i;
			ram_wreg <= ram_wreg_i;
		end    //if
	end      //always
			

endmodule