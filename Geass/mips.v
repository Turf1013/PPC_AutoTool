`include "arch_def.v"
`include "ctrl_encode_def.v"
`include "default_def.v"
`include "instruction_def.v"

module mips (
	clk, rst_n
);

	input clk;
	input rst_n;

	wire [`DM_WIDTH-1:0] DM_dout_M;
	wire [0:0] BrCmp_Comp_D;
	wire [31:0] NPC_NPC_D;
	wire [31:0] NPC_Laddr_D;
	wire [`DM_WIDTH-1:0] DMIn_BE_dout_M;
	wire [`DMBE_WIDTH-1:0] DMIn_BE_DMBE_M;
	wire [`PC_WIDTH-1:0] PC_PC_F;
	wire [31:0] Ext_Imm32_E;
	wire [`DM_WIDTH-1:0] DMOut_ME_dout_M;
	wire [31:0] ALU_C_E;
	wire [31:0] GPR_rd1_D;
	wire [31:0] GPR_rd2_D;
	wire [`ExtOp_WIDTH-1:0] ExtOp;
	wire [`GPRWr_WIDTH-1:0] GPRWr;
	wire [2:0] GPR_waddr_Sel;
	wire [2:0] GPRWd_Sel;
	wire [`NPCOp_WIDTH-1:0] NPCOp;
	wire [`BrCmp_Op_WIDTH-1:0] BrCmp_Op;
	wire [`DMIn_BEOp_WIDTH-1:0] DMIn_BEOp;
	wire [`ALUOp_WIDTH-1:0] ALUOp;
	wire [2:0] GPR_rd1_E_Bp_Sel;
	wire [1:0] ALU_B_Sel;
	wire [`DMWr_WIDTH-1:0] DMWr;
	wire [`DMOut_MEOp_WIDTH-1:0] DMOut_MEOp;
	wire PCWr;
	wire pipeRegWr_F;
	wire pipeRegWr_E;
	wire pipeRegWr_D;
	wire [2:0] GPR_rd1_D_Bp_Sel;
	wire pipeRegWr_M;
	wire [2:0] GPR_rd2_E_Bp_Sel;
	wire pipeRegWr_W;
	wire [2:0] GPR_rd2_D_Bp_Sel;
	wire [`INSTR_WIDTH-1:0] Instr_F;
	wire [31:0] GPR_rd2_D_Bp;
	wire [31:0] GPR_rd2_E_Bp;
	wire [31:0] GPR_rd1_D_Bp;
	wire [31:0] GPR_rd1_E_Bp;

	reg [`INSTR_WIDTH-1:0] Instr_D;
	reg [31:0] GPR_rd2_E;
	reg [31:0] NPC_Laddr_E;
	reg [31:0] GPR_rd1_E;
	reg [`INSTR_WIDTH-1:0] Instr_E;
	reg [31:0] NPC_Laddr_M;
	reg [31:0] ALU_C_M;
	reg [`INSTR_WIDTH-1:0] Instr_M;
	reg [31:0] NPC_Laddr_W;
	reg [`DM_WIDTH-1:0] DMOut_ME_dout_W;
	reg [31:0] ALU_C_W;
	reg [`INSTR_WIDTH-1:0] Instr_W;

	DM U_DM (
		.DMBE(DMIn_BE_DMBE_M), .dout(DM_dout_M), .addr(ALU_C_M[1+`DM_DEPTH:2]), .clk(clk), 
		.DMWr(DMWr), .din(DMIn_BE_dout_M)
	);

	BrCmp U_BrCmp (
		.A(GPR_rd1_D_Bp), .Comp(BrCmp_Comp_D), .B(GPR_rd2_D_Bp), .Op(BrCmp_Op)
	);

	NPC U_NPC (
		.Rs(GPR_rd1_D_Bp), .Comp(BrCmp_Comp_D), .NPCOp(NPCOp), .NPC(NPC_NPC_D), 
		.PC(PC_PC_F), .Imm26(Instr_D[25:0]), .NPC_Laddr(NPC_Laddr_D)
	);

	DMIn_BE U_DMIn_BE (
		.laddr(ALU_C_M[1:0]), .dout(DMIn_BE_dout_M), .din(GPR_rd1_M), .DMIn_BEOp(DMIn_BEOp), 
		.DMBE(DMIn_BE_DMBE_M)
	);

	PC U_PC (
		.rst_n(rst_n), .PCWr(PCWr), .PC(PC_PC_F), .NPC(NPC_NPC_D), 
		.clk(clk)
	);

	Ext U_Ext (
		.ExtOp(ExtOp), .Imm32(Ext_Imm32_E), .Imm16(Instr_E[15:0])
	);

	IM U_IM (
		.dout(Instr_F), .addr(PC_PC_F)
	);

	DMOut_ME U_DMOut_ME (
		.laddr(ALU_C_M[1:0]), .din(DM_dout_M), .DMOut_MEOp(DMOut_MEOp), .dout(DMOut_ME_dout_M)
	);

	ALU U_ALU (
		.A(GPR_rd1_E_Bp), .ALUOp(ALUOp), .C(ALU_C_E), .B(ALU_B_E)
	);

	GPR U_GPR (
		.GPRWd(GPRWd_W), .raddr1(Instr_D[25:21]), .waddr(GPR_waddr_W), .rd1(GPR_rd1_D), 
		.rst_n(rst_n), .clk(clk), .raddr2(Instr_D[20:16]), .GPRWr(GPRWr), 
		.rd2(GPR_rd2_D)
	);

	control U_control (
		.ExtOp(ExtOp), .rst_n(rst_n), .GPRWr(GPRWr), .GPR_waddr_Sel(GPR_waddr_Sel), 
		.GPRWd_Sel(GPRWd_Sel), .clk(clk), .NPCOp(NPCOp), .BrCmp_Op(BrCmp_Op), 
		.DMIn_BEOp(DMIn_BEOp), .ALUOp(ALUOp), .GPR_rd1_E_Bp_Sel(GPR_rd1_E_Bp_Sel), .ALU_B_Sel(ALU_B_Sel), 
		.Instr_M(Instr_M), .DMWr(DMWr), .DMOut_MEOp(DMOut_MEOp), .PCWr(PCWr), 
		.pipeRegWr_F(pipeRegWr_F), .pipeRegWr_E(pipeRegWr_E), .pipeRegWr_D(pipeRegWr_D), .GPR_rd1_D_Bp_Sel(GPR_rd1_D_Bp_Sel), 
		.Instr_D(Instr_D), .Instr_E(Instr_E), .pipeRegWr_M(pipeRegWr_M), .GPR_rd2_E_Bp_Sel(GPR_rd2_E_Bp_Sel), 
		.pipeRegWr_W(pipeRegWr_W), .GPR_rd2_D_Bp_Sel(GPR_rd2_D_Bp_Sel), .Instr_W(Instr_W)
	);

	mux2 #((31)-(0)+1) U_ALU_B_E_mux2 (
		.d0(GPR_rd2_E_Bp), .d1(Ext_Imm32_E), 
		.s(ALU_B_E_Sel), .y(ALU_B_E)
	);

	mux4 #((4)-(0)+1) U_GPR_waddr_W_mux4 (
		.d0(32'd31), .d1(Instr_W[15:11]), .d2(Instr_W[20:16]), .d3(`MUX_D_DEFAULT), 
		.s(GPR_waddr_W_Sel), .y(GPR_waddr_W)
	);

	mux4 #((31)-(0)+1) U_GPRWd_W_mux4 (
		.d0(DMOut_ME_dout_W), .d1(ALU_C_W), .d2(NPC_Laddr_W), .d3(`MUX_D_DEFAULT), 
		.s(GPRWd_W_Sel), .y(GPRWd_W)
	);

	mux8 #((31)-(0)+1) U_GPR_rd2_D_Bp_mux8 (
		.d0(GPR_rd2_D), .d1(DMOut_ME_dout_W), .d2(ALU_C_M), .d3(ALU_C_W), 
		.d4(NPC_Laddr_E), .d5(NPC_Laddr_M), .d6(NPC_Laddr_W), .d7(`MUX_D_DEFAULT), 
		.s(GPR_rd2_D_Bp_Sel), .y(GPR_rd2_D_Bp)
	);

	mux8 #((31)-(0)+1) U_GPR_rd2_E_Bp_mux8 (
		.d0(GPR_rd2_E), .d1(DMOut_ME_dout_W), .d2(ALU_C_M), .d3(ALU_C_W), 
		.d4(NPC_Laddr_M), .d5(NPC_Laddr_W), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT), 
		.s(GPR_rd2_E_Bp_Sel), .y(GPR_rd2_E_Bp)
	);

	mux8 #((31)-(0)+1) U_GPR_rd1_D_Bp_mux8 (
		.d0(GPR_rd1_D), .d1(DMOut_ME_dout_W), .d2(ALU_C_M), .d3(ALU_C_W), 
		.d4(NPC_Laddr_E), .d5(NPC_Laddr_M), .d6(NPC_Laddr_W), .d7(`MUX_D_DEFAULT), 
		.s(GPR_rd1_D_Bp_Sel), .y(GPR_rd1_D_Bp)
	);

	mux8 #((31)-(0)+1) U_GPR_rd1_E_Bp_mux8 (
		.d0(GPR_rd1_E), .d1(DMOut_ME_dout_W), .d2(ALU_C_M), .d3(ALU_C_W), 
		.d4(NPC_Laddr_M), .d5(NPC_Laddr_W), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT), 
		.s(GPR_rd1_E_Bp_Sel), .y(GPR_rd1_E_Bp)
	);

	/*****     Pipe_D     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			Instr_D <= 0;
		end
		else if ( pipeRegWr_F ) begin
			Instr_D <= Instr_F;
		end
	end // end always

	/*****     Pipe_E     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			GPR_rd2_E <= 0;
			NPC_Laddr_E <= 0;
			GPR_rd1_E <= 0;
			Instr_E <= 0;
		end
		else if ( pipeRegWr_D ) begin
			GPR_rd2_E <= GPR_rd2_D;
			NPC_Laddr_E <= NPC_Laddr_D;
			GPR_rd1_E <= GPR_rd1_D;
			Instr_E <= Instr_D;
		end
	end // end always

	/*****     Pipe_M     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			NPC_Laddr_M <= 0;
			ALU_C_M <= 0;
			Instr_M <= 0;
		end
		else if ( pipeRegWr_E ) begin
			NPC_Laddr_M <= NPC_Laddr_E;
			ALU_C_M <= ALU_C_E;
			Instr_M <= Instr_E;
		end
	end // end always

	/*****     Pipe_W     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			NPC_Laddr_W <= 0;
			DMOut_ME_dout_W <= 0;
			ALU_C_W <= 0;
			Instr_W <= 0;
		end
		else if ( pipeRegWr_M ) begin
			NPC_Laddr_W <= NPC_Laddr_M;
			DMOut_ME_dout_W <= DMOut_ME_dout_M;
			ALU_C_W <= ALU_C_M;
			Instr_W <= Instr_M;
		end
	end // end always

endmodule
