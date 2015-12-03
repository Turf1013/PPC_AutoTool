/*
 * Description: This module is all about definition of PPC-ARCH .
 * Author: ZengYX
 * Date:   2014.8.1
 */

/**** About Instruction ****/
`define INSTR_OPCD	0:5
`define INSTR_XO	21:30
`define INSTR_BO	6:10
`define INSTR_rA	11:15
`define INSTR_rB	16:20
`define INSTR_rS	6:10
`define INSTR_Imm16	16:31
`define INSTR_FXM	12:19
`define INSTR_SH	16:20
`define INSTR_MB	21:25
`define INSTR_ME	26:30
`define INSTR_AA	30
`define INSTR_LK	31

`define INSTR_OPCD_WIDTH 6
`define INSTR_XO_WIDTH 10
 
/**** About CR ****/
`define CR_DEPTH	5
`define CR_WIDTH	32
`define CR0_WIDTH	8

/**** About GPR ****/
`define GPR_N			32
`define GPR_DEPTH		5
`define GPR_WIDTH		32

/**** About ALU ****/
`define ROTL_WIDTH 		5 

/**** About MSR ****/
`define MSR_WIDTH		32

/**** About SPR ****/
`define SPR_DEPTH		10
`define SPR_WIDTH		32
// LR
`define LR_WIDTH   `SPR_WIDTH
// XER
`define XER_WIDTH		32
`define XER_SPRN		10'd1
`define XER_CA			0
`define XER_OV			1
`define XER_SO			2
// Others
`define XER_SPRN		10'd1
`define LR_SPRN			10'd8
`define CTR_SPRN		10'd9
`define SRR0_SPRN		10'd26
`define SRR1_SPRN		10'd27

/**** About CTR ****/
`define CTR_WIDTH		32

/**** About NPC ****/
`define IMM24_WIDTH		24
`define BO_WIDTH		5
`define BI_WIDTH		5
`define BD_WIDTH		14
`define LI_WIDTH		24


/**** About NPC ****/
`define PC_WIDTH		32

/**** About IM ****/
`define IM_SIZE			1024
`define IM_DEPTH		12
`define IM_WIDTH		32

/**** About IM ****/
`define DM_SIZE			1024
`define DM_DEPTH		12
`define DM_WIDTH		32
`define DMBE_WIDTH		4

/**** About TOP ****/
`define INSTR_WIDTH		32
`define ARCH_WIDTH		32
`define ARCH_GE			1

