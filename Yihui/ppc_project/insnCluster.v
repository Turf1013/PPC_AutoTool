/**
	\author: 	Trasier
	\date:		2017.7.16
*/
`include "instruction_def.v"
`include "instruction_format_def.v"
`include "arch_def.v"

module insnCluster (
	instr,
	insnCluster_SPR, insnCluster_MSR, insnCluster_CAL, insnCluster_MDU,
	insnCluster_LGC, insnCluster_LSU, insnCluster_LD, insnCluster_ST,
	insnCluster_CR_MOVE, insnCluster_BR
);

	input [0:`INSTR_WIDTH-1] instr;
	output insnCluster_SPR;
	output insnCluster_MSR;
	output insnCluster_CAL;
	output insnCluster_MDU;
	output insnCluster_CR_MOVE;
	output insnCluster_BR;
	output insnCluster_LGC;
	output insnCluster_LSU;
	output insnCluster_LD;
	output insnCluster_ST;
	
	
	/*********   Logic of instruction flag   *********/
	wire insn_ANDIS_ ; assign insn_ANDIS_ = ( instr`OPCD == `ANDIS__OPCD );
	wire insn_BC     ; assign insn_BC = ( instr`OPCD == `BC_OPCD );
	wire insn_LWZUX  ; assign insn_LWZUX = ( instr`OPCD == `LWZUX_OPCD && instr`XXO == `LWZUX_XXO );
	wire insn_XORI   ; assign insn_XORI = ( instr`OPCD == `XORI_OPCD );
	wire insn_LWARX  ; assign insn_LWARX = ( instr`OPCD == `LWARX_OPCD && instr`XXO == `LWARX_XXO );
	wire insn_MTMSR  ; assign insn_MTMSR = ( instr`OPCD == `MTMSR_OPCD && instr`XXO == `MTMSR_XXO );
	wire insn_ADDIC_ ; assign insn_ADDIC_ = ( instr`OPCD == `ADDIC__OPCD );
	wire insn_LBZX   ; assign insn_LBZX = ( instr`OPCD == `LBZX_OPCD && instr`XXO == `LBZX_XXO );
	wire insn_EXTSB  ; assign insn_EXTSB = ( instr`OPCD == `EXTSB_OPCD && instr`XXO == `EXTSB_XXO );
	wire insn_LBZU   ; assign insn_LBZU = ( instr`OPCD == `LBZU_OPCD );
	wire insn_LBZ    ; assign insn_LBZ = ( instr`OPCD == `LBZ_OPCD );
	wire insn_EXTSH  ; assign insn_EXTSH = ( instr`OPCD == `EXTSH_OPCD && instr`XXO == `EXTSH_XXO );
	wire insn_LHZ    ; assign insn_LHZ = ( instr`OPCD == `LHZ_OPCD );
	wire insn_STHUX  ; assign insn_STHUX = ( instr`OPCD == `STHUX_OPCD && instr`XXO == `STHUX_XXO );
	wire insn_MULHW  ; assign insn_MULHW = ( instr`OPCD == `MULHW_OPCD && instr`XOXO == `MULHW_XOXO );
	wire insn_LHA    ; assign insn_LHA = ( instr`OPCD == `LHA_OPCD );
	wire insn_STDUX  ; assign insn_STDUX = ( instr`OPCD == `STDUX_OPCD && instr`XXO == `STDUX_XXO );
	wire insn_EQV    ; assign insn_EQV = ( instr`OPCD == `EQV_OPCD && instr`XXO == `EQV_XXO );
	wire insn_LHAX   ; assign insn_LHAX = ( instr`OPCD == `LHAX_OPCD && instr`XXO == `LHAX_XXO );
	wire insn_LWBRX  ; assign insn_LWBRX = ( instr`OPCD == `LWBRX_OPCD && instr`XXO == `LWBRX_XXO );
	wire insn_STDX   ; assign insn_STDX = ( instr`OPCD == `STDX_OPCD && instr`XXO == `STDX_XXO );
	wire insn_MTCRF  ; assign insn_MTCRF = ( instr`OPCD == `MTCRF_OPCD && instr`XFXXO == `MTCRF_XFXXO );
	wire insn_STDU   ; assign insn_STDU = ( instr`OPCD == `STDU_OPCD );
	wire insn_MULHWU ; assign insn_MULHWU = ( instr`OPCD == `MULHWU_OPCD && instr`XOXO == `MULHWU_XOXO );
	wire insn_LHBRX  ; assign insn_LHBRX = ( instr`OPCD == `LHBRX_OPCD && instr`XXO == `LHBRX_XXO );
	wire insn_LHAU   ; assign insn_LHAU = ( instr`OPCD == `LHAU_OPCD );
	wire insn_LHZUX  ; assign insn_LHZUX = ( instr`OPCD == `LHZUX_OPCD && instr`XXO == `LHZUX_XXO );
	wire insn_ADDE   ; assign insn_ADDE = ( instr`OPCD == `ADDE_OPCD && instr`XOXO == `ADDE_XOXO );
	wire insn_RLWINM ; assign insn_RLWINM = ( instr`OPCD == `RLWINM_OPCD );
	wire insn_CNTLZW ; assign insn_CNTLZW = ( instr`OPCD == `CNTLZW_OPCD && instr`XXO == `CNTLZW_XXO );
	wire insn_MTSPR  ; assign insn_MTSPR = ( instr`OPCD == `MTSPR_OPCD && instr`XFXXO == `MTSPR_XFXXO );
	wire insn_ADDI   ; assign insn_ADDI = ( instr`OPCD == `ADDI_OPCD );
	wire insn_STHBRX ; assign insn_STHBRX = ( instr`OPCD == `STHBRX_OPCD && instr`XXO == `STHBRX_XXO );
	wire insn_SYNC   ; assign insn_SYNC = ( instr`OPCD == `SYNC_OPCD && instr`XXO == `SYNC_XXO );
	wire insn_LWAX   ; assign insn_LWAX = ( instr`OPCD == `LWAX_OPCD && instr`XXO == `LWAX_XXO );
	wire insn_MFSPR  ; assign insn_MFSPR = ( instr`OPCD == `MFSPR_OPCD && instr`XFXXO == `MFSPR_XFXXO );
	wire insn_CMPI   ; assign insn_CMPI = ( instr`OPCD == `CMPI_OPCD );
	wire insn_SUBFIC ; assign insn_SUBFIC = ( instr`OPCD == `SUBFIC_OPCD );
	wire insn_CMPL   ; assign insn_CMPL = ( instr`OPCD == `CMPL_OPCD && instr`XXO == `CMPL_XXO );
	wire insn_STWCX_ ; assign insn_STWCX_ = ( instr`OPCD == `STWCX__OPCD && instr`XXO == `STWCX__XXO );
	wire insn_CMP    ; assign insn_CMP = ( instr`OPCD == `CMP_OPCD && instr`XXO == `CMP_XXO );
	wire insn_SUBFZE ; assign insn_SUBFZE = ( instr`OPCD == `SUBFZE_OPCD && instr`XOXO == `SUBFZE_XOXO );
	wire insn_LDU    ; assign insn_LDU = ( instr`OPCD == `LDU_OPCD );
	wire insn_ADDC   ; assign insn_ADDC = ( instr`OPCD == `ADDC_OPCD && instr`XOXO == `ADDC_XOXO );
	wire insn_ADDME  ; assign insn_ADDME = ( instr`OPCD == `ADDME_OPCD && instr`XOXO == `ADDME_XOXO );
	wire insn_LDX    ; assign insn_LDX = ( instr`OPCD == `LDX_OPCD && instr`XXO == `LDX_XXO );
	wire insn_LHZX   ; assign insn_LHZX = ( instr`OPCD == `LHZX_OPCD && instr`XXO == `LHZX_XXO );
	wire insn_SRAWI  ; assign insn_SRAWI = ( instr`OPCD == `SRAWI_OPCD && instr`XXO == `SRAWI_XXO );
	wire insn_LHZU   ; assign insn_LHZU = ( instr`OPCD == `LHZU_OPCD );
	wire insn_SUBF   ; assign insn_SUBF = ( instr`OPCD == `SUBF_OPCD && instr`XOXO == `SUBF_XOXO );
	wire insn_STBX   ; assign insn_STBX = ( instr`OPCD == `STBX_OPCD && instr`XXO == `STBX_XXO );
	wire insn_RFI    ; assign insn_RFI = ( instr`OPCD == `RFI_OPCD && instr`XLXO == `RFI_XLXO );
	wire insn_STBU   ; assign insn_STBU = ( instr`OPCD == `STBU_OPCD );
	wire insn_AND    ; assign insn_AND = ( instr`OPCD == `AND_OPCD && instr`XXO == `AND_XXO );
	wire insn_OR     ; assign insn_OR = ( instr`OPCD == `OR_OPCD && instr`XXO == `OR_XXO );
	wire insn_STWUX  ; assign insn_STWUX = ( instr`OPCD == `STWUX_OPCD && instr`XXO == `STWUX_XXO );
	wire insn_LHAUX  ; assign insn_LHAUX = ( instr`OPCD == `LHAUX_OPCD && instr`XXO == `LHAUX_XXO );
	wire insn_WRTEEI ; assign insn_WRTEEI = ( instr`OPCD == `WRTEEI_OPCD && instr`XXO == `WRTEEI_XXO );
	wire insn_NOR    ; assign insn_NOR = ( instr`OPCD == `NOR_OPCD && instr`XXO == `NOR_XXO );
	wire insn_LDUX   ; assign insn_LDUX = ( instr`OPCD == `LDUX_OPCD && instr`XXO == `LDUX_XXO );
	wire insn_BCCTR  ; assign insn_BCCTR = ( instr`OPCD == `BCCTR_OPCD && instr`XLXO == `BCCTR_XLXO );
	wire insn_NEG    ; assign insn_NEG = ( instr`OPCD == `NEG_OPCD && instr`XOXO == `NEG_XOXO );
	wire insn_ORIS   ; assign insn_ORIS = ( instr`OPCD == `ORIS_OPCD );
	wire insn_CROR   ; assign insn_CROR = ( instr`OPCD == `CROR_OPCD && instr`XLXO == `CROR_XLXO );
	wire insn_LWZX   ; assign insn_LWZX = ( instr`OPCD == `LWZX_OPCD && instr`XXO == `LWZX_XXO );
	wire insn_LWZU   ; assign insn_LWZU = ( instr`OPCD == `LWZU_OPCD );
	wire insn_STWU   ; assign insn_STWU = ( instr`OPCD == `STWU_OPCD );
	wire insn_STWX   ; assign insn_STWX = ( instr`OPCD == `STWX_OPCD && instr`XXO == `STWX_XXO );
	wire insn_ANDC   ; assign insn_ANDC = ( instr`OPCD == `ANDC_OPCD && instr`XXO == `ANDC_XXO );
	wire insn_MCRF   ; assign insn_MCRF = ( instr`OPCD == `MCRF_OPCD && instr`XLXO == `MCRF_XLXO );
	wire insn_ANDI_  ; assign insn_ANDI_ = ( instr`OPCD == `ANDI__OPCD );
	wire insn_ADDZE  ; assign insn_ADDZE = ( instr`OPCD == `ADDZE_OPCD && instr`XOXO == `ADDZE_XOXO );
	wire insn_SUBFE  ; assign insn_SUBFE = ( instr`OPCD == `SUBFE_OPCD && instr`XOXO == `SUBFE_XOXO );
	wire insn_XORIS  ; assign insn_XORIS = ( instr`OPCD == `XORIS_OPCD );
	wire insn_B      ; assign insn_B = ( instr`OPCD == `B_OPCD );
	wire insn_DIVWU  ; assign insn_DIVWU = ( instr`OPCD == `DIVWU_OPCD && instr`XOXO == `DIVWU_XOXO );
	wire insn_MULLI  ; assign insn_MULLI = ( instr`OPCD == `MULLI_OPCD );
	wire insn_CRNAND ; assign insn_CRNAND = ( instr`OPCD == `CRNAND_OPCD && instr`XLXO == `CRNAND_XLXO );
	wire insn_RLWIMI ; assign insn_RLWIMI = ( instr`OPCD == `RLWIMI_OPCD );
	wire insn_ADD    ; assign insn_ADD = ( instr`OPCD == `ADD_OPCD && instr`XOXO == `ADD_XOXO );
	wire insn_STBUX  ; assign insn_STBUX = ( instr`OPCD == `STBUX_OPCD && instr`XXO == `STBUX_XXO );
	wire insn_MULLW  ; assign insn_MULLW = ( instr`OPCD == `MULLW_OPCD && instr`XOXO == `MULLW_XOXO );
	wire insn_SRW    ; assign insn_SRW = ( instr`OPCD == `SRW_OPCD && instr`XXO == `SRW_XXO );
	wire insn_DIVW   ; assign insn_DIVW = ( instr`OPCD == `DIVW_OPCD && instr`XOXO == `DIVW_XOXO );
	wire insn_SUBFC  ; assign insn_SUBFC = ( instr`OPCD == `SUBFC_OPCD && instr`XOXO == `SUBFC_XOXO );
	wire insn_CRORC  ; assign insn_CRORC = ( instr`OPCD == `CRORC_OPCD && instr`XLXO == `CRORC_XLXO );
	wire insn_CRAND  ; assign insn_CRAND = ( instr`OPCD == `CRAND_OPCD && instr`XLXO == `CRAND_XLXO );
	wire insn_LMW    ; assign insn_LMW = ( instr`OPCD == `LMW_OPCD );
	wire insn_STHX   ; assign insn_STHX = ( instr`OPCD == `STHX_OPCD && instr`XXO == `STHX_XXO );
	wire insn_ORI    ; assign insn_ORI = ( instr`OPCD == `ORI_OPCD );
	wire insn_SC     ; assign insn_SC = ( instr`OPCD == `SC_OPCD );
	wire insn_STHU   ; assign insn_STHU = ( instr`OPCD == `STHU_OPCD );
	wire insn_ORC    ; assign insn_ORC = ( instr`OPCD == `ORC_OPCD && instr`XXO == `ORC_XXO );
	wire insn_CRANDC ; assign insn_CRANDC = ( instr`OPCD == `CRANDC_OPCD && instr`XLXO == `CRANDC_XLXO );
	wire insn_LWZ    ; assign insn_LWZ = ( instr`OPCD == `LWZ_OPCD );
	wire insn_CMPLI  ; assign insn_CMPLI = ( instr`OPCD == `CMPLI_OPCD );
	wire insn_TWI    ; assign insn_TWI = ( instr`OPCD == `TWI_OPCD );
	wire insn_STMW   ; assign insn_STMW = ( instr`OPCD == `STMW_OPCD );
	wire insn_SUBFME ; assign insn_SUBFME = ( instr`OPCD == `SUBFME_OPCD && instr`XOXO == `SUBFME_XOXO );
	wire insn_STWBRX ; assign insn_STWBRX = ( instr`OPCD == `STWBRX_OPCD && instr`XXO == `STWBRX_XXO );
	wire insn_SRAW   ; assign insn_SRAW = ( instr`OPCD == `SRAW_OPCD && instr`XXO == `SRAW_XXO );
	wire insn_LBZUX  ; assign insn_LBZUX = ( instr`OPCD == `LBZUX_OPCD && instr`XXO == `LBZUX_XXO );
	wire insn_MFMSR  ; assign insn_MFMSR = ( instr`OPCD == `MFMSR_OPCD && instr`XXO == `MFMSR_XXO );
	wire insn_BCLR   ; assign insn_BCLR = ( instr`OPCD == `BCLR_OPCD && instr`XLXO == `BCLR_XLXO );
	wire insn_CRNOR  ; assign insn_CRNOR = ( instr`OPCD == `CRNOR_OPCD && instr`XLXO == `CRNOR_XLXO );
	wire insn_LD     ; assign insn_LD = ( instr`OPCD == `LD_OPCD );
	wire insn_RLWNM  ; assign insn_RLWNM = ( instr`OPCD == `RLWNM_OPCD );
	wire insn_ADDIC  ; assign insn_ADDIC = ( instr`OPCD == `ADDIC_OPCD );
	wire insn_TW     ; assign insn_TW = ( instr`OPCD == `TW_OPCD && instr`XXO == `TW_XXO );
	wire insn_NAND   ; assign insn_NAND = ( instr`OPCD == `NAND_OPCD && instr`XXO == `NAND_XXO );
	wire insn_MFCR   ; assign insn_MFCR = ( instr`OPCD == `MFCR_OPCD && instr`XLXO == `MFCR_XLXO );
	wire insn_ADDIS  ; assign insn_ADDIS = ( instr`OPCD == `ADDIS_OPCD );
	wire insn_LWAUX  ; assign insn_LWAUX = ( instr`OPCD == `LWAUX_OPCD && instr`XXO == `LWAUX_XXO );
	wire insn_STD    ; assign insn_STD = ( instr`OPCD == `STD_OPCD );
	wire insn_XOR    ; assign insn_XOR = ( instr`OPCD == `XOR_OPCD && instr`XXO == `XOR_XXO );
	wire insn_STB    ; assign insn_STB = ( instr`OPCD == `STB_OPCD );
	wire insn_SLW    ; assign insn_SLW = ( instr`OPCD == `SLW_OPCD && instr`XXO == `SLW_XXO );
	wire insn_STH    ; assign insn_STH = ( instr`OPCD == `STH_OPCD );
	wire insn_STW    ; assign insn_STW = ( instr`OPCD == `STW_OPCD );
	wire insn_INTR   ; assign insn_INTR = ( instr`OPCD == `INTR_OPCD );
	wire insn_CRXOR  ; assign insn_CRXOR = ( instr`OPCD == `CRXOR_OPCD && instr`XLXO == `CRXOR_XLXO );
	wire insn_CREQV  ; assign insn_CREQV = ( instr`OPCD == `CREQV_OPCD && instr`XLXO == `CREQV_XLXO );
	wire insn_TLBILX ; assign insn_TLBILX = ( instr`OPCD == `TLBILX_OPCD && instr`XXO == `TLBILX_XXO );
	wire insn_TLBIVAX; assign insn_TLBIVAX = ( instr`OPCD == `TLBIVAX_OPCD && instr`XXO == `TLBIVAX_XXO );
	wire insn_TLBRE  ; assign insn_TLBRE = ( instr`OPCD == `TLBRE_OPCD && instr`XXO == `TLBRE_XXO );
	wire insn_TLBWE  ; assign insn_TLBWE = ( instr`OPCD == `TLBWE_OPCD && instr`XXO == `TLBWE_XXO );
	wire insn_TLBSX  ; assign insn_TLBSX = ( instr`OPCD == `TLBSX_OPCD && instr`XXO == `TLBSX_XXO );
	wire insn_TLBSYNC; assign insn_TLBSYNC = ( instr`OPCD == `TLBSYNC_OPCD && instr`XXO == `TLBSYNC_XXO );
	wire insn_DCBF   ; assign insn_DCBF = ( instr`OPCD == `DCBF_OPCD && instr`XXO == `DCBF_XXO );
	wire insn_DCBI   ; assign insn_DCBI = ( instr`OPCD == `DCBI_OPCD && instr`XXO == `DCBI_XXO );	
	wire insn_DCBST  ; assign insn_DCBST = ( instr`OPCD == `DCBST_OPCD && instr`XXO == `DCBST_XXO );
	wire insn_DCBT   ; assign insn_DCBT = ( instr`OPCD == `DCBT_OPCD && instr`XXO == `DCBT_XXO );	
	wire insn_DCBTST ; assign insn_DCBTST = ( instr`OPCD == `DCBTST_OPCD && instr`XXO == `DCBTST_XXO );
	wire insn_DCBZ   ; assign insn_DCBZ = ( instr`OPCD == `DCBZ_OPCD && instr`XXO == `DCBZ_XXO );	
	wire insn_ICBI   ; assign insn_ICBI = ( instr`OPCD == `ICBI_OPCD && instr`XXO == `ICBI_XXO );
	wire insn_ISYNC  ; assign insn_ISYNC = ( instr`OPCD == `ISYNC_OPCD && instr`XXO == `ISYNC_XXO );
	

							   
	assign insnCluster_MSR = insn_MFMSR;
	
	assign insnCluster_SPR = insn_MFSPR;
	
	assign insnCluster_CR_MOVE = insn_MFCR;
	
	assign insnCluster_MDU = (
								insn_MULHW || insn_MULHWU || insn_MULLI || insn_MULLW || 
								insn_DIVW || insn_DIVWU
							 );

	assign insnCluster_CAL = (
								insn_ADD || insn_ADDC || insn_ADDE || insn_ADDI || 
								insn_ADDIC || insn_ADDIC_ || insn_ADDIS || insn_ADDME || 
								insn_ADDZE || insn_NEG || insn_SUBF || insn_SUBFC || 
								insn_SUBFE || insn_SUBFIC || insn_SUBFME || insn_SUBFZE
							 );
							 	
	assign insnCluster_BR = (
								insn_B || insn_BC || insn_BCLR || insn_BCCTR
							);
							
	assign insnCluster_LGC = (
								insn_AND || insn_ANDC || insn_ANDIS_ || insn_ANDI_ || 
								insn_CNTLZW || insn_EQV || insn_EXTSB || insn_EXTSH || 
								insn_NAND || insn_NOR || insn_OR || insn_ORC || 
								insn_ORI || insn_ORIS || insn_RLWIMI || insn_RLWINM || 
								insn_RLWNM || insn_SLW || insn_SRAW || insn_SRAWI || 
								insn_SRW || insn_XOR || insn_XORI || insn_XORIS
							 );
	
	wire insnCluster_LDU, insnCluster_STU;
	
	assign insnCluster_LDU = (
								insn_LBZU || insn_LBZUX || 
								insn_LHZU || insn_LHZUX || insn_LHAU || insn_LHAUX || 
								insn_LWZU || insn_LWZUX 
							 );
							 
	assign insnCluster_STU = (
								insn_STBU || insn_STBUX || insn_STHU || insn_STHUX || 
								insn_STWU || insn_STWUX
							 );			 
							 
	assign insnCluster_LSU = insnCluster_LDU || insnCluster_STU;
	
	
	wire insnCluster_LD, insnCluster_ST;
	
	assign insnCluster_LD = (
								insn_LBZ || insn_LBZX || insn_LHZ || insn_LHZX || 
								insn_LWZ || insn_LWZX || insn_LHA || insn_LHAX || 
								insn_LHBRX || insn_LWBRX || insnCluster_LDU
							);
							
	assign insnCluster_ST = (
								insn_STB || insn_STBX || insn_STH || insn_STHX || 
								insn_STW || insn_STWX || insnCluster_STU
							);
	
endmodule
