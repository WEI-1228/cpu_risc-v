`include "defines.v"

module if_id(

	input wire clk,
	input wire rst,
	input wire is_in_delay,

	input wire[`InstAddrBus] if_pc,
	input wire[`InstBus] if_inst,
	output reg[`InstAddrBus] id_pc,
	output reg[`InstBus] id_inst
);

	reg open = 1'b1;
	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end else begin
		 	id_pc <= if_pc;
		 	if (is_in_delay == 1'b0 || open == 1'b1) id_inst <= if_inst;
		 	else id_inst <= 32'b0;
		 	open <= 1'b0;
		end
	end

endmodule