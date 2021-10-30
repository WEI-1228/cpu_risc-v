`include "defines.v"


module regfile(
	input wire clk,
	input wire rst,

	input wire[`RegAddrBus] raddr1,
	input wire re1,
	output reg[`RegBus] rdata1,

	input wire[`RegAddrBus] raddr2,
	input wire re2,
	output reg[`RegBus] rdata2,

	input wire we,
	input wire[`RegBus] wdata,
	input wire[`RegAddrBus] waddr
);

	reg[`RegBus]  regs[0:31];

	initial begin
		regs[1] = 32'h0001;
		regs[2] = 32'h0010;
		regs[3] = 32'h0000;
		regs[4] = 32'h0100;
		regs[5] = 32'h0000;
		regs[16] = 32'h4321;
	end

	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != 5'b0)) begin
				regs[waddr] <= wdata;
			end
		end
	end

	always @ (*) begin
		if(rst == `RstEnable) begin
			rdata1 <= `ZeroWord;
	  	end else if(raddr1 == 5'b0) begin
	  		rdata1 <= `ZeroWord;
	  	end else if((raddr1 == waddr) && (we == `WriteEnable) 
	  	            && (re1 == `ReadEnable)) begin
	  	  	rdata1 <= wdata;
	  	end else if(re1 == `ReadEnable) begin
	      	rdata1 <= regs[raddr1];
	  	end else begin
	      	rdata1 <= `ZeroWord;
	  	end
	end

	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 <= `ZeroWord;
	  end else if(raddr2 == 5'b0) begin
	  		rdata2 <= `ZeroWord;
	  end else if((raddr2 == waddr) && (we == `WriteEnable) 
	  	            && (re2 == `ReadEnable)) begin
	  	  rdata2 <= wdata;
	  end else if(re2 == `ReadEnable) begin
	      rdata2 <= regs[raddr2];
	  end else begin
	      rdata2 <= `ZeroWord;
	  end
	end


endmodule