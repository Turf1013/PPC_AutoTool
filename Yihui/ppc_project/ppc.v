`include "arch_def.v"
`include "ctrl_encode_def.v"
`include "global_def.v"
`include "instruction_def.v"
`include "instruction_format_def.v"
`include "SPR_def.v"

module ppc (
	clk, rst_n,
	PrAddr, PrRD, PrWD, 
	hw_int 
);
	// input statement
	input clk;
	input rst_n;
	input hw_int;


	// output statement
	output [`ARCH_WIDTH-1:0] PrAddr;
	output [`ARCH_WIDTH-1:0] PrRD;
	output [`ARCH_WIDTH-1:0] PrWD;


	// wire statement
	wire [0:0] MDU_ack;
	wire [`MDU_CNT_WIDTH-1:0] MDU_cnt;
	wire [0:0] MDU_req;
	wire [0:0] PCWr;
	wire [0:0] latch;
	wire [0:`INSTR_WIDTH-1] mcInsn;
	wire [0:0] restore_mcInsn;
	wire [0:0] stall_ext;
	wire [`ARCH_WIDTH-1:0] IM_addr_FB;
	wire [0:`IM_WIDTH-1] IM_dout_FB;
	wire [0:`IM_WIDTH-1] Instr_FB;
	wire [0:`PC_WIDTH-1] NPC_PC_FB;
	wire [`ARCH_WIDTH-1:0] PC_PC_FB;
	reg [0:`INSTR_WIDTH-1] Instr_FE;
	reg [0:`PC_WIDTH-1] PC_PC_FE;
	wire [0:`INSTR_WIDTH-1] newInstr;
	reg [0:`INSTR_WIDTH-1] orgInstr;
	wire [0:0] BrFlush_D;
	wire [0:`CR_WIDTH-1] CR_rd_D;
	wire [0:`CR_WIDTH-1] CR_rd_D_Bmux_dout_D;
	wire [2:0] CR_rd_D_Bmux_sel_D;
	wire [0:`GPR_DEPTH-1] GPR_raddr0_D;
	wire [0:`GPR_DEPTH-1] GPR_raddr1_D;
	wire [0:`GPR_DEPTH-1] GPR_raddr2_D;
	wire [0:`GPR_WIDTH-1] GPR_rd0_D;
	wire [0:`GPR_WIDTH-1] GPR_rd0_D_Bmux_dout_D;
	wire [4:0] GPR_rd0_D_Bmux_sel_D;
	wire [0:`GPR_WIDTH-1] GPR_rd1_D;
	wire [0:`GPR_WIDTH-1] GPR_rd1_D_Bmux_dout_D;
	wire [4:0] GPR_rd1_D_Bmux_sel_D;
	wire [0:`GPR_WIDTH-1] GPR_rd2_D;
	wire [0:`GPR_WIDTH-1] GPR_rd2_D_Bmux_dout_D;
	wire [4:0] GPR_rd2_D_Bmux_sel_D;
	reg [0:`INSTR_WIDTH-1] Instr_D;
	wire [0:`MSR_WIDTH-1] MSR_rd_D;
	wire [0:`MSR_WIDTH-1] MSR_rd_D_Bmux_dout_D;
	wire [2:0] MSR_rd_D_Bmux_sel_D;
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
	wire [0:`PC_WIDTH-1] PC_PC_D;
	wire [0:`SPR_DEPTH-1] SPR_raddr0_D_Pmux_dout_D;
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
	wire [0:4] ALU_AIn_RA_E;
	wire [0:`ARCH_WIDTH-1] ALU_AIn_din_E_Pmux_dout_E;
	wire [0:0] ALU_AIn_din_E_Pmux_sel_E;
	wire [0:`ARCH_WIDTH-1] ALU_AIn_dout_E;
	wire [0:`ARCH_WIDTH-1] ALU_A_E;
	wire [0:`ARCH_WIDTH-1] ALU_B_E_Pmux_dout_E;
	wire [2:0] ALU_B_E_Pmux_sel_E;
	wire [0:`ARCH_WIDTH-1] ALU_C_E;
	wire [0:`XER_WIDTH-1] ALU_DOut_XERwd_E;
	wire [0:2] ALU_D_E;
	wire [0:`ROTL_WIDTH-1] ALU_MB_E;
	wire [0:`ROTL_WIDTH-1] ALU_ME_E;
	wire [0:`ALUOp_WIDTH-1] ALU_Op_E;
	wire [0:`ROTL_WIDTH-1] ALU_rotn_E_Pmux_dout_E;
	wire [0:0] ALU_rotn_E_Pmux_sel_E;
	wire [0:`CR_DEPTH-1] CR_ALU_BA_E;
	wire [0:`CR_DEPTH-1] CR_ALU_BB_E;
	wire [0:`CR_DEPTH-1] CR_ALU_BT_E;
	wire [0:`CR_WIDTH-1] CR_ALU_CRrd_E;
	wire [0:0] CR_ALU_C_E;
	wire [0:`CR_ALUOp_WIDTH-1] CR_ALU_Op_E;
	wire [0:2] CR_MOVE_ALU_D_E;
	wire [0:2] CR_MOVE_BFA_E;
	wire [0:2] CR_MOVE_BF_E;
	wire [0:5] CR_MOVE_BT_E;
	wire [0:`CR_WIDTH-1] CR_MOVE_CRrd_E;
	wire [0:`CR_WIDTH-1] CR_MOVE_CRwd_E;
	wire [0:2] CR_MOVE_MDU_D_E;
	wire [0:`CR_MOVEOp_WIDTH-1] CR_MOVE_Op_E;
	wire [0:2] CR_MOVE_cmpALU_D_E;
	wire [0:0] CR_MOVE_crALU_C_E;
	wire [0:`CR_WIDTH-1] CR_MOVE_rS_E;
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
	reg [0:`INSTR_WIDTH-1] Instr_E;
	wire [0:`ARCH_WIDTH-1] MDU_A_E;
	wire [0:`ARCH_WIDTH-1] MDU_B_E_Pmux_dout_E;
	wire [0:0] MDU_B_E_Pmux_sel_E;
	wire [0:`ARCH_WIDTH-1] MDU_C_E;
	wire [0:2] MDU_D_E;
	wire [0:`MDUOp_WIDTH-1] MDU_Op_E;
	reg [0:`MSR_WIDTH-1] MSR_rd_E;
	reg [0:`CTR_WIDTH-1] NPC_CTRwd_E;
	reg [0:`LR_WIDTH-1] NPC_LRwd_E;
	reg [0:`SPR_WIDTH-1] SPR_rd0_E;
	wire [0:0] clr_E;
	wire [0:`ARCH_WIDTH-1] cmpALU_A_E;
	wire [0:`ARCH_WIDTH-1] cmpALU_B_E;
	wire [0:2] cmpALU_D_E;
	wire [0:`cmpALUOp_WIDTH-1] cmpALU_Op_E;
	wire [0:`ARCH_WIDTH-1] rotnIn_din_E_Pmux_dout_E;
	wire [0:0] rotnIn_din_E_Pmux_sel_E;
	wire [0:4] rotnIn_dout_E;
	reg [0:`ARCH_WIDTH-1] ALU_C_MB;
	reg [0:`XER_WIDTH-1] ALU_DOut_XERwd_MB;
	reg [0:`CR_WIDTH-1] CR_MOVE_CRwd_MB;
	reg [0:`CR_WIDTH-1] CR_rd_MB;
	wire [0:`CR_WIDTH-1] CR_rd_MB_Bmux_dout_MB;
	wire [0:0] CR_rd_MB_Bmux_sel_MB;
	reg [0:`GPR_WIDTH-1] GPR_rd2_MB;
	wire [0:`GPR_WIDTH-1] GPR_rd2_MB_Bmux_dout_MB;
	wire [0:0] GPR_rd2_MB_Bmux_sel_MB;
	reg [0:`INSTR_WIDTH-1] Instr_MB;
	reg [0:`ARCH_WIDTH-1] MDU_C_MB;
	reg [0:`MSR_WIDTH-1] MSR_rd_MB;
	reg [0:`CTR_WIDTH-1] NPC_CTRwd_MB;
	reg [0:`LR_WIDTH-1] NPC_LRwd_MB;
	reg [0:`SPR_WIDTH-1] SPR_rd0_MB;
	wire [0:0] clr_MB;
	reg [0:`ARCH_WIDTH-1] ALU_C_ME;
	wire [0:`XER_WIDTH-1] ALU_DOut_XERwd_ME;
	reg [0:`CR_WIDTH-1] CR_MOVE_CRwd_ME;
	reg [0:`CR_WIDTH-1] CR_rd_ME;
	wire [0:`CR_WIDTH-1] CR_rd_ME_Bmux_dout_ME;
	wire [0:0] CR_rd_ME_Bmux_sel_ME;
	wire [0:`DMBE_WIDTH-1] DMIn_BE_BE_ME;
	wire [0:`DMIn_BEOp_WIDTH-1] DMIn_BE_Op_ME;
	wire [0:`ARCH_WIDTH-1] DMIn_BE_addr_ME;
	wire [0:`DM_WIDTH-1] DMIn_BE_din_ME;
	wire [`DM_WIDTH-1:0] DMIn_BE_dout_ME;
	wire [0:`DMOut_MEOp_WIDTH-1] DMOut_ME_Op_ME;
	wire [0:`ARCH_WIDTH-1] DMOut_ME_addr_ME;
	wire [0:`DM_WIDTH-1] DMOut_ME_din_ME;
	wire [0:`DM_WIDTH-1] DMOut_ME_dout_ME;
	wire [0:`DMBE_WIDTH-1] DM_BE_ME;
	wire [`ARCH_WIDTH-1:0] DM_addr_ME;
	wire [`DM_WIDTH-1:0] DM_din_ME;
	wire [0:`DM_WIDTH-1] DM_dout_ME;
	wire [0:0] DM_wr_ME;
	reg [0:`GPR_WIDTH-1] GPR_rd2_ME;
	wire [0:`GPR_WIDTH-1] GPR_rd2_ME_Bmux_dout_ME;
	wire [0:0] GPR_rd2_ME_Bmux_sel_ME;
	reg [0:`INSTR_WIDTH-1] Instr_ME;
	reg [0:`ARCH_WIDTH-1] MDU_C_ME;
	reg [0:`MSR_WIDTH-1] MSR_rd_ME;
	reg [0:`CTR_WIDTH-1] NPC_CTRwd_ME;
	reg [0:`LR_WIDTH-1] NPC_LRwd_ME;
	reg [0:`SPR_WIDTH-1] SPR_rd0_ME;
	wire [0:0] clr_ME;
	reg [0:`ARCH_WIDTH-1] ALU_C_W;
	reg [0:`XER_WIDTH-1] ALU_DOut_XERwd_W;
	wire [0:0] CR_ALU_C_W;
	reg [0:`CR_WIDTH-1] CR_MOVE_CRwd_W;
	reg [0:`CR_WIDTH-1] CR_rd_W;
	wire [0:`CR_WIDTH-1] CR_wd_W_Pmux_dout_W;
	wire [0:0] CR_wd_W_Pmux_sel_W;
	wire [0:0] CR_wr_W;
	reg [0:`DM_WIDTH-1] DMOut_ME_dout_W;
	reg [0:`GPR_WIDTH-1] GPR_rd2_W;
	wire [0:`GPR_DEPTH-1] GPR_waddr0_W_Pmux_dout_W;
	wire [0:0] GPR_waddr0_W_Pmux_sel_W;
	wire [0:`GPR_DEPTH-1] GPR_waddr1_W;
	wire [0:`GPR_WIDTH-1] GPR_wd0_W_Pmux_dout_W;
	wire [2:0] GPR_wd0_W_Pmux_sel_W;
	wire [0:`GPR_WIDTH-1] GPR_wd1_W;
	wire [0:0] GPR_wr0_W;
	wire [0:0] GPR_wr1_W;
	reg [0:`INSTR_WIDTH-1] Instr_W;
	reg [0:`ARCH_WIDTH-1] MDU_C_W;
	reg [0:`MSR_WIDTH-1] MSR_rd_W;
	wire [0:`MSR_WIDTH-1] MSR_wd_W;
	wire [0:0] MSR_wr_W;
	reg [0:`CTR_WIDTH-1] NPC_CTRwd_W;
	reg [0:`LR_WIDTH-1] NPC_LRwd_W;
	reg [0:`SPR_WIDTH-1] SPR_rd0_W;
	wire [0:`SPR_DEPTH-1] SPR_waddr0_W_Pmux_dout_W;
	wire [0:0] SPR_waddr0_W_Pmux_sel_W;
	wire [0:`SPR_DEPTH-1] SPR_waddr1_W;
	wire [0:`SPR_WIDTH-1] SPR_wd0_W_Pmux_dout_W;
	wire [0:0] SPR_wd0_W_Pmux_sel_W;
	wire [0:`SPR_WIDTH-1] SPR_wd1_W;
	wire [0:0] SPR_wr0_W;
	wire [0:0] SPR_wr1_W;
	wire [0:0] clr_W;




	// Instance Module
	DM I_DM (
		.BE(DMIn_BE_BE_ME),
		.din(DMIn_BE_dout_ME),
		.dout(DM_dout_ME),
		.addr(ALU_C_ME),
		.clk(clk),
		.wr(DM_wr_ME)
	);

	MSR I_MSR (
		.rst_n(rst_n),
		.wd(GPR_rd2_W),
		.clk(clk),
		.INT(0),
		.rd(MSR_rd_D),
		.wr(MSR_wr_W)
	);

	DMIn_BE I_DMIn_BE (
		.BE(DMIn_BE_BE_ME),
		.din(GPR_rd2_ME_Bmux_dout_ME),
		.dout(DMIn_BE_dout_ME),
		.addr(ALU_C_ME),
		.Op(DMIn_BE_Op_ME)
	);

	rotnIn I_rotnIn (
		.din(rotnIn_din_E_Pmux_dout_E),
		.dout(rotnIn_dout_E)
	);

	cmpALU I_cmpALU (
		.A(ALU_AIn_dout_E),
		.B(GPR_rd1_E_Bmux_dout_E),
		.D(cmpALU_D_E),
		.Op(cmpALU_Op_E)
	);

	ALU_DOut I_ALU_DOut (
		.BF(0),
		.D(0),
		.XERrd(0),
		.CRrd(0),
		.OE(0),
		.XERwd(ALU_DOut_XERwd_E),
		.Op(0)
	);

	PC I_PC (
		.PC(PC_PC_FB),
		.rst_n(rst_n),
		.wr(PCWr),
		.NPC(NPC_NPC_D),
		.clk(clk)
	);

	DMOut_ME I_DMOut_ME (
		.din(DM_dout_ME),
		.dout(DMOut_ME_dout_ME),
		.addr(ALU_C_ME),
		.Op(DMOut_ME_Op_ME)
	);

	MDU I_MDU (
		.A(GPR_rd0_E_Bmux_dout_E),
		.C(MDU_C_E),
		.B(MDU_B_E_Pmux_dout_E),
		.D(MDU_D_E),
		.Op(MDU_Op_E)
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
		.dout(Instr_FB),
		.addr(PC_PC_FB),
		.clk(clk)
	);

	CR I_CR (
		.rd(CR_rd_D),
		.rst_n(rst_n),
		.wd(CR_wd_W_Pmux_dout_W),
		.wr(CR_wr_W),
		.clk(clk)
	);

	GPR I_GPR (
		.rst_n(rst_n),
		.raddr1(Instr_D[16:20]),
		.raddr0(Instr_D[11:15]),
		.waddr0(GPR_waddr0_W_Pmux_dout_W),
		.waddr1(Instr_W[11:15]),
		.clk(clk),
		.rd2(GPR_rd2_D),
		.raddr2(Instr_D[6:10]),
		.wd0(GPR_wd0_W_Pmux_dout_W),
		.wd1(ALU_C_W),
		.wr0(GPR_wr0_W),
		.wr1(GPR_wr1_W),
		.rd1(GPR_rd1_D),
		.rd0(GPR_rd0_D)
	);

	insnConverter I_insnConverter (
		.rst_n(rst_n),
		.din(orgInstr),
		.intReq(0),
		.trapReq(0),
		.clk(clk),
		.PC(PC_PC_FE),
		.dout(newInstr),
		.stall(stall),
		.stall_ext(stall_ext),
		.latch(latch)
	);

	NPC I_NPC (
		.CRrd(CR_rd_D_Bmux_dout_D),
		.intAddr(0),
		.Imm26(Instr_D[6:31]),
		.LRrd(SPR_rd1_D_Bmux_dout_D),
		.PC(PC_PC_FB),
		.NPC(NPC_NPC_D),
		.CTRrd(SPR_rd0_D_Bmux_dout_D),
		.CTRwd(NPC_CTRwd_D),
		.PCB(PC_PC_D),
		.SRR0rd(0),
		.LRwd(NPC_LRwd_D),
		.Op(NPC_Op_D)
	);

	trapComp I_trapComp (
		.A(0),
		.TO(0),
		.C(trapReq),
		.B(0),
		.Op(0)
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
		.wr0(SPR_wr0_W),
		.wr1(SPR_wr1_W),
		.rd1(SPR_rd1_D),
		.rd0(SPR_rd0_D)
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
		.MB(Instr_E[21:25]),
		.rotn(ALU_rotn_E_Pmux_dout_E),
		.Op(ALU_Op_E)
	);

	CR_MOVE I_CR_MOVE (
		.MDU_D(MDU_D_E),
		.crALU_C(CR_ALU_C_E),
		.BF(Instr_E[6:8]),
		.ALU_D(ALU_D_E),
		.rS(GPR_rd2_E_Bmux_dout_E),
		.CRrd(CR_rd_E_Bmux_dout_E),
		.BFA(Instr_E[11:13]),
		.BT(Instr_E[6:10]),
		.CRwd(CR_MOVE_CRwd_E),
		.cmpALU_D(cmpALU_D_E),
		.Op(CR_MOVE_Op_E)
	);





	// Instance Port Mux
	mux2 #(`SPR_DEPTH) SPR_raddr0_D_Pmux (
		.sel(SPR_raddr0_D_Pmux_sel_D),
		.dout(SPR_raddr0_D_Pmux_dout_D),
		.din1(`CTR_ADDR),
		.din0({Instr_D[16:20],Instr_D[11:15]})
	);

	mux2 #(`ARCH_WIDTH) MDU_B_E_Pmux (
		.sel(MDU_B_E_Pmux_sel_E),
		.dout(MDU_B_E_Pmux_dout_E),
		.din1(Ext_Imm32_E),
		.din0(GPR_rd1_E_Bmux_dout_E)
	);

	mux8 #(`ARCH_WIDTH) ALU_B_E_Pmux (
		.dout(ALU_B_E_Pmux_dout_E),
		.din7( 0/* empty */ ),
		.din6( 0/* empty */ ),
		.din5(GPR_rd0_E_Bmux_dout_E),
		.din4(Ext_Imm32_E),
		.din3(32'd0),
		.din2(GPR_rd1_E_Bmux_dout_E),
		.din1(`CONST_NEG1),
		.din0(`CONST_ZERO),
		.sel(ALU_B_E_Pmux_sel_E)
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
		.din1(GPR_rd1_E_Bmux_dout_E),
		.din0(GPR_rd0_E_Bmux_dout_E)
	);

	mux2 #(`ROTL_WIDTH) ALU_rotn_E_Pmux (
		.sel(ALU_rotn_E_Pmux_sel_E),
		.dout(ALU_rotn_E_Pmux_dout_E),
		.din1(rotnIn_dout_E),
		.din0(Instr_E[16:20])
	);

	mux2 #(`SPR_DEPTH) SPR_waddr0_W_Pmux (
		.sel(SPR_waddr0_W_Pmux_sel_W),
		.dout(SPR_waddr0_W_Pmux_dout_W),
		.din1(`LR_ADDR),
		.din0({Instr_W[16:20],Instr_W[11:15]})
	);

	mux2 #(`SPR_WIDTH) SPR_wd0_W_Pmux (
		.sel(SPR_wd0_W_Pmux_sel_W),
		.dout(SPR_wd0_W_Pmux_dout_W),
		.din1(NPC_LRwd_W),
		.din0(GPR_rd2_W)
	);

	mux8 #(`GPR_WIDTH) GPR_wd0_W_Pmux (
		.dout(GPR_wd0_W_Pmux_dout_W),
		.din7( 0/* empty */ ),
		.din6( 0/* empty */ ),
		.din5(DMOut_ME_dout_W),
		.din4(SPR_rd0_W),
		.din3(CR_rd_W),
		.din2(MSR_rd_W),
		.din1(MDU_C_W),
		.din0(ALU_C_W),
		.sel(GPR_wd0_W_Pmux_sel_W)
	);

	mux2 #(`GPR_DEPTH) GPR_waddr0_W_Pmux (
		.sel(GPR_waddr0_W_Pmux_sel_W),
		.dout(GPR_waddr0_W_Pmux_dout_W),
		.din1(Instr_W[11:15]),
		.din0(Instr_W[6:10])
	);

	mux2 #(`CR_WIDTH) CR_wd_W_Pmux (
		.sel(CR_wd_W_Pmux_sel_W),
		.dout(CR_wd_W_Pmux_dout_W),
		.din1(CR_MOVE_CRwd_W),
		.din0(CR_ALU_C_W)
	);





	// Instance Bypass Mux
	mux32 #(32) GPR_rd0_D_Bmux (
		.din26( 0/* empty */ ),
		.din27( 0/* empty */ ),
		.din24( 0/* empty */ ),
		.din25( 0/* empty */ ),
		.din22( 0/* empty */ ),
		.din23( 0/* empty */ ),
		.din20( 0/* empty */ ),
		.din21( 0/* empty */ ),
		.din28( 0/* empty */ ),
		.din29( 0/* empty */ ),
		.dout(GPR_rd0_D_Bmux_dout_D),
		.din31( 0/* empty */ ),
		.sel(GPR_rd0_D_Bmux_sel_D),
		.din30( 0/* empty */ ),
		.din13(CR_rd_MB),
		.din12(SPR_rd0_W),
		.din11(MDU_C_W),
		.din10(CR_rd_ME),
		.din17(MSR_rd_E),
		.din16(SPR_rd0_ME),
		.din15(SPR_rd0_MB),
		.din14(MDU_C_ME),
		.din19(MSR_rd_W),
		.din18(CR_rd_E),
		.din7(ALU_C_MB),
		.din6(ALU_C_ME),
		.din5(SPR_rd0_E),
		.din4(CR_rd_W),
		.din3(MSR_rd_MB),
		.din2(DMOut_ME_dout_W),
		.din1(MSR_rd_ME),
		.din0(GPR_rd0_D),
		.din9(MDU_C_MB),
		.din8(ALU_C_W)
	);

	mux4 #(32) GPR_rd0_E_Bmux (
		.dout(GPR_rd0_E_Bmux_dout_E),
		.din3(MDU_C_MB),
		.din2(ALU_C_MB),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd0_E),
		.sel(GPR_rd0_E_Bmux_sel_E)
	);

	mux32 #(32) GPR_rd1_D_Bmux (
		.din26( 0/* empty */ ),
		.din27( 0/* empty */ ),
		.din24( 0/* empty */ ),
		.din25( 0/* empty */ ),
		.din22( 0/* empty */ ),
		.din23( 0/* empty */ ),
		.din20( 0/* empty */ ),
		.din21( 0/* empty */ ),
		.din28( 0/* empty */ ),
		.din29( 0/* empty */ ),
		.dout(GPR_rd1_D_Bmux_dout_D),
		.din31( 0/* empty */ ),
		.sel(GPR_rd1_D_Bmux_sel_D),
		.din30( 0/* empty */ ),
		.din13(CR_rd_MB),
		.din12(SPR_rd0_W),
		.din11(MDU_C_W),
		.din10(CR_rd_ME),
		.din17(MSR_rd_E),
		.din16(SPR_rd0_ME),
		.din15(SPR_rd0_MB),
		.din14(MDU_C_ME),
		.din19(MSR_rd_W),
		.din18(CR_rd_E),
		.din7(ALU_C_MB),
		.din6(ALU_C_ME),
		.din5(SPR_rd0_E),
		.din4(CR_rd_W),
		.din3(MSR_rd_MB),
		.din2(DMOut_ME_dout_W),
		.din1(MSR_rd_ME),
		.din0(GPR_rd1_D),
		.din9(MDU_C_MB),
		.din8(ALU_C_W)
	);

	mux4 #(32) GPR_rd1_E_Bmux (
		.dout(GPR_rd1_E_Bmux_dout_E),
		.din3(MDU_C_MB),
		.din2(ALU_C_MB),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd1_E),
		.sel(GPR_rd1_E_Bmux_sel_E)
	);

	mux32 #(32) GPR_rd2_D_Bmux (
		.din26( 0/* empty */ ),
		.din27( 0/* empty */ ),
		.din24( 0/* empty */ ),
		.din25( 0/* empty */ ),
		.din22( 0/* empty */ ),
		.din23( 0/* empty */ ),
		.din20( 0/* empty */ ),
		.din21( 0/* empty */ ),
		.din28( 0/* empty */ ),
		.din29( 0/* empty */ ),
		.dout(GPR_rd2_D_Bmux_dout_D),
		.din31( 0/* empty */ ),
		.sel(GPR_rd2_D_Bmux_sel_D),
		.din30( 0/* empty */ ),
		.din13(CR_rd_MB),
		.din12(SPR_rd0_W),
		.din11(MDU_C_W),
		.din10(CR_rd_ME),
		.din17(MSR_rd_E),
		.din16(SPR_rd0_ME),
		.din15(SPR_rd0_MB),
		.din14(MDU_C_ME),
		.din19(MSR_rd_W),
		.din18(CR_rd_E),
		.din7(ALU_C_MB),
		.din6(ALU_C_ME),
		.din5(SPR_rd0_E),
		.din4(CR_rd_W),
		.din3(MSR_rd_MB),
		.din2(DMOut_ME_dout_W),
		.din1(MSR_rd_ME),
		.din0(GPR_rd2_D),
		.din9(MDU_C_MB),
		.din8(ALU_C_W)
	);

	mux4 #(32) GPR_rd2_E_Bmux (
		.dout(GPR_rd2_E_Bmux_dout_E),
		.din3(MDU_C_MB),
		.din2(ALU_C_MB),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd2_E),
		.sel(GPR_rd2_E_Bmux_sel_E)
	);

	mux2 #(32) GPR_rd2_MB_Bmux (
		.sel(GPR_rd2_MB_Bmux_sel_MB),
		.dout(GPR_rd2_MB_Bmux_dout_MB),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd2_MB)
	);

	mux2 #(32) GPR_rd2_ME_Bmux (
		.sel(GPR_rd2_ME_Bmux_sel_ME),
		.dout(GPR_rd2_ME_Bmux_dout_ME),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd2_ME)
	);

	mux16 #(32) SPR_rd0_D_Bmux (
		.din13( 0/* empty */ ),
		.din12(NPC_LRwd_W),
		.din11(NPC_CTRwd_W),
		.din10(NPC_LRwd_E),
		.dout(SPR_rd0_D_Bmux_dout_D),
		.din15( 0/* empty */ ),
		.din14( 0/* empty */ ),
		.din7(NPC_CTRwd_E),
		.din6(NPC_CTRwd_ME),
		.din5(NPC_CTRwd_MB),
		.din4(GPR_rd2_W),
		.din3(GPR_rd2_E),
		.din2(NPC_LRwd_MB),
		.din1(NPC_LRwd_ME),
		.din0(SPR_rd0_D),
		.sel(SPR_rd0_D_Bmux_sel_D),
		.din9(GPR_rd2_MB),
		.din8(GPR_rd2_ME)
	);

	mux16 #(32) SPR_rd1_D_Bmux (
		.din13( 0/* empty */ ),
		.din12(NPC_LRwd_W),
		.din11(GPR_rd2_W),
		.din10(NPC_CTRwd_W),
		.dout(SPR_rd1_D_Bmux_dout_D),
		.din15( 0/* empty */ ),
		.din14( 0/* empty */ ),
		.din7(GPR_rd2_MB),
		.din6(GPR_rd2_ME),
		.din5(NPC_CTRwd_E),
		.din4(NPC_CTRwd_ME),
		.din3(NPC_LRwd_MB),
		.din2(NPC_LRwd_ME),
		.din1(NPC_CTRwd_MB),
		.din0(SPR_rd1_D),
		.sel(SPR_rd1_D_Bmux_sel_D),
		.din9(NPC_LRwd_E),
		.din8(GPR_rd2_E)
	);

	mux8 #(32) CR_rd_D_Bmux (
		.dout(CR_rd_D_Bmux_dout_D),
		.din7( 0/* empty */ ),
		.din6( 0/* empty */ ),
		.din5( 0/* empty */ ),
		.din4(CR_MOVE_CRwd_ME),
		.din3(CR_MOVE_CRwd_MB),
		.din2(CR_ALU_C_W),
		.din1(CR_MOVE_CRwd_W),
		.din0(CR_rd_D),
		.sel(CR_rd_D_Bmux_sel_D)
	);

	mux4 #(32) CR_rd_E_Bmux (
		.dout(CR_rd_E_Bmux_dout_E),
		.din3( 0/* empty */ ),
		.din2(CR_MOVE_CRwd_MB),
		.din1(CR_ALU_C_W),
		.din0(CR_rd_E),
		.sel(CR_rd_E_Bmux_sel_E)
	);

	mux2 #(32) CR_rd_MB_Bmux (
		.sel(CR_rd_MB_Bmux_sel_MB),
		.dout(CR_rd_MB_Bmux_dout_MB),
		.din1(CR_ALU_C_W),
		.din0(CR_rd_MB)
	);

	mux2 #(32) CR_rd_ME_Bmux (
		.sel(CR_rd_ME_Bmux_sel_ME),
		.dout(CR_rd_ME_Bmux_dout_ME),
		.din1(CR_ALU_C_W),
		.din0(CR_rd_ME)
	);

	mux8 #(32) MSR_rd_D_Bmux (
		.dout(MSR_rd_D_Bmux_dout_D),
		.din7( 0/* empty */ ),
		.din6( 0/* empty */ ),
		.din5( 0/* empty */ ),
		.din4(GPR_rd2_W),
		.din3(GPR_rd2_E),
		.din2(GPR_rd2_MB),
		.din1(GPR_rd2_ME),
		.din0(MSR_rd_D),
		.sel(MSR_rd_D_Bmux_sel_D)
	);





	// Instance Controller
	control I_control (
		.clk(clk),
		.rst_n(rst_n),
		.Instr_D(Instr_D),
		.Instr_E(Instr_E),
		.Instr_MB(Instr_MB),
		.Instr_ME(Instr_ME),
		.Instr_W(Instr_W),
		.clr_D(clr_D),
		.clr_E(clr_E),
		.clr_MB(clr_MB),
		.clr_ME(clr_ME),
		.clr_W(clr_W),
		.BrFlush_D(BrFlush_D),
		.stall(stall),
		.PCWr(PCWr),
		.latch(latch),
		.MDU_cnt(MDU_cnt),
		.stall_ext(stall_ext),
		.mcInsn(mcInsn),
		.MDU_req(MDU_req),
		.MDU_ack(MDU_ack),
		.restore_mcInsn(restore_mcInsn),
		.GPR_rd0_D_Bmux_sel_D(GPR_rd0_D_Bmux_sel_D),
		.GPR_rd0_E_Bmux_sel_E(GPR_rd0_E_Bmux_sel_E),
		.GPR_rd1_D_Bmux_sel_D(GPR_rd1_D_Bmux_sel_D),
		.GPR_rd1_E_Bmux_sel_E(GPR_rd1_E_Bmux_sel_E),
		.GPR_rd2_D_Bmux_sel_D(GPR_rd2_D_Bmux_sel_D),
		.GPR_rd2_E_Bmux_sel_E(GPR_rd2_E_Bmux_sel_E),
		.GPR_rd2_MB_Bmux_sel_MB(GPR_rd2_MB_Bmux_sel_MB),
		.GPR_rd2_ME_Bmux_sel_ME(GPR_rd2_ME_Bmux_sel_ME),
		.SPR_rd0_D_Bmux_sel_D(SPR_rd0_D_Bmux_sel_D),
		.SPR_rd1_D_Bmux_sel_D(SPR_rd1_D_Bmux_sel_D),
		.CR_rd_D_Bmux_sel_D(CR_rd_D_Bmux_sel_D),
		.CR_rd_E_Bmux_sel_E(CR_rd_E_Bmux_sel_E),
		.CR_rd_MB_Bmux_sel_MB(CR_rd_MB_Bmux_sel_MB),
		.CR_rd_ME_Bmux_sel_ME(CR_rd_ME_Bmux_sel_ME),
		.MSR_rd_D_Bmux_sel_D(MSR_rd_D_Bmux_sel_D),
		.SPR_raddr0_D_Pmux_sel_D(SPR_raddr0_D_Pmux_sel_D),
		.MDU_B_E_Pmux_sel_E(MDU_B_E_Pmux_sel_E),
		.ALU_B_E_Pmux_sel_E(ALU_B_E_Pmux_sel_E),
		.ALU_AIn_din_E_Pmux_sel_E(ALU_AIn_din_E_Pmux_sel_E),
		.rotnIn_din_E_Pmux_sel_E(rotnIn_din_E_Pmux_sel_E),
		.ALU_rotn_E_Pmux_sel_E(ALU_rotn_E_Pmux_sel_E),
		.SPR_waddr0_W_Pmux_sel_W(SPR_waddr0_W_Pmux_sel_W),
		.SPR_wd0_W_Pmux_sel_W(SPR_wd0_W_Pmux_sel_W),
		.GPR_wd0_W_Pmux_sel_W(GPR_wd0_W_Pmux_sel_W),
		.GPR_waddr0_W_Pmux_sel_W(GPR_waddr0_W_Pmux_sel_W),
		.CR_wd_W_Pmux_sel_W(CR_wd_W_Pmux_sel_W),
		.NPC_Op_D(NPC_Op_D),
		.Ext_Op_E(Ext_Op_E),
		.cmpALU_Op_E(cmpALU_Op_E),
		.ALU_Op_E(ALU_Op_E),
		.CR_MOVE_Op_E(CR_MOVE_Op_E),
		.ALU_AIn_Op_E(ALU_AIn_Op_E),
		.MDU_Op_E(MDU_Op_E),
		.CR_ALU_Op_E(CR_ALU_Op_E),
		.DM_wr_ME(DM_wr_ME),
		.DMOut_ME_Op_ME(DMOut_ME_Op_ME),
		.DMIn_BE_Op_ME(DMIn_BE_Op_ME),
		.CR_wr_W(CR_wr_W),
		.SPR_wr0_W(SPR_wr0_W),
		.GPR_wr1_W(GPR_wr1_W),
		.GPR_wr0_W(GPR_wr0_W),
		.SPR_wr1_W(SPR_wr1_W),
		.MSR_wr_W(MSR_wr_W)
	);





	// Pipe Register
	/*****     Pipe_FB     *****/
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			orgInstr <= `NOP;
			PC_PC_FE <= `IM_BASE_ADDR;
		end
		else if (stall) begin
			orgInstr <= orgInstr;
			PC_PC_FE <= PC_PC_FE;
		end
		else if (BrFlush_D) begin
			orgInstr <= `NOP;
			PC_PC_FE <= `IM_BASE_ADDR;
		end
		else begin
			orgInstr <= Instr_FB;
			PC_PC_FE <= PC_PC_FB;
		end
	end // end always

	/*****     Pipe_FE     *****/
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			Instr_D <= `NOP;
		end
		else if (stall) begin
			Instr_D <= Instr_D;
		end
		else if (BrFlush_D) begin
			Instr_D <= `NOP;
		end
		else begin
			Instr_D <= Instr_FE;
		end
	end // end always

	/*****     Pipe_D     *****/
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			GPR_rd2_E <= 0;
			GPR_rd0_E <= 0;
			NPC_CTRwd_E <= 0;
			Instr_E <= `NOP;
			GPR_rd1_E <= 0;
			NPC_LRwd_E <= 0;
			SPR_rd0_E <= 0;
			CR_rd_E <= 0;
			MSR_rd_E <= 0;
		end
		else if (clr_D) begin
			GPR_rd2_E <= GPR_rd2_D_Bmux_dout_D;
			GPR_rd0_E <= GPR_rd0_D_Bmux_dout_D;
			NPC_CTRwd_E <= NPC_CTRwd_D;
			Instr_E <= `NOP;
			GPR_rd1_E <= GPR_rd1_D_Bmux_dout_D;
			NPC_LRwd_E <= NPC_LRwd_D;
			SPR_rd0_E <= SPR_rd0_D_Bmux_dout_D;
			CR_rd_E <= CR_rd_D_Bmux_dout_D;
			MSR_rd_E <= MSR_rd_D_Bmux_dout_D;
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
			MSR_rd_E <= MSR_rd_D_Bmux_dout_D;
		end
	end // end always

	/*****     Pipe_E     *****/
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			SPR_rd0_MB <= 0;
			NPC_LRwd_MB <= 0;
			MSR_rd_MB <= 0;
			GPR_rd2_MB <= 0;
			NPC_CTRwd_MB <= 0;
			ALU_DOut_XERwd_MB <= 0;
			ALU_C_MB <= 0;
			CR_rd_MB <= 0;
			Instr_MB <= `NOP;
			CR_MOVE_CRwd_MB <= 0;
			MDU_C_MB <= 0;
		end
		else if (clr_E && ~restore_mcInsn) begin
			SPR_rd0_MB <= SPR_rd0_E;
			NPC_LRwd_MB <= NPC_LRwd_E;
			MSR_rd_MB <= MSR_rd_E;
			GPR_rd2_MB <= GPR_rd2_E_Bmux_dout_E;
			NPC_CTRwd_MB <= NPC_CTRwd_E;
			ALU_DOut_XERwd_MB <= ALU_DOut_XERwd_E;
			ALU_C_MB <= ALU_C_E;
			CR_rd_MB <= CR_rd_E_Bmux_dout_E;
			Instr_MB <= `NOP;
			CR_MOVE_CRwd_MB <= CR_MOVE_CRwd_E;
			MDU_C_MB <= MDU_C_E;
		end
		else begin
			SPR_rd0_MB <= SPR_rd0_E;
			NPC_LRwd_MB <= NPC_LRwd_E;
			MSR_rd_MB <= MSR_rd_E;
			GPR_rd2_MB <= GPR_rd2_E_Bmux_dout_E;
			NPC_CTRwd_MB <= NPC_CTRwd_E;
			ALU_DOut_XERwd_MB <= ALU_DOut_XERwd_E;
			ALU_C_MB <= ALU_C_E;
			CR_rd_MB <= CR_rd_E_Bmux_dout_E;
			Instr_MB <= (restore_mcInsn) ? mcInsn : Instr_E;
			CR_MOVE_CRwd_MB <= CR_MOVE_CRwd_E;
			MDU_C_MB <= MDU_C_E;
		end
	end // end always

	/*****     Pipe_MB     *****/
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			MSR_rd_ME <= 0;
			NPC_LRwd_ME <= 0;
			NPC_CTRwd_ME <= 0;
			SPR_rd0_ME <= 0;
			GPR_rd2_ME <= 0;
			ALU_C_ME <= 0;
			CR_rd_ME <= 0;
			Instr_ME <= `NOP;
			CR_MOVE_CRwd_ME <= 0;
			MDU_C_ME <= 0;
		end
		else if (clr_MB) begin
			MSR_rd_ME <= MSR_rd_MB;
			NPC_LRwd_ME <= NPC_LRwd_MB;
			NPC_CTRwd_ME <= NPC_CTRwd_MB;
			SPR_rd0_ME <= SPR_rd0_MB;
			GPR_rd2_ME <= GPR_rd2_MB_Bmux_dout_MB;
			ALU_C_ME <= ALU_C_MB;
			CR_rd_ME <= CR_rd_MB_Bmux_dout_MB;
			Instr_ME <= `NOP;
			CR_MOVE_CRwd_ME <= CR_MOVE_CRwd_MB;
			MDU_C_ME <= MDU_C_MB;
		end
		else begin
			MSR_rd_ME <= MSR_rd_MB;
			NPC_LRwd_ME <= NPC_LRwd_MB;
			NPC_CTRwd_ME <= NPC_CTRwd_MB;
			SPR_rd0_ME <= SPR_rd0_MB;
			GPR_rd2_ME <= GPR_rd2_MB_Bmux_dout_MB;
			ALU_C_ME <= ALU_C_MB;
			CR_rd_ME <= CR_rd_MB_Bmux_dout_MB;
			Instr_ME <= Instr_MB;
			CR_MOVE_CRwd_ME <= CR_MOVE_CRwd_MB;
			MDU_C_ME <= MDU_C_MB;
		end
	end // end always

	/*****     Pipe_ME     *****/
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			CR_rd_W <= 0;
			DMOut_ME_dout_W <= 0;
			MDU_C_W <= 0;
			CR_MOVE_CRwd_W <= 0;
			MSR_rd_W <= 0;
			NPC_CTRwd_W <= 0;
			ALU_C_W <= 0;
			Instr_W <= `NOP;
			ALU_DOut_XERwd_W <= 0;
			SPR_rd0_W <= 0;
			GPR_rd2_W <= 0;
			NPC_LRwd_W <= 0;
		end
		else if (clr_ME) begin
			CR_rd_W <= CR_rd_ME_Bmux_dout_ME;
			DMOut_ME_dout_W <= DMOut_ME_dout_ME;
			MDU_C_W <= MDU_C_ME;
			CR_MOVE_CRwd_W <= CR_MOVE_CRwd_ME;
			MSR_rd_W <= MSR_rd_ME;
			NPC_CTRwd_W <= NPC_CTRwd_ME;
			ALU_C_W <= ALU_C_ME;
			Instr_W <= `NOP;
			ALU_DOut_XERwd_W <= ALU_DOut_XERwd_ME;
			SPR_rd0_W <= SPR_rd0_ME;
			GPR_rd2_W <= GPR_rd2_ME_Bmux_dout_ME;
			NPC_LRwd_W <= NPC_LRwd_ME;
		end
		else begin
			CR_rd_W <= CR_rd_ME_Bmux_dout_ME;
			DMOut_ME_dout_W <= DMOut_ME_dout_ME;
			MDU_C_W <= MDU_C_ME;
			CR_MOVE_CRwd_W <= CR_MOVE_CRwd_ME;
			MSR_rd_W <= MSR_rd_ME;
			NPC_CTRwd_W <= NPC_CTRwd_ME;
			ALU_C_W <= ALU_C_ME;
			Instr_W <= Instr_ME;
			ALU_DOut_XERwd_W <= ALU_DOut_XERwd_ME;
			SPR_rd0_W <= SPR_rd0_ME;
			GPR_rd2_W <= GPR_rd2_ME_Bmux_dout_ME;
			NPC_LRwd_W <= NPC_LRwd_ME;
		end
	end // end always





	// output logic
	assign PrWD = GPR_wd0_W_Pmux_dout_W;
	assign PrAddr = ALU_C_E;
	assign PrRD = DM_dout_ME;




	// newInstr to Instr_FE logic
	always @(*) begin
		Instr_FE = newInstr;
	end // end always




endmodule

