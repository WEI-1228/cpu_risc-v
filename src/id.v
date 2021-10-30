`include "defines.v"

module id(
	input wire rst,		//清空信号
	input wire[`InstBus] inst,		//pc送来的指令
	input wire[`InstAddrBus] pc,
	input wire[`RegBus] reg1_data,		//regfile一号读取口
	input wire[`RegBus] reg2_data,		//regfile二号读取口

	//EX阶段数据前推
	input wire ex_wreg,
	input wire[`RegBus] ex_wdata,
	input wire[`RegAddrBus] ex_waddr,

	//MEM阶段数据前推
	input wire mem_wreg,
	input wire[`RegBus] mem_wdata,
	input wire[`RegAddrBus] mem_waddr,


	//送到执行阶段
	output reg wreg,		//是否需要写寄存器
	output reg[`RegAddrBus] waddr, 		//需要写的地址
	output reg[`RegBus] op1,		//运算数1
	output reg[`RegBus] op2,		//运算数2
	// output reg[`SelBus] sel_op,		//运算类型
	output reg[`OpBus] alu_op, 		//运算操作类型

	//送到寄存器
	output reg[`RegAddrBus] reg1_addr,		//读寄存器端口1的地址
	output reg[`RegAddrBus] reg2_addr,		//读寄存器端口2的地址
	output reg reg1_read,					//是否读寄存器1
	output reg reg2_read,					//是否读寄存器2

	output reg branch_flag_o,
	output reg[`RegBus] branch_target_address_o,
	output reg next_inst_in_delay,
	output reg ram_wreg,
	output reg[`RegBus] ram_addr,
	output reg[2:0] ld_type,
	output reg[`RegBus] read_addr
);

	wire[6:0] opcode = inst[6:0];
	wire[4:0] rs1 = inst[19:15];
	wire[4:0] rs2 = inst[24:20];
	wire[4:0] rd = inst[11:7];
	wire[2:0] fun3 = inst[14:12];

	reg[`RegBus] imm;

	reg tmp = 1'b0;

	reg[`RegBus] num1;
	reg[`RegBus] num2;


	always @ (*) begin
		if (rst == `RstEnable) begin
			alu_op <= `ALU_NO_OP;
			wreg <= `WriteDisable;
			waddr <= `NOPRegAddr;
			op1 <= `ZeroWord;
			op2 <= `ZeroWord;
			reg1_addr <= `NOPRegAddr;
			reg2_addr <= `NOPRegAddr;
			reg1_read <= `ReadDisable;
			reg2_read <= `ReadDisable;
			ram_wreg <= `WriteDisable;
			ram_addr <= `ZeroWord;
			branch_target_address_o <= `ZeroWord;
			branch_flag_o <= `NotBranch;
			next_inst_in_delay <= 1'b0;
			ld_type <= 3'b111;
		end else begin
		/*           必须清空！             */
			alu_op <= `ALU_NO_OP;
			wreg <= `WriteDisable;
			waddr <= `NOPRegAddr;
			op1 <= `ZeroWord;
			op2 <= `ZeroWord;
			reg1_addr <= rs1;
			reg2_addr <= rs2;
			reg1_read <= `ReadDisable;
			reg2_read <= `ReadDisable;
			ram_wreg <= `WriteDisable;
			ram_addr <= `ZeroWord;
			branch_target_address_o <= `ZeroWord;
			branch_flag_o <= `NotBranch;
			next_inst_in_delay <= 1'b0;
			ld_type <= 3'b111;
			case (opcode)
				`I_OP: begin
					reg1_read <= `ReadEnable;
					waddr <= rd;
					wreg <= `WriteEnable;
					if (fun3 == 3'b101) begin
						tmp <= inst[30];
					end
					alu_op <= {tmp, fun3};
					case ({tmp, fun3})
						`ADDI: imm <= {20'h0,inst[31:20]};
						`SLTI: imm <= {20'h0,inst[31:20]};
						`SLTIU:imm <= {20'h0,inst[31:20]};
						`XORI: imm <= {20'h0,inst[31:20]};
						`ORI: imm <= {20'h0,inst[31:20]};
						`ANDI: imm <= {20'h0,inst[31:20]};
						`SLLI: imm <= {27'h0,inst[24:20]};
						`SRLI: imm <= {27'h0,inst[24:20]};
						`SRAI: imm <= {27'h0,inst[24:20]};
					endcase
				end
				`R_OP: begin
					reg1_read <= `ReadEnable;
					reg2_read <= `ReadEnable;
					waddr <= rd;
					wreg <= `WriteEnable;
					alu_op <= {inst[30],fun3};
				end
				`B_OP: begin
					wreg <= `WriteDisable;
					imm <= { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 };
					reg1_read <= `ReadEnable;
					reg2_read <= `ReadEnable;
					next_inst_in_delay <= 1'b1;
					if((ex_wreg == `WriteEnable) && (ex_waddr == reg1_addr)) begin
						num1 <= ex_wdata;
					end else if((mem_wreg == `WriteEnable) && (mem_waddr == reg1_addr)) begin
						num1 <= mem_wdata;
					end else begin
						num1 <= reg1_data;
					end

					if((ex_wreg == `WriteEnable) && (ex_waddr == reg2_addr)) begin
						num2 <= ex_wdata;
					end else if((mem_wreg == `WriteEnable) && (mem_waddr == reg2_addr)) begin
						num2 <= mem_wdata;
					end else begin
						num2 <= reg2_data;
					end
					branch_target_address_o <= pc + imm;
					case (fun3) 
						`BEQ: if (num1 == num2) branch_flag_o <= `Branch;
						`BNE: if (num1 != num2) branch_flag_o <= `Branch;
						`BLT: if ($signed(num1) < $signed(num2)) branch_flag_o <= `Branch;
						`BGE: if ($signed(num1) >= $signed(num2)) branch_flag_o <= `Branch;
						`BLTU: if (num1 < num2) branch_flag_o <= `Branch;
						`BGEU: if (num1 >= num2) branch_flag_o <= `Branch;
					endcase
				end
				`LUI_OP: begin
					wreg <= `WriteEnable;
					imm <= { inst[31:12], {12{1'b0}} };
					waddr <= rd;
					alu_op <= `LUI;
				end
				`AUIPC_OP: begin
					wreg <= `WriteEnable;
					imm <= { inst[31:12], {12{1'b0}} } + pc;
					waddr <= rd;
					alu_op <= `LUI;
				end
				`S_OP: begin
					case (fun3)
						3'b000: alu_op <= `SB;
						3'b001: alu_op <= `SH;
						3'b010: alu_op <= `SW;
					endcase
					reg1_read <= `ReadEnable;
					reg2_read <= `ReadEnable;
					ram_wreg <= `WriteEnable;
					imm <= { {21{inst[31]}}, inst[30:25], inst[11:7] };
					if((ex_wreg == `WriteEnable) && (ex_waddr == reg1_addr)) begin
						num1 <= ex_wdata;
					end else if((mem_wreg == `WriteEnable) && (mem_waddr == reg1_addr)) begin
						num1 <= mem_wdata;
					end else begin
						num1 <= reg1_data;
					end
					ram_addr <= num1 + imm;
				end
				`JAL_OP: begin
					wreg <= `WriteEnable;
					branch_flag_o <= `Branch;
					waddr <= rd;
					imm <= pc + 32'd4;
					next_inst_in_delay <= 1'b1;
					branch_target_address_o <= pc + { {12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0 };
					alu_op <= `JAL;
				end
				`JALR_OP: begin
					wreg <= `WriteEnable;
					branch_flag_o <= `Branch;
					waddr <= rd;
					reg1_read <= `ReadEnable;
					imm <= pc + 32'd4;
					next_inst_in_delay <= 1'b1;
					if((ex_wreg == `WriteEnable) && (ex_waddr == reg1_addr)) begin
						num1 <= ex_wdata;
					end else if((mem_wreg == `WriteEnable) && (mem_waddr == reg1_addr)) begin
						num1 <= mem_wdata;
					end else begin
						num1 <= reg1_data;
					end
					branch_target_address_o <= num1 + { {21{inst[31]}}, inst[30:20] };
					alu_op <= `JAL;
				end
				`LOAD_OP: begin
					wreg <= `WriteEnable;
					waddr <= rd;
					ld_type <= fun3;
					reg1_read <= `ReadEnable;
					if((ex_wreg == `WriteEnable) && (ex_waddr == reg1_addr)) begin
						num1 <= ex_wdata;
					end else if((mem_wreg == `WriteEnable) && (mem_waddr == reg1_addr)) begin
						num1 <= mem_wdata;
					end else begin
						num1 <= reg1_data;
					end
					read_addr <= num1 + { {21{inst[31]}}, inst[30:20] };
				end
				default: begin
				end
			endcase
		end
	end


	//读取寄存器1的数据
	always @ (*) begin
		if (rst == `RstEnable) begin
			op1 <= `ZeroWord;
		end else begin
			if((ex_wreg == `WriteEnable) && (ex_waddr == reg1_addr) && (reg1_read == `ReadEnable)) begin
				op1 <= ex_wdata;
			end else if((mem_wreg == `WriteEnable) && (mem_waddr == reg1_addr) && (reg1_read == `ReadEnable))begin
				op1 <= mem_wdata;
			end else if (reg1_read == `ReadEnable) begin
				op1 <= reg1_data;
			end else begin
				
			end
		end
	end

	//读取寄存器2的数据
	always @ (*) begin
		if (rst == `RstEnable) begin
			op2 <= `ZeroWord;
		end else begin
			if((ex_wreg == `WriteEnable) && (ex_waddr == reg2_addr) && (reg2_read == `ReadEnable)) begin
				op2 <= ex_wdata;
			end else if((mem_wreg == `WriteEnable) && (mem_waddr == reg2_addr) && (reg2_read == `ReadEnable))begin
				op2 <= mem_wdata;
			end else if (reg2_read == `ReadEnable) begin
				op2 <= reg2_data;
			end else begin
				op2 <= imm;
			end
		end
	end

endmodule