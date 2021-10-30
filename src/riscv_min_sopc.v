`include "defines.v"

module riscv_min_sopc(
	input wire clk,
	input wire rst,
	input wire change,
	output wire[15:0] led
);
	
	wire ce;

	//指令，传到crtl模块进行输出，也传到cpu模块进行执行
	wire[`InstBus] inst;
	wire[`InstAddrBus] inst_addr;

	wire ram_wreg;
	wire[`RegBus] ram_waddr;
	wire[`RegBus] rdata;
	wire[`RegBus] ram_wdata;
	wire[`RegBus] raddr;
	
	riscv riscv0(
		.clk(clk), .rst(rst),
		.inst(inst), .inst_addr(inst_addr), .ce(ce),
		.rdata(rdata) ,.ram_waddr(ram_waddr), .ram_wdata(ram_wdata), .ram_wreg(ram_wreg), .raddr(raddr)
	);

	inst_rom inst_rom0(
		.ce(ce), .addr(inst_addr), .inst(inst)
	);

	//控制输出模块
	ctrl ctrl0(
		.data(inst), .change(change), .led(led)
	);

	dataram dataram0(
		.rst(rst), .clk(clk), .we(ram_wreg), .wdata(ram_wdata), .waddr(ram_waddr), .raddr(raddr), .rdata(rdata)
	);

endmodule