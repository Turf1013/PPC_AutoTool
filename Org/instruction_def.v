/*
 * Description: This module is all about definition of instruction.
 * Author: ZengYX
 * Date:   2014.8.1
 */
 
`define TWI_OPCD     6'd3
`define MULLI_OPCD   6'd7
`define SUBFIC_OPCD  6'd8
`define CMPLI_OPCD   6'd10
`define CMPI_OPCD    6'd11
`define ADDIC_OPCD   6'd12
`define ADDIC__OPCD  6'd13
`define ADDI_OPCD    6'd14
`define ADDIS_OPCD   6'd15
`define BC_OPCD      6'd16
`define SC_OPCD      6'd17
`define B_OPCD       6'd18
`define MCRF_OPCD    6'd19
`define BCLR_OPCD    6'd19
`define CRNOR_OPCD   6'd19
`define RFI_OPCD     6'd19
`define CRXOR_OPCD   6'd19
`define CRAND_OPCD   6'd19
`define BCCTR_OPCD   6'd19
`define RLWIMI_OPCD  6'd20
`define RLWINM_OPCD  6'd21
`define RLWNM_OPCD   6'd23
`define ORI_OPCD     6'd24
`define ORIS_OPCD    6'd25
`define XORI_OPCD    6'd26
`define XORIS_OPCD   6'd27
`define ANDI__OPCD   6'd28
`define ANDIS__OPCD  6'd29
`define CMP_OPCD     6'd31
`define SUBFC_OPCD   6'd31
`define ADDC_OPCD    6'd31
`define MULHWU_OPCD  6'd31
`define MFCR_OPCD    6'd31
`define LWARX_OPCD   6'd31
`define LWZX_OPCD    6'd31
`define SLW_OPCD     6'd31
`define CNTLZW_OPCD  6'd31
`define AND_OPCD     6'd31
`define CMPL_OPCD    6'd31
`define SUBF_OPCD    6'd31
`define ANDC_OPCD    6'd31
`define MULHW_OPCD   6'd31
`define MFMSR_OPCD   6'd31
`define LBZX_OPCD    6'd31
`define NEG_OPCD     6'd31
`define NOR_OPCD     6'd31
`define SUBFE_OPCD   6'd31
`define ADDE_OPCD    6'd31
`define MTCRF_OPCD   6'd31
`define MTMSR_OPCD   6'd31
`define STWCX__OPCD  6'd31
`define STWX_OPCD    6'd31
`define WRTEEI_OPCD  6'd31
`define SUBFZE_OPCD  6'd31
`define ADDZE_OPCD   6'd31
`define STBX_OPCD    6'd31
`define ADDME_OPCD   6'd31
`define MULLW_OPCD   6'd31
`define ADD_OPCD     6'd31
`define LHZX_OPCD    6'd31
`define XOR_OPCD     6'd31
`define MFSPR_OPCD   6'd31
`define LHAX_OPCD    6'd31
`define STHX_OPCD    6'd31
`define ORC_OPCD     6'd31
`define OR_OPCD      6'd31
`define DIVWU_OPCD   6'd31
`define MTSPR_OPCD   6'd31
`define NAND_OPCD    6'd31
`define DIVW_OPCD    6'd31
`define LWBRX_OPCD   6'd31
`define SRW_OPCD     6'd31
`define SYNC_OPCD    6'd31
`define STWBRX_OPCD  6'd31
`define LHBRX_OPCD   6'd31
`define SRAW_OPCD    6'd31
`define SRAWI_OPCD   6'd31
`define STHBRX_OPCD  6'd31
`define EXTSH_OPCD   6'd31
`define EXTSB_OPCD   6'd31
`define LWZ_OPCD     6'd32
`define LBZ_OPCD     6'd34
`define STW_OPCD     6'd36
`define STB_OPCD     6'd38
`define LHZ_OPCD     6'd40
`define LHA_OPCD     6'd42
`define STH_OPCD     6'd44
`define LMW_OPCD     6'd46
`define STMW_OPCD    6'd47
`define LBZU_OPCD	 6'd35
`define LBZUX_OPCD	 6'd31
`define LHZU_OPCD	 6'd41
`define LHZUX_OPCD	 6'd31
`define LHAU_OPCD	 6'd43
`define LHAUX_OPCD	 6'd31
`define LWZU_OPCD	 6'd33
`define LWZUX_OPCD	 6'd31
`define STBU_OPCD	 6'd39
`define STBUX_OPCD	 6'd31
`define STHU_OPCD	 6'd45
`define STHUX_OPCD	 6'd31
`define STWU_OPCD	 6'd37
`define STWUX_OPCD	 6'd31
`define SUBFME_OPCD	 6'd31

`define TWI_XO       10'd0
`define MULLI_XO     10'd0
`define SUBFIC_XO    10'd0
`define CMPLI_XO     10'd0
`define CMPI_XO      10'd0
`define ADDIC_XO     10'd0
`define ADDIC__XO    10'd0
`define ADDI_XO      10'd0
`define ADDIS_XO     10'd0
`define BC_XO        10'd0
`define SC_XO        10'd0
`define B_XO         10'd0
`define MCRF_XO      10'd0
`define BCLR_XO      10'd16
`define CRNOR_XO     10'd33
`define RFI_XO       10'd50
`define CRXOR_XO     10'd193
`define CRAND_XO     10'd257
`define BCCTR_XO     10'd528
`define RLWIMI_XO    10'd0
`define RLWINM_XO    10'd0
`define RLWNM_XO     10'd0
`define ORI_XO       10'd0
`define ORIS_XO      10'd0
`define XORI_XO      10'd0
`define XORIS_XO     10'd0
`define ANDI__XO     10'd0
`define ANDIS__XO    10'd0
`define CMP_XO       10'd0
`define SUBFC_XO     10'bx000001000
`define ADDC_XO      10'bx000001010
`define MULHWU_XO    10'd11
`define MFCR_XO      10'd19
`define LWARX_XO     10'd20
`define LWZX_XO      10'd23
`define SLW_XO       10'd24
`define CNTLZW_XO    10'd26
`define AND_XO       10'd28
`define CMPL_XO      10'd32
`define SUBF_XO      10'bx000101000
`define ANDC_XO      10'd60
`define MULHW_XO     10'd75
`define MFMSR_XO     10'd83
`define LBZX_XO      10'd87
`define NEG_XO       10'bx001101000
`define NOR_XO       10'd124
`define SUBFE_XO     10'bx010001000
`define ADDE_XO      10'bx010001010
`define MTCRF_XO     10'd144
`define MTMSR_XO     10'd146
`define STWCX__XO    10'd150
`define STWX_XO      10'd151
`define WRTEEI_XO    10'd163
`define SUBFZE_XO    10'bx011001000
`define ADDZE_XO     10'bx011001010
`define STBX_XO      10'd215
`define ADDME_XO     10'bx011101010
`define MULLW_XO     10'bx011101011
`define ADD_XO       10'bx100001010
`define LHZX_XO      10'd279
`define XOR_XO       10'd316
`define MFSPR_XO     10'd339
`define LHAX_XO      10'd343
`define STHX_XO      10'd407
`define ORC_XO       10'd412
`define OR_XO        10'd444
`define DIVWU_XO     10'bx111001011
`define MTSPR_XO     10'd467
`define NAND_XO      10'd476
`define DIVW_XO      10'bx111101011
`define LWBRX_XO     10'd534
`define SRW_XO       10'd536
`define SYNC_XO      10'd598
`define STWBRX_XO    10'd662
`define LHBRX_XO     10'd790
`define SRAW_XO      10'd792
`define SRAWI_XO     10'd824
`define STHBRX_XO    10'd918
`define EXTSH_XO     10'd922
`define EXTSB_XO     10'd954
`define LWZ_XO       10'd0
`define LBZ_XO       10'd0
`define STW_XO       10'd0
`define STB_XO       10'd0
`define LHZ_XO       10'd0
`define LHA_XO       10'd0
`define STH_XO       10'd0
`define LMW_XO       10'd0
`define STMW_XO      10'd0
`define LBZU_XO	 	 10'd0
`define LBZUX_XO	 10'd119
`define LHZU_XO	 	 10'd0
`define LHZUX_XO	 10'd311
`define LHAU_XO	 	 10'd0
`define LHAUX_XO	 10'd375
`define LWZU_XO	 	 10'd0
`define LWZUX_XO	 10'd55
`define STBU_XO	 	 10'd0
`define STBUX_XO	 10'd247
`define STHU_XO	 	 10'd0
`define STHUX_XO	 10'd439
`define STWU_XO	 	 10'd0
`define STWUX_XO	 10'd183
`define SUBFME_XO	 10'bx011101000