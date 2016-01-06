/*
 * Description: This module is all about definition of control signal in CU.
 * Author: ZengYX
 * Date:   2014.8.1
 */
 
/**** About CR ****/
// CR_ALU
`define CR_ALUOp_WIDTH 	4
`define CR_ALUOp_AND	4'd0
`define CR_ALUOp_OR		4'd1
`define CR_ALUOp_XOR	4'd2
`define CR_ALUOp_NAND	4'd3
`define CR_ALUOp_NOR	4'd4
`define CR_ALUOp_EQV	4'd5
`define CR_ALUOp_ANDC	4'd6
`define CR_ALUOp_ORC	4'd7
`define CR_ALUOp_MOV	4'd8


/**** About Ext ****/
`define ExtOp_WIDTH		2
`define ExtOp_SIGNED	2'd0
`define ExtOp_UNSIGN	2'd1
`define ExtOp_HIGH16	2'd2


/**** About NPC ****/
`define NPCOp_WIDTH		3
`define NPCOp_PLUS4		3'd0
`define NPCOp_B			3'd1
`define NPCOp_BC		3'd2
`define NPCOp_BCCTR		3'd3
`define NPCOp_BCLR		3'd4
`define NPCOp_RFI		3'd5
`define NPCOp_INT		3'd6


/**** About DM ****/
`define DMIn_BEOp_WIDTH		3
`define DMIn_BEOp_SW		3'd0
`define DMIn_BEOp_SH		3'd1
`define DMIn_BEOp_SB		3'd2
`define DMIn_BEOp_SWBR		3'd3
`define DMIn_BEOp_SHBR		3'd4
`define DMOut_MEOp_WIDTH 	3
`define DMOut_MEOp_LW		3'd0
`define DMOut_MEOp_LH		3'd1
`define DMOut_MEOp_LHA		3'd2
`define DMOut_MEOp_LB		3'd3
`define DMOut_MEOp_LHBR		3'd4
`define DMOut_MEOp_LWBR		3'd5


/**** About ALU ****/
`define ALUOp_WIDTH	5
`define ALUOp_MOVA	5'd0
`define ALUOp_AND	5'd1
`define ALUOp_ANDC	5'd2
`define ALUOp_CMP	5'd3
`define ALUOp_CMPL	5'd4
`define ALUOp_CNTZ	5'd5
`define ALUOp_EXTSB	5'd6
`define ALUOp_EXTSH	5'd7
`define ALUOp_ADDU	5'd8
`define ALUOp_NAND	5'd9
`define ALUOp_OR	5'd10
`define ALUOp_ORC	5'd11
`define ALUOp_SLL	5'd12
`define ALUOp_SRA	5'd13
`define ALUOp_SRL	5'd14
`define ALUOp_XOR	5'd15
`define ALUOp_NOR	5'd16
`define ALUOp_ADD	5'd17
`define ALUOp_ADDE	5'd18
`define ALUOp_SUBF	5'd17
`define ALUOp_SUBFE	5'd18
`define ALUOp_RLNM	5'd19
`define ALUOp_RLIM	5'd20
`define ALUOp_MOVB	5'd21
`define ALUOp_NEG	5'd22
`define ALUOp_EQV	5'd23

`define CNTZ_00    32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_01    32'b01xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_02    32'b001x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_03    32'b0001_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_04    32'b0000_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_05    32'b0000_01xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_06    32'b0000_001x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_07    32'b0000_0001_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_08    32'b0000_0000_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_09    32'b0000_0000_01xx_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_10    32'b0000_0000_001x_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_11    32'b0000_0000_0001_xxxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_12    32'b0000_0000_0000_1xxx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_13    32'b0000_0000_0000_01xx_xxxx_xxxx_xxxx_xxxx
`define CNTZ_14    32'b0000_0000_0000_001x_xxxx_xxxx_xxxx_xxxx
`define CNTZ_15    32'b0000_0000_0000_0001_xxxx_xxxx_xxxx_xxxx
`define CNTZ_16    32'b0000_0000_0000_0000_1xxx_xxxx_xxxx_xxxx
`define CNTZ_17    32'b0000_0000_0000_0000_01xx_xxxx_xxxx_xxxx
`define CNTZ_18    32'b0000_0000_0000_0000_001x_xxxx_xxxx_xxxx
`define CNTZ_19    32'b0000_0000_0000_0000_0001_xxxx_xxxx_xxxx
`define CNTZ_20    32'b0000_0000_0000_0000_0000_1xxx_xxxx_xxxx
`define CNTZ_21    32'b0000_0000_0000_0000_0000_01xx_xxxx_xxxx
`define CNTZ_22    32'b0000_0000_0000_0000_0000_001x_xxxx_xxxx
`define CNTZ_23    32'b0000_0000_0000_0000_0000_0001_xxxx_xxxx
`define CNTZ_24    32'b0000_0000_0000_0000_0000_0000_1xxx_xxxx
`define CNTZ_25    32'b0000_0000_0000_0000_0000_0000_01xx_xxxx
`define CNTZ_26    32'b0000_0000_0000_0000_0000_0000_001x_xxxx
`define CNTZ_27    32'b0000_0000_0000_0000_0000_0000_0001_xxxx
`define CNTZ_28    32'b0000_0000_0000_0000_0000_0000_0000_1xxx
`define CNTZ_29    32'b0000_0000_0000_0000_0000_0000_0000_01xx
`define CNTZ_30    32'b0000_0000_0000_0000_0000_0000_0000_001x
`define CNTZ_31    32'b0000_0000_0000_0000_0000_0000_0000_0001
`define CNTZ_32    32'b0000_0000_0000_0000_0000_0000_0000_0000

/**** About ALU_DOut ****/
`define ALU_DOutOp_WIDTH 	3
`define ALU_DOutOp_NOP		3'd0
`define ALU_DOutOp_CA		3'd1
`define ALU_DOutOp_OV		3'd2
`define ALU_DOutOp_CAOV		3'd3
`define ALU_DOutOp_OVCA		`ALU_DOutOp_CAOV
`define ALU_DOutOp_CMP		3'd4


/**** About ALU_AIn ****/
`define ALU_AInOp_WIDTH	1
`define ALU_AInOp_NOP	1'b0
`define ALU_AInOp_ZERO	1'b1

/**** About MDU ****/
`define MDUOp_WIDTH		3
`define MDUOp_MULH		3'd0
`define MDUOp_MULHU		3'd1
`define MDUOp_MULW		3'd2
`define MDUOp_DIVW		3'd3
`define MDUOp_DIVWU		3'd4

/**** About MDU_DOut ****/
`define MDU_DOutOp_WIDTH 	1
`define MDU_DOutOp_NOP		1'd0
`define MDU_DOutOp_OV		1'd1
