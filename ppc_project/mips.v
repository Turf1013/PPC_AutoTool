`include "arch_def.v"
`include "ctrl_encode_def.v"
`include "instruction_def.v"
`include "instruction_format_def.v"
`include "SPR_def.v"

module mips (
	clk, rst_n
);
	// input statement
	input clk;
	input rst_n;


	// output statement


	// wire statement
	wire [`ARCH_WIDTH-1:0] IM_addr_F;
	wire [0:`IM_WIDTH-1] IM_dout_F;
	wire [0:`IM_WIDTH-1] Instr_F;
	wire [0:`PC_WIDTH-1] NPC_PC_F;
	wire [`ARCH_WIDTH-1:0] PC_PC_F;
	wire [0:`CR_WIDTH-1] CR_rd_D;
	wire [0:`CR_WIDTH-1] CR_rd_D_Bmux_dout_D;
	wire [2:0] CR_rd_D_Bmux_sel_D;
	wire [0:`GPR_DEPTH-1] GPR_raddr0_D;
	wire [0:`GPR_DEPTH-1] GPR_raddr1_D;
	wire [0:`GPR_DEPTH-1] GPR_raddr2_D;
	wire [0:`GPR_WIDTH-1] GPR_rd0_D;
	wire [0:`GPR_WIDTH-1] GPR_rd0_D_Bmux_dout_D;
	wire [2:0] GPR_rd0_D_Bmux_sel_D;
	wire [0:`GPR_WIDTH-1] GPR_rd1_D;
	wire [0:`GPR_WIDTH-1] GPR_rd1_D_Bmux_dout_D;
	wire [2:0] GPR_rd1_D_Bmux_sel_D;
	wire [0:`GPR_WIDTH-1] GPR_rd2_D;
	wire [0:`GPR_WIDTH-1] GPR_rd2_D_Bmux_dout_D;
	wire [2:0] GPR_rd2_D_Bmux_sel_D;
	reg [`INSTR_WIDTH-1:0] Instr_D;
	wire [0:`CR_WIDTH-1] NPC_CRrd_D;
	wire [0:`CTR_WIDTH-1] NPC_CTRrd_D;
	wire [0:`CTR_WIDTH-1] NPC_CTRwd_D;
	wire [0:25] NPC_Imm26_D;
	wire [0:`LR_WIDTH-1] NPC_LRrd_D;
	wire [0:`LR_WIDTH-1] NPC_LRwd_D;
	wire [0:`PC_WIDTH-1] NPC_NPC_D;
	wire [0:`NPCOp_WIDTH-1] NPC_Op_D;
	wire [0:`PC_WIDTH-1] NPC_PCB_D;
	wire [0:`PC_WIDTH-1] PC_NPC_D;
	reg [0:`PC_WIDTH-1] PC_PC_D;
	wire `SPR_DEPTH SPR_raddr0_D_Pmux_dout_D;
	wire [0:0] SPR_raddr0_D_Pmux_sel_D;
	wire [0:`SPR_DEPTH-1] SPR_raddr1_D;
	wire [0:`CTR_WIDTH-1] SPR_rd0_D;
	wire [0:`SPR_WIDTH-1] SPR_rd0_D_Bmux_dout_D;
	wire [3:0] SPR_rd0_D_Bmux_sel_D;
	wire [0:`LR_WIDTH-1] SPR_rd1_D;
	wire [31:0] SPR_rd1_D_Bmux_dout_D;
	wire [3:0] SPR_rd1_D_Bmux_sel_D;
	wire [0:0] clr_D;
	wire [0:0] stall;
	wire [0:`ALU_AInOp_WIDTH-1] ALU_AIn_Op_E;
	wire [0:5] ALU_AIn_RA_E;
	wire `ARCH_WIDTH ALU_AIn_din_E_Pmux_dout_E;
	wire [0:0] ALU_AIn_din_E_Pmux_sel_E;
	wire [0:`ARCH_WIDTH-1] ALU_AIn_dout_E;
	wire [0:`ARCH_WIDTH-1] ALU_A_E;
	wire `ARCH_WIDTH ALU_B_E_Pmux_dout_E;
	wire [2:0] ALU_B_E_Pmux_sel_E;
	wire [0:`CR_WIDTH-1] ALU_CRrd_E;
	wire [0:`ARCH_WIDTH-1] ALU_C_E;
	wire [0:2] ALU_DOut_BF_E;
	wire [0:`CR_WIDTH-1] ALU_DOut_CRrd_E;
	wire [0:`CR_WIDTH-1] ALU_DOut_CRwd_E;
	wire [0:`ALU_D_WIDTH-1] ALU_DOut_D_E;
	wire [0:0] ALU_DOut_OE_E;
	wire [0:`ALU_DOutOp_WIDTH-1] ALU_DOut_Op_E;
	wire [0:`XER_WIDTH-1] ALU_DOut_XERrd_E;
	wire [0:`XER_WIDTH-1] ALU_DOut_XERwd_E;
	wire [0:`ALU_D_WIDTH-1] ALU_D_E;
	wire [0:`ROTL_WIDTH-1] ALU_MB_E;
	wire [0:`ROTL_WIDTH-1] ALU_ME_E;
	wire [0:`ALUOp_WIDTH-1] ALU_Op_E;
	wire [0:`XER_WIDTH-1] ALU_XERrd_E;
	wire `ROTL_WIDTH ALU_rotn_E_Pmux_dout_E;
	wire [0:0] ALU_rotn_E_Pmux_sel_E;
	wire [0:`CR_DEPTH-1] CR_ALU_BA_E;
	wire [0:`CR_DEPTH-1] CR_ALU_BB_E;
	wire [0:`CR_DEPTH-1] CR_ALU_BT_E;
	wire [0:`CR_WIDTH-1] CR_ALU_CRrd_E;
	wire [0:`CR_WIDTH-1] CR_ALU_C_E;
	wire [0:`CR_ALUOp_WIDTH-1] CR_ALU_Op_E;
	reg [0:`CR_WIDTH-1] CR_rd_E;
	wire [0:`CR_WIDTH-1] CR_rd_E_Bmux_dout_E;
	wire [1:0] CR_rd_E_Bmux_sel_E;
	wire [0:15] Ext_Imm16_E;
	wire [0:31] Ext_Imm32_E;
	wire [0:`ExtOp_WIDTH-1] Ext_Op_E;
	reg [0:`GPR_WIDTH-1] GPR_rd0_E;
	wire [31:0] GPR_rd0_E_Bmux_dout_E;
	wire [1:0] GPR_rd0_E_Bmux_sel_E;
	reg [0:`GPR_WIDTH-1] GPR_rd1_E;
	wire [31:0] GPR_rd1_E_Bmux_dout_E;
	wire [1:0] GPR_rd1_E_Bmux_sel_E;
	reg [0:`GPR_WIDTH-1] GPR_rd2_E;
	wire [0:`GPR_WIDTH-1] GPR_rd2_E_Bmux_dout_E;
	wire [1:0] GPR_rd2_E_Bmux_sel_E;
	reg [`INSTR_WIDTH-1:0] Instr_E;
	reg [0:`CTR_WIDTH-1] NPC_CTRwd_E;
	reg [0:`LR_WIDTH-1] NPC_LRwd_E;
	reg [0:`SPR_WIDTH-1] SPR_rd0_E;
	wire [31:0] SPR_rd0_E_Bmux_dout_E;
	wire [0:0] SPR_rd0_E_Bmux_sel_E;
	wire [0:0] clr_E;
	wire `ARCH_WIDTH rotnIn_din_E_Pmux_dout_E;
	wire [0:0] rotnIn_din_E_Pmux_sel_E;
	wire [0:4] rotnIn_dout_E;
	reg [0:`ARCH_WIDTH-1] ALU_C_M;
	reg [0:`CR_WIDTH-1] ALU_DOut_CRwd_M;
	reg [0:`XER_WIDTH-1] ALU_DOut_XERwd_M;
	reg [0:`CR_WIDTH-1] CR_ALU_C_M;
	reg [0:`CR_WIDTH-1] CR_rd_M;
	wire [0:`DMBE_WIDTH-1] DMIn_BE_BE_M;
	wire [0:`DMIn_BEOp_WIDTH-1] DMIn_BE_Op_M;
	wire [0:`ARCH_WIDTH-1] DMIn_BE_addr_M;
	wire [0:`DM_WIDTH-1] DMIn_BE_din_M;
	wire [0:`DM_WIDTH-1] DMIn_BE_dout_M;
	wire [0:`DMOut_MEOp_WIDTH-1] DMOut_ME_Op_M;
	wire [0:`ARCH_WIDTH-1] DMOut_ME_addr_M;
	wire [0:`DM_WIDTH-1] DMOut_ME_din_M;
	wire [0:`DM_WIDTH-1] DMOut_ME_dout_M;
	wire [0:`DMBE_WIDTH-1] DM_BE_M;
	wire [0:`ARCH_WIDTH-1] DM_addr_M;
	wire [0:`DM_WIDTH-1] DM_din_M;
	wire [0:`DM_WIDTH-1] DM_dout_M;
	wire [0:0] DM_wr_M;
	reg [0:`GPR_WIDTH-1] GPR_rd2_M;
	wire [31:0] GPR_rd2_M_Bmux_dout_M;
	wire [0:0] GPR_rd2_M_Bmux_sel_M;
	reg [`INSTR_WIDTH-1:0] Instr_M;
	reg [0:`CTR_WIDTH-1] NPC_CTRwd_M;
	reg [0:`LR_WIDTH-1] NPC_LRwd_M;
	wire [0:0] clr_M;
	reg [0:`ARCH_WIDTH-1] ALU_C_W;
	reg [0:`CR_WIDTH-1] ALU_DOut_CRwd_W;
	reg [0:`XER_WIDTH-1] ALU_DOut_XERwd_W;
	reg [0:`CR_WIDTH-1] CR_ALU_C_W;
	reg [0:`CR_WIDTH-1] CR_rd_W;
	wire `CR_WIDTH CR_wd_W_Pmux_dout_W;
	wire [0:0] CR_wd_W_Pmux_sel_W;
	wire [0:0] CR_wr_W;
	reg [0:`DM_WIDTH-1] DMOut_ME_dout_W;
	wire `GPR_DEPTH GPR_waddr_W_Pmux_dout_W;
	wire [0:0] GPR_waddr_W_Pmux_sel_W;
	wire `GPR_WIDTH GPR_wd_W_Pmux_dout_W;
	wire [1:0] GPR_wd_W_Pmux_sel_W;
	wire [0:0] GPR_wr_W;
	reg [`INSTR_WIDTH-1:0] Instr_W;
	reg [0:`CTR_WIDTH-1] NPC_CTRwd_W;
	reg [0:`LR_WIDTH-1] NPC_LRwd_W;
	wire `SPR_DEPTH SPR_waddr0_W_Pmux_dout_W;
	wire [0:0] SPR_waddr0_W_Pmux_sel_W;
	wire [0:`SPR_DEPTH-1] SPR_waddr1_W;
	wire `SPR_WIDTH SPR_wd0_W_Pmux_dout_W;
	wire [0:0] SPR_wd0_W_Pmux_sel_W;
	wire [0:`SPR_WIDTH-1] SPR_wd1_W;
	wire [0:0] SPR_wr0_W_Pmux_dout_W;
	wire [1:0] SPR_wr0_W_Pmux_sel_W;
	wire [0:0] SPR_wr1_W;
	wire [0:0] clr_W;




	// Instance Module
	DM I_DM (
		.BE(DMIn_BE_BE_M),
		.din(DMIn_BE_dout_M),
		.dout(DM_dout_M),
		.addr(ALU_C_M),
		.clk(clk),
		.wr(DM_wr_M)
	);

	DMIn_BE I_DMIn_BE (
		.BE(DMIn_BE_BE_M),
		.din(GPR_rd2_M_Bmux_dout_M),
		.dout(DMIn_BE_dout_M),
		.addr(ALU_C_M),
		.Op(DMIn_BE_Op_M)
	);

	rotnIn I_rotnIn (
		.din(rotnIn_din_E_Pmux_dout_E),
		.dout(rotnIn_dout_E)
	);

	SPR I_SPR (
		.rst_n(rst_n),
		.raddr1(`LR_ADDR),
		.raddr0(SPR_raddr0_D_Pmux_dout_D),
		.waddr0(SPR_waddr0_W_Pmux_dout_W),
		.waddr1(`CTR_ADDR),
		.clk(clk),
		.wd0(SPR_wd0_W_Pmux_dout_W),
		.wd1(NPC_CTRwd_W),
		.wr0(SPR_wr0_W_Pmux_dout_W),
		.wr1(~Instr_W[8]),
		.rd1(SPR_rd1_D),
		.rd0(SPR_rd0_D)
	);

	ALU_DOut I_ALU_DOut (
		.BF(Instr_E[6:8]),
		.D(ALU_D_E),
		.XERrd(SPR_rd0_E_Bmux_dout_E),
		.CRrd(CR_rd_E_Bmux_dout_E),
		.OE(Instr_E[21]),
		.CRwd(ALU_DOut_CRwd_E),
		.XERwd(ALU_DOut_XERwd_E),
		.Op(ALU_DOut_Op_E)
	);

	PC I_PC (
		.PC(PC_PC_F),
		.rst_n(rst_n),
		.wr(~clr_D),
		.NPC(NPC_NPC_D),
		.clk(clk)
	);

	DMOut_ME I_DMOut_ME (
		.din(DM_dout_M),
		.dout(DMOut_ME_dout_M),
		.addr(ALU_C_M),
		.Op(DMOut_ME_Op_M)
	);

	ALU_AIn I_ALU_AIn (
		.din(ALU_AIn_din_E_Pmux_dout_E),
		.dout(ALU_AIn_dout_E),
		.RA(Instr_E[11:15]),
		.Op(ALU_AIn_Op_E)
	);

	Ext I_Ext (
		.Op(Ext_Op_E),
		.Imm32(Ext_Imm32_E),
		.Imm16(Instr_E[16:31])
	);

	IM I_IM (
		.dout(Instr_F),
		.addr(PC_PC_F)
	);

	CR I_CR (
		.rd(CR_rd_D),
		.rst_n(rst_n),
		.wd(CR_wd_W_Pmux_dout_W),
		.wr(CR_wr_W),
		.clk(clk)
	);

	GPR I_GPR (
		.raddr2(Instr_D[6:10]),
		.raddr1(Instr_D[16:20]),
		.raddr0(Instr_D[11:15]),
		.rd1(GPR_rd1_D),
		.rd0(GPR_rd0_D),
		.wd(GPR_wd_W_Pmux_dout_W),
		.rst_n(rst_n),
		.clk(clk),
		.waddr(GPR_waddr_W_Pmux_dout_W),
		.wr(GPR_wr_W),
		.rd2(GPR_rd2_D)
	);

	NPC I_NPC (
		.CRrd(CR_rd_D_Bmux_dout_D),
		.Imm26(Instr_D[6:31]),
		.LRrd(SPR_rd1_D_Bmux_dout_D),
		.PC(PC_PC_F),
		.NPC(NPC_NPC_D),
		.CTRrd(SPR_rd0_D_Bmux_dout_D),
		.CTRwd(NPC_CTRwd_D),
		.PCB(PC_PC_D),
		.LRwd(NPC_LRwd_D),
		.Op(NPC_Op_D)
	);

	CR_ALU I_CR_ALU (
		.C(CR_ALU_C_E),
		.BA(Instr_E[11:15]),
		.BB(Instr_E[16:20]),
		.CRrd(CR_rd_E_Bmux_dout_E),
		.BT(Instr_E[6:10]),
		.Op(CR_ALU_Op_E)
	);

	ALU I_ALU (
		.A(ALU_AIn_dout_E),
		.ME(Instr_E[26:30]),
		.C(ALU_C_E),
		.B(ALU_B_E_Pmux_dout_E),
		.D(ALU_D_E),
		.XERrd(SPR_rd0_E_Bmux_dout_E),
		.MB(Instr_E[21:25]),
		.CRrd(CR_rd_E_Bmux_dout_E),
		.rotn(ALU_rotn_E_Pmux_dout_E),
		.Op(ALU_Op_E)
	);





	// Instance Port Mux
	mux2 #(`SPR_DEPTH) SPR_raddr0_D_Pmux (
		.sel(SPR_raddr0_D_Pmux_sel_D),
		.dout(SPR_raddr0_D_Pmux_dout_D),
		.din1(`CTR_ADDR),
		.din0(`XER_ADDR)
	);

	mux2 #(`ARCH_WIDTH) ALU_AIn_din_E_Pmux (
		.sel(ALU_AIn_din_E_Pmux_sel_E),
		.dout(ALU_AIn_din_E_Pmux_dout_E),
		.din1(GPR_rd0_E_Bmux_dout_E),
		.din0(GPR_rd2_E_Bmux_dout_E)
	);

	mux2 #(`ARCH_WIDTH) rotnIn_din_E_Pmux (
		.sel(rotnIn_din_E_Pmux_sel_E),
		.dout(rotnIn_din_E_Pmux_dout_E),
		.din1(GPR_rd0_E_Bmux_dout_E),
		.din0(GPR_rd1_E_Bmux_dout_E)
	);

	mux2 #(`ROTL_WIDTH) ALU_rotn_E_Pmux (
		.sel(ALU_rotn_E_Pmux_sel_E),
		.dout(ALU_rotn_E_Pmux_dout_E),
		.din1(Instr_E[16:20]),
		.din0(rotnIn_dout_E)
	);

	mux8 #(`ARCH_WIDTH) ALU_B_E_Pmux (
		.dout(ALU_B_E_Pmux_dout_E),
		.din7( 0/* empty */ ),
		.din6( 0/* empty */ ),
		.din5(32'd0),
		.din4(GPR_rd1_E_Bmux_dout_E),
		.din3(`CONST_NEG1),
		.din2(GPR_rd0_E_Bmux_dout_E),
		.din1(Ext_Imm32_E),
		.din0(`CONST_ZERO),
		.sel(ALU_B_E_Pmux_sel_E)
	);

	mux2 #(`SPR_DEPTH) SPR_waddr0_W_Pmux (
		.sel(SPR_waddr0_W_Pmux_sel_W),
		.dout(SPR_waddr0_W_Pmux_dout_W),
		.din1(`XER_ADDR),
		.din0(`LR_ADDR)
	);

	mux2 #(`SPR_WIDTH) SPR_wd0_W_Pmux (
		.sel(SPR_wd0_W_Pmux_sel_W),
		.dout(SPR_wd0_W_Pmux_dout_W),
		.din1(ALU_DOut_XERwd_W),
		.din0(NPC_LRwd_W)
	);

	mux2 #(`GPR_DEPTH) GPR_waddr_W_Pmux (
		.sel(GPR_waddr_W_Pmux_sel_W),
		.dout(GPR_waddr_W_Pmux_dout_W),
		.din1(Instr_W[6:10]),
		.din0(Instr_W[11:15])
	);

	mux4 #(1) SPR_wr0_W_Pmux (
		.dout(SPR_wr0_W_Pmux_dout_W),
		.din3( 0/* empty */ ),
		.din2(1'b1),
		.din1(Instr_W[31]),
		.din0(Instr_W[21]),
		.sel(SPR_wr0_W_Pmux_sel_W)
	);

	mux4 #(`GPR_WIDTH) GPR_wd_W_Pmux (
		.dout(GPR_wd_W_Pmux_dout_W),
		.din3( 0/* empty */ ),
		.din2(DMOut_ME_dout_W),
		.din1(CR_rd_W),
		.din0(ALU_C_W),
		.sel(GPR_wd_W_Pmux_sel_W)
	);

	mux2 #(`CR_WIDTH) CR_wd_W_Pmux (
		.sel(CR_wd_W_Pmux_sel_W),
		.dout(CR_wd_W_Pmux_dout_W),
		.din1(CR_ALU_C_W),
		.din0(ALU_DOut_CRwd_W)
	);





	// Instance Bypass Mux
	mux8 #(32) GPR_rd0_D_Bmux (
		.dout(GPR_rd0_D_Bmux_dout_D),
		.din7( 0/* empty */ ),
		.din6(CR_rd_M),
		.din5(ALU_C_W),
		.din4(CR_rd_E),
		.din3(ALU_C_M),
		.din2(DMOut_ME_dout_W),
		.din1(CR_rd_W),
		.din0(GPR_rd0_D),
		.sel(GPR_rd0_D_Bmux_sel_D)
	);

	mux4 #(32) GPR_rd0_E_Bmux (
		.dout(GPR_rd0_E_Bmux_dout_E),
		.din3( 0/* empty */ ),
		.din2(ALU_C_M),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd0_E),
		.sel(GPR_rd0_E_Bmux_sel_E)
	);

	mux8 #(32) GPR_rd1_D_Bmux (
		.dout(GPR_rd1_D_Bmux_dout_D),
		.din7( 0/* empty */ ),
		.din6(CR_rd_M),
		.din5(ALU_C_W),
		.din4(CR_rd_E),
		.din3(ALU_C_M),
		.din2(DMOut_ME_dout_W),
		.din1(CR_rd_W),
		.din0(GPR_rd1_D),
		.sel(GPR_rd1_D_Bmux_sel_D)
	);

	mux4 #(32) GPR_rd1_E_Bmux (
		.dout(GPR_rd1_E_Bmux_dout_E),
		.din3( 0/* empty */ ),
		.din2(ALU_C_M),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd1_E),
		.sel(GPR_rd1_E_Bmux_sel_E)
	);

	mux8 #(32) GPR_rd2_D_Bmux (
		.dout(GPR_rd2_D_Bmux_dout_D),
		.din7( 0/* empty */ ),
		.din6(CR_rd_M),
		.din5(ALU_C_W),
		.din4(CR_rd_E),
		.din3(ALU_C_M),
		.din2(DMOut_ME_dout_W),
		.din1(CR_rd_W),
		.din0(GPR_rd2_D),
		.sel(GPR_rd2_D_Bmux_sel_D)
	);

	mux4 #(32) GPR_rd2_E_Bmux (
		.dout(GPR_rd2_E_Bmux_dout_E),
		.din3( 0/* empty */ ),
		.din2(ALU_C_M),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd2_E),
		.sel(GPR_rd2_E_Bmux_sel_E)
	);

	mux2 #(32) GPR_rd2_M_Bmux (
		.sel(GPR_rd2_M_Bmux_sel_M),
		.dout(GPR_rd2_M_Bmux_dout_M),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd2_M)
	);

	mux16 #(32) SPR_rd0_D_Bmux (
		.din13( 0/* empty */ ),
		.din12( 0/* empty */ ),
		.din11( 0/* empty */ ),
		.din10( 0/* empty */ ),
		.dout(SPR_rd0_D_Bmux_dout_D),
		.din15( 0/* empty */ ),
		.din14( 0/* empty */ ),
		.din7(ALU_DOut_XERwd_W),
		.din6(NPC_CTRwd_W),
		.din5(NPC_CTRwd_M),
		.din4(NPC_LRwd_E),
		.din3(NPC_CTRwd_E),
		.din2(ALU_DOut_XERwd_M),
		.din1(NPC_LRwd_M),
		.din0(SPR_rd0_D),
		.sel(SPR_rd0_D_Bmux_sel_D),
		.din9( 0/* empty */ ),
		.din8(NPC_LRwd_W)
	);

	mux2 #(32) SPR_rd0_E_Bmux (
		.sel(SPR_rd0_E_Bmux_sel_E),
		.dout(SPR_rd0_E_Bmux_dout_E),
		.din1(ALU_DOut_XERwd_M),
		.din0(SPR_rd0_E)
	);

	mux16 #(32) SPR_rd1_D_Bmux (
		.din13( 0/* empty */ ),
		.din12( 0/* empty */ ),
		.din11( 0/* empty */ ),
		.din10( 0/* empty */ ),
		.dout(SPR_rd1_D_Bmux_dout_D),
		.din15( 0/* empty */ ),
		.din14( 0/* empty */ ),
		.din7(ALU_DOut_XERwd_W),
		.din6(NPC_CTRwd_W),
		.din5(NPC_CTRwd_M),
		.din4(NPC_LRwd_E),
		.din3(NPC_CTRwd_E),
		.din2(ALU_DOut_XERwd_M),
		.din1(NPC_LRwd_M),
		.din0(SPR_rd1_D),
		.sel(SPR_rd1_D_Bmux_sel_D),
		.din9( 0/* empty */ ),
		.din8(NPC_LRwd_W)
	);

	mux8 #(32) CR_rd_D_Bmux (
		.dout(CR_rd_D_Bmux_dout_D),
		.din7( 0/* empty */ ),
		.din6( 0/* empty */ ),
		.din5( 0/* empty */ ),
		.din4(CR_ALU_C_W),
		.din3(ALU_DOut_CRwd_M),
		.din2(ALU_DOut_CRwd_W),
		.din1(CR_ALU_C_M),
		.din0(CR_rd_D),
		.sel(CR_rd_D_Bmux_sel_D)
	);

	mux4 #(32) CR_rd_E_Bmux (
		.dout(CR_rd_E_Bmux_dout_E),
		.din3( 0/* empty */ ),
		.din2(ALU_DOut_CRwd_M),
		.din1(CR_ALU_C_M),
		.din0(CR_rd_E),
		.sel(CR_rd_E_Bmux_sel_E)
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
		.GPR_rd0_D_Bmux_sel_D(GPR_rd0_D_Bmux_sel_D),
		.GPR_rd0_E_Bmux_sel_E(GPR_rd0_E_Bmux_sel_E),
		.GPR_rd1_D_Bmux_sel_D(GPR_rd1_D_Bmux_sel_D),
		.GPR_rd1_E_Bmux_sel_E(GPR_rd1_E_Bmux_sel_E),
		.GPR_rd2_D_Bmux_sel_D(GPR_rd2_D_Bmux_sel_D),
		.GPR_rd2_E_Bmux_sel_E(GPR_rd2_E_Bmux_sel_E),
		.GPR_rd2_M_Bmux_sel_M(GPR_rd2_M_Bmux_sel_M),
		.SPR_rd0_D_Bmux_sel_D(SPR_rd0_D_Bmux_sel_D),
		.SPR_rd0_E_Bmux_sel_E(SPR_rd0_E_Bmux_sel_E),
		.SPR_rd1_D_Bmux_sel_D(SPR_rd1_D_Bmux_sel_D),
		.CR_rd_D_Bmux_sel_D(CR_rd_D_Bmux_sel_D),
		.CR_rd_E_Bmux_sel_E(CR_rd_E_Bmux_sel_E),
		.stall(stall),
		.SPR_raddr0_D_Pmux_sel_D(SPR_raddr0_D_Pmux_sel_D),
		.ALU_AIn_din_E_Pmux_sel_E(ALU_AIn_din_E_Pmux_sel_E),
		.rotnIn_din_E_Pmux_sel_E(rotnIn_din_E_Pmux_sel_E),
		.ALU_rotn_E_Pmux_sel_E(ALU_rotn_E_Pmux_sel_E),
		.ALU_B_E_Pmux_sel_E(ALU_B_E_Pmux_sel_E),
		.SPR_waddr0_W_Pmux_sel_W(SPR_waddr0_W_Pmux_sel_W),
		.SPR_wd0_W_Pmux_sel_W(SPR_wd0_W_Pmux_sel_W),
		.GPR_waddr_W_Pmux_sel_W(GPR_waddr_W_Pmux_sel_W),
		.SPR_wr0_W_Pmux_sel_W(SPR_wr0_W_Pmux_sel_W),
		.GPR_wd_W_Pmux_sel_W(GPR_wd_W_Pmux_sel_W),
		.CR_wd_W_Pmux_sel_W(CR_wd_W_Pmux_sel_W),
		.NPC_Op_D(NPC_Op_D),
		.Ext_Op_E(Ext_Op_E),
		.ALU_Op_E(ALU_Op_E),
		.ALU_AIn_Op_E(ALU_AIn_Op_E),
		.ALU_DOut_Op_E(ALU_DOut_Op_E),
		.CR_ALU_Op_E(CR_ALU_Op_E),
		.DM_wr_M(DM_wr_M),
		.DMOut_ME_Op_M(DMOut_ME_Op_M),
		.DMIn_BE_Op_M(DMIn_BE_Op_M),
		.CR_wr_W(CR_wr_W),
		.GPR_wr_W(GPR_wr_W)
	);





	// Pipe Register
	/*****     Pipe_F     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			Instr_D <= `NOP;
			PC_PC_D <= 0;
		end
		else if ( !clr_D ) begin
			Instr_D <= Instr_F;
			PC_PC_D <= PC_PC_F;
		end
	end // end always

	/*****     Pipe_D     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n || clr_D ) begin
			GPR_rd2_E <= 0;
			GPR_rd0_E <= 0;
			NPC_CTRwd_E <= 0;
			Instr_E <= `NOP;
			GPR_rd1_E <= 0;
			NPC_LRwd_E <= 0;
			SPR_rd0_E <= 0;
			CR_rd_E <= 0;
		end
		else begin
			GPR_rd2_E <= GPR_rd2_D_Bmux_dout_D;
			GPR_rd0_E <= GPR_rd0_D_Bmux_dout_D;
			NPC_CTRwd_E <= NPC_CTRwd_D;
			Instr_E <= Instr_D;
			GPR_rd1_E <= GPR_rd1_D_Bmux_dout_D;
			NPC_LRwd_E <= NPC_LRwd_D;
			SPR_rd0_E <= SPR_rd0_D_Bmux_dout_D;
			CR_rd_E <= CR_rd_D_Bmux_dout_D;
		end
	end // end always

	/*****     Pipe_E     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n || clr_E ) begin
			Instr_M <= `NOP;
			CR_ALU_C_M <= 0;
			NPC_LRwd_M <= 0;
			ALU_DOut_XERwd_M <= 0;
			ALU_C_M <= 0;
			NPC_CTRwd_M <= 0;
			ALU_DOut_CRwd_M <= 0;
			CR_rd_M <= 0;
			GPR_rd2_M <= 0;
		end
		else begin
			Instr_M <= Instr_E;
			CR_ALU_C_M <= CR_ALU_C_E;
			NPC_LRwd_M <= NPC_LRwd_E;
			ALU_DOut_XERwd_M <= ALU_DOut_XERwd_E;
			ALU_C_M <= ALU_C_E;
			NPC_CTRwd_M <= NPC_CTRwd_E;
			ALU_DOut_CRwd_M <= ALU_DOut_CRwd_E;
			CR_rd_M <= CR_rd_E_Bmux_dout_E;
			GPR_rd2_M <= GPR_rd2_E_Bmux_dout_E;
		end
	end // end always

	/*****     Pipe_M     *****/
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n || clr_M ) begin
			CR_rd_W <= 0;
			DMOut_ME_dout_W <= 0;
			ALU_DOut_CRwd_W <= 0;
			NPC_CTRwd_W <= 0;
			ALU_C_W <= 0;
			CR_ALU_C_W <= 0;
			Instr_W <= `NOP;
			ALU_DOut_XERwd_W <= 0;
			NPC_LRwd_W <= 0;
		end
		else begin
			CR_rd_W <= CR_rd_M;
			DMOut_ME_dout_W <= DMOut_ME_dout_M;
			ALU_DOut_CRwd_W <= ALU_DOut_CRwd_M;
			NPC_CTRwd_W <= NPC_CTRwd_M;
			ALU_C_W <= ALU_C_M;
			CR_ALU_C_W <= CR_ALU_C_M;
			Instr_W <= Instr_M;
			ALU_DOut_XERwd_W <= ALU_DOut_XERwd_M;
			NPC_LRwd_W <= NPC_LRwd_M;
		end
	end // end always





endmodule

