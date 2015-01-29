/*
 * Description: This module is all about definition of control signal in CU.
 * Author: ZengYX
 * Date:   2014.8.1
 */
 
/**** About CR ****/
// CR_Reg
`define CR_Hsel_WIDTH	8
`define CR_Lsel_WIDTH	4
// CR_BE
`define CR_BEOp_WIDTH	2
`define CR_BEOp_1bits	2'd0
`define CR_BEOp_4bits	2'd1
`define CR_BEOp_32bits	2'd2
// CR_ALU
`define CR_ALUOp_WIDTH 2
`define CR_ALU_Op_WIDTH	`CR_ALUOp_WIDTH
`define CR_ALUOp_AND	2'd0
`define CR_ALUOp_XOR	2'd1
`define CR_ALUOp_NOR	2'd2


/**** About Ext ****/
`define ExtOp_WIDTH		2
`define ExtOp_SIGNED	2'd0
`define ExtOp_UNSIGN	2'd1
`define ExtOp_HIGH16	2'd2


/**** About NPC ****/
`define NPCOp_WIDTH		3
`define NPCOp_PLUS4		3'd0
`define NPCOp_JUMP		3'd1
`define NPCOp_BRANCH	3'd2
`define NPCOp_CTR		3'd3
`define NPCOp_LR		3'd4


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
`define ALUOp_NOP	5'd0
`define ALUOp_AND	5'd1
`define ALUOp_ANDC	5'd2
`define ALUOp_CMP	5'd3
`define ALUOp_CMPU	5'd4
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


