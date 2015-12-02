`include "arch_def.v"
`include "ctrl_encode_def.v"
`include "default_def.v"
`include "instruction_def.v"

module mips (
	clk, rst_n
);
	// input statement
	input clk;
	input rst_n;


	// input statement


	// wire statement
	wire [`IM_WIDTH-1:0] Instr_F;
	wire [`PC_WIDTH-1:0] PC_PC_F;
	wire [0:0] BrCmp_Comp_D;
	wire [`BrCmp_Op_WIDTH-1:0] BrCmp_Op;
	wire [31:0] GPR_rd0_D;
	wire [31:0] GPR_rd0_D_Bmux_dout_D;
	wire [31:0] GPR_rd1_D;
	wire [31:0] GPR_rd1_D_Bmux_dout_D;
	reg [`INSTR_WIDTH-1:0] Instr_D;
	wire [31:0] NPC_Laddr_D;
	wire [`PC_WIDTH-1:0] NPC_NPC_D;
	wire [`NPCOp_WIDTH-1:0] NPC_Op;
	wire [0:0] ALU_B_E_Pmux2_sel;
	wire [31:0] ALU_C_E;
	wire [`ALUOp_WIDTH-1:0] ALU_Op;
	wire [31:0] Ext_Imm32_E;
	wire [`ExtOp_WIDTH-1:0] Ext_Op;
	reg [31:0] GPR_rd0_E;
	reg [31:0] GPR_rd1_E;
	reg [`INSTR_WIDTH-1:0] Instr_E;
	reg [31:0] NPC_Laddr_E;
	reg [31:0] ALU_C_M;
	wire [`DMIn_BE_WIDTH-1:0] DMIn_BE_BE_M;
	wire [`DMIn_BEOp_WIDTH-1:0] DMIn_BE_Op;
	wire [`DM_WIDTH-1:0] DMIn_BE_dout_M;
	wire [`DMOut_MEOp_WIDTH-1:0] DMOut_ME_Op;
	wire [`DM_WIDTH-1:0] DMOut_ME_dout_M;
	wire [`DM_WIDTH-1:0] DM_dout_M;
	wire [0:0] DM_wr;
	wire [`DM_WIDTH-1:0] GPR_rd0_M;
	reg [`INSTR_WIDTH-1:0] Instr_M;
	reg [31:0] NPC_Laddr_M;
	reg [31:0] ALU_C_W;
	reg [`DM_WIDTH-1:0] DMOut_ME_dout_W;
	wire [1:0] GPR_waddr_W_Pmux4_sel;
	wire [1:0] GPR_wd_W_Pmux4_sel;
	wire [0:0] GPR_wr;
	reg [`INSTR_WIDTH-1:0] Instr_W;
	reg [31:0] NPC_Laddr_W;




	// Instance Module
	DM I_DM(
		.BE(DMIn_BE_BE_M),
		.din(DMIn_BE_dout_M),
		.dout(DM_dout_M),
		.addr(ALU_C_M),
		.clk(clk),
		.wr(DM_wr)
	);

	BrCmp I_BrCmp(
		.A(GPR_rd0_D_Bmux_dout_D),
		.Comp(BrCmp_Comp_D),
		.B(GPR_rd1_D_Bmux_dout_D),
		.Op(BrCmp_Op)
	);

	NPC I_NPC(
		.Rs(0000),
		.Comp(BrCmp_Comp_D),
		.NPC(NPC_NPC_D),
		.PC(PC_PC_F),
		.Imm26(Instr_D[25:0]),
		.Laddr(NPC_Laddr_D),
		.Op(NPC_Op)
	);

	DMIn_BE I_DMIn_BE(
		.BE(DMIn_BE_BE_M),
		.din(GPR_rd0_M),
		.dout(DMIn_BE_dout_M),
		.addr(ALU_C_M),
		.Op(DMIn_BE_Op)
	);

	PC I_PC(
		.PC(PC_PC_F),
		.rst_n(rst_n),
		.wr(~clr_D),
		.NPC(NPC_NPC_D),
		.clk(clk)
	);

	Ext I_Ext(
		.Op(Ext_Op),
		.Imm32(Ext_Imm32_E),
		.Imm16(Instr_E[15:0])
	);

	DMOut_ME I_DMOut_ME(
		.din(DM_dout_M),
		.dout(DMOut_ME_dout_M),
		.addr(ALU_C_M),
		.Op(DMOut_ME_Op)
	);

	IM I_IM(
		.dout(Instr_F),
		.addr(PC_PC_F)
	);

	ALU I_ALU(
		.A(GPR_rd0_E_Bmux_dout_E),
		.C(ALU_C_E),
		.B(ALU_B_E_Pmux2_dout),
		.Op(ALU_Op)
	);

	GPR I_GPR(
		.rst_n(rst_n),
		.raddr1(Instr_D[20:16]),
		.raddr0(Instr_D[25:21]),
		.rd1(GPR_rd1_D),
		.rd0(GPR_rd0_D),
		.wd(GPR_wd_W_Pmux4_dout),
		.clk(clk),
		.waddr(GPR_waddr_W_Pmux4_dout),
		.wr(GPR_wr)
	);





	// Instance Port Mux
	mux2 #(32) ALU_B_E_Pmux2(
		.sel(ALU_B_E_Pmux2_sel),
		.dout(ALU_B_E_Pmux2_dout),
		.din1(Ext_Imm32_E),
		.din0(GPR_rd1_E_Bmux_dout_E)
	);

	mux4 #(5) GPR_waddr_W_Pmux4(
		.dout(GPR_waddr_W_Pmux4_dout),
		.din3(0000),
		.din2(Instr_W[20:16]),
		.din1(32'd31),
		.din0(Instr_W[15:11]),
		.sel(GPR_waddr_W_Pmux4_sel)
	);

	mux4 #(32) GPR_wd_W_Pmux4(
		.dout(GPR_wd_W_Pmux4_dout),
		.din3(0000),
		.din2(DMOut_ME_dout_W),
		.din1(ALU_C_W),
		.din0(NPC_Laddr_W),
		.sel(GPR_wd_W_Pmux4_sel)
	);





	// Instance Bypass Mux
	mux8 #(32) GPR_rd0_D_Bmux(
		.dout(GPR_rd0_D_Bmux_dout),
		.din7(0000),
		.din6(NPC_Laddr_W),
		.din5(ALU_C_W),
		.din4(ALU_C_M),
		.din3(NPC_Laddr_E),
		.din2(DMOut_ME_dout_W),
		.din1(NPC_Laddr_M),
		.din0(GPR_rd0_D),
		.sel(GPR_rd0_D_Bmux_sel)
	);

	mux4 #(32) GPR_rd0_E_Bmux(
		.dout(GPR_rd0_E_Bmux_dout),
		.din3(0000),
		.din2(ALU_C_M),
		.din1(GPR_rd0_E),
		.din0(DMOut_ME_dout_W),
		.sel(GPR_rd0_E_Bmux_sel)
	);

	mux8 #(32) GPR_rd1_D_Bmux(
		.dout(GPR_rd1_D_Bmux_dout),
		.din7(0000),
		.din6(NPC_Laddr_W),
		.din5(ALU_C_W),
		.din4(NPC_Laddr_E),
		.din3(ALU_C_M),
		.din2(GPR_rd1_D),
		.din1(NPC_Laddr_M),
		.din0(DMOut_ME_dout_W),
		.sel(GPR_rd1_D_Bmux_sel)
	);

	mux4 #(32) GPR_rd1_E_Bmux(
		.dout(GPR_rd1_E_Bmux_dout),
		.din3(0000),
		.din2(ALU_C_M),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd1_E),
		.sel(GPR_rd1_E_Bmux_sel)
	);





	// Instance Module
	control I_control(
		.clk(clk),
		.rst_n(rst_n),
		.Instr_D(Instr_D),
		.Instr_E(Instr_E),
		.Instr_M(Instr_M),
		.Instr_W(Instr_W),
		.clr_D(clr_D),
		.clr_E(clr_E),
		.clr_M(clr_M),
		.clr_W(clr_W),
		.GPR_rd0_D_Bmux_sel(GPR_rd0_D_Bmux_sel),
		.GPR_rd0_E_Bmux_sel(GPR_rd0_E_Bmux_sel),
		.GPR_rd1_D_Bmux_sel(GPR_rd1_D_Bmux_sel),
		.GPR_rd1_E_Bmux_sel(GPR_rd1_E_Bmux_sel),
		.stall(stall),
		.BrCmp_Op_D(BrCmp_Op_D),
		.NPC_Op_D(NPC_Op_D),
		.Ext_Op_E(Ext_Op_E),
		.ALU_Op_E(ALU_Op_E),
		.DM_wr_M(DM_wr_M),
		.DMOut_ME_Op_M(DMOut_ME_Op_M),
		.DMIn_BE_Op_M(DMIn_BE_Op_M),
		.GPR_wr_W(GPR_wr_W)
	);





	// Pipe Register
	/*****     Pipe_F     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			Instr_D <= 0;
		end
		else if ( !clr_D )begin
			Instr_D <= Instr_F;
		end
	end // end always

	/*****     Pipe_D     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			Instr_E <= 0;
			GPR_rd1_E <= 0;
			GPR_rd0_E <= 0;
			NPC_Laddr_E <= 0;
		end
		else if ( !clr_D )begin
			Instr_E <= Instr_D;
			GPR_rd1_E <= GPR_rd1_D_Bmux_dout_D;
			GPR_rd0_E <= GPR_rd0_D_Bmux_dout_D;
			NPC_Laddr_E <= NPC_Laddr_D;
		end
	end // end always

	/*****     Pipe_E     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n || clr_D ) begin
			Instr_M <= 0;
			ALU_C_M <= 0;
			NPC_Laddr_M <= 0;
		end
		else begin
			Instr_M <= Instr_E;
			ALU_C_M <= ALU_C_E;
			NPC_Laddr_M <= NPC_Laddr_E;
		end
	end // end always

	/*****     Pipe_M     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n || clr_E ) begin
			DMOut_ME_dout_W <= 0;
			Instr_W <= 0;
			NPC_Laddr_W <= 0;
			ALU_C_W <= 0;
		end
		else begin
			DMOut_ME_dout_W <= DMOut_ME_dout_M;
			Instr_W <= Instr_M;
			NPC_Laddr_W <= NPC_Laddr_M;
			ALU_C_W <= ALU_C_M;
		end
	end // end always





endmodule

