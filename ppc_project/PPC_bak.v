`include "arch_def.v"
`include "cu_def.v"
`include "defaut_def.v"
`include "instruction_def.v"

module PPC (

);
	/**** about ALU ****/
	wire signed [0:`ARCH_WIDTH-1] ALU_A, ALU_B;
	wire [0:`ARCH_WIDTH-1] ALU_C_E, ALU_C_M, ALU_C_W;
	wire signed [0:`ALUOp_WIDTH-1] ALUOp;
	wire [0:`ROTL_WIDTH-1] ALU_rotn;
	wire ALU_CA_E, ALU_SO_E, ALU_OV_E;
	wire ALU_CA_M, ALU_SO_M, ALU_OV_M;
	wire [0:3] ALU_CR0_E, ALU_CR0_M, ALU_CR0_W;

	/**** about CR_ALU ****/
	wire CR_ALU_A;
	wire CR_ALU_B;
	wire [0:`CR_ALUOp_WIDTH-1] CR_ALU_Op;
	wire CR_ALU_C_E, CR_ALU_C_M;
	/**** about CR ****/
	wire [0:`CR_WIDTH-1] CR;
	wire CRWr;
	wire [0:`CR_BEOp_WIDTH-1] CR_BEOp;
	wire [0:`CR_DEPTH-1] CR_addr_W;
	wire [0:`CR_WIDTH-1] CRWd_W;
	wire [0:`CR_WIDTH-1] Mov_CRWd_M, Mov_CRWd_W;
	wire [0:`CR_WIDTH-1] ALU_CRWd_M, ALU_CRWd_W;
	wire [0:`CR_WIDTH-1] CR0_CRWd_M, CR0_CRWd_W;
	wire [0:`CR_WIDTH-1] Cmp_CRWd_M, Cmp_CRWd_W;

	/**** about DM ****/
	wire [0:`DMBE_WIDTH-1] DMBE;
	wire DMWr;
	wire [0:`DM_DEPTH-1] DM_addr;
	wire [0:`DM_WIDTH-1] DM_din;
	wire [0:`DM_WIDTH-1] DM_dout;
	/**** about DMIn_BE ****/
	wire [0:1] DMIn_BE_laddr;
	wire [0:`DMIn_BEOp_WIDTH-1] DMIn_BEOp;
	wire [0:`DM_WIDTH-1] DMIn_BE_din;
	wire [0:`DM_WIDTH-1] DMIn_BE_dout;
	/**** about DMOut_ME ****/
	wire [0:1] DMOut_ME_laddr;
	wire [0:`DMOut_MEOp_WIDTH-1] DMOut_MEOp;
	wire [0:`DM_WIDTH-1] DMOut_ME_din;
	wire [0:`DM_WIDTH-1] DMOut_ME_dout_M, DMOut_ME_dout_W;

	/**** about Ext ****/
	wire [0:15] Ext_Imm16;
	wire [0:`ExtOp_WIDTH-1] ExtOp;


	/**** about GPR ****/
	wire GPRWr;
	wire [0:`GPR_DEPTH-1] GPR_wr1_W;
	wire [0:`GPR_WIDTH-1] GPRWd1_W;
	wire [0:`GPR_WIDTH-1] GPR_rd1_D, GPR_rd2_D, GPR_rd3_D;
	wire [0:`GPR_WIDTH-1] GPR_rd1_E, GPR_rd2_E, GPR_rd3_E;
	wire [0:`GPR_WIDTH-1] GPR_rd1_M, GPR_rd1_W;



	/**** about MSR ****/
	wire MSRWr;
	wire [0:`MSR_WIDTH-1] MSRWd;
	wire [0:`MSR_WIDTH-1] MSR_M, MSR_W;

	/**** about NPC ****/
	wire [0:`NPCOp_WIDTH-1] NPCOp;
	wire [0:`CTR_WIDTH-1] SPR_CTR;
	wire [0:`LR_WIDTH-1] SPR_LR;
	wire [0:`CTR_WIDTH-1] NPC_CTRWd_D, NPC_CTRWd_E, NPC_CTRWd_M, NPC_CTRWd_W;
	wire [0:`LR_WIDTH-1] NPC_LRWd_D, NPC_LRWd_E, NPC_LRWd_M, NPC_LRWd_W;

	/**** about PC ****/
	wire PCWr;
	wire [0:`PC_WIDTH-1] NPC;
	wire [0:`PC_WIDTH-1] PC;
	
	/**** about IM ****/
	wire [0:`IM_DEPTH-1] IM_addr;
	wire [0:`IM_WIDTH-1] IM_dout;
	
	/**** about XERIn ****/
   wire [0:`XER_WIDTH-1] XER;
	wire [0:`XER_WIDTH-1] ALU_XERWd_M, ALU_XERWd_W;
   
	/**** about SPR ****/
	wire SPRWr;
	wire SPR_CTRWr;
	wire [0:`SPR_WIDTH-1] SPR_CTRWd_W;
	wire [0:`SPR_DEPTH-1] SPR_addr;
	wire [0:`SPR_WIDTH-1] SPRWd;
	wire [0:`SPR_WIDTH-1] SPR_XER;
	wire [0:`SPR_WIDTH-1] SPRWd_M, SPRWd_W;

	wire [0:`INSTR_WIDTH-1] Instr;
   
	wire [0:9] SPRN, sprn, SPRN_M, sprn_M;

	wire [0:`INSTR_WIDTH-1] Instr_F;
	wire [0:`INSTR_WIDTH-1] Instr_D;
	wire [0:`INSTR_WIDTH-1] Instr_E;
	wire [0:`INSTR_WIDTH-1] Instr_M;
	wire [0:`INSTR_WIDTH-1] Instr_W;
	
	// special adjust
	wire [0:`ARCH_WIDTH-1] MovfWd_M, MovfWd_W;
	
	// Bypass
	wire [0:`CR_WIDTH-1]   Bypass_CR_D_Out;
   wire [0:`CR_WIDTH-1]   Bypass_CR_E_Out;
   wire [0:`CTR_WIDTH-1]  Bypass_CTR_D_Out;
   wire [0:`LR_WIDTH-1]   Bypass_LR_D_Out;
   wire [0:`ARCH_WIDTH-1] Bypass_rA_E_Out;
   wire [0:`ARCH_WIDTH-1] Bypass_rB_E_Out;
   wire [0:`ARCH_WIDTH-1] Bypass_rC_E_Out;
   wire [0:`XER_WIDTH-1]   Bypass_XER_E_Out;
   
   
	
	/*************************************************************/
	/************************** Fetch ****************************/
	PC U_PC (
		.rst_n(rst_n), .PCWr(PCWr), .PC(PC_F), .NPC(NPC), 
		.clk(clk)
	);
	
	IM U_IM (
		.dout(IM_dout), .addr(PC)
	);
	
	assign Instr_F = IM_dout;
	
	parameter F_D_FFW_DIN_WIDTH = `INSTR_WIDTH;
	wire [0:F_D_FFW_DIN_WIDTH-1] F_D_FFW_Din, F_D_FFW_Dout;
	
	FFW #(0, F_D_FFW_DIN_WIDTH) U_F_D_FFW (
		.clk(clk), .rst_n(rst_n), .wr(~Stall_FD), .d(F_D_FFW_Din), .q(F_D_FFW_Dout)
	);
	
	assign F_D_FFW_Din = Instr_F;
	assign Instr_D = F_D_FFW_Dout;
	
	
	
	/*************************************************************/
	/************************* Decode ****************************/
   /*
    * Add MB6(Bypass_CR_D)
    */
   mux8 #(`CR_WIDTH) Bypass_CR_D (
      .d0(CR), .d1(CR0_CRWd_M), .d2(Mov_CRWd_M), .d3(ALU_CRWd_M),
      .d4(GPR_rd1_M), .d5(ALU_CRWd_E), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT),
      .s(Bypass_CR_D_Sel), .y(Bypass_CR_D_Out)
   );
   
   /*
    * Add MB7(Bypass_CTR_D)
    */
   mux4 #(`CTR_WIDTH) Bypass_CTR_D (
      .d0(SPR_CTR), .d1(NPC_CTRWd_M), .d2(Bypass_rC_E_Out), .d3(GPR_rd1_M),
      .s(Bypass_CTR_D_Sel), .y(Bypass_CTR_D_Out)
   );
   
   /*
    * Add MB8(Bypass_LR_D)
    */
   mux4 #(`LR_WIDTH) Bypass_LR_D (
      .d0(SPR_LR), .d1(NPC_LRWd_M), .d2(Bypass_rC_E_Out), .d3(GPR_rd1_M),
      .s(Bypass_LR_D_Sel), .y(Bypass_LR_D_Out)
   );
   
   
	NPC U_NPC (
		.AA(Instr_D[`INSTR_AA]), .NPC_LRWd(NPC_LRWd_D), .CTR(Bypass_CTR_D_Out), .BO(Instr_F[`INSTR_BO]),
		.Imm24(Imm24), .NPCOp(NPCOp), .NPC(NPC), .PC(PC_F), 
		.LR(Bypass_LR_D_Out), .CR(Bypass_CR_D_Out), .NPC_CTRWd(NPC_CTRWd_D)
	);
   
	GPR U_GPR (
		.rst_n(rst_n), .rd1(GPR_rd1_D), .rd3(GPR_rd3_D), .clk(clk), 
		.wr1(GPR_wr1), .GPRWr(GPRWr), .rd2(GPR_rd2_D), .GPRWd1(GPRWd1), 
		.rr3(Instr_D[`INSTR_rB]), .rr2(Instr_D[`INSTR_rA]), .rr1(Instr_D[`INSTR_rS])
	);
	
	parameter D_E_FFW_DIN_WIDTH = `INSTR_WIDTH + `GPR_WIDTH*3 + `CTR_WIDTH + `LR_WIDTH;
	wire [0:D_E_FFW_DIN_WIDTH-1] D_E_FFW_Din, D_E_FFW_Dout;
	
	FFW #(0, D_E_FFW_DIN_WIDTH) U_D_E_FFW (
		.clk(clk), .rst_n(rst_n), .wr(~Stall_DE), .d(D_E_FFW_Din), .q(D_E_FFW_Dout)
	);
	
	assign D_E_FFW_Din = {Instr_D, GPR_rd1_D, GPR_rd2_D, GPR_rd3_D, NPC_CTRWd_D, NPC_LRWd_D};
	assign {Instr_E, GPR_rd1_E, GPR_rd2_E, GPR_rd3_E, NPC_CTRWd_E, NPC_LRWd_E} = D_E_FFW_Dout;
	
	
	
	/*************************************************************/
	/************************* Execute ***************************/
   /*
    * Add MB1(Bypass_rA_E)
    */
   mux4 #(`ARCH_WIDTH) Bypass_rA_E (
      .d0(GPR_rd2_E), .d1(ALU_C_M), .d2(MovfWd_M), .d3(GPRWd1_W),
      .s(Bypass_rA_E_Sel), .y(Bypass_rA_E_Out)
   );
   
   /*
    * Add MB2(Bypass_rB_E)
    */
   mux4 #(`ARCH_WIDTH) Bypass_rB_E (
      .d0(GPR_rd3_E), .d1(ALU_C_M), .d2(MovfWd_M), .d3(GPRWd1_W),
      .s(Bypass_rB_E_Sel), .y(Bypass_rB_E_Out)
   );
   
   /*
    * Add MB3(Bypass_rC_E)
    */
   mux4 #(`ARCH_WIDTH) Bypass_rC_E (
      .d0(GPR_rd1_E), .d1(ALU_C_M), .d2(MovfWd_M), .d3(GPRWd1_W),
      .s(Bypass_rC_E_Sel), .y(Bypass_rC_E_Out)
   );
   
   /*
    * Add MB5(Bypass_CR_E)
    */
   mux8 #(`CR_WIDTH) Bypass_CR_E (
      .d0(CR), .d1(CR0_CRWd_M), .d2(Mov_CRWd_M), .d3(ALU_CRWd_M),
      .d4(GPR_rd1_M), .d5(`MUX_D_DEFAULT), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT),
      .s(Bypass_CR_E_Sel), .y(Bypass_CR_E_Out)
   );
   
      
   /*
    * Add MB9(Bypass_XER_E)
    */
   mux4 #(`XER_WIDTH) Bypass_XER_E (
      .d0(SPR_XER), .d1(ALU_XERWd_M), .d2(GPR_rd1_M), .d3(`MUX_D_DEFAULT),
      .s(Bypass_XER_E_Sel), .y(Bypass_XER_E_Out)
   );
   
   
	mux2 #(5) U_ALU_rotn_mux2 (
		.d0(Instr_E[`INSTR_SH]), .d1(Bypass_rB_E_Out[27:31]), 
		.s(ALU_rotn_Sel), .y(ALU_rotn)
	);

	mux4 #(`ARCH_WIDTH) U_ALU_A_mux4 (
		.d0(Bypass_rA_E_Out), .d1(0), .d2(Bypass_rC_E_Out), .d3(`MUX_D_DEFAULT), 
		.s(ALU_A_Sel), .y(ALU_A)
	);

	mux8 #(`ARCH_WIDTH) U_ALU_B_mux8 (
		.d0(Bypass_rB_E_Out), .d1(Ext_Imm32), .d2(32'hffff_ffff), .d3(32'h0), 
		.d4(Bypass_rA_E_Out), .d5(`MUX_D_DEFAULT), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT), 
		.s(ALU_B_Sel), .y(ALU_B)
	);
	
	Ext U_Ext (
		.ExtOp(ExtOp), .Imm32(Ext_Imm32), .Imm16(Instr_E[`INSTR_Imm16])
	);

	CR_ALU U_CR_ALU (
		.A(Bypass_CR_E_Out[BA]), .C(CR_ALU_C_E), .B(Bypass_CR_E_Out[BB]), .Op(CR_ALU_Op)
	);
	
	ALU U_ALU (
		.ME(Instr_E[`INSTR_ME]), .ALUOp(ALUOp), .C(ALU_C_E), .B(ALU_B), 
		.MB(Instr_E[`INSTR_MB]), .ALU_SO(ALU_SO_E), .CR0(ALU_CR0_E), .XER_CA(Bypass_XER_E_Out[`XER_CA]), 
		.ALU_OV(ALU_OV_E), .XER_SO(Bypass_XER_E_Out[`XER_SO]), .A(ALU_A), .ALU_CA(ALU_CA_E), 
		.rotn(ALU_rotn)
	);
	
	parameter E_M_FFW_DIN_WIDTH = `INSTR_WIDTH + `GPR_WIDTH + `CTR_WIDTH + `LR_WIDTH + `ARCH_WIDTH + 3 + 4 + 1;
	wire [0:E_M_FFW_DIN_WIDTH-1] E_M_FFW_Din, E_M_FFW_Dout;
	
	FFW #(0, E_M_FFW_DIN_WIDTH) U_E_M_FFW (
		.clk(clk), .rst_n(rst_n), .wr(~Stall_EM), .d(E_M_FFW_Din), .q(E_M_FFW_Dout)
	);
	
	assign E_M_FFW_Din = {Instr_E, Bypass_rC_E_Out, NPC_CTRWd_E, NPC_LRWd_E, ALU_C_E,
						  ALU_SO_E, ALU_OV_E, ALU_CA_E, ALU_CR0_E, CR_ALU_C_E};
	assign {Instr_M, GPR_rd1_M, NPC_CTRWd_M, NPC_LRWd_M, ALU_C_M,
			ALU_SO_M, ALU_OV_M, ALU_CA_M, ALU_CR0_M, CR_ALU_C_M} = E_M_FFW_Dout;
	
	
	
	/*************************************************************/
	/************************* Memory ****************************/
	DM U_DM (
		.din(DMIn_BE_dout), .dout(DM_dout), .addr(ALU_C_M[30-`DM_DEPTH:29]), .clk(clk), 
		.DMWr(DMWr), .DMBE(DMIn_BE_DMBE)
	);

	DMIn_BE U_DMIn_BE (
		.laddr(ALU_C_M[30:31]), .dout(DMIn_BE_dout), .din(GPR_rd1_M), .DMIn_BEOp(DMIn_BEOp), 
		.DMBE(DMIn_BE_DMBE)
	);
	
	DMOut_ME U_DMOut_ME (
		.laddr(ALU_C_M[30:31]), .din(DM_dout), .DMOut_MEOp(DMOut_MEOp), .dout(DMOut_ME_dout_M)
	);
	
	
	CR U_CR (
		.rst_n(rst_n), .CRWr(CRWr), .addr(CR_addr_W), .clk(clk), 
		.FXM(Instr_W[`INSTR_FXM]), .CRWd(CRWd), .CR(CR), .CR_BEOp(CR_BEOp)
	);
	
	CRIn U_CRIn (
		.ALU_CR0(ALU_CR0_M), .CR_ALU_C(CR_ALU_C_M), .CR(CR), .BT(Instr_M[11:15]),
		.BFA(Instr_M[11:13]), .Mov_CRWd(Mov_CRWd_M), .ALU_CRWd(ALU_CRWd_M), CR0_CRWd(CR0_CRWd_M),
		.BF(Instr_M[11:12]), .Cmp_CRWd(Cmp_CR_Wd_M)
    );
	
	MSR U_MSR (
		.MSRWr(MSRWr), .rst_n(rst_n), .MSR(MSR_M), .MSRWd(GPR_rd1), 
		.clk(clk)
	);
	
	assign SPRN_M = Instr_M[11:20];
	assign sprn_M = {SPRN_M[5:9], SPRN_M[0:4]};
	
	SPR U_SPR (
		.raddr(sprn_M), .SPRWd(SPRWd_W), .CTR(SPR_CTR), .clk(clk),
		.CTRWd(NPC_CTRWd_W), .SPR(SPR_M), .SPRWr(SPRWr), .LR(SPR_LR), 
		.XER(SPR_XER), .rst_n(rst_n), .CTRWr(CTRWr), .waddr(SPR_waddr_W)
	);
	
	XERIn U_XERIn (
		.OVWr(OVWr), .CAWr(CAWr), .ALU_CA(ALU_CA_M), .ALU_SO(ALU_SO_M),
		.ALU_OV(ALU_OV_M), .XER(SPR_XER), .ALU_XERWd(ALU_XERWd_M)
	);
	
	mux4 #(32) MovfWd_mux4 (
	   .d0(CR_M), .d1(MSR_M), .d2(SPR_M), .d3(`MUX_D_DEFAULT),
	   .s(MovfWd_Sel), .y(MovfWd_M)
	);
	
	parameter M_W_FFW_DIN_WIDTH = `INSTR_WIDTH + `GPR_WIDTH + `SPR_WIDTH*3 + `ARCH_WIDTH*2 + `DM_WIDTH + `CR_WIDTH*4;
	wire [0:M_W_FFW_DIN_WIDTH-1] M_W_FFW_Din, M_W_FFW_Dout;
	
	FFW #(0, M_W_FFW_DIN_WIDTH) U_M_W_FFW (
		.clk(clk), .rst_n(rst_n), .wr(~Stall_MW), .d(M_W_FFW_Din), .q(M_W_FFW_Dout)
	);
	
	assign M_W_FFW_Din = {Instr_M, GPR_rd1_M, NPC_CTRWd_M, NPC_LRWd_M, ALU_C_M,
						  Mov_CRWd_M, ALU_CRWd_M, CR0_CRWd_M, Cmp_CRWd_M, DMOut_ME_dout_M, 
						  MovfWd_M, ALU_XERWd_M};
	assign {Instr_W, GPR_rd1_W, NPC_CTRWd_W, NPC_LRWd_W, ALU_C_W,
			Mov_CRWd_W, ALU_CRWd_W, CR0_CRWd_W, Cmp_CRWd_M, DMOut_ME_dout_W, 
			MovfWd_W, ALU_XERWd_W} = M_W_FFW_Dout;
	
	
	
	/*************************************************************/
	/*********************** Write Back **************************/
	assign SPRN = Instr_W[11:20];
	assign sprn = {SPRN[5:9],SPRN[0:4]};
	
	mux2 #(5) U_GPR_wr1_mux2 (
		.d0(Instr_W[6:10]), .d1(Instr_W[11:15]), 
		.s(GPR_wr1_Sel), .y(GPR_wr1_W)
	);

	mux4 #(32) U_GPRWd1_mux4 (
		.d0(MovfWd_W), .d2(ALU_C_W), .d3(DMOut_ME_dout_W), .d4(`MUX_D_DEFAULT),
		.s(GPRWd1_Sel), .y(GPRWd1_W)
	);

	mux4 #(32) U_SPRWd_mux2 (
		.d0(NPC_LRWd_W), .d1(GPR_rd1), .d2(ALU_XERWd_W), .d3(`MUX_D_DEFAULT),
		.s(SPRWd_Sel), .y(SPRWd_W)
	);

	mux4 #(10) U_SPR_addr_mux2 (
		.d0(sprn), .d1(`LR_SPRN), .d2(`XER_SPRN), .d3(`MUX_D_DEFAULT),
		.s(SPR_addr_Sel), .y(SPR_addr_W)
	);
	
	mux4 #(32) U_CRWd_mux4 (
		.d0(Mov_CRWd_W), .d1(GPR_rd1_W), .d2(CR0_CRWd_W), .d3(ALU_CRWd_W),
		.d4(Cmp_CRWd_W), .d5(`MUX_D_DEFAULT), .d6(`MUX_D_DEFAULT), .d7(`MUX_D_DEFAULT),
		.s(CRWd_Sel), .y(CRWd_W)
	);

	mux4 #(5) U_CR_addr_mux4 (
		.d0({Instr_W[6:8],2'b00}), .d1(5'd0), .d2(Instr_W[11:15]), .d3(`MUX_D_DEFAULT), 
		.s(CR_addr_Sel), .y(CR_addr_W)
	);

endmodule
