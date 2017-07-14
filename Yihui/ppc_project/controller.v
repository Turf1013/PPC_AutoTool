/**
	\author: 	Trasier
	\date:		2017.7.14
*/

`include "arch_def.v"
`include "ctrl_encode_def.v"
`include "global_def.v"
`include "instruction_def.v"
`include "instruction_format_def.v"
`include "SPR_def.v"

module controller (
	clk, rst_n,
	Instr_D, Instr_E, Instr_MB, Instr_ME, Instr_W,
	BrFlush_D, SPR_raddr0_D_Pmux_sel_D, MDU_B_E_Pmux_sel_E, ALU_B_E_Pmux_sel_E,
	ALU_AIn_din_E_Pmux_sel_E, rotnIn_din_E_Pmux_sel_E, ALU_rotn_E_Pmux_sel_E, SPR_waddr0_W_Pmux_sel_W,
	SPR_wd0_W_Pmux_sel_W, GPR_wd0_W_Pmux_sel_W, GPR_waddr0_W_Pmux_sel_W, NPC_Op_D,
	Ext_Op_E, cmpALU_Op_E, ALU_Op_E, CR_MOVE_Op_E,
	ALU_AIn_Op_E, MDU_Op_E, CR_ALU_Op_E, DM_wr_ME,
	DMOut_ME_Op_ME, DMIn_BE_Op_ME, CR_wr_W, SPR_wr0_W,
	GPR_wr1_W, GPR_wr0_W, SPR_wr1_W, MSR_wr_W,
	valid_FE, valid_FB, valid_D, valid_E, valid_MB, valid_ME, valid_W,
	PCWr
);

	input clk, rst_n;
	input [0:`INSTR_WIDTH-1] Instr_D, Instr_E, Instr_MB, Instr_ME, Instr_W;
	output valid_FE, valid_FB, valid_D, valid_E, valid_MB, valid_ME, valid_W;
	output [0:0] BrFlush_D;
	output [0:0] SPR_raddr0_D_Pmux_sel_D;
	output [0:0] MDU_B_E_Pmux_sel_E;
	output [2:0] ALU_B_E_Pmux_sel_E;
	output [0:0] ALU_AIn_din_E_Pmux_sel_E;
	output [0:0] rotnIn_din_E_Pmux_sel_E;
	output [0:0] ALU_rotn_E_Pmux_sel_E;
	output [0:0] SPR_waddr0_W_Pmux_sel_W;
	output [0:0] SPR_wd0_W_Pmux_sel_W;
	output [2:0] GPR_wd0_W_Pmux_sel_W;
	output [0:0] GPR_waddr0_W_Pmux_sel_W;
	output [0:`NPCOp_WIDTH-1] NPC_Op_D;
	output [0:`ExtOp_WIDTH-1] Ext_Op_E;
	output [0:`cmpALUOp_WIDTH-1] cmpALU_Op_E;
	output [0:`ALUOp_WIDTH-1] ALU_Op_E;
	output [0:`CR_MOVEOp_WIDTH-1] CR_MOVE_Op_E;
	output [0:`ALU_AInOp_WIDTH-1] ALU_AIn_Op_E;
	output [0:`MDUOp_WIDTH-1] MDU_Op_E;
	output [0:`CR_ALUOp_WIDTH-1] CR_ALU_Op_E;
	output [0:0] DM_wr_ME;
	output [0:`DMOut_MEOp_WIDTH-1] DMOut_ME_Op_ME;
	output [0:`DMIn_BEOp_WIDTH-1] DMIn_BE_Op_ME;
	output [0:0] CR_wr_W;
	output [0:0] SPR_wr0_W;
	output [0:0] SPR_wr1_W;
	output [0:0] GPR_wr1_W;
	output [0:0] GPR_wr0_W;
	output [0:0] MSR_wr_W;
	output [0:0] PCWr;
	
	
	reg valid_FE, valid_FB, valid_D, valid_E, valid_MB, valid_ME, valid_W;
	wire validInsn_D, validInsn_E, validInsn_MB, validInsn_ME, validInsn_W;
	
	assign validInsn_D = valid_D && (Instr_D != `NOP);
	assign validInsn_E = valid_E && (Instr_E != `NOP);
	assign validInsn_MB = valid_MB && (Instr_MB != `NOP);
	assign validInsn_ME = valid_ME && (Instr_ME != `NOP);
	assign validInsn_W = valid_W && (Instr_W != `NOP);
	
	// control signals
	/*********   Logic of BrFlush_D   *********/
	assign BrFlush_D = 	validInsn_D && (
						(Instr_D`OPCD == `BCLR_OPCD && Instr_D`XLXO == `BCLR_XLXO) ||
						(Instr_D`OPCD == `BCCTR_OPCD && Instr_D`XLXO == `BCCTR_XLXO) ||
						(Instr_D`OPCD == `B_OPCD) ||
						(Instr_D`OPCD == `BC_OPCD) ||
						(Instr_D`OPCD == `SC_OPCD) ||
						(Instr_D`OPCD == `RFI_OPCD && Instr_D`XLXO == `RFI_XLXO) ||
						(Instr_D`OPCD == `TW_OPCD && Instr_D`XXO == `TW_XXO ) ||
						(Instr_D`OPCD == `TWI_OPCD)
						);
				
				
	/*********   Logic of SPR_raddr0_D_Pmux_sel_D   *********/
	assign SPR_raddr0_D_Pmux_sel_D = 	(Instr_D`OPCD == `MFSPR_OPCD && Instr_D`XFXXO == `MFSPR_XFXXO) ? 1'd0 :
										1'd1;
										// (Instr_D`OPCD == `BCCTR_OPCD && Instr_D`XLXO == `BCCTR_XLXO) ? 1'd1 : 
										// (Instr_D`OPCD == `BC_OPCD) ? 1'd1 : 
										// (Instr_D`OPCD == `BCLR_OPCD && Instr_D`XLXO == `BCLR_XLXO) ? 1'd1 : 
										// 1'd0;
	
	
	
	/*********   Logic of MDU_B_E_Pmux_sel_E   *********/
	assign MDU_B_E_Pmux_sel_E =	(Instr_E`OPCD == `MULLI_OPCD) ? 1'd1 : 1'd0;
	
	
	
	/*********   Logic of ALU_B_E_Pmux_sel_E   *********/
	assign ALU_B_E_Pmux_sel_E = (~validInsn_E) ? 3'd0 :
								((Instr_E`OPCD == `STWBRX_OPCD && Instr_E`XXO == `STWBRX_XXO) || (Instr_E`OPCD == `LHAX_OPCD && Instr_E`XXO == `LHAX_XXO) || (Instr_E`OPCD == `LWZUX_OPCD && Instr_E`XXO == `LWZUX_XXO) || (Instr_E`OPCD == `CMPL_OPCD && Instr_E`XXO == `CMPL_XXO) ||
								 (Instr_E`OPCD == `STHUX_OPCD && Instr_E`XXO == `STHUX_XXO) || (Instr_E`OPCD == `OR_OPCD && Instr_E`XXO == `OR_XXO) || (Instr_E`OPCD == `LHAUX_OPCD && Instr_E`XXO == `LHAUX_XXO) || (Instr_E`OPCD == `ADDE_OPCD && Instr_E`XOXO == `ADDE_XOXO) ||
								 (Instr_E`OPCD == `SUBF_OPCD && Instr_E`XOXO == `SUBF_XOXO) || (Instr_E`OPCD == `EQV_OPCD && Instr_E`XXO == `EQV_XXO) || (Instr_E`OPCD == `STBUX_OPCD && Instr_E`XXO == `STBUX_XXO) || (Instr_E`OPCD == `AND_OPCD && Instr_E`XXO == `AND_XXO) ||
								 (Instr_E`OPCD == `NEG_OPCD && Instr_E`XOXO == `NEG_XOXO) || (Instr_E`OPCD == `STHBRX_OPCD && Instr_E`XXO == `STHBRX_XXO) || (Instr_E`OPCD == `SLW_OPCD && Instr_E`XXO == `SLW_XXO) || (Instr_E`OPCD == `LHBRX_OPCD && Instr_E`XXO == `LHBRX_XXO) ||
								 (Instr_E`OPCD == `NOR_OPCD && Instr_E`XXO == `NOR_XXO) || (Instr_E`OPCD == `LWZX_OPCD && Instr_E`XXO == `LWZX_XXO) || (Instr_E`OPCD == `ANDC_OPCD && Instr_E`XXO == `ANDC_XXO) || (Instr_E`OPCD == `SRW_OPCD && Instr_E`XXO == `SRW_XXO) ||
								 (Instr_E`OPCD == `ADD_OPCD && Instr_E`XOXO == `ADD_XOXO) || (Instr_E`OPCD == `ADDC_OPCD && Instr_E`XOXO == `ADDC_XOXO) || (Instr_E`OPCD == `XOR_OPCD && Instr_E`XXO == `XOR_XXO) || (Instr_E`OPCD == `LHZX_OPCD && Instr_E`XXO == `LHZX_XXO) ||
								 (Instr_E`OPCD == `SRAW_OPCD && Instr_E`XXO == `SRAW_XXO) || (Instr_E`OPCD == `NAND_OPCD && Instr_E`XXO == `NAND_XXO) || (Instr_E`OPCD == `ORC_OPCD && Instr_E`XXO == `ORC_XXO) || ( Instr_E`OPCD == `ORC_OPCD && Instr_E`XXO == `ORC_XXO) ||
								 (Instr_E`OPCD == `LBZUX_OPCD && Instr_E`XXO == `LBZUX_XXO) || (Instr_E`OPCD == `SUBFE_OPCD && Instr_E`XOXO == `SUBFE_XOXO) || (Instr_E`OPCD == `SUBFC_OPCD && Instr_E`XOXO == `SUBFC_XOXO) || (Instr_E`OPCD == `STHX_OPCD && Instr_E`XXO == `STHX_XXO) ||
								 (Instr_E`OPCD == `LBZX_OPCD && Instr_E`XXO == `LBZX_XXO) || (Instr_E`OPCD == `STWX_OPCD && Instr_E`XXO == `STWX_XXO) || (Instr_E`OPCD == `STWUX_OPCD && Instr_E`XXO == `STWUX_XXO) || (Instr_E`OPCD == `STBX_OPCD && Instr_E`XXO == `STBX_XXO)
								) ? 3'd2 : 
								((Instr_E`OPCD == `ADDZE_OPCD && Instr_E`XOXO == `ADDZE_XOXO) || (Instr_E`OPCD == `SUBFZE_OPCD && Instr_E`XOXO == `SUBFZE_XOXO) 
								) ? 3'd0 : 
								((Instr_E`OPCD == `RLWIMI_OPCD)
								) ? 3'd5 :
								((Instr_E`OPCD == `ADDME_OPCD && Instr_E`XOXO == `ADDME_XOXO) || (Instr_E`OPCD == `SUBFME_OPCD && Instr_E`XOXO == `SUBFME_XOXO)
								) ? 3'd1 : 
								((Instr_E`OPCD == `SRAWI_OPCD && Instr_E`XXO == `SRAWI_XXO)
								) ? 3'd3 :
								((Instr_E`OPCD == `LWZU_OPCD) || (Instr_E`OPCD == `ADDI_OPCD) || (Instr_E`OPCD == `STW_OPCD) || (Instr_E`OPCD == `ADDIS_OPCD) ||
								 (Instr_E`OPCD == `CMPLI_OPCD) || (Instr_E`OPCD == `STH_OPCD) || (Instr_E`OPCD == `LBZU_OPCD) || (Instr_E`OPCD == `LHAU_OPCD) ||
								 (Instr_E`OPCD == `STWU_OPCD) || (Instr_E`OPCD == `LWZ_OPCD) || (Instr_E`OPCD == `ANDIS__OPCD) || (Instr_E`OPCD == `LHA_OPCD) || 
								 (Instr_E`OPCD == `ORIS_OPCD) || (Instr_E`OPCD == `ADDIC_OPCD) || (Instr_E`OPCD == `XORIS_OPCD) || (Instr_E`OPCD == `ANDI__OPCD) ||
								 (Instr_E`OPCD == `ORI_OPCD) || (Instr_E`OPCD == `STB_OPCD) || (Instr_E`OPCD == `LHZ_OPCD) || (Instr_E`OPCD == `ADDIC__OPCD) ||
								 (Instr_E`OPCD == `CMPI_OPCD) || (Instr_E`OPCD == `STHU_OPCD) || (Instr_E`OPCD == `LHZU_OPCD) || (Instr_E`OPCD == `STBU_OPCD) ||
								 (Instr_E`OPCD == `LBZ_OPCD) || (Instr_E`OPCD == `SUBFIC_OPCD) || (Instr_E`OPCD == `LWBRX_OPCD && Instr_E`XXO == `LWBRX_XXO) || 
								 (Instr_E`OPCD == `XORI_OPCD) 
								) ? 3'd4 : 
								3'd0;
	
	
	
	/*********   Logic of ALU_AIn_din_E_Pmux_sel_E   *********/
	assign ALU_AIn_din_E_Pmux_sel_E = ((Instr_E`OPCD == `ORC_OPCD && Instr_E`XXO == `ORC_XXO) || ( Instr_E`OPCD == `XOR_OPCD && Instr_E`XXO == `XOR_XXO) || (Instr_E`OPCD == `NEG_OPCD && Instr_E`XOXO == `NEG_XOXO) || (Instr_E`OPCD == `SRAW_OPCD && Instr_E`XXO == `SRAW_XXO) ||
									   (Instr_E`OPCD == `EXTSH_OPCD && Instr_E`XXO == `EXTSH_XXO) || (Instr_E`OPCD == `SRAWI_OPCD && Instr_E`XXO == `SRAWI_XXO) || (Instr_E`OPCD == `RLWNM_OPCD) || (Instr_E`OPCD == `XORIS_OPCD) ||
									   (Instr_E`OPCD == `ANDC_OPCD && Instr_E`XXO == `ANDC_XXO) || (Instr_E`OPCD == `NOR_OPCD && Instr_E`XXO == `NOR_XXO) || (Instr_E`OPCD == `AND_OPCD && Instr_E`XXO == `AND_XXO) || (Instr_E`OPCD == `EQV_OPCD && Instr_E`XXO == `EQV_XXO) ||
									   (Instr_E`OPCD == `ANDI__OPCD) || (Instr_E`OPCD == `RLWIMI_OPCD) || (Instr_E`OPCD == `RLWINM_OPCD) || (Instr_E`OPCD == `EXTSB_OPCD && Instr_E`XXO == `EXTSB_XXO) || 
									   (Instr_E`OPCD == `ORI_OPCD) || (Instr_E`OPCD == `NAND_OPCD && Instr_E`XXO == `NAND_XXO) || (Instr_E`OPCD == `ANDIS__OPCD) || (Instr_E`OPCD == `CNTLZW_OPCD && Instr_E`XXO == `CNTLZW_XXO) ||
									   (Instr_E`OPCD == `ORIS_OPCD) || (Instr_E`OPCD == `SLW_OPCD && Instr_E`XXO == `SLW_XXO) || (Instr_E`OPCD == `XORI_OPCD) || (Instr_E`OPCD == `SRW_OPCD && Instr_E`XXO == `SRW_XXO) || (Instr_E`OPCD == `OR_OPCD && Instr_E`XXO == `OR_XXO)
									  )	? 1'd0 :
									  1'd1;
	
	
	
	/*********   Logic of rotnIn_din_E_Pmux_sel_E   *********/
	assign rotnIn_din_E_Pmux_sel_E = ((Instr_E`OPCD == `RLWNM_OPCD)
									 ) ? 1'd0 :
									 1'd1;
	
	
	
	/*********   Logic of ALU_rotn_E_Pmux_sel_E   *********/
	assign ALU_rotn_E_Pmux_sel_E = ((Instr_E`OPCD == `RLWIMI_OPCD) || (Instr_E`OPCD == `SRAWI_OPCD && Instr_E`XXO == `SRAWI_XXO) || (Instr_E`OPCD == `RLWINM_OPCD)
								   ) ? 1'd0 :
								   1'd1;
	
	
	
	/*********   Logic of SPR_waddr0_W_Pmux_sel_W   *********/
	assign SPR_waddr0_W_Pmux_sel_W = ((Instr_W`OPCD == `MTSPR_OPCD && Instr_W`XFXXO == `MTSPR_XFXXO)
									 ) ? 1'd0 :
									 1'd1;
									 

									 
	/*********   Logic of SPR_wd0_W_Pmux_sel_W   *********/
	assign SPR_wd0_W_Pmux_sel_W = ((Instr_W`OPCD == `MTSPR_OPCD && Instr_W`XFXXO == `MTSPR_XFXXO)
								  ) ? 1'd0 :
								  1'd1;
	
	
	
	/*********   Logic of GPR_wd0_W_Pmux_sel_W   *********/
	assign GPR_wd0_W_Pmux_sel_W = ((Instr_W`OPCD == `EQV_OPCD && Instr_W`XXO == `EQV_XXO) || (Instr_W`OPCD == `ADDIC_OPCD) || (Instr_W`OPCD == `ADDC_OPCD && Instr_W`XOXO == `ADDC_XOXO) || (Instr_W`OPCD == `SLW_OPCD && Instr_W`XXO == `SLW_XXO) ||
								   (Instr_W`OPCD == `SRW_OPCD && Instr_W`XXO == `SRW_XXO) || (Instr_W`OPCD == `ANDC_OPCD && Instr_W`XXO == `ANDC_XXO) || (Instr_W`OPCD == `OR_OPCD && Instr_W`XXO == `OR_XXO) || (Instr_W`OPCD == `SUBFE_OPCD && Instr_W`XOXO == `SUBFE_XOXO) ||
								   (Instr_W`OPCD == `STBU_OPCD) || (Instr_W`OPCD == `ADDZE_OPCD && Instr_W`XOXO == `ADDZE_XOXO) || (Instr_W`OPCD == `ADDME_OPCD && Instr_W`XOXO == `ADDME_XOXO) || (Instr_W`OPCD == `STWUX_OPCD && Instr_W`XXO == `STWUX_XXO) ||
								   (Instr_W`OPCD == `STWU_OPCD) || (Instr_W`OPCD == `ADDE_OPCD && Instr_W`XOXO == `ADDE_XOXO) || (Instr_W`OPCD == `STBUX_OPCD && Instr_W`XXO == `STBUX_XXO) || (Instr_W`OPCD == `ADDIS_OPCD) ||
								   (Instr_W`OPCD == `CNTLZW_OPCD && Instr_W`XXO == `CNTLZW_XXO) || (Instr_W`OPCD == `EXTSB_OPCD && Instr_W`XXO == `EXTSB_XXO) || (Instr_W`OPCD == `NOR_OPCD && Instr_W`XXO == `NOR_XXO) || (Instr_W`OPCD == `ADDIC__OPCD) ||
								   (Instr_W`OPCD == `STHU_OPCD) || (Instr_W`OPCD == `SUBF_OPCD && Instr_W`XOXO == `SUBF_XOXO) || (Instr_W`OPCD == `ADDI_OPCD) || (Instr_W`OPCD == `NEG_OPCD && Instr_W`XOXO == `NEG_XOXO) ||
								   (Instr_W`OPCD == `ORIS_OPCD) || (Instr_W`OPCD == `SUBFME_OPCD && Instr_W`XOXO == `SUBFME_XOXO) || (Instr_W`OPCD == `XORIS_OPCD) || (Instr_W`OPCD == `ADD_OPCD && Instr_W`XOXO == `ADD_XOXO) ||
								   (Instr_W`OPCD == `SRAW_OPCD && Instr_W`XXO == `SRAW_XXO) || (Instr_W`OPCD == `STHUX_OPCD && Instr_W`XXO == `STHUX_XXO) || (Instr_W`OPCD == `XOR_OPCD && Instr_W`XXO == `XOR_XXO) || (Instr_W`OPCD == `AND_OPCD && Instr_W`XXO == `AND_XXO) ||
								   (Instr_W`OPCD == `SUBFIC_OPCD) || (Instr_W`OPCD == `NAND_OPCD && Instr_W`XXO == `NAND_XXO) || (Instr_W`OPCD == `XORI_OPCD) || (Instr_W`OPCD == `ORC_OPCD && Instr_W`XXO == `ORC_XXO) ||
								   (Instr_W`OPCD == `RLWINM_OPCD) || (Instr_W`OPCD == `RLWNM_OPCD) || (Instr_W`OPCD == `SUBFC_OPCD && Instr_W`XOXO == `SUBFC_XOXO) || (Instr_W`OPCD == `SUBFZE_OPCD && Instr_W`XOXO == `SUBFZE_XOXO) ||
								   (Instr_W`OPCD == `ORI_OPCD) || (Instr_W`OPCD == `ANDIS__OPCD) || (Instr_W`OPCD == `SRAWI_OPCD && Instr_W`XXO == `SRAWI_XXO) || (Instr_W`OPCD == `ANDI__OPCD) ||
								   (Instr_W`OPCD == `RLWIMI_OPCD) || (Instr_W`OPCD == `EXTSH_OPCD && Instr_W`XXO == `EXTSH_XXO)
								  ) ? 3'd0 : 
								  ((Instr_W`OPCD == `DIVWU_OPCD && Instr_W`XOXO == `DIVWU_XOXO) || (Instr_W`OPCD == `MULLW_OPCD && Instr_W`XOXO == `MULLW_XOXO) || (Instr_W`OPCD == `MULHWU_OPCD && Instr_W`XOXO == `MULHWU_XOXO) || (Instr_W`OPCD == `DIVW_OPCD && Instr_W`XOXO == `DIVW_XOXO) ||
								   (Instr_W`OPCD == `MULHW_OPCD && Instr_W`XOXO == `MULHW_XOXO) || (Instr_W`OPCD == `MULLI_OPCD)
								  ) ? 3'd1 : 
								  ((Instr_W`OPCD == `MFMSR_OPCD && Instr_W`XXO == `MFMSR_XXO)
								  ) ? 3'd2 :
								  ((Instr_W`OPCD == `MFCR_OPCD && Instr_W`XLXO == `MFCR_XLXO)
								  ) ? 3'd3 :
								  ((Instr_W`OPCD == `MFSPR_OPCD && Instr_W`XFXXO == `MFSPR_XFXXO)
								  ) ? 3'd4 :
								  ((Instr_W`OPCD == `LBZX_OPCD && Instr_W`XXO == `LBZX_XXO) || (Instr_W`OPCD == `LWZUX_OPCD && Instr_W`XXO == `LWZUX_XXO) || (Instr_W`OPCD == `LWZU_OPCD) || (Instr_W`OPCD == `LHZX_OPCD && Instr_W`XXO == `LHZX_XXO) || 
								   (Instr_W`OPCD == `LBZU_OPCD) || (Instr_W`OPCD == `LHBRX_OPCD && Instr_W`XXO == `LHBRX_XXO) || (Instr_W`OPCD == `LBZ_OPCD) || (Instr_W`OPCD == `LWBRX_OPCD && Instr_W`XXO == `LWBRX_XXO) ||
								   (Instr_W`OPCD == `LHZUX_OPCD && Instr_W`XXO == `LHZUX_XXO) || (Instr_W`OPCD == `LHZU_OPCD) || (Instr_W`OPCD == `LHAX_OPCD && Instr_W`XXO == `LHAX_XXO) || (Instr_W`OPCD == `LHA_OPCD) ||
								   (Instr_W`OPCD == `LWZ_OPCD) || (Instr_W`OPCD == `LHAU_OPCD) || (Instr_W`OPCD == `LHZ_OPCD) || (Instr_W`OPCD == `LHAUX_OPCD && Instr_W`XXO == `LHAUX_XXO) ||
								   (Instr_W`OPCD == `LBZUX_OPCD && Instr_W`XXO == `LBZUX_XXO) || (Instr_W`OPCD == `LWZX_OPCD && Instr_W`XXO == `LWZX_XXO)
								  ) ? 3'd5 :								  
								  3'd0;
								  
								  
	/*********   Logic of GPR_waddr0_W_Pmux_sel_W   *********/
	assign GPR_waddr0_W_Pmux_sel_W = ((Instr_W`OPCD == `XORI_OPCD) || (Instr_W`OPCD == `STWU_OPCD) || (Instr_W`OPCD == `RLWNM_OPCD) || (Instr_W`OPCD == `RLWINM_OPCD) ||
									  (Instr_W`OPCD == `ANDIS__OPCD) || (Instr_W`OPCD == `SRAWI_OPCD && Instr_W`XXO == `SRAWI_XXO) || (Instr_W`OPCD == `NEG_OPCD && Instr_W`XOXO == `NEG_XOXO) || (Instr_W`OPCD == `EQV_OPCD && Instr_W`XXO == `EQV_XXO) ||
									  (Instr_W`OPCD == `STWUX_OPCD && Instr_W`XXO == `STWUX_XXO) || (Instr_W`OPCD == `EXTSH_OPCD && Instr_W`XXO == `EXTSH_XXO) || (Instr_W`OPCD == `AND_OPCD && Instr_W`XXO == `AND_XXO) || (Instr_W`OPCD == `STHUX_OPCD && Instr_W`XXO == `STHUX_XXO) ||
									  (Instr_W`OPCD == `NAND_OPCD && Instr_W`XXO == `NAND_XXO) || (Instr_W`OPCD == `SRAW_OPCD && Instr_W`XXO == `SRAW_XXO) || (Instr_W`OPCD == `RLWIMI_OPCD) || (Instr_W`OPCD == `ANDC_OPCD && Instr_W`XXO == `ANDC_XXO) ||
									  (Instr_W`OPCD == `SRW_OPCD && Instr_W`XXO == `SRW_XXO) || (Instr_W`OPCD == `ORIS_OPCD) || (Instr_W`OPCD == `SLW_OPCD && Instr_W`XXO == `SLW_XXO) || (Instr_W`OPCD == `XOR_OPCD && Instr_W`XXO == `XOR_XXO) ||
									  (Instr_W`OPCD == `ORI_OPCD) || (Instr_W`OPCD == `CNTLZW_OPCD && Instr_W`XXO == `CNTLZW_XXO) || (Instr_W`OPCD == `STBUX_OPCD && Instr_W`XXO == `STBUX_XXO) || (Instr_W`OPCD == `NOR_OPCD && Instr_W`XXO == `NOR_XXO) ||
									  (Instr_W`OPCD == `ORC_OPCD && Instr_W`XXO == `ORC_XXO) || (Instr_W`OPCD == `XORIS_OPCD) || (Instr_W`OPCD == `ANDI__OPCD) || (Instr_W`OPCD == `STBU_OPCD) ||
									  (Instr_W`OPCD == `OR_OPCD && Instr_W`XXO == `OR_XXO) || (Instr_W`OPCD == `EXTSB_OPCD && Instr_W`XXO == `EXTSB_XXO) || (Instr_W`OPCD == `STHU_OPCD)
								     ) ? 1'd1 :
									 1'd0;
	
	
	
	/*********   Logic of NPC_Op_D   *********/
	assign NPC_Op_D = ((Instr_D`OPCD == `BC_OPCD)
					  ) ? `NPCOp_BC :
					  ((Instr_D`OPCD == `BCCTR_OPCD && Instr_D`XLXO == `BCCTR_XLXO)
					  ) ? `NPCOp_BCCTR :
					  ((Instr_D`OPCD == `BCLR_OPCD && Instr_D`XLXO == `BCLR_XLXO)
					  ) ? `NPCOp_BCLR :
					  ((Instr_D`OPCD == `B_OPCD)
					  ) ? `NPCOp_B :
					  `NPCOp_PLUS4;
					  
					  
					  
	/*********   Logic of Ext_Op_E   *********/
	assign Ext_Op_E = ((Instr_E`OPCD == `ORI_OPCD) || (Instr_E`OPCD == `XORI_OPCD) || (Instr_E`OPCD == `CMPLI_OPCD) || (Instr_E`OPCD == `ANDI__OPCD)
					  ) ? `ExtOp_UNSIGN : 
					  ((Instr_E`OPCD == `ANDIS__OPCD) || (Instr_E`OPCD == `ADDIS_OPCD) || (Instr_E`OPCD == `XORIS_OPCD) || (Instr_E`OPCD == `ORIS_OPCD)
					  ) ? `ExtOp_HIGH16 :
					  `ExtOp_SIGNED;
	
	
	/*********   Logic of cmpALU_Op_E   *********/
	assign cmpALU_Op_E = ((Instr_E`OPCD == `CMP_OPCD && Instr_E`XXO == `CMP_XXO) || (Instr_E`OPCD == `CMPI_OPCD)
						 ) ? `cmpALUOp_CMP :
						 ((Instr_E`OPCD == `CMPL_OPCD && Instr_E`XXO == `CMPL_XXO) || (Instr_E`OPCD == `CMPLI_OPCD)
						 ) ? `cmpALUOp_CMPL :
						 `cmpALUOp_NOP;
	
	
	
	/*********   Logic of ALU_Op_E   *********/
	assign ALU_Op_E = ((Instr_E`OPCD == `SUBFC_OPCD && Instr_E`XOXO == `SUBFC_XOXO) || (Instr_E`OPCD == `SUBFIC_OPCD) || (Instr_E`OPCD == `SUBF_OPCD && Instr_E`XOXO == `SUBF_XOXO)
					  ) ? `ALUOp_SUBF :
					  ((Instr_E`OPCD == `XOR_OPCD && Instr_E`XXO == `XOR_XXO) || (Instr_E`OPCD == `XORIS_OPCD) || (Instr_E`OPCD == `XORI_OPCD)
					  ) ? `ALUOp_XOR :
					  ((Instr_E`OPCD == `ORIS_OPCD) || (Instr_E`OPCD == `ORI_OPCD) || (Instr_E`OPCD == `OR_OPCD && Instr_E`XXO == `OR_XXO)
					  ) ? `ALUOp_OR :
					  ((Instr_E`OPCD == `ADDZE_OPCD && Instr_E`XOXO == `ADDZE_XOXO) || (Instr_E`OPCD == `ADDE_OPCD && Instr_E`XOXO == `ADDE_XOXO) || (Instr_E`OPCD == `ADDME_OPCD && Instr_E`XOXO == `ADDME_XOXO)
					  ) ? `ALUOp_ADDE :
					  ((Instr_E`OPCD == `SUBFE_OPCD && Instr_E`XOXO == `SUBFE_XOXO) || (Instr_E`OPCD == `SUBFZE_OPCD && Instr_E`XOXO == `SUBFZE_XOXO) || (Instr_E`OPCD == `SUBFME_OPCD && Instr_E`XOXO == `SUBFME_XOXO)
					  ) ? `ALUOp_SUBFE :
					  ((Instr_E`OPCD == `AND_OPCD && Instr_E`XXO == `AND_XXO) || (Instr_E`OPCD == `ANDI__OPCD) || (Instr_E`OPCD == `ANDIS__OPCD)
					  ) ? `ALUOp_AND :
					  ((Instr_E`OPCD == `EQV_OPCD && Instr_E`XXO == `EQV_XXO)
					  ) ? `ALUOp_EQV :
					  ((Instr_E`OPCD == `CNTLZW_OPCD && Instr_E`XXO == `CNTLZW_XXO)
					  ) ? `ALUOp_CNTZ :
					  ((Instr_E`OPCD == `NEG_OPCD && Instr_E`XOXO == `NEG_XOXO)
					  ) ? `ALUOp_NEG :
					  ((Instr_E`OPCD == `SLW_OPCD && Instr_E`XXO == `SLW_XXO)
					  ) ? `ALUOp_SLL :
					  ((Instr_E`OPCD == `SRW_OPCD && Instr_E`XXO == `SRW_XXO)
					  ) ? `ALUOp_SRL :
					  ((Instr_E`OPCD == `SRAWI_OPCD && Instr_E`XXO == `SRAWI_XXO) || (Instr_E`OPCD == `SRAW_OPCD && Instr_E`XXO == `SRAW_XXO)
					  ) ? `ALUOp_SRA :
					  ((Instr_E`OPCD == `RLWINM_OPCD) || (Instr_E`OPCD == `RLWNM_OPCD)
					  ) ? `ALUOp_RLNM :
					  ((Instr_E`OPCD == `RLWIMI_OPCD)
					  ) ? `ALUOp_RLIM :
					  ((Instr_E`OPCD == `EXTSH_OPCD && Instr_E`XXO == `EXTSH_XXO)
					  ) ? `ALUOp_EXTSH :
					  ((Instr_E`OPCD == `EXTSB_OPCD && Instr_E`XXO == `EXTSB_XXO)
					  ) ? `ALUOp_EXTSB :
					  ((Instr_E`OPCD == `ORC_OPCD && Instr_E`XXO == `ORC_XXO)
					  ) ? `ALUOp_ORC :
					  ((Instr_E`OPCD == `NAND_OPCD && Instr_E`XXO == `NAND_XXO)
					  ) ? `ALUOp_NAND :
					  ((Instr_E`OPCD == `ANDC_OPCD && Instr_E`XXO == `ANDC_XXO)
					  ) ? `ALUOp_ANDC :
					  ((Instr_E`OPCD == `NOR_OPCD && Instr_E`XXO == `NOR_XXO)
					  ) ? `ALUOp_NOR :
					  `ALUOp_ADD;
	
	
	
	/*********   Logic of CR_MOVE_Op_E   *********/
	assign CR_MOVE_Op_E = ((Instr_E`OPCD == `MULHWU_OPCD && Instr_E`XOXO == `MULHWU_XOXO) || (Instr_E`OPCD == `MULHW_OPCD && Instr_E`XOXO == `MULHW_XOXO) || (Instr_E`OPCD == `MULLW_OPCD && Instr_E`XOXO == `MULLW_XOXO)
						  ) ? `CR_MOVEOp_MDU0 :
						  ((Instr_E`OPCD == `CMP_OPCD && Instr_E`XXO == `CMP_XXO) || (Instr_E`OPCD == `CMPI_OPCD) || (Instr_E`OPCD == `CMPLI_OPCD)
						  ) ? `CR_MOVEOp_CRX :
						  ((Instr_E`OPCD == `CRNOR_OPCD && Instr_E`XLXO == `CRNOR_XLXO) || (Instr_E`OPCD == `CMPL_OPCD && Instr_E`XXO == `CMPL_XXO) || (Instr_E`OPCD == `CRAND_OPCD && Instr_E`XLXO == `CRAND_XLXO) || (Instr_E`OPCD == `CRXOR_OPCD && Instr_E`XLXO == `CRXOR_XLXO)
						  ) ? `CR_MOVEOp_CAL :
						  ((Instr_E`OPCD == `MCRF_OPCD && Instr_E`XLXO == `MCRF_XLXO)
						  ) ? `CR_MOVEOp_CRF : 
						  ((Instr_E`OPCD == `MTCRF_OPCD && Instr_E`XFXXO == `MTCRF_XFXXO)
						  ) ? `CR_MOVEOp_TCRF : 
						  `CR_MOVEOp_ALU0;
						  
						  
	
	/*********   Logic of ALU_AIn_Op_E   *********/
	assign ALU_AIn_Op_E = ((Instr_E`OPCD == `LHZ_OPCD) || (Instr_E`OPCD == `LHAU_OPCD) || (Instr_E`OPCD == `STHX_OPCD && Instr_E`XXO == `STHX_XXO) || (Instr_E`OPCD == `STHBRX_OPCD && Instr_E`XXO == `STHBRX_XXO) ||
						   (Instr_E`OPCD == `LWZ_OPCD) || (Instr_E`OPCD == `LBZ_OPCD) || (Instr_E`OPCD == `STBU_OPCD) || (Instr_E`OPCD == `LHA_OPCD) ||
						   (Instr_E`OPCD == `STB_OPCD) || (Instr_E`OPCD == `LBZUX_OPCD && Instr_E`XXO == `LBZUX_XXO) || (Instr_E`OPCD == `STWX_OPCD && Instr_E`XXO == `STWX_XXO) || (Instr_E`OPCD == `STBX_OPCD && Instr_E`XXO == `STBX_XXO) ||
						   (Instr_E`OPCD == `STH_OPCD) || (Instr_E`OPCD == `LHAUX_OPCD && Instr_E`XXO == `LHAUX_XXO) || (Instr_E`OPCD == `ADDIS_OPCD) || (Instr_E`OPCD == `STWBRX_OPCD && Instr_E`XXO == `STWBRX_XXO) ||
						   (Instr_E`OPCD == `LWZUX_OPCD && Instr_E`XXO == `LWZUX_XXO) || (Instr_E`OPCD == `STWU_OPCD) || (Instr_E`OPCD == `LHZX_OPCD && Instr_E`XXO == `LHZX_XXO) || (Instr_E`OPCD == `LHBRX_OPCD && Instr_E`XXO == `LHBRX_XXO) ||
						   (Instr_E`OPCD == `LHZUX_OPCD && Instr_E`XXO == `LHZUX_XXO) || (Instr_E`OPCD == `STBUX_OPCD && Instr_E`XXO == `STBUX_XXO) || (Instr_E`OPCD == `LWZU_OPCD) || (Instr_E`OPCD == `ADDIC__OPCD) ||
						   (Instr_E`OPCD == `STHUX_OPCD && Instr_E`XXO == `STHUX_XXO) || (Instr_E`OPCD == `STHU_OPCD) || (Instr_E`OPCD == `STWUX_OPCD && Instr_E`XXO == `STWUX_XXO) || (Instr_E`OPCD == `LBZU_OPCD) ||
						   (Instr_E`OPCD == `ADDI_OPCD) || (Instr_E`OPCD == `STW_OPCD) || (Instr_E`OPCD == `LWZX_OPCD && Instr_E`XXO == `LWZX_XXO) || (Instr_E`OPCD == `LHZU_OPCD) ||
						   (Instr_E`OPCD == `LHAX_OPCD && Instr_E`XXO == `LHAX_XXO) || (Instr_E`OPCD == `LBZX_OPCD && Instr_E`XXO == `LBZX_XXO) || (Instr_E`OPCD == `LWBRX_OPCD && Instr_E`XXO == `LWBRX_XXO)
						  ) ? `ALU_AInOp_ZERO :
						  `ALU_AInOp_NOP;
	
	
	
	/*********   Logic of MDU_Op_E   *********/
	assign MDU_Op_E = ((Instr_E`OPCD == `DIVW_OPCD && Instr_E`XOXO == `DIVW_XOXO)
					  ) ? `MDUOp_DIVW :
					  ((Instr_E`OPCD == `MULHWU_OPCD && Instr_E`XOXO == `MULHWU_XOXO)
					  ) ? `MDUOp_MULHU :
					  ((Instr_E`OPCD == `DIVWU_OPCD && Instr_E`XOXO == `DIVWU_XOXO)
					  ) ? `MDUOp_DIVWU :
					  ((Instr_E`OPCD == `MULHW_OPCD && Instr_E`XOXO == `MULHW_XOXO)
					  ) ? `MDUOp_MULH :
					  `MDUOp_MULW;
					  
					  
					  
	/*********   Logic of CR_ALU_Op_E   *********/	
	assign CR_ALU_Op_E = (Instr_E`OPCD == `CRNOR_OPCD && Instr_E`XLXO == `CRNOR_XLXO) ? `CR_ALUOp_NOR : 
						 (Instr_E`OPCD == `CRNAND_OPCD && Instr_E`XLXO == `CRNAND_XLXO) ? `CR_ALUOp_NAND : 
						 (Instr_E`OPCD == `CREQV_OPCD && Instr_E`XLXO == `CREQV_XLXO) ? `CR_ALUOp_EQV : 
						 (Instr_E`OPCD == `CRAND_OPCD && Instr_E`XLXO == `CRAND_XLXO) ? `CR_ALUOp_AND : 
						 (Instr_E`OPCD == `CRORC_OPCD && Instr_E`XLXO == `CRORC_XLXO) ? `CR_ALUOp_ORC : 
						 (Instr_E`OPCD == `CRXOR_OPCD && Instr_E`XLXO == `CRXOR_XLXO) ? `CR_ALUOp_XOR : 
						 (Instr_E`OPCD == `CRANDC_OPCD && Instr_E`XLXO == `CRANDC_XLXO) ? `CR_ALUOp_ANDC : 
						 (Instr_E`OPCD == `CROR_OPCD && Instr_E`XLXO == `CROR_XLXO) ? `CR_ALUOp_OR :
						 0;
						 
						 
	
	/*********   Logic of DM_wr_ME   *********/
	assign DM_wr_ME = (validInsn_ME) && 
					  ((Instr_ME`OPCD == `STHU_OPCD) || (Instr_ME`OPCD == `STBUX_OPCD && Instr_ME`XXO == `STBUX_XXO) || (Instr_ME`OPCD == `STHUX_OPCD && Instr_ME`XXO == `STHUX_XXO) || (Instr_ME`OPCD == `STWUX_OPCD && Instr_ME`XXO == `STWUX_XXO) ||
					   (Instr_ME`OPCD == `STHBRX_OPCD && Instr_ME`XXO == `STHBRX_XXO) || (Instr_ME`OPCD == `STWBRX_OPCD && Instr_ME`XXO == `STWBRX_XXO) || (Instr_ME`OPCD == `STW_OPCD) || (Instr_ME`OPCD == `STH_OPCD) ||
					   (Instr_ME`OPCD == `STWX_OPCD && Instr_ME`XXO == `STWX_XXO) || (Instr_ME`OPCD == `STBU_OPCD) || (Instr_ME`OPCD == `STHX_OPCD && Instr_ME`XXO == `STHX_XXO) || (Instr_ME`OPCD == `STWU_OPCD) || 
					   (Instr_ME`OPCD == `STBX_OPCD && Instr_ME`XXO == `STBX_XXO) || (Instr_ME`OPCD == `STB_OPCD)
				      );
					  
					  
	
	/*********   Logic of DMOut_ME_Op_ME   *********/
	assign DMOut_ME_Op_ME = ((Instr_ME`OPCD == `LHAUX_OPCD && Instr_ME`XXO == `LHAUX_XXO) || (Instr_ME`OPCD == `LHAX_OPCD && Instr_ME`XXO == `LHAX_XXO) || (Instr_ME`OPCD == `LHAU_OPCD) || (Instr_ME`OPCD == `LHA_OPCD)) ? `DMOut_MEOp_LHA :
							((Instr_ME`OPCD == `LBZX_OPCD && Instr_ME`XXO == `LBZX_XXO) || (Instr_ME`OPCD == `LBZU_OPCD) || (Instr_ME`OPCD == `LBZ_OPCD) || (Instr_ME`OPCD == `LBZUX_OPCD && Instr_ME`XXO == `LBZUX_XXO)) ? `DMOut_MEOp_LB :
							((Instr_ME`OPCD == `LWZU_OPCD) || (Instr_ME`OPCD == `LWZUX_OPCD && Instr_ME`XXO == `LWZUX_XXO) || (Instr_ME`OPCD == `LWZ_OPCD) || (Instr_ME`OPCD == `LWZX_OPCD && Instr_ME`XXO == `LWZX_XXO)) ? `DMOut_MEOp_LW :
							((Instr_ME`OPCD == `LHZUX_OPCD && Instr_ME`XXO == `LHZUX_XXO) || (Instr_ME`OPCD == `LHZ_OPCD) || (Instr_ME`OPCD == `LHZU_OPCD) || (Instr_ME`OPCD == `LHZX_OPCD && Instr_ME`XXO == `LHZX_XXO)) ? `DMOut_MEOp_LH : 
							((Instr_ME`OPCD == `LHBRX_OPCD && Instr_ME`XXO == `LHBRX_XXO)) ? `DMOut_MEOp_LHBR :
							((Instr_ME`OPCD == `LWBRX_OPCD && Instr_ME`XXO == `LWBRX_XXO)) ? `DMOut_MEOp_LWBR :
							0;
							
							
							
	/*********   Logic of DMIn_BE_Op_ME   *********/
	assign DMIn_BE_Op_ME = ((Instr_ME`OPCD == `STWU_OPCD) || (Instr_ME`OPCD == `STW_OPCD) || (Instr_ME`OPCD == `STWX_OPCD && Instr_ME`XXO == `STWX_XXO) || (Instr_ME`OPCD == `STWUX_OPCD && Instr_ME`XXO == `STWUX_XXO)) ? `DMIn_BEOp_SW :
						   ((Instr_ME`OPCD == `STHX_OPCD && Instr_ME`XXO == `STHX_XXO) || (Instr_ME`OPCD == `STH_OPCD) || (Instr_ME`OPCD == `STHU_OPCD) || (Instr_ME`OPCD == `STHUX_OPCD && Instr_ME`XXO == `STHUX_XXO)) ? `DMIn_BEOp_SH :
						   ((Instr_ME`OPCD == `STBUX_OPCD && Instr_ME`XXO == `STBUX_XXO) || (Instr_ME`OPCD == `STBU_OPCD) || (Instr_ME`OPCD == `STB_OPCD) || (Instr_ME`OPCD == `STBX_OPCD && Instr_ME`XXO == `STBX_XXO)) ? `DMIn_BEOp_SB :
						   ((Instr_ME`OPCD == `STHBRX_OPCD && Instr_ME`XXO == `STHBRX_XXO)) ? `DMIn_BEOp_SHBR :
						   ((Instr_ME`OPCD == `STWBRX_OPCD && Instr_ME`XXO == `STWBRX_XXO)) ? `DMIn_BEOp_SWBR :
						   0;
						   
	
	
	/*********   Logic of CR_wr_W   *********/
	assign CR_wr_W = (validInsn_W) &&
					 ((Instr_W[31] && (
					  (Instr_W`OPCD == `XOR_OPCD && Instr_W`XXO == `XOR_XXO) || (Instr_W`OPCD == `DIVWU_OPCD && Instr_W`XOXO == `DIVWU_XOXO) || (Instr_W`OPCD == `SLW_OPCD && Instr_W`XXO == `SLW_XXO) || (Instr_W`OPCD == `OR_OPCD && Instr_W`XXO == `OR_XXO) || 
					  (Instr_W`OPCD == `SRW_OPCD && Instr_W`XXO == `SRW_XXO) || (Instr_W`OPCD == `EXTSB_OPCD && Instr_W`XXO == `EXTSB_XXO) || (Instr_W`OPCD == `MULHW_OPCD && Instr_W`XOXO == `MULHW_XOXO) || (Instr_W`OPCD == `ADDME_OPCD && Instr_W`XOXO == `ADDME_XOXO) ||
					  (Instr_W`OPCD == `NOR_OPCD && Instr_W`XXO == `NOR_XXO) || (Instr_W`OPCD == `MULLW_OPCD && Instr_W`XOXO == `MULLW_XOXO) || (Instr_W`OPCD == `CNTLZW_OPCD && Instr_W`XXO == `CNTLZW_XXO) || (Instr_W`OPCD == `AND_OPCD && Instr_W`XXO == `AND_XXO) ||
					  (Instr_W`OPCD == `DIVW_OPCD && Instr_W`XOXO == `DIVW_XOXO) || (Instr_W`OPCD == `ORC_OPCD && Instr_W`XXO == `ORC_XXO) || (Instr_W`OPCD == `NAND_OPCD && Instr_W`XXO == `NAND_XXO) || (Instr_W`OPCD == `ADDC_OPCD && Instr_W`XOXO == `ADDC_XOXO) ||
					  (Instr_W`OPCD == `ANDC_OPCD && Instr_W`XXO == `ANDC_XXO) || (Instr_W`OPCD == `SUBFC_OPCD && Instr_W`XOXO == `SUBFC_XOXO) || (Instr_W`OPCD == `MULHWU_OPCD && Instr_W`XOXO == `MULHWU_XOXO) || (Instr_W`OPCD == `SUBFME_OPCD && Instr_W`XOXO == `SUBFME_XOXO) ||
					  (Instr_W`OPCD == `SUBFE_OPCD && Instr_W`XOXO == `SUBFE_XOXO) || (Instr_W`OPCD == `RLWNM_OPCD) || (Instr_W`OPCD == `SUBF_OPCD && Instr_W`XOXO == `SUBF_XOXO) || (Instr_W`OPCD == `EXTSH_OPCD && Instr_W`XXO == `EXTSH_XXO) ||
					  (Instr_W`OPCD == `RLWINM_OPCD) || (Instr_W`OPCD == `SUBFZE_OPCD && Instr_W`XOXO == `SUBFZE_XOXO) || (Instr_W`OPCD == `ADDE_OPCD && Instr_W`XOXO == `ADDE_XOXO) || (Instr_W`OPCD == `ADDZE_OPCD && Instr_W`XOXO == `ADDZE_XOXO) ||
					  (Instr_W`OPCD == `NEG_OPCD && Instr_W`XOXO == `NEG_XOXO) || (Instr_W`OPCD == `ADD_OPCD && Instr_W`XOXO == `ADD_XOXO) || (Instr_W`OPCD == `RLWIMI_OPCD) || (Instr_W`OPCD == `SRAWI_OPCD && Instr_W`XXO == `SRAWI_XXO) ||
					  (Instr_W`OPCD == `SRAW_OPCD && Instr_W`XXO == `SRAW_XXO) || (Instr_W`OPCD == `EQV_OPCD && Instr_W`XXO == `EQV_XXO)
					 )) ||
					  (
					  (Instr_W`OPCD == `CRANDC_OPCD && Instr_W`XLXO == `CRANDC_XLXO) || (Instr_W`OPCD == `CMPLI_OPCD) || (Instr_W`OPCD == `CMPI_OPCD) || (Instr_W`OPCD == `ANDIS__OPCD) || 
					  (Instr_W`OPCD == `MTCRF_OPCD && Instr_W`XFXXO == `MTCRF_XFXXO) || (Instr_W`OPCD == `CROR_OPCD && Instr_W`XLXO == `CROR_XLXO) || (Instr_W`OPCD == `CREQV_OPCD && Instr_W`XLXO == `CREQV_XLXO) || (Instr_W`OPCD == `CMPL_OPCD && Instr_W`XXO == `CMPL_XXO) ||
					  (Instr_W`OPCD == `CRORC_OPCD && Instr_W`XLXO == `CRORC_XLXO) || (Instr_W`OPCD == `ADDIC__OPCD) || (Instr_W`OPCD == `CRAND_OPCD && Instr_W`XLXO == `CRAND_XLXO) || (Instr_W`OPCD == `MCRF_OPCD && Instr_W`XLXO == `MCRF_XLXO) ||
					  (Instr_W`OPCD == `ANDI__OPCD) || (Instr_W`OPCD == `CRXOR_OPCD && Instr_W`XLXO == `CRXOR_XLXO) || (Instr_W`OPCD == `CRNAND_OPCD && Instr_W`XLXO == `CRNAND_XLXO) || (Instr_W`OPCD == `CRNOR_OPCD && Instr_W`XLXO == `CRNOR_XLXO) ||
					  (Instr_W`OPCD == `CMP_OPCD && Instr_W`XXO == `CMP_XXO)
					  )
					 );
	
	
	
	/*********   Logic of SPR_wr0_W   *********/
	assign SPR_wr0_W = (validInsn_W) &&
					   ((Instr_W`OPCD == `MTSPR_OPCD && Instr_W`XFXXO == `MTSPR_XFXXO) || (
					    (Instr_W[31]) && (
						(Instr_W`OPCD == `BCCTR_OPCD && Instr_W`XLXO == `BCCTR_XLXO) || (Instr_W`OPCD == `BCLR_OPCD && Instr_W`XLXO == `BCLR_XLXO) || (Instr_W`OPCD == `BC_OPCD) || (Instr_W`OPCD == `B_OPCD))
					   ));
					   
					   
					   
	/*********   Logic of GPR_wr1_W   *********/
	assign GPR_wr1_W = (validInsn_W) && 
					   ((Instr_W`OPCD == `LWZU_OPCD) || (Instr_W`OPCD == `LHAUX_OPCD && Instr_W`XXO == `LHAUX_XXO) || (Instr_W`OPCD == `LHZU_OPCD) || (Instr_W`OPCD == `LWZUX_OPCD && Instr_W`XXO == `LWZUX_XXO) || 
					    (Instr_W`OPCD == `LBZU_OPCD) || (Instr_W`OPCD == `LBZUX_OPCD && Instr_W`XXO == `LBZUX_XXO) || (Instr_W`OPCD == `LHZUX_OPCD && Instr_W`XXO == `LHZUX_XXO) || (Instr_W`OPCD == `LHAU_OPCD)
					   );
					   
	
	
	/*********   Logic of GPR_wr0_W   *********/
	assign GPR_wr0_W = (validInsn_W) && 
					   ((Instr_W`OPCD == `LHAUX_OPCD && Instr_W`XXO == `LHAUX_XXO) || (Instr_W`OPCD == `RLWINM_OPCD) || (Instr_W`OPCD == `LBZUX_OPCD && Instr_W`XXO == `LBZUX_XXO) || (Instr_W`OPCD == `LBZ_OPCD) ||
						(Instr_W`OPCD == `RLWIMI_OPCD) || (Instr_W`OPCD == `LWZUX_OPCD && Instr_W`XXO == `LWZUX_XXO) || (Instr_W`OPCD == `MULLI_OPCD) || (Instr_W`OPCD == `SUBFZE_OPCD && Instr_W`XOXO == `SUBFZE_XOXO) ||
						(Instr_W`OPCD == `MFSPR_OPCD && Instr_W`XFXXO == `MFSPR_XFXXO) || (Instr_W`OPCD == `LHZX_OPCD && Instr_W`XXO == `LHZX_XXO) || (Instr_W`OPCD == `ORIS_OPCD) || (Instr_W`OPCD == `ORC_OPCD && Instr_W`XXO == `ORC_XXO) ||
						(Instr_W`OPCD == `LHZUX_OPCD && Instr_W`XXO == `LHZUX_XXO) || (Instr_W`OPCD == `STHUX_OPCD && Instr_W`XXO == `STHUX_XXO) || (Instr_W`OPCD == `ANDC_OPCD && Instr_W`XXO == `ANDC_XXO) || (Instr_W`OPCD == `SRAW_OPCD && Instr_W`XXO == `SRAW_XXO) || 
						(Instr_W`OPCD == `ORI_OPCD) || (Instr_W`OPCD == `ADDIS_OPCD) || (Instr_W`OPCD == `ADDIC__OPCD) || (Instr_W`OPCD == `MFCR_OPCD && Instr_W`XLXO == `MFCR_XLXO) || 
						(Instr_W`OPCD == `ADDI_OPCD) || (Instr_W`OPCD == `NAND_OPCD && Instr_W`XXO == `NAND_XXO) || (Instr_W`OPCD == `OR_OPCD && Instr_W`XXO == `OR_XXO) || (Instr_W`OPCD == `SUBF_OPCD && Instr_W`XOXO == `SUBF_XOXO) ||
						(Instr_W`OPCD == `ANDI__OPCD) || (Instr_W`OPCD == `MULHW_OPCD && Instr_W`XOXO == `MULHW_XOXO) || (Instr_W`OPCD == `LWZU_OPCD) || (Instr_W`OPCD == `SUBFIC_OPCD) || 
						(Instr_W`OPCD == `STHU_OPCD) || (Instr_W`OPCD == `LWZX_OPCD && Instr_W`XXO == `LWZX_XXO) || (Instr_W`OPCD == `SLW_OPCD && Instr_W`XXO == `SLW_XXO) || (Instr_W`OPCD == `ADDME_OPCD && Instr_W`XOXO == `ADDME_XOXO) || 
						(Instr_W`OPCD == `SRW_OPCD && Instr_W`XXO == `SRW_XXO) || (Instr_W`OPCD == `EXTSB_OPCD && Instr_W`XXO == `EXTSB_XXO) || (Instr_W`OPCD == `MULLW_OPCD && Instr_W`XOXO == `MULLW_XOXO) || (Instr_W`OPCD == `DIVWU_OPCD && Instr_W`XOXO == `DIVWU_XOXO) || 
						(Instr_W`OPCD == `AND_OPCD && Instr_W`XXO == `AND_XXO) || (Instr_W`OPCD == `XORIS_OPCD) || (Instr_W`OPCD == `SUBFE_OPCD && Instr_W`XOXO == `SUBFE_XOXO) || (Instr_W`OPCD == `LBZX_OPCD && Instr_W`XXO == `LBZX_XXO) || 
						(Instr_W`OPCD == `ADDZE_OPCD && Instr_W`XOXO == `ADDZE_XOXO) || (Instr_W`OPCD == `STWUX_OPCD && Instr_W`XXO == `STWUX_XXO) || (Instr_W`OPCD == `MULHWU_OPCD && Instr_W`XOXO == `MULHWU_XOXO) || (Instr_W`OPCD == `LWBRX_OPCD && Instr_W`XXO == `LWBRX_XXO) || 
						(Instr_W`OPCD == `SRAWI_OPCD && Instr_W`XXO == `SRAWI_XXO) || (Instr_W`OPCD == `ANDIS__OPCD) || (Instr_W`OPCD == `EXTSH_OPCD && Instr_W`XXO == `EXTSH_XXO) || (Instr_W`OPCD == `CNTLZW_OPCD && Instr_W`XXO == `CNTLZW_XXO) || 
						(Instr_W`OPCD == `ADDE_OPCD && Instr_W`XOXO == `ADDE_XOXO) || (Instr_W`OPCD == `LHZU_OPCD) || (Instr_W`OPCD == `NOR_OPCD && Instr_W`XXO == `NOR_XXO) || (Instr_W`OPCD == `MFMSR_OPCD && Instr_W`XXO == `MFMSR_XXO) || 
						(Instr_W`OPCD == `ADD_OPCD && Instr_W`XOXO == `ADD_XOXO) || (Instr_W`OPCD == `STWU_OPCD) || (Instr_W`OPCD == `SUBFME_OPCD && Instr_W`XOXO == `SUBFME_XOXO) || (Instr_W`OPCD == `ADDIC_OPCD) || 
						(Instr_W`OPCD == `LHA_OPCD) || (Instr_W`OPCD == `RLWNM_OPCD) || (Instr_W`OPCD == `LWZ_OPCD) || (Instr_W`OPCD == `LHAX_OPCD && Instr_W`XXO == `LHAX_XXO) || 
						(Instr_W`OPCD == `STBUX_OPCD && Instr_W`XXO == `STBUX_XXO) || (Instr_W`OPCD == `LHAU_OPCD) || (Instr_W`OPCD == `LHBRX_OPCD && Instr_W`XXO == `LHBRX_XXO) || (Instr_W`OPCD == `STBU_OPCD) ||
						(Instr_W`OPCD == `ADDC_OPCD && Instr_W`XOXO == `ADDC_XOXO) || (Instr_W`OPCD == `DIVW_OPCD && Instr_W`XOXO == `DIVW_XOXO) || (Instr_W`OPCD == `NEG_OPCD && Instr_W`XOXO == `NEG_XOXO) || (Instr_W`OPCD == `LBZU_OPCD) ||
						(Instr_W`OPCD == `SUBFC_OPCD && Instr_W`XOXO == `SUBFC_XOXO) || (Instr_W`OPCD == `XOR_OPCD && Instr_W`XXO == `XOR_XXO) || (Instr_W`OPCD == `XORI_OPCD) || (Instr_W`OPCD == `LHZ_OPCD) ||
						(Instr_W`OPCD == `EQV_OPCD && Instr_W`XXO == `EQV_XXO)
					   );
			

			
	/*********   Logic of SPR_wr1_W   *********/				   
	assign SPR_wr1_W = (validInsn_W) &&
					   (~Instr_W[8] && ((Instr_W`OPCD == `BC_OPCD) || (Instr_W`OPCD == `BCLR_OPCD && Instr_W`XLXO == `BCLR_XLXO))
					   );
					   
	
	
	/*********   Logic of MSR_wr_W   *********/
	assign MSR_wr_W = (validInsn_W) && (Instr_W`OPCD == `MTMSR_OPCD && Instr_W`XXO == `MTMSR_XXO);
	
	
	
	/*********   Logic of valid_XX   *********/
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			valid_E <= 1'b0;
			valid_MB <= 1'b0;
			valid_ME <= 1'b0;
			valid_W <= 1'b0;
		end
		else begin
			valid_E <= valid_D;
			valid_MB <= valid_E;
			valid_ME <= valid_MB;
			valid_W <= valid_ME;
		end
	end // end always
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			valid_FB <= 1'b0;
		end
		else if (BrFlush_D) begin
			valid_FB <= 1'b1;
		end
		else begin
			valid_FB <= 1'b0;
		end
	end // end always
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			valid_FE <= 1'b0;
		end
		else if (BrFlush_D) begin
			valid_FE <= 1'b1;
		end
		else begin
			valid_FE <= valid_FB;
		end
	end // end always
			
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			valid_D <= 1'b0;
		end
		else begin
			valid_D <= valid_FE;
		end
	end // end always
	
	
	/*********   Logic of PCWr   *********/
	assign PCWr = 1'b1;
	
endmodule
