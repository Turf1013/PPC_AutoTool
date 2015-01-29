`include "arch_def.v"
`include "cu_def.v"
`include "default_def.v"
`include "instruction_def.v"

module PPC (

);

	/*****     wire Statement HDL Code     *****/
	wire [0:`INSTR_WIDTH] Instr_F;
	wire [0:`CR_WIDTH-1] CRIn_Mov_CRWd_M;
	wire [0:`CR_WIDTH-1] CRIn_ALU_CRWd_M;
	wire [0:`CR_WIDTH-1] CRIn_Cmp_CRWd_M;
	wire [0:`CR_WIDTH-1] CRIn_CR0_CRWd_M;
	wire [0:`DM_WIDTH-1] DMIn_BE_dout_M;
	wire [0:`DM_WIDTH-1] DM_dout_M;
	wire [0:`DM_DEPTH-1] DM_DEPTH_M;
	wire [0:`DMBE_WIDTH-1] DMIn_BE_DMBE_M;
	wire  BA_E;
	wire  CR_ALU_C_E;
	wire  BB_E;
	wire [0:`SPR_DEPTH-1] SPR_raddr_D;
	wire [0:`SPR_DEPTH-1] SPR_waddr_W;
	wire [0:`SPR_WIDTH-1] SPRWd_W;
	wire [0:`SPR_WIDTH-1] SPR_SPR_D;
	wire [0:`SPR_WIDTH-1] SPR_LR_D;
	wire [0:`DM_WIDTH-1] DMOut_ME_dout_M;
	wire [0:`MSR_WIDTH-1] MSR_MSR_D;
	wire  AA_D;
	wire [0:`LR_WIDTH-1] NPC_LRWd_D;
	wire [0:`IMM24_WIDTH-1] Imm24_D;
	wire [0:`PC_WIDTH-1] NPC_NPC_D;
	wire [0:`PC_WIDTH-1] PC_PC_F;
	wire [0:`CR_WIDTH-1] CR_CR_D;
	wire [0:`CTR_WIDTH-1] NPC_CTRWd_D;
	wire [0:31] Ext_Imm32_E;
	wire [0:15] Imm16_E;
	wire [0:`IM_WIDTH-1] IM_dout_F;
	wire [0:`XER_WIDTH-1] XERIn_ALU_XERWd_M;
	wire [0:`CR_DEPTH-1] CR_addr_W;
	wire [0:`CR_Hsel_WIDTH-1] FXM_W;
	wire [0:`CR_WIDTH-1] CRWd_W;
	wire [0:`ARCH_WIDTH-1] ALU_A_E;
	wire [0:3] ALU_CR0_E;
	wire [0:`ARCH_WIDTH-1] ALU_B_E;
	wire [0:`ROTL_WIDTH-1] MB_E;
	wire [0:`ARCH_WIDTH-1] ALU_C_E;
	wire  ALU_SO_E;
	wire [0:`ROTL_WIDTH-1] ME_E;
	wire  XER_CA_E;
	wire  ALU_OV_E;
	wire  XER_SO_E;
	wire  ALU_CA_E;
	wire [0:`ROTL_WIDTH-1] ALU_rotn_E;
	wire [0:`GPR_WIDTH-1] GPR_rd1_D;
	wire [0:`GPR_DEPTH-1] GPR_waddr1_W;
	wire [0:`GPR_WIDTH-1] GPR_rd3_D;
	wire [0:`GPR_WIDTH-1] GPR_rd2_D;
	wire [0:`GPR_WIDTH-1] GPRWd1_W;
	wire [0:3] SPR_raddr_D_Sel;
	wire [0:`NPCOp_WIDTH] NPCOp_D;
	wire [0:`ExtOp_WIDTH] ExtOp_E;
	wire [0:`ALUOp_WIDTH] ALUOp_E;
	wire [0:`CR_ALU_Op_WIDTH] CR_ALU_Op_E;
	wire [0:1] ALU_rotn_E_Sel;
	wire [0:7] ALU_B_E_Sel;
	wire [0:3] ALU_A_E_Sel;
	wire XERIn_OVWr_M;
	wire DMWr_M;
	wire [0:`DMOut_MEOp_WIDTH] DMOut_MEOp_M;
	wire [0:`DMIn_BEOp_WIDTH] DMIn_BEOp_M;
	wire XERIn_CAWr_M;
	wire [0:3] SPR_waddr_W_Sel;
	wire [0:7] GPRWd1_W_Sel;
	wire MSRWr_W;
	wire GPRWr_W;
	wire [0:`CR_BEOp_WIDTH] CR_BEOp_W;
	wire SPRWr_W;
	wire [0:7] CRWd_W_Sel;
	wire CRWr_W;
	wire [0:3] CR_addr_W_Sel;
	wire SPR_LRWr_W;
	wire [0:3] SPRWd_W_Sel;
	wire [0:1] GPR_waddr1_W_Sel;
	wire [0:4] SPR_SPR_D_Sel;
	wire [0:4] CR_CR_D_Sel;
	wire [0:4] SPR_SPR_E_Sel;
	wire [0:4] CR_CR_E_Sel;
	wire [0:4] GPR_rd2_E_Sel;
	wire [0:4] GPR_rd3_E_Sel;
	wire [0:4] GPR_rd1_E_Sel;
	wire [0:3] SPR_SPR_M_Sel;
	wire [0:3] CR_CR_M_Sel;
	wire [0:3] GPR_rd1_M_Sel;

	/*****     reg Statement HDL Code     *****/
	reg [0:`INSTR_WIDTH] Instr_D;
	reg [0:`MSR_WIDTH-1] MSR_MSR_E;
	reg [0:`INSTR_WIDTH] Instr_E;
	reg [0:`SPR_WIDTH-1] SPR_SPR_E;
	reg [0:`LR_WIDTH-1] NPC_LRWd_E;
	reg [0:`CR_WIDTH-1] CR_CR_E;
	reg [0:`GPR_WIDTH-1] GPR_rd2_E;
	reg [0:`GPR_WIDTH-1] GPR_rd3_E;
	reg [0:`GPR_WIDTH-1] GPR_rd1_E;
	reg [0:`CTR_WIDTH-1] NPC_CTRWd_E;
	reg  CR_ALU_C_M;
	reg [0:`MSR_WIDTH-1] MSR_MSR_M;
	reg [0:`INSTR_WIDTH] Instr_M;
	reg [0:`SPR_WIDTH-1] SPR_SPR_M;
	reg [0:`LR_WIDTH-1] NPC_LRWd_M;
	reg  ALU_CA_M;
	reg [0:`CR_WIDTH-1] CR_CR_M;
	reg [0:3] ALU_CR0_M;
	reg  ALU_SO_M;
	reg  ALU_OV_M;
	reg [0:`ARCH_WIDTH-1] ALU_C_M;
	reg [0:`GPR_WIDTH-1] GPR_rd1_M;
	reg [0:`CTR_WIDTH-1] NPC_CTRWd_M;
	reg [0:`XER_WIDTH-1] XERIn_ALU_XERWd_W;
	reg [0:`GPR_WIDTH-1] GPR_rd1_W;
	reg [0:`MSR_WIDTH-1] MSR_MSR_W;
	reg [0:`INSTR_WIDTH] Instr_W;
	reg [0:`SPR_WIDTH-1] SPR_SPR_W;
	reg [0:`LR_WIDTH-1] NPC_LRWd_W;
	reg [0:`DM_WIDTH-1] DMOut_ME_dout_W;
	reg [0:`CR_WIDTH-1] CR_CR_W;
	reg [0:`ARCH_WIDTH-1] ALU_C_W;
	reg [0:`CR_WIDTH-1] CRIn_ALU_CRWd_W;
	reg [0:`CR_WIDTH-1] CRIn_Mov_CRWd_W;
	reg [0:`CR_WIDTH-1] CRIn_CR0_CRWd_W;
	reg [0:`CR_WIDTH-1] CRIn_Cmp_CRWd_W;
	reg [0:`CTR_WIDTH-1] NPC_CTRWd_W;


	/*****     Assign HDL Code     *****/

	assign Rc_W = Instr_W[31];
	assign SH_E = Instr_E[16:20];
	assign Imm16_E = Instr_E[16:31];
	assign Imm24_D = Instr_D[6:29];
	assign LK_W = Instr_W[31];
	assign ME_E = Instr_E[26:30];
	assign FXM_W = Instr_W[12:19];
	assign AA_D = Instr_D[30];
	assign MB_E = Instr_E[21:25];
	assign OE_W = Instr_W[21];
	assign OE_M = Instr_M[21];

	/*****     Utilize General Module HDL Code     *****/
	CRIn U_CRIn (
		.CR_ALU_C(CR_ALU_C_M), .BFA(Instr_M[11:13]), .Mov_CRWd(CRIn_Mov_CRWd_M), .ALU_CRWd(CRIn_ALU_CRWd_M), 
		.BF(Instr_M[6:8]), .Cmp_CRWd(CRIn_Cmp_CRWd_M), .BT(Instr_M[11:15]), .ALU_CR0(ALU_CR0_M), 
		.CR(CR_CR_M), .CR0_CRWd(CRIn_CR0_CRWd_M)
	);

	DM U_DM (
		.din(DMIn_BE_dout_M), .dout(DM_dout_M), .addr(ALU_C_M[30-`DM_DEPTH:29]), .clk(clk), 
		.DMWr(DMWr_M), .DMBE(DMIn_BE_DMBE_M)
	);

	CR_ALU U_CR_ALU (
		.A(CR_CR_E[BA_E]), .C(CR_ALU_C_E), .B(CR_CR_E[BB_E]), .Op(CR_ALU_Op_E)
	);

	SPR U_SPR (
		.rst_n(rst_n), .raddr(SPR_raddr_D), .waddr(SPR_waddr_W), .SPRWd(SPRWd_W), 
		.clk(clk), .LRWr(SPRLRWr_W), .SPR(SPR_SPR_D), .SPRWr(SPRWr_W), 
		.LR(SPR_LR_D), .LRWd(NPC_LRWd_W)
	);

	DMOut_ME U_DMOut_ME (
		.laddr(ALU_C_M[30:31]), .din(DM_dout_M), .DMOut_MEOp(DMOut_MEOp_M), .dout(DMOut_ME_dout_M)
	);

	MSR U_MSR (
		.MSRWr(MSRWr_W), .rst_n(rst_n), .MSR(MSR_MSR_D), .MSRWd(GPR_rd1_W), 
		.clk(clk)
	);

	NPC U_NPC (
		.AA(AA_D), .CTR(SPR_SPR_D), .NPC_LRWd(NPC_LRWd_D), .Imm24(Imm24_D), 
		.NPCOp(NPCOp_D), .NPC(NPC_NPC_D), .PC(PC_PC_F), .LR(SPR_LR_D), 
		.CR(CR_CR_D), .NPC_CTRWd(NPC_CTRWd_D)
	);

	DMIn_BE U_DMIn_BE (
		.laddr(ALU_C_M[30:31]), .dout(DMIn_BE_dout_M), .din(GPR_rd1_M), .DMIn_BEOp(DMIn_BEOp_M), 
		.DMBE(DMIn_BE_DMBE_M)
	);

	PC U_PC (
		.PC(PC_PC_F), .PCWr(PCWr_D), .rst_n(rst_n), .NPC(NPC_NPC_D), 
		.clk(clk)
	);

	Ext U_Ext (
		.ExtOp(ExtOp_E), .Imm(Imm16_E), .Imm32(Ext_Imm32_E), .Imm16(Imm16_E)
	);

	IM U_IM (
		.dout(IM_dout_F), .addr(PC_PC_F)
	);

	XERIn U_XERIn (
		.OVWr(XERIn_OVWr_M), .ALU_SO(ALU_SO_M), .ALU_OV(ALU_OV_M), .ALU_CA(ALU_CA_M), 
		.XER(SPR_SPR_M), .CAWr(XERIn_CAWr_M), .ALU_XERWd(XERIn_ALU_XERWd_M)
	);

	CR U_CR (
		.rst_n(rst_n), .CRWr(CRWr_W), .addr(CR_addr_W), .clk(clk), 
		.FXM(FXM_W), .CRWd(CRWd_W), .CR(CR_CR_D), .CR_BEOp(CR_BEOp_W)
	);

	ALU U_ALU (
		.A(ALU_A_E), .ALUOp(ALUOp_E), .CR0(ALU_CR0_E), .B(ALU_B_E), 
		.MB(MB_E), .C(ALU_C_E), .ALU_SO(ALU_SO_E), .ME(ME_E), 
		.XER_CA(SPR_SPR_E[`XER_CA]), .ALU_OV(ALU_OV_E), .XER_SO(SPR_SPR_E[`XER_SO]), .ALU_CA(ALU_CA_E), 
		.rotn(ALU_rotn_E)
	);

	GPR U_GPR (
		.raddr3(Instr_D[16:20]), .raddr2(Instr_D[11:15]), .raddr1(Instr_D[6:10]), .rd1(GPR_rd1_D), 
		.waddr1(GPR_waddr1_W), .rd3(GPR_rd3_D), .rd2(GPR_rd2_D), .clk(clk), 
		.GPRWr(GPRWr_W), .GPRWd1(GPRWd1_W), .rst_n(rst_n)
	);

	control U_control (
		.SPR_raddr_D_Sel(SPR_raddr_D_Sel), .NPCOp_D(NPCOp_D), .ExtOp_E(ExtOp_E), .ALUOp_E(ALUOp_E), 
		.CR_ALU_Op_E(CR_ALU_Op_E), .ALU_rotn_E_Sel(ALU_rotn_E_Sel), .ALU_B_E_Sel(ALU_B_E_Sel), .ALU_A_E_Sel(ALU_A_E_Sel), 
		.XERIn_OVWr_M(XERIn_OVWr_M), .DMWr_M(DMWr_M), .DMOut_MEOp_M(DMOut_MEOp_M), .DMIn_BEOp_M(DMIn_BEOp_M), 
		.XERIn_CAWr_M(XERIn_CAWr_M), .SPR_waddr_W_Sel(SPR_waddr_W_Sel), .GPRWd1_W_Sel(GPRWd1_W_Sel), .MSRWr_W(MSRWr_W), 
		.GPRWr_W(GPRWr_W), .CR_BEOp_W(CR_BEOp_W), .SPRWr_W(SPRWr_W), .CRWd_W_Sel(CRWd_W_Sel), 
		.CRWr_W(CRWr_W), .CR_addr_W_Sel(CR_addr_W_Sel), .SPR_LRWr_W(SPR_LRWr_W), .SPRWd_W_Sel(SPRWd_W_Sel), 
		.GPR_waddr1_W_Sel(GPR_waddr1_W_Sel), .SPR_SPR_D_Sel(SPR_SPR_D_Sel), .CR_CR_D_Sel(CR_CR_D_Sel), .SPR_SPR_E_Sel(SPR_SPR_E_Sel), 
		.CR_CR_E_Sel(CR_CR_E_Sel), .GPR_rd2_E_Sel(GPR_rd2_E_Sel), .GPR_rd3_E_Sel(GPR_rd3_E_Sel), .GPR_rd1_E_Sel(GPR_rd1_E_Sel), 
		.SPR_SPR_M_Sel(SPR_SPR_M_Sel), .CR_CR_M_Sel(CR_CR_M_Sel), .GPR_rd1_M_Sel(GPR_rd1_M_Sel), .pipeRegWr_F(pipeRegWr_F), 
		.pipeRegWr_D(pipeRegWr_D), .pipeRegWr_E(pipeRegWr_E), .pipeRegWr_M(pipeRegWr_M), .PCWr_D(PCWr_D), 
		.Instr_F(Instr_F), .Instr_D(Instr_D), .Instr_E(Instr_E), .Instr_M(Instr_M), 
		.Instr_W(Instr_W), .clk(clk), .rst_n(rst_n)
	);

	/*****     NORMAL MUX HDL Code     *****/
	/******    D    ******/
	mux4 #() U_SPR_raddr_D_mux4 (
		.d0(`CTR_SPRN), .d1(`XER_SPRN), .d2({Instr_D[16:20],Instr_D[11:15]}), .d3(`MUX_D_DEFAULT), 
		.s(SPR_raddr_D_Sel), .y(SPR_raddr_D)
	);

	/******    E    ******/
	mux4 #() U_ALU_A_E_mux4 (
		.d0(GPR_rd2_E), .d1(GPR_rd1_E), .d2(32'd0), .d3(`MUX_D_DEFAULT), 
		.s(ALU_A_E_Sel), .y(ALU_A_E)
	);

	mux2 #() U_ALU_rotn_E_mux2 (
		.d0(SH_E), .d1(GPR_rd3_E[27:31]), 
		.s(ALU_rotn_E_Sel), .y(ALU_rotn_E)
	);

	mux8 #() U_ALU_B_E_mux8 (
		.d0(GPR_rd2_E), .d1(GPR_rd3_E), .d2(Ext_Imm32_E), .d3(32'h0), 
		.d4(32'hffff_ffff), .d5(`MUX_D_DEFAULT), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT), 
		.s(ALU_B_E_Sel), .y(ALU_B_E)
	);

	/******    W    ******/
	mux4 #() U_SPR_waddr_W_mux4 (
		.d0(`LR_SPRN), .d1(`CTR_SPRN), .d2(`XER_SPRN), .d3({Instr_W[16:20],Instr_W[11:15]}), 
		.s(SPR_waddr_W_Sel), .y(SPR_waddr_W)
	);

	mux8 #() U_GPRWd1_W_mux8 (
		.d0(SPR_SPR_W), .d1(DMOut_ME_dout_W), .d2(ALU_C_W), .d3(MSR_MSR_W), 
		.d4(CR_CR_W), .d5(`MUX_D_DEFAULT), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT), 
		.s(GPRWd1_W_Sel), .y(GPRWd1_W)
	);

	mux4 #() U_CR_addr_W_mux4 (
		.d0(5'd0), .d1({Instr_W[6:8],2'b00}), .d2(Instr_W[11:15]), .d3(`MUX_D_DEFAULT), 
		.s(CR_addr_W_Sel), .y(CR_addr_W)
	);

	mux8 #() U_CRWd_W_mux8 (
		.d0(CRIn_ALU_CRWd_W), .d1(CRIn_Mov_CRWd_W), .d2(CRIn_CR0_CRWd_W), .d3(CRIn_Cmp_CRWd_W), 
		.d4(GPR_rd1_W), .d5(`MUX_D_DEFAULT), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT), 
		.s(CRWd_W_Sel), .y(CRWd_W)
	);

	mux4 #() U_SPRWd_W_mux4 (
		.d0(XERIn_ALU_XERWd_W), .d1(NPC_CTRWd_W), .d2(GPR_rd1_W), .d3(NPC_LRWd_W), 
		.s(SPRWd_W_Sel), .y(SPRWd_W)
	);

	mux2 #() U_GPR_waddr1_W_mux2 (
		.d0(Instr_W[6:10]), .d1(Instr_W[11:15]), 
		.s(GPR_waddr1_W_Sel), .y(GPR_waddr1_W)
	);


	/*****     Bypass MUX HDL Code     *****/
	mux16 #() U_SPR_SPR_D_mux16 (
		.d0(SPR_SPR_D), .d1(NPC_LRWd_E), .d2(NPC_LRWd_M), .d3(NPC_LRWd_W), 
		.d4(NPC_CTRWd_E), .d5(NPC_CTRWd_M), .d6(NPC_CTRWd_W), .d7(XERIn_ALU_XERWd_M), 
		.d8(XERIn_ALU_XERWd_W), .d9(GPR_rd1_E), .d10(GPR_rd1_M), .d11(GPR_rd1_W), 
		.d12(NPC_LRWd_E), .d13(NPC_LRWd_M), .d14(NPC_LRWd_W), .d15(`MUX_D_DEFAULT), 
		.s(SPR_SPR_D_Sel), .y(SPR_SPR_D_Bp)
	);

	mux16 #() U_CR_CR_D_mux16 (
		.d0(CR_CR_D), .d1(CRIn_Mov_CRWd_M), .d2(CRIn_Mov_CRWd_W), .d3(CRIn_ALU_CRWd_M), 
		.d4(CRIn_ALU_CRWd_W), .d5(CRIn_CR0_CRWd_M), .d6(CRIn_CR0_CRWd_W), .d7(GPR_rd1_E), 
		.d8(GPR_rd1_M), .d9(GPR_rd1_W), .d10(CRIn_Cmp_CRWd_M), .d11(CRIn_Cmp_CRWd_W), .d12(`MUX_D_DEFAULT), .d13(`MUX_D_DEFAULT), .d14(`MUX_D_DEFAULT), .d15(`MUX_D_DEFAULT), 
		.s(CR_CR_D_Sel), .y(CR_CR_D_Bp)
	);

	mux16 #() U_SPR_SPR_E_mux16 (
		.d0(SPR_SPR_E), .d1(NPC_LRWd_M), .d2(NPC_LRWd_W), .d3(NPC_CTRWd_M), 
		.d4(NPC_CTRWd_W), .d5(XERIn_ALU_XERWd_M), .d6(XERIn_ALU_XERWd_W), .d7(GPR_rd1_M), 
		.d8(GPR_rd1_W), .d9(NPC_LRWd_M), .d10(NPC_LRWd_W), .d11(`MUX_D_DEFAULT), .d12(`MUX_D_DEFAULT), .d13(`MUX_D_DEFAULT), .d14(`MUX_D_DEFAULT), .d15(`MUX_D_DEFAULT), 
		.s(SPR_SPR_E_Sel), .y(SPR_SPR_E_Bp)
	);

	mux16 #() U_CR_CR_E_mux16 (
		.d0(CR_CR_E), .d1(CRIn_Mov_CRWd_M), .d2(CRIn_Mov_CRWd_W), .d3(CRIn_ALU_CRWd_M), 
		.d4(CRIn_ALU_CRWd_W), .d5(CRIn_CR0_CRWd_M), .d6(CRIn_CR0_CRWd_W), .d7(GPR_rd1_M), 
		.d8(GPR_rd1_W), .d9(CRIn_Cmp_CRWd_M), .d10(CRIn_Cmp_CRWd_W), .d11(`MUX_D_DEFAULT), .d12(`MUX_D_DEFAULT), .d13(`MUX_D_DEFAULT), .d14(`MUX_D_DEFAULT), .d15(`MUX_D_DEFAULT), 
		.s(CR_CR_E_Sel), .y(CR_CR_E_Bp)
	);

	mux16 #() U_GPR_rd2_E_mux16 (
		.d0(GPR_rd2_E), .d1(CR_CR_M), .d2(CR_CR_W), .d3(MSR_MSR_M), 
		.d4(MSR_MSR_W), .d5(DMOut_ME_dout_W), .d6(SPR_SPR_M), .d7(SPR_SPR_W), 
		.d8(ALU_C_M), .d9(ALU_C_W), .d10(`MUX_D_DEFAULT), .d11(`MUX_D_DEFAULT), .d12(`MUX_D_DEFAULT), .d13(`MUX_D_DEFAULT), .d14(`MUX_D_DEFAULT), .d15(`MUX_D_DEFAULT), 
		.s(GPR_rd2_E_Sel), .y(GPR_rd2_E_Bp)
	);

	mux16 #() U_GPR_rd3_E_mux16 (
		.d0(GPR_rd3_E), .d1(CR_CR_M), .d2(CR_CR_W), .d3(MSR_MSR_M), 
		.d4(MSR_MSR_W), .d5(DMOut_ME_dout_W), .d6(SPR_SPR_M), .d7(SPR_SPR_W), 
		.d8(ALU_C_M), .d9(ALU_C_W), .d10(`MUX_D_DEFAULT), .d11(`MUX_D_DEFAULT), .d12(`MUX_D_DEFAULT), .d13(`MUX_D_DEFAULT), .d14(`MUX_D_DEFAULT), .d15(`MUX_D_DEFAULT), 
		.s(GPR_rd3_E_Sel), .y(GPR_rd3_E_Bp)
	);

	mux16 #() U_GPR_rd1_E_mux16 (
		.d0(GPR_rd1_E), .d1(CR_CR_M), .d2(CR_CR_W), .d3(MSR_MSR_M), 
		.d4(MSR_MSR_W), .d5(DMOut_ME_dout_W), .d6(SPR_SPR_M), .d7(SPR_SPR_W), 
		.d8(ALU_C_M), .d9(ALU_C_W), .d10(`MUX_D_DEFAULT), .d11(`MUX_D_DEFAULT), .d12(`MUX_D_DEFAULT), .d13(`MUX_D_DEFAULT), .d14(`MUX_D_DEFAULT), .d15(`MUX_D_DEFAULT), 
		.s(GPR_rd1_E_Sel), .y(GPR_rd1_E_Bp)
	);

	mux8 #() U_SPR_SPR_M_mux8 (
		.d0(SPR_SPR_M), .d1(NPC_LRWd_W), .d2(NPC_CTRWd_W), .d3(XERIn_ALU_XERWd_W), 
		.d4(GPR_rd1_W), .d5(NPC_LRWd_W), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT), 
		.s(SPR_SPR_M_Sel), .y(SPR_SPR_M_Bp)
	);

	mux8 #() U_CR_CR_M_mux8 (
		.d0(CR_CR_M), .d1(CRIn_Mov_CRWd_W), .d2(CRIn_ALU_CRWd_W), .d3(CRIn_CR0_CRWd_W), 
		.d4(GPR_rd1_W), .d5(CRIn_Cmp_CRWd_W), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT), 
		.s(CR_CR_M_Sel), .y(CR_CR_M_Bp)
	);

	mux8 #() U_GPR_rd1_M_mux8 (
		.d0(GPR_rd1_M), .d1(CR_CR_W), .d2(MSR_MSR_W), .d3(DMOut_ME_dout_W), 
		.d4(SPR_SPR_W), .d5(ALU_C_W), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT), 
		.s(GPR_rd1_M_Sel), .y(GPR_rd1_M_Bp)
	);


	/*****     PipeReg HDL Code     *****/
	/*****    D    *****/

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			Instr_D <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_F ) begin
			Instr_D <= Instr_F;
		end
	end // end always

	/*****    E    *****/

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			MSR_MSR_E <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_D ) begin
			MSR_MSR_E <= MSR_MSR_D;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			Instr_E <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_D ) begin
			Instr_E <= Instr_D;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			SPR_SPR_E <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_D ) begin
			SPR_SPR_E <= SPR_SPR_D;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			NPC_LRWd_E <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_D ) begin
			NPC_LRWd_E <= NPC_LRWd_D;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			CR_CR_E <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_D ) begin
			CR_CR_E <= CR_CR_D;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			GPR_rd2_E <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_D ) begin
			GPR_rd2_E <= GPR_rd2_D;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			GPR_rd3_E <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_D ) begin
			GPR_rd3_E <= GPR_rd3_D;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			GPR_rd1_E <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_D ) begin
			GPR_rd1_E <= GPR_rd1_D;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			NPC_CTRWd_E <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_D ) begin
			NPC_CTRWd_E <= NPC_CTRWd_D;
		end
	end // end always

	/*****    M    *****/

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			CR_ALU_C_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			CR_ALU_C_M <= CR_ALU_C_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			MSR_MSR_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			MSR_MSR_M <= MSR_MSR_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			Instr_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			Instr_M <= Instr_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			SPR_SPR_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			SPR_SPR_M <= SPR_SPR_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			NPC_LRWd_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			NPC_LRWd_M <= NPC_LRWd_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			ALU_CA_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			ALU_CA_M <= ALU_CA_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			CR_CR_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			CR_CR_M <= CR_CR_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			ALU_CR0_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			ALU_CR0_M <= ALU_CR0_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			ALU_SO_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			ALU_SO_M <= ALU_SO_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			ALU_OV_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			ALU_OV_M <= ALU_OV_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			ALU_C_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			ALU_C_M <= ALU_C_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			GPR_rd1_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			GPR_rd1_M <= GPR_rd1_E;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			NPC_CTRWd_M <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_E ) begin
			NPC_CTRWd_M <= NPC_CTRWd_E;
		end
	end // end always

	/*****    W    *****/

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			XERIn_ALU_XERWd_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			XERIn_ALU_XERWd_W <= XERIn_ALU_XERWd_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			GPR_rd1_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			GPR_rd1_W <= GPR_rd1_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			MSR_MSR_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			MSR_MSR_W <= MSR_MSR_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			Instr_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			Instr_W <= Instr_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			SPR_SPR_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			SPR_SPR_W <= SPR_SPR_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			NPC_LRWd_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			NPC_LRWd_W <= NPC_LRWd_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			DMOut_ME_dout_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			DMOut_ME_dout_W <= DMOut_ME_dout_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			CR_CR_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			CR_CR_W <= CR_CR_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			ALU_C_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			ALU_C_W <= ALU_C_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			CRIn_ALU_CRWd_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			CRIn_ALU_CRWd_W <= CRIn_ALU_CRWd_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			CRIn_Mov_CRWd_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			CRIn_Mov_CRWd_W <= CRIn_Mov_CRWd_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			CRIn_CR0_CRWd_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			CRIn_CR0_CRWd_W <= CRIn_CR0_CRWd_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			CRIn_Cmp_CRWd_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			CRIn_Cmp_CRWd_W <= CRIn_Cmp_CRWd_M;
		end
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			NPC_CTRWd_W <= `RST_N_DEFAULT;
		end
		else if ( pipeRegWr_M ) begin
			NPC_CTRWd_W <= NPC_CTRWd_M;
		end
	end // end always

endmodule
