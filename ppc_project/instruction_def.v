`define ADD_OPCD	6'b011_111
`define ADD_XOXO	9'b10000_1010

`define ADDC_OPCD	6'b011_111
`define ADDC_XOXO	9'b00000_1010

`define ADDE_OPCD	6'b011_111
`define ADDE_XOXO	9'b01000_1010

`define ADDI_OPCD	6'b001_110

`define ADDIC_OPCD	6'b001_100

`define ADDIC__OPCD	6'b001_101

`define ADDIS_OPCD	6'b001_111

`define ADDME_OPCD	6'b011_111
`define ADDME_XOXO	9'b01110_1010

`define ADDZE_OPCD	6'b011_111
`define ADDZE_XOXO	9'b01100_1010

`define AND_OPCD	6'b011_111
`define AND_XXO		10'b00000_11100

`define ANDC_OPCD	6'b011_111
`define ANDC_XXO	10'b00001_11100

`define ANDI__OPCD	6'b011_100

`define ANDIS__OPCD	6'b011_101

`define B_OPCD		6'b010_010

`define BC_OPCD		6'b010_000

`define BCCTR_OPCD	6'b010_011
`define BCCTR_XLXO	10'b10000_10000

`define BCLR_OPCD	6'b010_011
`define BCLR_XLXO	10'b00000_10000

`define CMP_OPCD	6'b011_111
`define CMP_XXO		10'b00000_00000

`define CMPI_OPCD	6'b001_011

`define CMPL_OPCD	6'b011_111
`define CMPL_XXO	10'b00001_00000

`define CMPLI_OPCD	6'b001_010

`define CNTLZW_OPCD	6'b011_111
`define CNTLZW_XXO	10'b00000_11010

`define CRAND_OPCD	6'b010_011
`define CRAND_XLXO	10'b01000_00001

`define CRNOR_OPCD	6'b010_011
`define CRNOR_XLXO	10'b00001_00001

`define CRXOR_OPCD	6'b010_011
`define CRXOR_XLXO	10'b00110_00001

`define DIVW_OPCD	6'b011_111
`define DIVW_XOXO	9'b11110_1011

`define DIVWU_OPCD	6'b011_111
`define DIVWU_XOXO	9'b11100_1011

`define EXTSB_OPCD	6'b011_111
`define EXTSB_XXO	10'b11101_11010

`define EXTSH_OPCD	6'b011_111
`define EXTSH_XXO	10'b11100_11010

`define LBZ_OPCD	6'b100_010

`define LBZU_OPCD	6'b100_011

`define LBZX_OPCD	6'b011_111
`define LBZX_XXO	10'b00010_10111

`define LBZUX_OPCD	6'b011_111
`define LBZUX_XXO	10'b00011_10111

`define LHA_OPCD	6'b101_010

`define LHAU_OPCD	6'b101_011

`define LHAX_OPCD	6'b011_111
`define LHAX_XXO	10'b01010_10111

`define LHAUX_OPCD	6'b011_111
`define LHAUX_XXO	10'b01011_10111

`define LHBRX_OPCD	6'b011_111
`define LHBRX_XXO	10'b11000_10110

`define LHZ_OPCD	6'b101_000

`define LHZU_OPCD	6'b101_001

`define LHZX_OPCD	6'b011_111
`define LHZX_XXO	10'b01000_10111

`define LHZUX_OPCD	6'b011_111
`define LHZUX_XXO	10'b01001_10111

`define LMW_OPCD	6'b101_110

`define LWARX_OPCD	6'b011_111
`define LWARX_XXO	10'b00000_10100

`define LWBRX_OPCD	6'b011_111
`define LWBRX_XXO	10'b10000_10110

`define LWZ_OPCD	6'b100_000

`define LWZU_OPCD	6'b100_001

`define LWZX_OPCD	6'b011_111
`define LWZX_XXO	10'b00000_10111

`define LWZUX_OPCD	6'b011_111
`define LWZUX_XXO	10'b00001_10111

`define MCRF_OPCD	6'b010_011
`define MCRF_XLXO	10'b00000_00000

`define MFCR_OPCD	6'b011_111
`define MFCR_XLXO	10'b00000_10011

`define MFMSR_OPCD	6'b011_111
`define MFMSR_XXO	10'b00010_10011

`define MFSPR_OPCD	6'b011_111
`define MFSPR_XFXXO	10'b01010_10011

`define MTCRF_OPCD	6'b011_111
`define MTCRF_XFXXO	10'b00100_10000

`define MTMSR_OPCD	6'b011_111
`define MTMSR_XXO	10'b00100_10010

`define MTSPR_OPCD	6'b011_111
`define MTSPR_XFXXO	10'b01110_10011

`define MULHW_OPCD	6'b011_111
`define MULHW_XOXO	9'b00100_1011

`define MULHWU_OPCD	6'b011_111
`define MULHWU_XOXO	9'b00000_1011

`define MULLI_OPCD	6'b000_111

`define MULLW_OPCD	6'b011_111
`define MULLW_XOXO	9'b01110_1011

`define NAND_OPCD	6'b011_111
`define NAND_XXO	10'b01110_11100

`define NEG_OPCD	6'b011_111
`define NEG_XOXO	9'b00110_1000

`define NOR_OPCD	6'b011_111
`define NOR_XXO		10'b00011_11100

`define OR_OPCD		6'b011_111
`define OR_XXO		10'b01101_11100

`define ORC_OPCD	6'b011_111
`define ORC_XXO		10'b01100_11100

`define ORI_OPCD	6'b011_000

`define ORIS_OPCD	6'b011_001

`define RLWIMI_OPCD	6'b010_100

`define RLWINM_OPCD	6'b010_101

`define RLWNM_OPCD	6'b010_111

`define SC_OPCD		6'b010_001

`define SLW_OPCD	6'b011_111
`define SLW_XXO		10'b00000_11000

`define SRAW_OPCD	6'b011_111
`define SRAW_XXO	10'b11000_11000

`define SRAWI_OPCD	6'b011_111
`define SRAWI_XXO	10'b11001_11000

`define SRW_OPCD	6'b011_111
`define SRW_XXO		10'b10000_11000

`define STB_OPCD	6'b100_110

`define STBU_OPCD	6'b100_111

`define STBX_OPCD	6'b011_111
`define STBX_XXO	10'b00110_10111

`define STBUX_OPCD	6'b011_111
`define STBUX_XXO	10'b00111_10111

`define STH_OPCD	6'b101_100

`define STHBRX_OPCD	6'b011_111
`define STHBRX_XXO	10'b11100_10110

`define STHU_OPCD	6'b101_101

`define STHX_OPCD	6'b011_111
`define STHX_XXO	10'b01100_10111

`define STHUX_OPCD	6'b011_111
`define STHUX_XXO	10'b01101_10111

`define STMW_OPCD	6'b101_111

`define STW_OPCD	6'b100_100

`define STWBRX_OPCD	6'b011_111
`define STWBRX_XXO	10'b10100_10110

`define STWCX__OPCD	6'b011_111
`define STWCX__XXO	10'b00100_10110

`define STWU_OPCD	6'b100_101

`define STWX_OPCD	6'b011_111
`define STWX_XXO	10'b00100_10111

`define STWUX_OPCD	6'b011_111
`define STWUX_XXO	10'b00101_10111

`define SUBF_OPCD	6'b011_111
`define SUBF_XOXO	9'b00010_1000

`define SUBFC_OPCD	6'b011_111
`define SUBFC_XOXO	9'b00000_1000

`define SUBFE_OPCD	6'b011_111
`define SUBFE_XOXO	9'b01000_1000

`define SUBFIC_OPCD	6'b001_000

`define SUBFME_OPCD	6'b011_111
`define SUBFME_XOXO	9'b01110_1000

`define SUBFZE_OPCD	6'b011_111
`define SUBFZE_XOXO	9'b01100_1000

`define SYNC_OPCD	6'b011_111
`define SYNC_XXO	10'b10010_10110

`define TWI_OPCD	6'b000_011

`define WRTEEI_OPCD	6'b011_111
`define WRTEEI_XXO 	10'b00101_00011

`define XOR_OPCD	6'b011_111
`define XOR_XXO		10'b01001_11100

`define XORI_OPCD	6'b011010

`define XORIS_OPCD	6'b011011

`define RFI_OPCD	6'b010_011
`define RFI_XLXO	10'b00001_10010
