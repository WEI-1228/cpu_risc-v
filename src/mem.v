`include "defines.v"

module mem(

	input wire rst,
	
	//����ִ�н׶ε���Ϣ	
	input wire[`RegAddrBus]waddr,
	input wire wreg,
	input wire[`RegBus]	wdata,
	input wire[2:0] ld_type,
	input wire[`RegBus] read_addr,


	//ram��ȡ��������
	input wire[`RegBus] rdata,

	//ramд�ص�����
	input wire[`RegBus] ram_wdata_i,
	input wire[`RegBus] ram_waddr_i,
	input wire ram_wreg_i,
	
	//�͵���д�׶ε���Ϣ
	output reg[`RegAddrBus] waddr_o,
	output reg wreg_o,
	output reg[`RegBus]	wdata_o,

	//д��ram
	output reg[`RegBus] ram_waddr,
	output reg[`RegBus] ram_wdata,
	output reg ram_wreg,

	//��ȡram�ĵ�ַ
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