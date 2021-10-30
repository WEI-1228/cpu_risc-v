`include "defines.v"

module ctrl(
	input wire[`RegBus] data,
	input wire change,
	output reg[15:0] led
);

	always @ (*) begin
		if (change == 1'b0) begin
			led <= data[15:0];
		end else begin
			led <= data[31:16];
		end
	end
endmodule