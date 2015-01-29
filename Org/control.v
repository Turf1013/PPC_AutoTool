  `include "arch_def.v"
`include "cu_def.v"
`include "default_def.v"
`include "instruction_def.v"

module control (
	SPR_raddr_D_Sel, NPCOp_D, ExtOp_E, ALUOp_E, 
	CR_ALU_Op_E, ALU_rotn_E_Sel, ALU_B_E_Sel, ALU_A_E_Sel, 
	XERIn_OVWr_M, DMWr_M, DMOut_MEOp_M, DMIn_BEOp_M, 
	XERIn_CAWr_M, SPR_waddr_W_Sel, GPRWd1_W_Sel, MSRWr_W, 
	GPRWr_W, CR_BEOp_W, SPRWr_W, CRWd_W_Sel, 
	CRWr_W, CR_addr_W_Sel, SPR_LRWr_W, SPRWd_W_Sel, 
	GPR_waddr1_W_Sel, SPR_SPR_D_Sel, CR_CR_D_Sel, SPR_SPR_E_Sel, 
	CR_CR_E_Sel, GPR_rd2_E_Sel, GPR_rd3_E_Sel, GPR_rd1_E_Sel, 
	SPR_SPR_M_Sel, CR_CR_M_Sel, GPR_rd1_M_Sel, pipeRegWr_F, 
	pipeRegWr_D, pipeRegWr_E, pipeRegWr_M, PCWr_D, 
	Instr_F, Instr_D, Instr_E, Instr_M, 
	Instr_W, clk, rst_n
);

	input clk;
	input rst_n;
	input [0:`INSTR_WIDTH] Instr_F;
	input [0:`INSTR_WIDTH] Instr_D;
	input [0:`INSTR_WIDTH] Instr_E;
	input [0:`INSTR_WIDTH] Instr_M;
	input [0:`INSTR_WIDTH] Instr_W;
	output [0:3] SPR_raddr_D_Sel;
	output [0:`NPCOp_WIDTH] NPCOp_D;
	output [0:`ExtOp_WIDTH] ExtOp_E;
	output [0:`ALUOp_WIDTH] ALUOp_E;
	output [0:`CR_ALU_Op_WIDTH] CR_ALU_Op_E;
	output [0:1] ALU_rotn_E_Sel;
	output [0:7] ALU_B_E_Sel;
	output [0:3] ALU_A_E_Sel;
	output XERIn_OVWr_M;
	output DMWr_M;
	output [0:`DMOut_MEOp_WIDTH] DMOut_MEOp_M;
	output [0:`DMIn_BEOp_WIDTH] DMIn_BEOp_M;
	output XERIn_CAWr_M;
	output [0:3] SPR_waddr_W_Sel;
	output [0:7] GPRWd1_W_Sel;
	output MSRWr_W;
	output GPRWr_W;
	output [0:`CR_BEOp_WIDTH] CR_BEOp_W;
	output SPRWr_W;
	output [0:7] CRWd_W_Sel;
	output CRWr_W;
	output [0:3] CR_addr_W_Sel;
	output SPR_LRWr_W;
	output [0:3] SPRWd_W_Sel;
	output [0:1] GPR_waddr1_W_Sel;
	output [0:4] SPR_SPR_D_Sel;
	output [0:4] CR_CR_D_Sel;
	output [0:4] SPR_SPR_E_Sel;
	output [0:4] CR_CR_E_Sel;
	output [0:4] GPR_rd2_E_Sel;
	output [0:4] GPR_rd3_E_Sel;
	output [0:4] GPR_rd1_E_Sel;
	output [0:3] SPR_SPR_M_Sel;
	output [0:3] CR_CR_M_Sel;
	output [0:3] GPR_rd1_M_Sel;
	output pipeRegWr_F;
	output pipeRegWr_D;
	output pipeRegWr_E;
	output pipeRegWr_M;
	output PCWr_D;


	/*****     wire statment HDL Code     *****/
	wire [0:`INSTR_WIDTH] Instr_F;
	wire [0:`INSTR_WIDTH] Instr_D;
	wire [0:`INSTR_WIDTH] Instr_E;
	wire [0:`INSTR_WIDTH] Instr_M;
	wire [0:`INSTR_WIDTH] Instr_W;
	wire [0:`INSTR_OPCD_WIDTH] opcd_D;
	wire [0:`INSTR_OPCD_WIDTH] opcd_E;
	wire [0:`INSTR_OPCD_WIDTH] opcd_M;
	wire [0:`INSTR_OPCD_WIDTH] opcd_W;
	wire [0:`INSTR_OPCD_WIDTH] xo_D;
	wire [0:`INSTR_OPCD_WIDTH] xo_E;
	wire [0:`INSTR_OPCD_WIDTH] xo_M;
	wire [0:`INSTR_OPCD_WIDTH] xo_W;
	wire OE_M;
	wire OE_W;
	wire Rc_W;
	wire LK_W;
	/*****     hazard wire HDL Code    *****/
	wire SPR_SPR_E_wr_grp_0_0;
	wire SPR_SPR_M_wr_grp_0_0;
	wire SPR_SPR_W_wr_grp_0_0;
	wire SPR_SPR_E_wr_grp_1_0;
	wire SPR_SPR_M_wr_grp_1_0;
	wire SPR_SPR_W_wr_grp_1_0;
	wire SPR_SPR_E_wr_grp_2_0;
	wire SPR_SPR_M_wr_grp_2_0;
	wire SPR_SPR_W_wr_grp_2_0;
	wire SPR_SPR_E_wr_grp_3_0;
	wire SPR_SPR_M_wr_grp_3_0;
	wire SPR_SPR_W_wr_grp_3_0;
	wire SPR_SPR_E_wr_grp_4_0;
	wire SPR_SPR_M_wr_grp_4_0;
	wire SPR_SPR_W_wr_grp_4_0;
	wire SPR_SPR_D_rd_grp_0_0;
	wire SPR_SPR_E_rd_grp_1_0;
	wire SPR_SPR_M_rd_grp_2_0;
	wire CR_CR_E_wr_grp_0_0;
	wire CR_CR_M_wr_grp_0_0;
	wire CR_CR_W_wr_grp_0_0;
	wire CR_CR_E_wr_grp_1_0;
	wire CR_CR_M_wr_grp_1_0;
	wire CR_CR_W_wr_grp_1_0;
	wire CR_CR_E_wr_grp_2_0;
	wire CR_CR_M_wr_grp_2_0;
	wire CR_CR_W_wr_grp_2_0;
	wire CR_CR_E_wr_grp_3_0;
	wire CR_CR_M_wr_grp_3_0;
	wire CR_CR_W_wr_grp_3_0;
	wire CR_CR_E_wr_grp_4_0;
	wire CR_CR_M_wr_grp_4_0;
	wire CR_CR_W_wr_grp_4_0;
	wire CR_CR_D_rd_grp_0_0;
	wire CR_CR_E_rd_grp_1_0;
	wire CR_CR_M_rd_grp_2_0;
	wire GPR_rd2_M_wr_grp_0_0;
	wire GPR_rd2_W_wr_grp_0_0;
	wire GPR_rd2_M_wr_grp_1_0;
	wire GPR_rd2_W_wr_grp_1_0;
	wire GPR_rd2_M_wr_grp_2_0;
	wire GPR_rd2_W_wr_grp_2_0;
	wire GPR_rd2_M_wr_grp_3_0;
	wire GPR_rd2_W_wr_grp_3_0;
	wire GPR_rd2_M_wr_grp_4_0;
	wire GPR_rd2_W_wr_grp_4_0;
	wire GPR_rd2_M_wr_grp_4_1;
	wire GPR_rd2_W_wr_grp_4_1;
	wire GPR_rd2_E_rd_grp_0_0;
	wire GPR_rd3_M_wr_grp_0_0;
	wire GPR_rd3_W_wr_grp_0_0;
	wire GPR_rd3_M_wr_grp_1_0;
	wire GPR_rd3_W_wr_grp_1_0;
	wire GPR_rd3_M_wr_grp_2_0;
	wire GPR_rd3_W_wr_grp_2_0;
	wire GPR_rd3_M_wr_grp_3_0;
	wire GPR_rd3_W_wr_grp_3_0;
	wire GPR_rd3_M_wr_grp_4_0;
	wire GPR_rd3_W_wr_grp_4_0;
	wire GPR_rd3_M_wr_grp_4_1;
	wire GPR_rd3_W_wr_grp_4_1;
	wire GPR_rd3_E_rd_grp_0_0;
	wire GPR_rd1_M_wr_grp_0_0;
	wire GPR_rd1_W_wr_grp_0_0;
	wire GPR_rd1_M_wr_grp_1_0;
	wire GPR_rd1_W_wr_grp_1_0;
	wire GPR_rd1_M_wr_grp_2_0;
	wire GPR_rd1_W_wr_grp_2_0;
	wire GPR_rd1_M_wr_grp_3_0;
	wire GPR_rd1_W_wr_grp_3_0;
	wire GPR_rd1_M_wr_grp_4_0;
	wire GPR_rd1_W_wr_grp_4_0;
	wire GPR_rd1_M_wr_grp_4_1;
	wire GPR_rd1_W_wr_grp_4_1;
	wire GPR_rd1_E_rd_grp_0_0;
	wire GPR_rd1_M_rd_grp_1_0;
	wire flush_F;
	wire flush_D;
	wire flush_E;
	wire flush_M;
	wire flush_W;
	wire PCWr_D;

	/*****     reg statment HDL Code     *****/
	reg [0:3] SPR_raddr_D_Sel;
	reg [0:`NPCOp_WIDTH] NPCOp_D;
	reg [0:`ExtOp_WIDTH] ExtOp_E;
	reg [0:`ALUOp_WIDTH] ALUOp_E;
	reg [0:`CR_ALU_Op_WIDTH] CR_ALU_Op_E;
	reg [0:1] ALU_rotn_E_Sel;
	reg [0:7] ALU_B_E_Sel;
	reg [0:3] ALU_A_E_Sel;
	reg XERIn_OVWr_M;
	reg DMWr_M;
	reg [0:`DMOut_MEOp_WIDTH] DMOut_MEOp_M;
	reg [0:`DMIn_BEOp_WIDTH] DMIn_BEOp_M;
	reg XERIn_CAWr_M;
	reg [0:3] SPR_waddr_W_Sel;
	reg [0:7] GPRWd1_W_Sel;
	reg MSRWr_W;
	reg GPRWr_W;
	reg [0:`CR_BEOp_WIDTH] CR_BEOp_W;
	reg SPRWr_W;
	reg [0:7] CRWd_W_Sel;
	reg CRWr_W;
	reg [0:3] CR_addr_W_Sel;
	reg SPR_LRWr_W;
	reg [0:3] SPRWd_W_Sel;
	reg [0:1] GPR_waddr1_W_Sel;
	reg [0:4] SPR_SPR_D_Sel;
	reg [0:4] CR_CR_D_Sel;
	reg [0:4] SPR_SPR_E_Sel;
	reg [0:4] CR_CR_E_Sel;
	reg [0:4] GPR_rd2_E_Sel;
	reg [0:4] GPR_rd3_E_Sel;
	reg [0:4] GPR_rd1_E_Sel;
	reg [0:3] SPR_SPR_M_Sel;
	reg [0:3] CR_CR_M_Sel;
	reg [0:3] GPR_rd1_M_Sel;
	/*****     hazard reg HDL Code    *****/
	reg stall_F;
	reg stall_D;
	reg stall_E;
	reg stall_M;
	reg flush_F_r;
	reg flush_D_r;
	reg flush_E_r;
	reg flush_M_r;
	reg flush_W_r;
	reg pipeRegWr_F;
	reg pipeRegWr_D;
	reg pipeRegWr_E;
	reg pipeRegWr_M;

	/*****     assign HDL Code     *****/
	assign opcd_D = Instr_D[`INSTR_OPCD];
	assign opcd_E = Instr_E[`INSTR_OPCD];
	assign opcd_M = Instr_M[`INSTR_OPCD];
	assign opcd_W = Instr_W[`INSTR_OPCD];
	assign xo_D = Instr_D[`INSTR_XO];
	assign xo_E = Instr_E[`INSTR_XO];
	assign xo_M = Instr_M[`INSTR_XO];
	assign xo_W = Instr_W[`INSTR_XO];
	assign OE_M = Instr_M[21];
	assign OE_W = Instr_W[21];
	assign Rc_W = Instr_W[31];
	assign LK_W = Instr_W[31];
	/*****     hazard assign HDL Code    *****/
	assign SPR_SPR_E_wr_grp_0_0 = ( ~flush_E ) && ( ( opcd_E == `BCLR_OPCD && xo_E == `BCLR_XO ) || ( opcd_E == `BC_OPCD ) );
	assign SPR_SPR_M_wr_grp_0_0 = ( ~flush_M ) && ( ( opcd_M == `BCLR_OPCD && xo_M == `BCLR_XO ) || ( opcd_M == `BC_OPCD ) );
	assign SPR_SPR_W_wr_grp_0_0 = ( ~flush_W ) && ( ( opcd_W == `BCLR_OPCD && xo_W == `BCLR_XO ) || ( opcd_W == `BC_OPCD ) );
	assign SPR_SPR_E_wr_grp_1_0 = ( ~flush_E ) && ( ( opcd_E == `BCLR_OPCD && xo_E == `BCLR_XO ) );
	assign SPR_SPR_M_wr_grp_1_0 = ( ~flush_M ) && ( ( opcd_M == `BCLR_OPCD && xo_M == `BCLR_XO ) );
	assign SPR_SPR_W_wr_grp_1_0 = ( ~flush_W ) && ( ( opcd_W == `BCLR_OPCD && xo_W == `BCLR_XO ) );
	assign SPR_SPR_E_wr_grp_2_0 = ( ~flush_E ) && ( ( opcd_E == `SUBF_OPCD && xo_E == `SUBF_XO ) );
	assign SPR_SPR_M_wr_grp_2_0 = ( ~flush_M ) && ( ( opcd_M == `SUBF_OPCD && xo_M == `SUBF_XO ) );
	assign SPR_SPR_W_wr_grp_2_0 = ( ~flush_W ) && ( ( opcd_W == `SUBF_OPCD && xo_W == `SUBF_XO ) );
	assign SPR_SPR_E_wr_grp_3_0 = ( ~flush_E ) && ( ( opcd_E == `MTSPR_OPCD && xo_E == `MTSPR_XO ) );
	assign SPR_SPR_M_wr_grp_3_0 = ( ~flush_M ) && ( ( opcd_M == `MTSPR_OPCD && xo_M == `MTSPR_XO ) );
	assign SPR_SPR_W_wr_grp_3_0 = ( ~flush_W ) && ( ( opcd_W == `MTSPR_OPCD && xo_W == `MTSPR_XO ) );
	assign SPR_SPR_E_wr_grp_4_0 = ( ~flush_E ) && ( ( opcd_E == `B_OPCD ) );
	assign SPR_SPR_M_wr_grp_4_0 = ( ~flush_M ) && ( ( opcd_M == `B_OPCD ) );
	assign SPR_SPR_W_wr_grp_4_0 = ( ~flush_W ) && ( ( opcd_W == `B_OPCD ) );
	assign SPR_SPR_D_rd_grp_0_0 = ( ~flush_D ) && ( ( opcd_D == `BCLR_OPCD && xo_D == `BCLR_XO ) );
	assign SPR_SPR_E_rd_grp_1_0 = ( ~flush_E ) && ( ( opcd_E == `AND_OPCD && xo_E == `AND_XO ) );
	assign SPR_SPR_M_rd_grp_2_0 = ( ~flush_M ) && ( ( opcd_M == `SUBF_OPCD && xo_M == `SUBF_XO ) );
	assign CR_CR_E_wr_grp_0_0 = ( ~flush_E ) && ( ( opcd_E == `MCRF_OPCD && xo_E == `MCRF_XO ) );
	assign CR_CR_M_wr_grp_0_0 = ( ~flush_M ) && ( ( opcd_M == `MCRF_OPCD && xo_M == `MCRF_XO ) );
	assign CR_CR_W_wr_grp_0_0 = ( ~flush_W ) && ( ( opcd_W == `MCRF_OPCD && xo_W == `MCRF_XO ) );
	assign CR_CR_E_wr_grp_1_0 = ( ~flush_E ) && ( ( opcd_E == `CRNOR_OPCD && xo_E == `CRNOR_XO ) || ( opcd_E == `CRAND_OPCD && xo_E == `CRAND_XO ) || ( opcd_E == `CRXOR_OPCD && xo_E == `CRXOR_XO ) );
	assign CR_CR_M_wr_grp_1_0 = ( ~flush_M ) && ( ( opcd_M == `CRNOR_OPCD && xo_M == `CRNOR_XO ) || ( opcd_M == `CRAND_OPCD && xo_M == `CRAND_XO ) || ( opcd_M == `CRXOR_OPCD && xo_M == `CRXOR_XO ) );
	assign CR_CR_W_wr_grp_1_0 = ( ~flush_W ) && ( ( opcd_W == `CRNOR_OPCD && xo_W == `CRNOR_XO ) || ( opcd_W == `CRAND_OPCD && xo_W == `CRAND_XO ) || ( opcd_W == `CRXOR_OPCD && xo_W == `CRXOR_XO ) );
	assign CR_CR_E_wr_grp_2_0 = ( ~flush_E ) && ( ( opcd_E == `AND_OPCD && xo_E == `AND_XO ) || ( opcd_E == `RLWIMI_OPCD ) || ( opcd_E == `NAND_OPCD && xo_E == `NAND_XO ) || ( opcd_E == `SUBF_OPCD && xo_E == `SUBF_XO ) || ( opcd_E == `ANDIS__OPCD ) || ( opcd_E == `SUBFC_OPCD && xo_E == `SUBFC_XO ) || ( opcd_E == `NEG_OPCD && xo_E == `NEG_XO ) || ( opcd_E == `EXTSB_OPCD && xo_E == `EXTSB_XO ) || ( opcd_E == `ADD_OPCD && xo_E == `ADD_XO ) || ( opcd_E == `ANDC_OPCD && xo_E == `ANDC_XO ) || ( opcd_E == `ORC_OPCD && xo_E == `ORC_XO ) || ( opcd_E == `SUBFZE_OPCD && xo_E == `SUBFZE_XO ) || ( opcd_E == `ADDE_OPCD && xo_E == `ADDE_XO ) || ( opcd_E == `CNTLZW_OPCD && xo_E == `CNTLZW_XO ) || ( opcd_E == `ADDC_OPCD && xo_E == `ADDC_XO ) || ( opcd_E == `ANDI__OPCD ) || ( opcd_E == `RLWNM_OPCD ) || ( opcd_E == `EXTSH_OPCD && xo_E == `EXTSH_XO ) || ( opcd_E == `SUBFME_OPCD && xo_E == `SUBFME_XO ) || ( opcd_E == `SRAW_OPCD && xo_E == `SRAW_XO ) || ( opcd_E == `XOR_OPCD && xo_E == `XOR_XO ) || ( opcd_E == `ADDME_OPCD && xo_E == `ADDME_XO ) || ( opcd_E == `ADDZE_OPCD && xo_E == `ADDZE_XO ) || ( opcd_E == `SUBFE_OPCD && xo_E == `SUBFE_XO ) || ( opcd_E == `NOR_OPCD && xo_E == `NOR_XO ) || ( opcd_E == `SLW_OPCD && xo_E == `SLW_XO ) || ( opcd_E == `OR_OPCD && xo_E == `OR_XO ) || ( opcd_E == `RLWINM_OPCD ) || ( opcd_E == `SRW_OPCD && xo_E == `SRW_XO ) || ( opcd_E == `ADDIC__OPCD ) );
	assign CR_CR_M_wr_grp_2_0 = ( ~flush_M ) && ( ( opcd_M == `AND_OPCD && xo_M == `AND_XO ) || ( opcd_M == `RLWIMI_OPCD ) || ( opcd_M == `NAND_OPCD && xo_M == `NAND_XO ) || ( opcd_M == `SUBF_OPCD && xo_M == `SUBF_XO ) || ( opcd_M == `ANDIS__OPCD ) || ( opcd_M == `SUBFC_OPCD && xo_M == `SUBFC_XO ) || ( opcd_M == `NEG_OPCD && xo_M == `NEG_XO ) || ( opcd_M == `EXTSB_OPCD && xo_M == `EXTSB_XO ) || ( opcd_M == `ADD_OPCD && xo_M == `ADD_XO ) || ( opcd_M == `ANDC_OPCD && xo_M == `ANDC_XO ) || ( opcd_M == `ORC_OPCD && xo_M == `ORC_XO ) || ( opcd_M == `SUBFZE_OPCD && xo_M == `SUBFZE_XO ) || ( opcd_M == `ADDE_OPCD && xo_M == `ADDE_XO ) || ( opcd_M == `CNTLZW_OPCD && xo_M == `CNTLZW_XO ) || ( opcd_M == `ADDC_OPCD && xo_M == `ADDC_XO ) || ( opcd_M == `ANDI__OPCD ) || ( opcd_M == `RLWNM_OPCD ) || ( opcd_M == `EXTSH_OPCD && xo_M == `EXTSH_XO ) || ( opcd_M == `SUBFME_OPCD && xo_M == `SUBFME_XO ) || ( opcd_M == `SRAW_OPCD && xo_M == `SRAW_XO ) || ( opcd_M == `XOR_OPCD && xo_M == `XOR_XO ) || ( opcd_M == `ADDME_OPCD && xo_M == `ADDME_XO ) || ( opcd_M == `ADDZE_OPCD && xo_M == `ADDZE_XO ) || ( opcd_M == `SUBFE_OPCD && xo_M == `SUBFE_XO ) || ( opcd_M == `NOR_OPCD && xo_M == `NOR_XO ) || ( opcd_M == `SLW_OPCD && xo_M == `SLW_XO ) || ( opcd_M == `OR_OPCD && xo_M == `OR_XO ) || ( opcd_M == `RLWINM_OPCD ) || ( opcd_M == `SRW_OPCD && xo_M == `SRW_XO ) || ( opcd_M == `ADDIC__OPCD ) );
	assign CR_CR_W_wr_grp_2_0 = ( ~flush_W ) && ( ( opcd_W == `AND_OPCD && xo_W == `AND_XO ) || ( opcd_W == `RLWIMI_OPCD ) || ( opcd_W == `NAND_OPCD && xo_W == `NAND_XO ) || ( opcd_W == `SUBF_OPCD && xo_W == `SUBF_XO ) || ( opcd_W == `ANDIS__OPCD ) || ( opcd_W == `SUBFC_OPCD && xo_W == `SUBFC_XO ) || ( opcd_W == `NEG_OPCD && xo_W == `NEG_XO ) || ( opcd_W == `EXTSB_OPCD && xo_W == `EXTSB_XO ) || ( opcd_W == `ADD_OPCD && xo_W == `ADD_XO ) || ( opcd_W == `ANDC_OPCD && xo_W == `ANDC_XO ) || ( opcd_W == `ORC_OPCD && xo_W == `ORC_XO ) || ( opcd_W == `SUBFZE_OPCD && xo_W == `SUBFZE_XO ) || ( opcd_W == `ADDE_OPCD && xo_W == `ADDE_XO ) || ( opcd_W == `CNTLZW_OPCD && xo_W == `CNTLZW_XO ) || ( opcd_W == `ADDC_OPCD && xo_W == `ADDC_XO ) || ( opcd_W == `ANDI__OPCD ) || ( opcd_W == `RLWNM_OPCD ) || ( opcd_W == `EXTSH_OPCD && xo_W == `EXTSH_XO ) || ( opcd_W == `SUBFME_OPCD && xo_W == `SUBFME_XO ) || ( opcd_W == `SRAW_OPCD && xo_W == `SRAW_XO ) || ( opcd_W == `XOR_OPCD && xo_W == `XOR_XO ) || ( opcd_W == `ADDME_OPCD && xo_W == `ADDME_XO ) || ( opcd_W == `ADDZE_OPCD && xo_W == `ADDZE_XO ) || ( opcd_W == `SUBFE_OPCD && xo_W == `SUBFE_XO ) || ( opcd_W == `NOR_OPCD && xo_W == `NOR_XO ) || ( opcd_W == `SLW_OPCD && xo_W == `SLW_XO ) || ( opcd_W == `OR_OPCD && xo_W == `OR_XO ) || ( opcd_W == `RLWINM_OPCD ) || ( opcd_W == `SRW_OPCD && xo_W == `SRW_XO ) || ( opcd_W == `ADDIC__OPCD ) );
	assign CR_CR_E_wr_grp_3_0 = ( ~flush_E ) && ( ( opcd_E == `MTCRF_OPCD && xo_E == `MTCRF_XO ) );
	assign CR_CR_M_wr_grp_3_0 = ( ~flush_M ) && ( ( opcd_M == `MTCRF_OPCD && xo_M == `MTCRF_XO ) );
	assign CR_CR_W_wr_grp_3_0 = ( ~flush_W ) && ( ( opcd_W == `MTCRF_OPCD && xo_W == `MTCRF_XO ) );
	assign CR_CR_E_wr_grp_4_0 = ( ~flush_E ) && ( ( opcd_E == `CMPI_OPCD ) || ( opcd_E == `CMPL_OPCD && xo_E == `CMPL_XO ) || ( opcd_E == `CMPLI_OPCD ) || ( opcd_E == `CMP_OPCD && xo_E == `CMP_XO ) );
	assign CR_CR_M_wr_grp_4_0 = ( ~flush_M ) && ( ( opcd_M == `CMPI_OPCD ) || ( opcd_M == `CMPL_OPCD && xo_M == `CMPL_XO ) || ( opcd_M == `CMPLI_OPCD ) || ( opcd_M == `CMP_OPCD && xo_M == `CMP_XO ) );
	assign CR_CR_W_wr_grp_4_0 = ( ~flush_W ) && ( ( opcd_W == `CMPI_OPCD ) || ( opcd_W == `CMPL_OPCD && xo_W == `CMPL_XO ) || ( opcd_W == `CMPLI_OPCD ) || ( opcd_W == `CMP_OPCD && xo_W == `CMP_XO ) );
	assign CR_CR_D_rd_grp_0_0 = ( ~flush_D ) && ( ( opcd_D == `BCLR_OPCD && xo_D == `BCLR_XO ) || ( opcd_D == `BC_OPCD ) || ( opcd_D == `BCCTR_OPCD && xo_D == `BCCTR_XO ) );
	assign CR_CR_E_rd_grp_1_0 = ( ~flush_E ) && ( ( opcd_E == `CRNOR_OPCD && xo_E == `CRNOR_XO ) || ( opcd_E == `CRNOR_OPCD && xo_E == `CRNOR_XO ) || ( opcd_E == `CRAND_OPCD && xo_E == `CRAND_XO ) || ( opcd_E == `CRAND_OPCD && xo_E == `CRAND_XO ) || ( opcd_E == `CRXOR_OPCD && xo_E == `CRXOR_XO ) || ( opcd_E == `CRXOR_OPCD && xo_E == `CRXOR_XO ) );
	assign CR_CR_M_rd_grp_2_0 = ( ~flush_M ) && ( ( opcd_M == `AND_OPCD && xo_M == `AND_XO ) || ( opcd_M == `CRNOR_OPCD && xo_M == `CRNOR_XO ) || ( opcd_M == `RLWIMI_OPCD ) || ( opcd_M == `NAND_OPCD && xo_M == `NAND_XO ) || ( opcd_M == `SUBF_OPCD && xo_M == `SUBF_XO ) || ( opcd_M == `CMPI_OPCD ) || ( opcd_M == `CMPL_OPCD && xo_M == `CMPL_XO ) || ( opcd_M == `ANDIS__OPCD ) || ( opcd_M == `CRAND_OPCD && xo_M == `CRAND_XO ) || ( opcd_M == `CMPLI_OPCD ) || ( opcd_M == `SUBFC_OPCD && xo_M == `SUBFC_XO ) || ( opcd_M == `NEG_OPCD && xo_M == `NEG_XO ) || ( opcd_M == `EXTSB_OPCD && xo_M == `EXTSB_XO ) || ( opcd_M == `ADD_OPCD && xo_M == `ADD_XO ) || ( opcd_M == `ANDC_OPCD && xo_M == `ANDC_XO ) || ( opcd_M == `ORC_OPCD && xo_M == `ORC_XO ) || ( opcd_M == `SUBFZE_OPCD && xo_M == `SUBFZE_XO ) || ( opcd_M == `ADDE_OPCD && xo_M == `ADDE_XO ) || ( opcd_M == `CNTLZW_OPCD && xo_M == `CNTLZW_XO ) || ( opcd_M == `ADDC_OPCD && xo_M == `ADDC_XO ) || ( opcd_M == `ANDI__OPCD ) || ( opcd_M == `RLWNM_OPCD ) || ( opcd_M == `CRXOR_OPCD && xo_M == `CRXOR_XO ) || ( opcd_M == `EXTSH_OPCD && xo_M == `EXTSH_XO ) || ( opcd_M == `SUBFME_OPCD && xo_M == `SUBFME_XO ) || ( opcd_M == `SRAW_OPCD && xo_M == `SRAW_XO ) || ( opcd_M == `XOR_OPCD && xo_M == `XOR_XO ) || ( opcd_M == `ADDME_OPCD && xo_M == `ADDME_XO ) || ( opcd_M == `ADDZE_OPCD && xo_M == `ADDZE_XO ) || ( opcd_M == `SUBFE_OPCD && xo_M == `SUBFE_XO ) || ( opcd_M == `NOR_OPCD && xo_M == `NOR_XO ) || ( opcd_M == `SLW_OPCD && xo_M == `SLW_XO ) || ( opcd_M == `OR_OPCD && xo_M == `OR_XO ) || ( opcd_M == `RLWINM_OPCD ) || ( opcd_M == `SRW_OPCD && xo_M == `SRW_XO ) || ( opcd_M == `SRAWI_OPCD && xo_M == `SRAWI_XO ) || ( opcd_M == `MCRF_OPCD && xo_M == `MCRF_XO ) || ( opcd_M == `ADDIC__OPCD ) || ( opcd_M == `CMP_OPCD && xo_M == `CMP_XO ) );
	assign GPR_rd2_M_wr_grp_0_0 = ( ~flush_M ) && ( ( opcd_M == `MFCR_OPCD && xo_M == `MFCR_XO ) );
	assign GPR_rd2_W_wr_grp_0_0 = ( ~flush_W ) && ( ( opcd_W == `MFCR_OPCD && xo_W == `MFCR_XO ) );
	assign GPR_rd2_M_wr_grp_1_0 = ( ~flush_M ) && ( ( opcd_M == `MFMSR_OPCD && xo_M == `MFMSR_XO ) );
	assign GPR_rd2_W_wr_grp_1_0 = ( ~flush_W ) && ( ( opcd_W == `MFMSR_OPCD && xo_W == `MFMSR_XO ) );
	assign GPR_rd2_M_wr_grp_2_0 = ( ~flush_M ) && ( ( opcd_M == `LHZX_OPCD && xo_M == `LHZX_XO ) );
	assign GPR_rd2_W_wr_grp_2_0 = ( ~flush_W ) && ( ( opcd_W == `LHZX_OPCD && xo_W == `LHZX_XO ) );
	assign GPR_rd2_M_wr_grp_3_0 = ( ~flush_M ) && ( ( opcd_M == `MFSPR_OPCD && xo_M == `MFSPR_XO ) );
	assign GPR_rd2_W_wr_grp_3_0 = ( ~flush_W ) && ( ( opcd_W == `MFSPR_OPCD && xo_W == `MFSPR_XO ) );
	assign GPR_rd2_M_wr_grp_4_0 = ( ~flush_M ) && ( ( opcd_M == `SUBF_OPCD && xo_M == `SUBF_XO ) );
	assign GPR_rd2_W_wr_grp_4_0 = ( ~flush_W ) && ( ( opcd_W == `SUBF_OPCD && xo_W == `SUBF_XO ) );
	assign GPR_rd2_M_wr_grp_4_1 = ( ~flush_M ) && ( ( opcd_M == `AND_OPCD && xo_M == `AND_XO ) );
	assign GPR_rd2_W_wr_grp_4_1 = ( ~flush_W ) && ( ( opcd_W == `AND_OPCD && xo_W == `AND_XO ) );
	assign GPR_rd2_E_rd_grp_0_0 = ( ~flush_E ) && ( ( opcd_E == `STHBRX_OPCD && xo_E == `STHBRX_XO ) );
	assign GPR_rd3_M_wr_grp_0_0 = ( ~flush_M ) && ( ( opcd_M == `MFCR_OPCD && xo_M == `MFCR_XO ) );
	assign GPR_rd3_W_wr_grp_0_0 = ( ~flush_W ) && ( ( opcd_W == `MFCR_OPCD && xo_W == `MFCR_XO ) );
	assign GPR_rd3_M_wr_grp_1_0 = ( ~flush_M ) && ( ( opcd_M == `MFMSR_OPCD && xo_M == `MFMSR_XO ) );
	assign GPR_rd3_W_wr_grp_1_0 = ( ~flush_W ) && ( ( opcd_W == `MFMSR_OPCD && xo_W == `MFMSR_XO ) );
	assign GPR_rd3_M_wr_grp_2_0 = ( ~flush_M ) && ( ( opcd_M == `LHZX_OPCD && xo_M == `LHZX_XO ) );
	assign GPR_rd3_W_wr_grp_2_0 = ( ~flush_W ) && ( ( opcd_W == `LHZX_OPCD && xo_W == `LHZX_XO ) );
	assign GPR_rd3_M_wr_grp_3_0 = ( ~flush_M ) && ( ( opcd_M == `MFSPR_OPCD && xo_M == `MFSPR_XO ) );
	assign GPR_rd3_W_wr_grp_3_0 = ( ~flush_W ) && ( ( opcd_W == `MFSPR_OPCD && xo_W == `MFSPR_XO ) );
	assign GPR_rd3_M_wr_grp_4_0 = ( ~flush_M ) && ( ( opcd_M == `SUBF_OPCD && xo_M == `SUBF_XO ) );
	assign GPR_rd3_W_wr_grp_4_0 = ( ~flush_W ) && ( ( opcd_W == `SUBF_OPCD && xo_W == `SUBF_XO ) );
	assign GPR_rd3_M_wr_grp_4_1 = ( ~flush_M ) && ( ( opcd_M == `AND_OPCD && xo_M == `AND_XO ) );
	assign GPR_rd3_W_wr_grp_4_1 = ( ~flush_W ) && ( ( opcd_W == `AND_OPCD && xo_W == `AND_XO ) );
	assign GPR_rd3_E_rd_grp_0_0 = ( ~flush_E ) && ( ( opcd_E == `AND_OPCD && xo_E == `AND_XO ) );
	assign GPR_rd1_M_wr_grp_0_0 = ( ~flush_M ) && ( ( opcd_M == `MFCR_OPCD && xo_M == `MFCR_XO ) );
	assign GPR_rd1_W_wr_grp_0_0 = ( ~flush_W ) && ( ( opcd_W == `MFCR_OPCD && xo_W == `MFCR_XO ) );
	assign GPR_rd1_M_wr_grp_1_0 = ( ~flush_M ) && ( ( opcd_M == `MFMSR_OPCD && xo_M == `MFMSR_XO ) );
	assign GPR_rd1_W_wr_grp_1_0 = ( ~flush_W ) && ( ( opcd_W == `MFMSR_OPCD && xo_W == `MFMSR_XO ) );
	assign GPR_rd1_M_wr_grp_2_0 = ( ~flush_M ) && ( ( opcd_M == `LHZX_OPCD && xo_M == `LHZX_XO ) );
	assign GPR_rd1_W_wr_grp_2_0 = ( ~flush_W ) && ( ( opcd_W == `LHZX_OPCD && xo_W == `LHZX_XO ) );
	assign GPR_rd1_M_wr_grp_3_0 = ( ~flush_M ) && ( ( opcd_M == `MFSPR_OPCD && xo_M == `MFSPR_XO ) );
	assign GPR_rd1_W_wr_grp_3_0 = ( ~flush_W ) && ( ( opcd_W == `MFSPR_OPCD && xo_W == `MFSPR_XO ) );
	assign GPR_rd1_M_wr_grp_4_0 = ( ~flush_M ) && ( ( opcd_M == `SUBF_OPCD && xo_M == `SUBF_XO ) );
	assign GPR_rd1_W_wr_grp_4_0 = ( ~flush_W ) && ( ( opcd_W == `SUBF_OPCD && xo_W == `SUBF_XO ) );
	assign GPR_rd1_M_wr_grp_4_1 = ( ~flush_M ) && ( ( opcd_M == `AND_OPCD && xo_M == `AND_XO ) );
	assign GPR_rd1_W_wr_grp_4_1 = ( ~flush_W ) && ( ( opcd_W == `AND_OPCD && xo_W == `AND_XO ) );
	assign GPR_rd1_E_rd_grp_0_0 = ( ~flush_E ) && ( ( opcd_E == `AND_OPCD && xo_E == `AND_XO ) );
	assign GPR_rd1_M_rd_grp_1_0 = ( ~flush_M ) && ( ( opcd_M == `STHBRX_OPCD && xo_M == `STHBRX_XO ) );

	/*****     stall assign HDL Code     *****/
	assign flush_F = ( flush_F_r ) || ( ( ~flush_D ) && ( ( opcd_D == `B_OPCD ) || ( opcd_D == `BC_OPCD ) || ( opcd_D == `BCCTR_OPCD ) || ( opcd_D == `BCLR_OPCD ) ) );
	assign flush_D = ( stall_F ) || ( flush_D_r );
	assign flush_E = ( stall_D ) || ( flush_E_r );
	assign flush_M = ( stall_E ) || ( flush_M_r );
	assign flush_W = ( stall_M ) || ( flush_W_r );
	assign PCWr_D = ~( stall_F || stall_D || stall_E || stall_M );

	/*****     always HDL Code     *****/
	/*****    F    *****/

	/*****    D    *****/
	always @( * ) begin
		if ( ~flush_D ) begin
			case ( opcd_D )
				`ADDI_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`ADDIC_OPCD: begin
					SPR_raddr_D_Sel = 4'd1;
					NPCOp_D = `NPCOp_PLUS4;
				end
				`ADDIC__OPCD: begin
					SPR_raddr_D_Sel = 4'd1;
					NPCOp_D = `NPCOp_PLUS4;
				end
				`ADDIS_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`ANDI__OPCD: begin
					SPR_raddr_D_Sel = 4'd1;
					NPCOp_D = `NPCOp_PLUS4;
				end
				`ANDIS__OPCD: begin
					SPR_raddr_D_Sel = 4'd1;
					NPCOp_D = `NPCOp_PLUS4;
				end
				`B_OPCD: begin
					SPR_raddr_D_Sel = 4'd0;
					NPCOp_D = `NPCOp_JUMP;
				end
				`BC_OPCD: begin
					SPR_raddr_D_Sel = 4'd0;
					NPCOp_D = `NPCOp_BRANCH;
				end
				`CMPI_OPCD: begin
					SPR_raddr_D_Sel = 4'd1;
					NPCOp_D = `NPCOp_PLUS4;
				end
				`CMPLI_OPCD: begin
					SPR_raddr_D_Sel = 4'd1;
					NPCOp_D = `NPCOp_PLUS4;
				end
				`LBZ_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`LHA_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`LHZ_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`LWZ_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`ORI_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`ORIS_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`RLWIMI_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`RLWINM_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`RLWNM_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`STB_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`STH_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`STW_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				`SUBFIC_OPCD: begin
					SPR_raddr_D_Sel = 4'd1;
					NPCOp_D = `NPCOp_PLUS4;
				end
				`XORI_OPCD: begin
					NPCOp_D = `NPCOp_PLUS4;
					SPR_raddr_D_Sel = 4'd0;
				end
				6'd31: begin
					case ( xo_D )
						`ADD_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`ADDC_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`ADDE_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`ADDME_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`ADDZE_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`AND_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`ANDC_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`CMP_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`CMPL_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`CNTLZW_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`EXTSB_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`EXTSH_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`LBZX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`LHAX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`LHBRX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`LHZX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`LWBRX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`LWZX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`MFCR_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`MFMSR_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`MFSPR_XO: begin
							SPR_raddr_D_Sel = 4'd2;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`MTCRF_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`MTMSR_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`MTSPR_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`NAND_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`NEG_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`NOR_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`OR_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`ORC_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`SLW_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`SRAW_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`SRAWI_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`SRW_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`STBX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`STHBRX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`STHX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`STWBRX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`STWX_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`SUBF_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`SUBFC_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`SUBFE_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`SUBFME_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`SUBFZE_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						`XOR_XO: begin
							SPR_raddr_D_Sel = 4'd1;
							NPCOp_D = `NPCOp_PLUS4;
						end
						default: begin
							SPR_raddr_D_Sel = 0;
							NPCOp_D = 0;
						end
					endcase
				end
				6'd19: begin
					case ( xo_D )
						`BCCTR_XO: begin
							SPR_raddr_D_Sel = 4'd0;
							NPCOp_D = `NPCOp_CTR;
						end
						`BCLR_XO: begin
							SPR_raddr_D_Sel = 4'd0;
							NPCOp_D = `NPCOp_LR;
						end
						`CRAND_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`CRNOR_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`CRXOR_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						`MCRF_XO: begin
							NPCOp_D = `NPCOp_PLUS4;
							SPR_raddr_D_Sel = 4'd0;
						end
						default: begin
							SPR_raddr_D_Sel = 0;
							NPCOp_D = 0;
						end
					endcase
				end
				default: begin
					SPR_raddr_D_Sel = 0;
					NPCOp_D = 0;
				end
			endcase
		end
		else begin
			SPR_raddr_D_Sel = 0;
			NPCOp_D = 0;
		end
	end // end always

	/*****    E    *****/
	always @( * ) begin
		if ( ~flush_E ) begin
			case ( opcd_E )
				`ADDI_OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADD;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`ADDIC_OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADD;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`ADDIC__OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADD;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`ADDIS_OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_HIGH16;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADD;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`ANDI__OPCD: begin
					ALU_A_E_Sel = 4'd1;
					ExtOp_E = `ExtOp_UNSIGN;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_AND;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`ANDIS__OPCD: begin
					ALU_A_E_Sel = 4'd1;
					ExtOp_E = `ExtOp_HIGH16;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_AND;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`B_OPCD: begin
					ExtOp_E = 1'd0;
					ALUOp_E = 1'd0;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
					ALU_B_E_Sel = 8'd0;
					ALU_A_E_Sel = 4'd0;
				end
				`BC_OPCD: begin
					ExtOp_E = 1'd0;
					ALUOp_E = 1'd0;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
					ALU_B_E_Sel = 8'd0;
					ALU_A_E_Sel = 4'd0;
				end
				`CMPI_OPCD: begin
					ALU_A_E_Sel = 4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_CMP;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`CMPLI_OPCD: begin
					ALU_A_E_Sel = 4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_CMPU;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`LBZ_OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADDU;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`LHA_OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADDU;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`LHZ_OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADDU;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`LWZ_OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADDU;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`ORI_OPCD: begin
					ALU_A_E_Sel = 4'd1;
					ExtOp_E = `ExtOp_UNSIGN;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_OR;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`ORIS_OPCD: begin
					ALU_A_E_Sel = 4'd1;
					ExtOp_E = `ExtOp_HIGH16;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_OR;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`RLWIMI_OPCD: begin
					ALU_A_E_Sel = 4'd1;
					ALU_B_E_Sel = 8'd0;
					ALU_rotn_E_Sel = 2'd0;
					ALUOp_E = `ALUOp_RLIM;
					ExtOp_E = 1'd0;
					CR_ALU_Op_E = 1'd0;
				end
				`RLWINM_OPCD: begin
					ALU_A_E_Sel = 4'd1;
					ALU_rotn_E_Sel = 2'd0;
					ALUOp_E = `ALUOp_RLNM;
					ExtOp_E = 1'd0;
					CR_ALU_Op_E = 1'd0;
					ALU_B_E_Sel = 8'd0;
				end
				`RLWNM_OPCD: begin
					ALU_A_E_Sel = 4'd1;
					ALU_rotn_E_Sel = 2'd1;
					ALUOp_E = `ALUOp_RLNM;
					ExtOp_E = 1'd0;
					CR_ALU_Op_E = 1'd0;
					ALU_B_E_Sel = 8'd0;
				end
				`STB_OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADDU;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`STH_OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADDU;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`STW_OPCD: begin
					ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_ADDU;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`SUBFIC_OPCD: begin
					ALU_A_E_Sel = 4'd0;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_SUBF;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				`XORI_OPCD: begin
					ALU_A_E_Sel = 4'd1;
					ExtOp_E = `ExtOp_SIGNED;
					ALU_B_E_Sel = 8'd2;
					ALUOp_E = `ALUOp_XOR;
					CR_ALU_Op_E = 1'd0;
					ALU_rotn_E_Sel = 2'd0;
				end
				6'd31: begin
					case ( xo_E )
						`ADD_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADD;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`ADDC_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADD;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`ADDE_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDE;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`ADDME_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd4;
							ALUOp_E = `ALUOp_ADDE;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`ADDZE_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd3;
							ALUOp_E = `ALUOp_ADDE;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`AND_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_AND;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`ANDC_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ANDC;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`CMP_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_CMP;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`CMPL_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_CMPU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`CNTLZW_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALUOp_E = `ALUOp_CNTZ;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
						end
						`EXTSB_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALUOp_E = `ALUOp_EXTSB;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
						end
						`EXTSH_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALUOp_E = `ALUOp_EXTSH;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
						end
						`LBZX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`LHAX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`LHBRX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`LHZX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`LWBRX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`LWZX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`MFCR_XO: begin
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`MFMSR_XO: begin
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`MFSPR_XO: begin
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`MTCRF_XO: begin
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`MTMSR_XO: begin
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`MTSPR_XO: begin
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`NAND_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_NAND;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`NEG_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd3;
							ALUOp_E = `ALUOp_SUBF;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`NOR_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_NOR;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`OR_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_OR;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`ORC_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ORC;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`SLW_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd1;
							ALU_rotn_E_Sel = 2'd1;
							ALUOp_E = `ALUOp_SLL;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
						end
						`SRAW_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd1;
							ALU_rotn_E_Sel = 2'd1;
							ALUOp_E = `ALUOp_SRA;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
						end
						`SRAWI_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd3;
							ALU_rotn_E_Sel = 2'd0;
							ALUOp_E = `ALUOp_SRA;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
						end
						`SRW_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd1;
							ALU_rotn_E_Sel = 2'd1;
							ALUOp_E = `ALUOp_SRL;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
						end
						`STBX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`STHBRX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`STHX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`STWBRX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`STWX_XO: begin
							ALU_A_E_Sel = (Instr_E[11:15]==0)?4'd2:4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_ADDU;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`SUBF_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_SUBF;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`SUBFC_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_SUBF;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`SUBFE_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_SUBFE;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`SUBFME_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd4;
							ALUOp_E = `ALUOp_SUBFE;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`SUBFZE_XO: begin
							ALU_A_E_Sel = 4'd0;
							ALU_B_E_Sel = 8'd3;
							ALUOp_E = `ALUOp_SUBFE;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						`XOR_XO: begin
							ALU_A_E_Sel = 4'd1;
							ALU_B_E_Sel = 8'd1;
							ALUOp_E = `ALUOp_XOR;
							ExtOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
						end
						default: begin
							ExtOp_E = 0;
							ALUOp_E = 0;
							CR_ALU_Op_E = 0;
							ALU_rotn_E_Sel = 0;
							ALU_B_E_Sel = 0;
							ALU_A_E_Sel = 0;
						end
					endcase
				end
				6'd19: begin
					case ( xo_E )
						`BCCTR_XO: begin
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`BCLR_XO: begin
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`CRAND_XO: begin
							CR_ALU_Op_E = `CR_ALUOp_AND;
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`CRNOR_XO: begin
							CR_ALU_Op_E = `CR_ALUOp_NOR;
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`CRXOR_XO: begin
							CR_ALU_Op_E = `CR_ALUOp_XOR;
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						`MCRF_XO: begin
							ExtOp_E = 1'd0;
							ALUOp_E = 1'd0;
							CR_ALU_Op_E = 1'd0;
							ALU_rotn_E_Sel = 2'd0;
							ALU_B_E_Sel = 8'd0;
							ALU_A_E_Sel = 4'd0;
						end
						default: begin
							ExtOp_E = 0;
							ALUOp_E = 0;
							CR_ALU_Op_E = 0;
							ALU_rotn_E_Sel = 0;
							ALU_B_E_Sel = 0;
							ALU_A_E_Sel = 0;
						end
					endcase
				end
				default: begin
					ExtOp_E = 0;
					ALUOp_E = 0;
					CR_ALU_Op_E = 0;
					ALU_rotn_E_Sel = 0;
					ALU_B_E_Sel = 0;
					ALU_A_E_Sel = 0;
				end
			endcase
		end
		else begin
			ExtOp_E = 0;
			ALUOp_E = 0;
			CR_ALU_Op_E = 0;
			ALU_rotn_E_Sel = 0;
			ALU_B_E_Sel = 0;
			ALU_A_E_Sel = 0;
		end
	end // end always

	/*****    M    *****/
	always @( * ) begin
		if ( ~flush_M ) begin
			case ( opcd_M )
				`ADDI_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`ADDIC_OPCD: begin
					XERIn_OVWr_M = 1'b0;
					XERIn_CAWr_M = 1'b1;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
				end
				`ADDIC__OPCD: begin
					XERIn_OVWr_M = 1'b0;
					XERIn_CAWr_M = 1'b1;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
				end
				`ADDIS_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`ANDI__OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`ANDIS__OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`B_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`BC_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`CMPI_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`CMPLI_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`LBZ_OPCD: begin
					DMOut_MEOp_M = `DMOut_MEOp_LB;
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`LHA_OPCD: begin
					DMOut_MEOp_M = `DMOut_MEOp_LHA;
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`LHZ_OPCD: begin
					DMOut_MEOp_M = `DMOut_MEOp_LH;
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`LWZ_OPCD: begin
					DMOut_MEOp_M = `DMOut_MEOp_LW;
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`ORI_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`ORIS_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`RLWIMI_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`RLWINM_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`RLWNM_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`STB_OPCD: begin
					DMIn_BEOp_M = `DMIn_BEOp_SB;
					DMWr_M = 1'b1;
					XERIn_OVWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`STH_OPCD: begin
					DMIn_BEOp_M = `DMIn_BEOp_SH;
					DMWr_M = 1'b1;
					XERIn_OVWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`STW_OPCD: begin
					DMIn_BEOp_M = `DMIn_BEOp_SW;
					DMWr_M = 1'b1;
					XERIn_OVWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				`SUBFIC_OPCD: begin
					XERIn_OVWr_M = 1'b0;
					XERIn_CAWr_M = 1'b1;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
				end
				`XORI_OPCD: begin
					XERIn_OVWr_M = 1'd0;
					DMWr_M = 1'd0;
					DMOut_MEOp_M = 1'd0;
					DMIn_BEOp_M = 1'd0;
					XERIn_CAWr_M = 1'd0;
				end
				6'd31: begin
					case ( xo_M )
						`ADD_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`ADDC_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b1;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`ADDE_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b1;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`ADDME_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b1;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`ADDZE_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b1;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`AND_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`ANDC_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`CMP_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`CMPL_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`CNTLZW_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`EXTSB_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`EXTSH_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`LBZX_XO: begin
							DMOut_MEOp_M = `DMOut_MEOp_LB;
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`LHAX_XO: begin
							DMOut_MEOp_M = `DMOut_MEOp_LHA;
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`LHBRX_XO: begin
							DMOut_MEOp_M = `DMOut_MEOp_LHBR;
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`LHZX_XO: begin
							DMOut_MEOp_M = `DMOut_MEOp_LH;
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`LWBRX_XO: begin
							DMOut_MEOp_M = `DMOut_MEOp_LWBR;
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`LWZX_XO: begin
							DMOut_MEOp_M = `DMOut_MEOp_LW;
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`MFCR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`MFMSR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`MFSPR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`MTCRF_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`MTMSR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`MTSPR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`NAND_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`NEG_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b1;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`NOR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`OR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`ORC_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`SLW_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`SRAW_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`SRAWI_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`SRW_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`STBX_XO: begin
							DMIn_BEOp_M = `DMIn_BEOp_SB;
							DMWr_M = 1'b1;
							XERIn_OVWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`STHBRX_XO: begin
							DMIn_BEOp_M = `DMIn_BEOp_SHBR;
							DMWr_M = 1'b1;
							XERIn_OVWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`STHX_XO: begin
							DMIn_BEOp_M = `DMIn_BEOp_SH;
							DMWr_M = 1'b1;
							XERIn_OVWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`STWBRX_XO: begin
							DMIn_BEOp_M = `DMIn_BEOp_SWBR;
							DMWr_M = 1'b1;
							XERIn_OVWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`STWX_XO: begin
							DMIn_BEOp_M = `DMIn_BEOp_SW;
							DMWr_M = 1'b1;
							XERIn_OVWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`SUBF_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b1;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`SUBFC_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b1;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`SUBFE_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b1;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`SUBFME_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b1;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`SUBFZE_XO: begin
							XERIn_OVWr_M = OE_M;
							XERIn_CAWr_M = 1'b1;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
						end
						`XOR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						default: begin
							XERIn_OVWr_M = 0;
							DMWr_M = 0;
							DMOut_MEOp_M = 0;
							DMIn_BEOp_M = 0;
							XERIn_CAWr_M = 0;
						end
					endcase
				end
				6'd19: begin
					case ( xo_M )
						`BCCTR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`BCLR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`CRAND_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`CRNOR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`CRXOR_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						`MCRF_XO: begin
							XERIn_OVWr_M = 1'd0;
							DMWr_M = 1'd0;
							DMOut_MEOp_M = 1'd0;
							DMIn_BEOp_M = 1'd0;
							XERIn_CAWr_M = 1'd0;
						end
						default: begin
							XERIn_OVWr_M = 0;
							DMWr_M = 0;
							DMOut_MEOp_M = 0;
							DMIn_BEOp_M = 0;
							XERIn_CAWr_M = 0;
						end
					endcase
				end
				default: begin
					XERIn_OVWr_M = 0;
					DMWr_M = 0;
					DMOut_MEOp_M = 0;
					DMIn_BEOp_M = 0;
					XERIn_CAWr_M = 0;
				end
			endcase
		end
		else begin
			XERIn_OVWr_M = 0;
			DMWr_M = 0;
			DMOut_MEOp_M = 0;
			DMIn_BEOp_M = 0;
			XERIn_CAWr_M = 0;
		end
	end // end always

	/*****    W    *****/
	always @( * ) begin
		if ( ~flush_W ) begin
			case ( opcd_W )
				`ADDI_OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd0;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`ADDIC_OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd0;
					SPRWr_W = 1'b1;
					SPR_waddr_W_Sel = 4'd2;
					SPRWd_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
				end
				`ADDIC__OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd0;
					CRWr_W = 1'b1;
					CR_BEOp_W = `CR_BEOp_4bits;
					CR_addr_W_Sel = 4'd0;
					CRWd_W_Sel = 8'd2;
					SPRWr_W = 1'b1;
					SPR_waddr_W_Sel = 4'd2;
					SPRWd_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					SPR_LRWr_W = 1'd0;
				end
				`ADDIS_OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd0;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`ANDI__OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd1;
					CRWr_W = 1'b1;
					CR_BEOp_W = `CR_BEOp_4bits;
					CR_addr_W_Sel = 4'd0;
					CRWd_W_Sel = 8'd2;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					SPRWr_W = 1'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`ANDIS__OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd1;
					CRWr_W = 1'b1;
					CR_BEOp_W = `CR_BEOp_4bits;
					CR_addr_W_Sel = 4'd0;
					CRWd_W_Sel = 8'd2;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					SPRWr_W = 1'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`B_OPCD: begin
					SPRWr_W = LK_W;
					SPRWd_W_Sel = 4'd3;
					SPR_waddr_W_Sel = 4'd0;
					GPRWd1_W_Sel = 8'd0;
					MSRWr_W = 1'd0;
					GPRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					GPR_waddr1_W_Sel = 2'd0;
				end
				`BC_OPCD: begin
					SPR_LRWr_W = LK_W;
					SPRWr_W = ~Instr_W[8];
					SPR_waddr_W_Sel = 4'd1;
					SPRWd_W_Sel = 4'd1;
					GPRWd1_W_Sel = 8'd0;
					MSRWr_W = 1'd0;
					GPRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					GPR_waddr1_W_Sel = 2'd0;
				end
				`CMPI_OPCD: begin
					CRWr_W = 1'b1;
					CR_BEOp_W = `CR_BEOp_4bits;
					CR_addr_W_Sel = 4'd1;
					CRWd_W_Sel = 8'd3;
					SPR_waddr_W_Sel = 4'd0;
					GPRWd1_W_Sel = 8'd0;
					MSRWr_W = 1'd0;
					GPRWr_W = 1'd0;
					SPRWr_W = 1'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
					GPR_waddr1_W_Sel = 2'd0;
				end
				`CMPLI_OPCD: begin
					CRWr_W = 1'b1;
					CR_BEOp_W = `CR_BEOp_4bits;
					CR_addr_W_Sel = 4'd1;
					CRWd_W_Sel = 8'd3;
					SPR_waddr_W_Sel = 4'd0;
					GPRWd1_W_Sel = 8'd0;
					MSRWr_W = 1'd0;
					GPRWr_W = 1'd0;
					SPRWr_W = 1'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
					GPR_waddr1_W_Sel = 2'd0;
				end
				`LBZ_OPCD: begin
					GPRWd1_W_Sel = 8'd1;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd0;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`LHA_OPCD: begin
					GPRWd1_W_Sel = 8'd1;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd0;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`LHZ_OPCD: begin
					GPRWd1_W_Sel = 8'd1;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd0;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`LWZ_OPCD: begin
					GPRWd1_W_Sel = 8'd1;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd0;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`ORI_OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd1;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`ORIS_OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd1;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`RLWIMI_OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd1;
					CRWr_W = Rc_W;
					CR_BEOp_W = `CR_BEOp_4bits;
					CR_addr_W_Sel = 4'd0;
					CRWd_W_Sel = 8'd2;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					SPRWr_W = 1'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`RLWINM_OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd1;
					CRWr_W = Rc_W;
					CR_BEOp_W = `CR_BEOp_4bits;
					CR_addr_W_Sel = 4'd0;
					CRWd_W_Sel = 8'd2;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					SPRWr_W = 1'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`RLWNM_OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd1;
					CRWr_W = Rc_W;
					CR_BEOp_W = `CR_BEOp_4bits;
					CR_addr_W_Sel = 4'd0;
					CRWd_W_Sel = 8'd2;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					SPRWr_W = 1'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				`STB_OPCD: begin
					SPR_waddr_W_Sel = 4'd0;
					GPRWd1_W_Sel = 8'd0;
					MSRWr_W = 1'd0;
					GPRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
					GPR_waddr1_W_Sel = 2'd0;
				end
				`STH_OPCD: begin
					SPR_waddr_W_Sel = 4'd0;
					GPRWd1_W_Sel = 8'd0;
					MSRWr_W = 1'd0;
					GPRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
					GPR_waddr1_W_Sel = 2'd0;
				end
				`STW_OPCD: begin
					SPR_waddr_W_Sel = 4'd0;
					GPRWd1_W_Sel = 8'd0;
					MSRWr_W = 1'd0;
					GPRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
					GPR_waddr1_W_Sel = 2'd0;
				end
				`SUBFIC_OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd0;
					SPRWr_W = 1'b1;
					SPR_waddr_W_Sel = 4'd2;
					SPRWd_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
				end
				`XORI_OPCD: begin
					GPRWd1_W_Sel = 8'd2;
					GPRWr_W = 1'b1;
					GPR_waddr1_W_Sel = 2'd1;
					SPR_waddr_W_Sel = 4'd0;
					MSRWr_W = 1'd0;
					CR_BEOp_W = 1'd0;
					SPRWr_W = 1'd0;
					CRWd_W_Sel = 8'd0;
					CRWr_W = 1'd0;
					CR_addr_W_Sel = 4'd0;
					SPR_LRWr_W = 1'd0;
					SPRWd_W_Sel = 4'd0;
				end
				6'd31: begin
					case ( xo_W )
						`ADD_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = OE_W;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`ADDC_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`ADDE_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`ADDME_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`ADDZE_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`AND_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`ANDC_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`CMP_XO: begin
							CRWr_W = 1'b1;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd1;
							CRWd_W_Sel = 8'd3;
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`CMPL_XO: begin
							CRWr_W = 1'b1;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd1;
							CRWd_W_Sel = 8'd3;
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`CNTLZW_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = 1'b1;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`EXTSB_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`EXTSH_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`LBZX_XO: begin
							GPRWd1_W_Sel = 8'd1;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`LHAX_XO: begin
							GPRWd1_W_Sel = 8'd1;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`LHBRX_XO: begin
							GPRWd1_W_Sel = 8'd1;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`LHZX_XO: begin
							GPRWd1_W_Sel = 8'd1;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`LWBRX_XO: begin
							GPRWd1_W_Sel = 8'd1;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`LWZX_XO: begin
							GPRWd1_W_Sel = 8'd1;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`MFCR_XO: begin
							GPRWd1_W_Sel = 8'd4;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`MFMSR_XO: begin
							GPRWd1_W_Sel = 8'd3;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`MFSPR_XO: begin
							GPRWd1_W_Sel = 8'd0;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`MTCRF_XO: begin
							CRWd_W_Sel = 8'd4;
							CRWr_W = 1'b1;
							CR_BEOp_W = `CR_BEOp_32bits;
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`MTMSR_XO: begin
							MSRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							GPRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`MTSPR_XO: begin
							SPRWd_W_Sel = 4'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd3;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`NAND_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`NEG_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`NOR_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`OR_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`ORC_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`SLW_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`SRAW_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`SRAWI_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`SRW_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						`STBX_XO: begin
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`STHBRX_XO: begin
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`STHX_XO: begin
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`STWBRX_XO: begin
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`STWX_XO: begin
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							SPRWr_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`SUBF_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`SUBFC_XO: begin
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`SUBFE_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`SUBFME_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`SUBFZE_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd0;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPRWr_W = 1'b1;
							SPR_waddr_W_Sel = 4'd2;
							SPRWd_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
						end
						`XOR_XO: begin
							GPRWd1_W_Sel = 8'd2;
							GPRWr_W = 1'b1;
							GPR_waddr1_W_Sel = 2'd1;
							CRWr_W = Rc_W;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd0;
							CRWd_W_Sel = 8'd2;
							SPR_waddr_W_Sel = 4'd0;
							MSRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
						end
						default: begin
							SPR_waddr_W_Sel = 0;
							GPRWd1_W_Sel = 0;
							MSRWr_W = 0;
							GPRWr_W = 0;
							CR_BEOp_W = 0;
							SPRWr_W = 0;
							CRWd_W_Sel = 0;
							CRWr_W = 0;
							CR_addr_W_Sel = 0;
							SPR_LRWr_W = 0;
							SPRWd_W_Sel = 0;
							GPR_waddr1_W_Sel = 0;
						end
					endcase
				end
				6'd19: begin
					case ( xo_W )
						`BCCTR_XO: begin
							SPRWr_W = LK_W;
							SPRWd_W_Sel = 4'd3;
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							SPR_LRWr_W = 1'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`BCLR_XO: begin
							SPR_LRWr_W = LK_W;
							SPRWr_W = ~Instr_W[8];
							SPR_waddr_W_Sel = 4'd1;
							SPRWd_W_Sel = 4'd1;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							CR_BEOp_W = 1'd0;
							CRWd_W_Sel = 8'd0;
							CRWr_W = 1'd0;
							CR_addr_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`CRAND_XO: begin
							CRWr_W = 1'b1;
							CR_BEOp_W = `CR_BEOp_1bits;
							CR_addr_W_Sel = 4'd2;
							CRWd_W_Sel = 8'd0;
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`CRNOR_XO: begin
							CRWr_W = 1'b1;
							CR_BEOp_W = `CR_BEOp_1bits;
							CR_addr_W_Sel = 4'd2;
							CRWd_W_Sel = 8'd0;
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`CRXOR_XO: begin
							CRWr_W = 1'b1;
							CR_BEOp_W = `CR_BEOp_1bits;
							CR_addr_W_Sel = 4'd2;
							CRWd_W_Sel = 8'd0;
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						`MCRF_XO: begin
							CRWr_W = 1'b1;
							CR_BEOp_W = `CR_BEOp_4bits;
							CR_addr_W_Sel = 4'd1;
							CRWd_W_Sel = 8'd1;
							SPR_waddr_W_Sel = 4'd0;
							GPRWd1_W_Sel = 8'd0;
							MSRWr_W = 1'd0;
							GPRWr_W = 1'd0;
							SPRWr_W = 1'd0;
							SPR_LRWr_W = 1'd0;
							SPRWd_W_Sel = 4'd0;
							GPR_waddr1_W_Sel = 2'd0;
						end
						default: begin
							SPR_waddr_W_Sel = 0;
							GPRWd1_W_Sel = 0;
							MSRWr_W = 0;
							GPRWr_W = 0;
							CR_BEOp_W = 0;
							SPRWr_W = 0;
							CRWd_W_Sel = 0;
							CRWr_W = 0;
							CR_addr_W_Sel = 0;
							SPR_LRWr_W = 0;
							SPRWd_W_Sel = 0;
							GPR_waddr1_W_Sel = 0;
						end
					endcase
				end
				default: begin
					SPR_waddr_W_Sel = 0;
					GPRWd1_W_Sel = 0;
					MSRWr_W = 0;
					GPRWr_W = 0;
					CR_BEOp_W = 0;
					SPRWr_W = 0;
					CRWd_W_Sel = 0;
					CRWr_W = 0;
					CR_addr_W_Sel = 0;
					SPR_LRWr_W = 0;
					SPRWd_W_Sel = 0;
					GPR_waddr1_W_Sel = 0;
				end
			endcase
		end
		else begin
			SPR_waddr_W_Sel = 0;
			GPRWd1_W_Sel = 0;
			MSRWr_W = 0;
			GPRWr_W = 0;
			CR_BEOp_W = 0;
			SPRWr_W = 0;
			CRWd_W_Sel = 0;
			CRWr_W = 0;
			CR_addr_W_Sel = 0;
			SPR_LRWr_W = 0;
			SPRWd_W_Sel = 0;
			GPR_waddr1_W_Sel = 0;
		end
	end // end always

	/*****     hazard always HDL Code    *****/
	always @( * ) begin
		if ( SPR_SPR_E_wr_grp_1_0 ) begin
			if ( SPR_SPR_D_rd_grp_0_0 && ( `CTR_SPRN == `CTR_SPRN ) ) begin
				SPR_SPR_D_Sel = 4'd4;
			end
			else begin
				SPR_SPR_D_Sel = 4'd0;
			end
		end
		else if ( SPR_SPR_E_wr_grp_3_0 ) begin
			if ( SPR_SPR_D_rd_grp_0_0 && ( {Instr_E[16:20],Instr_E[11:15]} == `CTR_SPRN ) ) begin
				SPR_SPR_D_Sel = 4'd9;
			end
			else begin
				SPR_SPR_D_Sel = 4'd0;
			end
		end
		else begin
			SPR_SPR_D_Sel = 4'd0;
		end
		if ( SPR_SPR_M_wr_grp_1_0 ) begin
			if ( SPR_SPR_D_rd_grp_0_0 && ( `CTR_SPRN == `CTR_SPRN ) ) begin
				SPR_SPR_D_Sel = 4'd5;
			end
			else begin
				SPR_SPR_D_Sel = 4'd0;
			end
		end
		else if ( SPR_SPR_M_wr_grp_3_0 ) begin
			if ( SPR_SPR_D_rd_grp_0_0 && ( {Instr_M[16:20],Instr_M[11:15]} == `CTR_SPRN ) ) begin
				SPR_SPR_D_Sel = 4'd10;
			end
			else begin
				SPR_SPR_D_Sel = 4'd0;
			end
		end
		else begin
			SPR_SPR_D_Sel = 4'd0;
		end
		if ( SPR_SPR_W_wr_grp_1_0 ) begin
			if ( SPR_SPR_D_rd_grp_0_0 && ( `CTR_SPRN == `CTR_SPRN ) ) begin
				SPR_SPR_D_Sel = 4'd6;
			end
			else begin
				SPR_SPR_D_Sel = 4'd0;
			end
		end
		else if ( SPR_SPR_W_wr_grp_3_0 ) begin
			if ( SPR_SPR_D_rd_grp_0_0 && ( {Instr_W[16:20],Instr_W[11:15]} == `CTR_SPRN ) ) begin
				SPR_SPR_D_Sel = 4'd11;
			end
			else begin
				SPR_SPR_D_Sel = 4'd0;
			end
		end
		else begin
			SPR_SPR_D_Sel = 4'd0;
		end
	end // end always

	always @( * ) begin
		if ( SPR_SPR_E_wr_grp_2_0 ) begin
			if ( SPR_SPR_E_rd_grp_1_0 && ( `XER_SPRN == `XER_SPRN ) ) begin
				SPR_SPR_E_Sel = 4'd7;
			end
			else begin
				SPR_SPR_E_Sel = 4'd0;
			end
		end
		else if ( SPR_SPR_E_wr_grp_3_0 ) begin
			if ( SPR_SPR_E_rd_grp_1_0 && ( {Instr_M[16:20],Instr_M[11:15]} == `XER_SPRN ) ) begin
				SPR_SPR_E_Sel = 4'd10;
			end
			else begin
				SPR_SPR_E_Sel = 4'd0;
			end
		end
		else begin
			SPR_SPR_E_Sel = 4'd0;
		end
		if ( SPR_SPR_M_wr_grp_2_0 ) begin
			if ( SPR_SPR_E_rd_grp_1_0 && ( `XER_SPRN == `XER_SPRN ) ) begin
				SPR_SPR_E_Sel = 4'd8;
			end
			else begin
				SPR_SPR_E_Sel = 4'd0;
			end
		end
		else if ( SPR_SPR_M_wr_grp_3_0 ) begin
			if ( SPR_SPR_E_rd_grp_1_0 && ( {Instr_W[16:20],Instr_W[11:15]} == `XER_SPRN ) ) begin
				SPR_SPR_E_Sel = 4'd11;
			end
			else begin
				SPR_SPR_E_Sel = 4'd0;
			end
		end
		else begin
			SPR_SPR_E_Sel = 4'd0;
		end
	end // end always

	always @( * ) begin
		if ( SPR_SPR_E_wr_grp_2_0 ) begin
			if ( SPR_SPR_M_rd_grp_2_0 && ( `XER_SPRN == `XER_SPRN ) ) begin
				SPR_SPR_M_Sel = 4'd8;
			end
			else begin
				SPR_SPR_M_Sel = 4'd0;
			end
		end
		else if ( SPR_SPR_E_wr_grp_3_0 ) begin
			if ( SPR_SPR_M_rd_grp_2_0 && ( {Instr_W[16:20],Instr_W[11:15]} == `XER_SPRN ) ) begin
				SPR_SPR_M_Sel = 4'd11;
			end
			else begin
				SPR_SPR_M_Sel = 4'd0;
			end
		end
		else begin
			SPR_SPR_M_Sel = 4'd0;
		end
	end // end always

	always @( * ) begin
		if ( CR_CR_E_wr_grp_3_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd7;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else begin
			CR_CR_D_Sel = 4'd0;
		end
		if ( CR_CR_M_wr_grp_0_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd1;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else if ( CR_CR_M_wr_grp_1_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd3;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else if ( CR_CR_M_wr_grp_2_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd5;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else if ( CR_CR_M_wr_grp_3_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd8;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else if ( CR_CR_M_wr_grp_4_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd10;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else begin
			CR_CR_D_Sel = 4'd0;
		end
		if ( CR_CR_W_wr_grp_0_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd2;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else if ( CR_CR_W_wr_grp_1_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd4;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else if ( CR_CR_W_wr_grp_2_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd6;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else if ( CR_CR_W_wr_grp_3_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd9;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else if ( CR_CR_W_wr_grp_4_0 ) begin
			if ( CR_CR_D_rd_grp_0_0 ) begin
				CR_CR_D_Sel = 4'd11;
			end
			else begin
				CR_CR_D_Sel = 4'd0;
			end
		end
		else begin
			CR_CR_D_Sel = 4'd0;
		end
	end // end always

	always @( * ) begin
		if ( CR_CR_E_wr_grp_0_0 ) begin
			if ( CR_CR_E_rd_grp_1_0 ) begin
				CR_CR_E_Sel = 4'd1;
			end
			else begin
				CR_CR_E_Sel = 4'd0;
			end
		end
		else if ( CR_CR_E_wr_grp_1_0 ) begin
			if ( CR_CR_E_rd_grp_1_0 ) begin
				CR_CR_E_Sel = 4'd3;
			end
			else begin
				CR_CR_E_Sel = 4'd0;
			end
		end
		else if ( CR_CR_E_wr_grp_2_0 ) begin
			if ( CR_CR_E_rd_grp_1_0 ) begin
				CR_CR_E_Sel = 4'd5;
			end
			else begin
				CR_CR_E_Sel = 4'd0;
			end
		end
		else if ( CR_CR_E_wr_grp_3_0 ) begin
			if ( CR_CR_E_rd_grp_1_0 ) begin
				CR_CR_E_Sel = 4'd8;
			end
			else begin
				CR_CR_E_Sel = 4'd0;
			end
		end
		else if ( CR_CR_E_wr_grp_4_0 ) begin
			if ( CR_CR_E_rd_grp_1_0 ) begin
				CR_CR_E_Sel = 4'd10;
			end
			else begin
				CR_CR_E_Sel = 4'd0;
			end
		end
		else begin
			CR_CR_E_Sel = 4'd0;
		end
		if ( CR_CR_M_wr_grp_0_0 ) begin
			if ( CR_CR_E_rd_grp_1_0 ) begin
				CR_CR_E_Sel = 4'd2;
			end
			else begin
				CR_CR_E_Sel = 4'd0;
			end
		end
		else if ( CR_CR_M_wr_grp_1_0 ) begin
			if ( CR_CR_E_rd_grp_1_0 ) begin
				CR_CR_E_Sel = 4'd4;
			end
			else begin
				CR_CR_E_Sel = 4'd0;
			end
		end
		else if ( CR_CR_M_wr_grp_2_0 ) begin
			if ( CR_CR_E_rd_grp_1_0 ) begin
				CR_CR_E_Sel = 4'd6;
			end
			else begin
				CR_CR_E_Sel = 4'd0;
			end
		end
		else if ( CR_CR_M_wr_grp_3_0 ) begin
			if ( CR_CR_E_rd_grp_1_0 ) begin
				CR_CR_E_Sel = 4'd9;
			end
			else begin
				CR_CR_E_Sel = 4'd0;
			end
		end
		else if ( CR_CR_M_wr_grp_4_0 ) begin
			if ( CR_CR_E_rd_grp_1_0 ) begin
				CR_CR_E_Sel = 4'd11;
			end
			else begin
				CR_CR_E_Sel = 4'd0;
			end
		end
		else begin
			CR_CR_E_Sel = 4'd0;
		end
	end // end always

	always @( * ) begin
		if ( CR_CR_E_wr_grp_0_0 ) begin
			if ( CR_CR_M_rd_grp_2_0 ) begin
				CR_CR_M_Sel = 4'd2;
			end
			else begin
				CR_CR_M_Sel = 4'd0;
			end
		end
		else if ( CR_CR_E_wr_grp_1_0 ) begin
			if ( CR_CR_M_rd_grp_2_0 ) begin
				CR_CR_M_Sel = 4'd4;
			end
			else begin
				CR_CR_M_Sel = 4'd0;
			end
		end
		else if ( CR_CR_E_wr_grp_2_0 ) begin
			if ( CR_CR_M_rd_grp_2_0 ) begin
				CR_CR_M_Sel = 4'd6;
			end
			else begin
				CR_CR_M_Sel = 4'd0;
			end
		end
		else if ( CR_CR_E_wr_grp_3_0 ) begin
			if ( CR_CR_M_rd_grp_2_0 ) begin
				CR_CR_M_Sel = 4'd9;
			end
			else begin
				CR_CR_M_Sel = 4'd0;
			end
		end
		else if ( CR_CR_E_wr_grp_4_0 ) begin
			if ( CR_CR_M_rd_grp_2_0 ) begin
				CR_CR_M_Sel = 4'd11;
			end
			else begin
				CR_CR_M_Sel = 4'd0;
			end
		end
		else begin
			CR_CR_M_Sel = 4'd0;
		end
	end // end always

	always @( * ) begin
		if ( GPR_rd2_M_wr_grp_0_0 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd1;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd2_M_wr_grp_1_0 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd3;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd2_M_wr_grp_3_0 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd6;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd2_M_wr_grp_4_0 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd8;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd2_M_wr_grp_4_1 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_M[11:15] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd8;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else begin
			GPR_rd2_E_Sel = 4'd0;
		end
		if ( GPR_rd2_W_wr_grp_0_0 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd2;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd2_W_wr_grp_1_0 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd4;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd2_W_wr_grp_2_0 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd5;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd2_W_wr_grp_3_0 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd7;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd2_W_wr_grp_4_0 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd9;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd2_W_wr_grp_4_1 ) begin
			if ( GPR_rd2_E_rd_grp_0_0 && ( Instr_W[11:15] == Instr_E[11:15] ) ) begin
				GPR_rd2_E_Sel = 4'd9;
			end
			else begin
				GPR_rd2_E_Sel = 4'd0;
			end
		end
		else begin
			GPR_rd2_E_Sel = 4'd0;
		end
	end // end always

	always @( * ) begin
		if ( GPR_rd3_M_wr_grp_0_0 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd1;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd3_M_wr_grp_1_0 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd3;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd3_M_wr_grp_3_0 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd6;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd3_M_wr_grp_4_0 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd8;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd3_M_wr_grp_4_1 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_M[11:15] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd8;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else begin
			GPR_rd3_E_Sel = 4'd0;
		end
		if ( GPR_rd3_W_wr_grp_0_0 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd2;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd3_W_wr_grp_1_0 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd4;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd3_W_wr_grp_2_0 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd5;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd3_W_wr_grp_3_0 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd7;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd3_W_wr_grp_4_0 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd9;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd3_W_wr_grp_4_1 ) begin
			if ( GPR_rd3_E_rd_grp_0_0 && ( Instr_W[11:15] == Instr_E[16:20] ) ) begin
				GPR_rd3_E_Sel = 4'd9;
			end
			else begin
				GPR_rd3_E_Sel = 4'd0;
			end
		end
		else begin
			GPR_rd3_E_Sel = 4'd0;
		end
	end // end always

	always @( * ) begin
		if ( GPR_rd1_M_wr_grp_0_0 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd1;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_M_wr_grp_1_0 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd3;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_M_wr_grp_3_0 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd6;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_M_wr_grp_4_0 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd8;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_M_wr_grp_4_1 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_M[11:15] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd8;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else begin
			GPR_rd1_E_Sel = 4'd0;
		end
		if ( GPR_rd1_W_wr_grp_0_0 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd2;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_W_wr_grp_1_0 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd4;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_W_wr_grp_2_0 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd5;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_W_wr_grp_3_0 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd7;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_W_wr_grp_4_0 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_W[6:10] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd9;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_W_wr_grp_4_1 ) begin
			if ( GPR_rd1_E_rd_grp_0_0 && ( Instr_W[11:15] == Instr_E[6:10] ) ) begin
				GPR_rd1_E_Sel = 4'd9;
			end
			else begin
				GPR_rd1_E_Sel = 4'd0;
			end
		end
		else begin
			GPR_rd1_E_Sel = 4'd0;
		end
	end // end always

	always @( * ) begin
		if ( GPR_rd1_M_wr_grp_0_0 ) begin
			if ( GPR_rd1_M_rd_grp_1_0 && ( Instr_W[6:10] == Instr_M[6:10] ) ) begin
				GPR_rd1_M_Sel = 4'd2;
			end
			else begin
				GPR_rd1_M_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_M_wr_grp_1_0 ) begin
			if ( GPR_rd1_M_rd_grp_1_0 && ( Instr_W[6:10] == Instr_M[6:10] ) ) begin
				GPR_rd1_M_Sel = 4'd4;
			end
			else begin
				GPR_rd1_M_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_M_wr_grp_2_0 ) begin
			if ( GPR_rd1_M_rd_grp_1_0 && ( Instr_W[6:10] == Instr_M[6:10] ) ) begin
				GPR_rd1_M_Sel = 4'd5;
			end
			else begin
				GPR_rd1_M_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_M_wr_grp_3_0 ) begin
			if ( GPR_rd1_M_rd_grp_1_0 && ( Instr_W[6:10] == Instr_M[6:10] ) ) begin
				GPR_rd1_M_Sel = 4'd7;
			end
			else begin
				GPR_rd1_M_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_M_wr_grp_4_0 ) begin
			if ( GPR_rd1_M_rd_grp_1_0 && ( Instr_W[6:10] == Instr_M[6:10] ) ) begin
				GPR_rd1_M_Sel = 4'd9;
			end
			else begin
				GPR_rd1_M_Sel = 4'd0;
			end
		end
		else if ( GPR_rd1_W_wr_grp_4_0 ) begin
			if ( GPR_rd1_M_rd_grp_1_0 && ( Instr_W[11:15] == Instr_M[6:10] ) ) begin
				GPR_rd1_M_Sel = 4'd9;
			end
			else begin
				GPR_rd1_M_Sel = 4'd0;
			end
		end
		else begin
			GPR_rd1_M_Sel = 4'd0;
		end
	end // end always


	/*****     stall always HDL Code     *****/
	always @( * ) begin
		stall_F = 1'b0;
	end // end always

	always @( * ) begin
		if ( CR_CR_E_wr_grp_0_0 && CR_CR_D_rd_grp_0_0 ) begin
			stall_D = 1'b1;
		end
		else if ( CR_CR_E_wr_grp_1_0 && CR_CR_D_rd_grp_0_0 ) begin
			stall_D = 1'b1;
		end
		else if ( CR_CR_E_wr_grp_2_0 && CR_CR_D_rd_grp_0_0 ) begin
			stall_D = 1'b1;
		end
		else if ( CR_CR_E_wr_grp_4_0 && CR_CR_D_rd_grp_0_0 ) begin
			stall_D = 1'b1;
		end
		else begin
			stall_D = 1'b0;
		end
	end // end always

	always @( * ) begin
		if ( GPR_rd2_M_wr_grp_2_0 && GPR_rd2_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[11:15] ) ) begin
			stall_E = 1'b1;
		end
		else if ( GPR_rd3_M_wr_grp_2_0 && GPR_rd3_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[16:20] ) ) begin
			stall_E = 1'b1;
		end
		else if ( GPR_rd1_M_wr_grp_2_0 && GPR_rd1_E_rd_grp_0_0 && ( Instr_M[6:10] == Instr_E[6:10] ) ) begin
			stall_E = 1'b1;
		end
		else begin
			stall_E = 1'b0;
		end
	end // end always

	always @( * ) begin
		stall_M = 1'b0;
	end // end always

	always @(posedge clk or negedge rst_n) begin
		if ( !rst_n ) begin
			flush_F_r <= 1'b0;
			flush_D_r <= 1'b0;
			flush_E_r <= 1'b0;
			flush_M_r <= 1'b0;
			flush_W_r <= 1'b0;
		end
		else begin
			flush_F_r <= 1'b0;
			flush_D_r <= flush_F;
			flush_E_r <= flush_D;
			flush_M_r <= flush_E;
			flush_W_r <= flush_M;
		end
	end // end always

	always @( * ) begin
		if ( stall_F || stall_D || stall_E || stall_M ) begin
			pipeRegWr_F = 1'b0;
		end
		else begin
			pipeRegWr_F = 1'b1;
		end
	end // end always

	always @( * ) begin
		if ( stall_D || stall_E || stall_M ) begin
			pipeRegWr_D = 1'b0;
		end
		else begin
			pipeRegWr_D = 1'b1;
		end
	end // end always

	always @( * ) begin
		if ( stall_E || stall_M ) begin
			pipeRegWr_E = 1'b0;
		end
		else begin
			pipeRegWr_E = 1'b1;
		end
	end // end always

	always @( * ) begin
		if ( stall_M ) begin
			pipeRegWr_M = 1'b0;
		end
		else begin
			pipeRegWr_M = 1'b1;
		end
	end // end always


endmodule
