`include "defines.v"

module ex(
	
	input wire rst,

	input wire[`OpBus] alu_op,
	// input wire[`SelBus] sel_op,

	input wire wreg,
	input wire[`RegAddrBus] waddr,
	input wire[`RegBus] op1,
	input wire[`RegBus] op2,

	input wire ram_wreg,
	input wire[`RegBus] ram_waddr,
	input wire[2:0] ld_type,
	input wire[`RegBus] read_addr,

	output reg[`RegAddrBus] waddr_o,
	output reg[`RegBus] wdata_o,
	output reg wreg_o,

	output reg ram_wreg_o,
	output reg[`RegBus] ram_waddr_o,
	output reg[`RegBus] ram_wdata_o,
	output reg[2:0] ld_type_o,
	output reg[`RegBus] read_addr_o
);

	reg[`RegBus] AluOut;
	reg[`RegBus] RamData;

	//直接计算结果
	always@(*) begin
		if (rst == `RstEnable) begin
			AluOut <= `ZeroWord;
		end
		else begin
			case (alu_op)
				`ADD: AluOut = op1 + op2;
				`SUB: AluOut = op1 - op2;
				`AND: AluOut = op1 & op2;
				`OR : AluOut = op1 | op2;
				`XOR: AluOut = op1 ^ op2;
				`SLT: AluOut = ($signed(op1) < $signed(op2)) ? 32'b1 : 32'b0;
				`SLTU: AluOut = (op1 < op2) ? 32'b1 : 32'b0;
				`SLL: AluOut = op1 << op2[4:0];
				`SRL: AluOut = op1 >> op2[4:0];
				`SRA: AluOut = $signed(op1) >>> op2[4:0];
				`LUI: AluOut = op2;
				`SH: RamData = op2[15:0];
				`SB: RamData = op2[7:0];
				`SW: RamData = op2;
				`JAL: AluOut = op2;
				default: AluOut = 32'hxxxxxxxx;
			endcase
		end
	end

	//输出
	always @ (*) begin
		waddr_o <= waddr;
		wreg_o <= wreg;
		wdata_o <= AluOut;

		ram_wdata_o <= RamData;
		ram_waddr_o <= ram_waddr;
		ram_wreg_o <= ram_wreg;

		ld_type_o <= ld_type;
		read_addr_o <= read_addr;
	end


endmodule