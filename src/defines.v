`timescale 1ns / 1ps

`define RstEnable 		1'b1
`define RstDisable 		1'b0
`define ZeroWord 		32'h00000000
`define WriteEnable 	1'b1
`define WriteDisable 	1'b0
`define ReadEnable 		1'b1
`define ReadDisable 	1'b0
`define ChipEnable 		1'b1
`define ChipDisable 	1'b0

`define I_OP		7'b0010011
`define R_OP		7'b0110011
`define B_OP		7'b1100011
`define LUI_OP		7'b0110111
`define AUIPC_OP	7'b0110111
`define S_OP 		7'b0100011
`define JAL_OP		7'b1101111
`define JALR_OP		7'b1100111
`define LOAD_OP		7'b0000011


`define ALU_NO_OP	4'b1111
`define ADD  4'b0000
`define SLL  4'b0001
`define SLT  4'b0010
`define SLTU 4'b0011
`define XOR  4'b0100
`define SRL  4'b0101
`define OR   4'b0110
`define AND  4'b0111
`define SUB  4'b1000
`define LUI  4'b1001
`define SB   4'b1010
`define SH 	 4'b1011
`define SW 	 4'b1100
`define SRA  4'b1101
`define JAL	 4'b1110

`define ADDI 4'b0000
`define SLLI 4'b0001
`define SLTI 4'b0010
`define SLTIU 4'b0011
`define XORI 4'b0100
`define SRLI 4'b0101
`define ORI 4'b0110
`define ANDI 4'b0111
`define SRAI 4'b1101

`define Branch 1'b1
`define NotBranch 1'b0
`define BEQ  3'b000
`define BNE  3'b001
`define BLT  3'b100
`define BGE  3'b101
`define BLTU 3'b110
`define BGEU 3'b111

`define LB   3'b000
`define LW   3'b010
`define LH   3'b001
`define LBU  3'b100
`define LHU  3'b101

//指令存储器inst_rom
`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 131071
`define InstMemNumLog2 17

//通用寄存器regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define SelBus 2:0
`define OpBus 3:0

`define NOPRegAddr 5'b00000