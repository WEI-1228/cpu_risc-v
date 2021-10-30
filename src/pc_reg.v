`include "defines.v"

module pc_reg(
	input wire clk,
	input wire rst,

	input wire branch_flag_i,
	input wire[`InstAddrBus] branch_target_i,

	output reg[`InstAddrBus] pc,
	output reg ce
);

	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin
			pc <= 32'h00000000;
		end else begin
			if (branch_flag_i == `Branch) begin
				pc <= branch_target_i;
				pc[0] <= 0;
				pc[1] <= 0;
			end else begin
	 			pc <= pc + 4'h4;
	 		end
		end
	end
	
	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;
		end else begin
			ce <= `ChipEnable;
		end
	end

endmodule