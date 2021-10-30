`include "defines.v"

module riscv(
	input wire clk,
	input wire rst,
	input wire[`RegBus] inst,		//输入指令
	output wire[`RegBus] inst_addr,		//输出指令地址去取指令
	output wire ce,

	input wire[`RegBus] rdata,

	output wire[`RegBus] ram_waddr,
	output wire[`RegBus] ram_wdata,
	output wire ram_wreg,
	output wire[`RegBus] raddr
);

	
	//连接pc与if_id
	wire[`InstAddrBus] pc;	

	//连接if_id与id
	wire[`InstAddrBus] id_pc_i;
	wire[`InstBus] id_inst_i;

	//连接id与regfile
	wire[`RegBus] id_data1_i;
	wire[`RegBus] id_data2_i;
	wire reg_read1;
	wire reg_read2;
	wire[`RegAddrBus] reg_read1_re;
	wire[`RegAddrBus] reg_read2_re;

	//连接id与id_ex
	wire[`RegBus] id_op1_o;
	wire[`RegBus] id_op2_o;
	wire id_wreg_o;
	wire[`OpBus] id_aluop_o;
	wire[`RegAddrBus] id_waddr_o;

	wire id_ram_wreg_o;
	wire[`RegBus] id_ram_addr_o;

	//连接id_ex与ex
	wire ex_wreg_i;
	wire[`RegBus] ex_op1_i;
	wire[`RegBus] ex_op2_i;
	wire[`RegAddrBus] ex_waddr_i;
	wire[`OpBus] ex_aluop;

	wire[`RegBus] ex_ram_addr_i;
	wire ex_ram_wreg_i;

	//连接EX与EX_MEM
	wire[`RegBus] ex_wdata_o;
	wire ex_wreg_o;
	wire[`RegAddrBus] ex_waddr_o;

	wire ex_ram_wreg_o;
	wire[`RegBus] ex_ram_waddr_o;
	wire[`RegBus] ex_ram_wdata_o;


	pc_reg pc_reg0(
		.clk(clk), .rst(rst),
		.pc(pc), .ce(ce),
		.branch_flag_i(branch_flag_o), .branch_target_i(branch_target_address_o)
	);

	//将PC地址输出
	assign inst_addr = pc;

	if_id if_id0(
		.clk(clk), .rst(rst),
		.if_pc(pc), .if_inst(inst),
		.id_pc(id_pc_i), .id_inst(id_inst_i), .is_in_delay(is_in_delay)
	);

	//连接ID与PC
	wire branch_flag_o;
	wire[`InstAddrBus] branch_target_address_o;

	//连接id与if
	wire is_in_delay;


	id id0(
	.rst(rst),
	.inst(id_inst_i), .pc(id_pc_i),
	.reg1_data(id_data1_i), .reg2_data(id_data2_i),
	.wreg(id_wreg_o), .waddr(id_waddr_o),
	.op1(id_op1_o), .op2(id_op2_o), .alu_op(id_aluop_o),
	.reg1_addr(reg_read1_re), .reg2_addr(reg_read2_re),
	.reg1_read(reg_read1), .reg2_read(reg_read2),
	.ex_wreg(ex_wreg_o), .ex_wdata(ex_wdata_o), .ex_waddr(ex_waddr_o),
	.mem_wreg(mem_wreg_o), .mem_wdata(mem_wdata_o), .mem_waddr(mem_waddr_o),
	.branch_flag_o(branch_flag_o), .branch_target_address_o(branch_target_address_o),
	.next_inst_in_delay(is_in_delay),
	.ram_wreg(id_ram_wreg_o), .ram_addr(id_ram_addr_o),
	.ld_type(ld_type1), .read_addr(read_addr1)
	);

	wire[2:0] ld_type1;
	wire[`RegBus] read_addr1;

	id_ex id_ex0(
		.clk(clk), .rst(rst),
		.id_aluop(id_aluop_o),
		.id_op1(id_op1_o), .id_op2(id_op2_o),
		.id_waddr(id_waddr_o), .id_wreg(id_wreg_o),
		.ex_aluop(ex_aluop), .ex_op1(ex_op1_i), .ex_op2(ex_op2_i),
		.ex_waddr(ex_waddr_i), .ex_wreg(ex_wreg_i),
		.id_ram_wreg(id_ram_wreg_o), .id_ram_waddr(id_ram_addr_o), .ex_ram_wreg(ex_ram_wreg_i), .ex_ram_waddr(ex_ram_addr_i),
		.id_ld_type(ld_type1), .id_read_addr(read_addr1), .ex_ld_type(ld_type2), .ex_read_addr(read_addr2)
	);

	wire[2:0] ld_type2;
	wire[`RegBus] read_addr2;

	ex ex0(
		.rst(rst),
		.alu_op(ex_aluop), .wreg(ex_wreg_i), .waddr(ex_waddr_i),
		.op1(ex_op1_i), .op2(ex_op2_i),
		.waddr_o(ex_waddr_o), .wdata_o(ex_wdata_o), .wreg_o(ex_wreg_o),
		.ram_wreg(ex_ram_wreg_i), .ram_waddr(ex_ram_addr_i), .ram_wreg_o(ex_ram_wreg_o), .ram_waddr_o(ex_ram_waddr_o), .ram_wdata_o(ex_ram_wdata_o),
		.ld_type(ld_type2), .read_addr(read_addr2), .ld_type_o(ld_type3), .read_addr_o(read_addr3)
	);

	wire[2:0] ld_type3;
	wire[`RegBus] read_addr3;

	//连接EX_MEM与MEM
	wire mem_wreg_i;
	wire[`RegBus] mem_wdata_i;
	wire[`RegAddrBus] mem_waddr_i;

	wire mem_ram_wreg_i;
	wire[`RegBus] mem_ram_wdata_i;
	wire[`RegBus] mem_ram_waddr_i;

	ex_mem ex_mem0(
		.clk(clk), .rst(rst),
		.ex_waddr(ex_waddr_o), .ex_wreg(ex_wreg_o), .ex_wdata(ex_wdata_o),
		.mem_waddr(mem_waddr_i), .mem_wreg(mem_wreg_i), .mem_wdata(mem_wdata_i),
		.ex_ram_wdata(ex_ram_wdata_o), .ex_ram_waddr(ex_ram_waddr_o), .ex_ram_wreg(ex_ram_wreg_o),
		.mem_ram_wdata(mem_ram_wdata_i), .mem_ram_waddr(mem_ram_waddr_i), .mem_ram_wreg(mem_ram_wreg_i),
		.ex_read_addr(read_addr3), .ex_ld_type(ld_type3), .mem_read_addr(read_addr4), .mem_ld_type(ld_type4)
	);

	wire[2:0] ld_type4;
	wire[`RegBus] read_addr4;

	//连接MEM与MEM_WB
	wire mem_wreg_o;
	wire[`RegBus] mem_wdata_o;
	wire[`RegAddrBus] mem_waddr_o;

	mem mem0(
		.rst(rst),
		.waddr(mem_waddr_i), .wreg(mem_wreg_i), .wdata(mem_wdata_i),
		.waddr_o(mem_waddr_o), .wreg_o(mem_wreg_o), .wdata_o(mem_wdata_o),
		.rdata(rdata), .ram_waddr(ram_waddr), .ram_wdata(ram_wdata), .ram_wreg(ram_wreg), .raddr(raddr),
		.ram_wdata_i(mem_ram_wdata_i), .ram_waddr_i(mem_ram_waddr_i), .ram_wreg_i(mem_ram_wreg_i),
		.ld_type(ld_type4), .read_addr(read_addr4)
	);

	//连接MEM_WB与REGFILE
	wire wb_wreg;
	wire[`RegAddrBus] wb_waddr;
	wire[`RegBus] wb_wdata;
	mem_wb mem_wb0(
		.clk(clk), .rst(rst),
		.waddr(mem_waddr_o), .wreg(mem_wreg_o), .wdata(mem_wdata_o),
		.waddr_o(wb_waddr), .wreg_o(wb_wreg), .wdata_o(wb_wdata)
	);

	regfile regfile0(
		.clk(clk), .rst(rst),
		.raddr1(reg_read1_re), .re1(reg_read1), .rdata1(id_data1_i),
		.raddr2(reg_read2_re), .re2(reg_read2), .rdata2(id_data2_i),
		.we(wb_wreg), .wdata(wb_wdata), .waddr(wb_waddr)
	);



endmodule