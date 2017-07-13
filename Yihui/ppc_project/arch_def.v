/*
 * Description: This module is all about definition of PPC-ARCH .
 * Author: ZengYX
 * Date:   2014.8.1
 */

/**** About Instruction ****/
`define NOP			32'b011000_00000_00000_000000_00000_00000
`define INTR		32'b000100_00000_00000_000000_00000_00000

`define OPCD		[0:5]
`define OPCD_WIDTH	6
`define INSTR_OPCD	[0:5]
`define INSTR_XO	[21:30]
`define INSTR_BO	[6:10]
`define INSTR_rA	[11:15]
`define INSTR_rB	[16:20]
`define INSTR_rS	[6:10]
`define INSTR_Imm16	[16:31]
`define INSTR_FXM	[12:19]
`define INSTR_SH	[16:20]
`define INSTR_MB	[21:25]
`define INSTR_ME	[26:30]
`define INSTR_AA	[30]
`define INSTR_LK	[31]
`define INSTR_OPCD_WIDTH 6`define INSTR_XO_WIDTH 10

/**** About CR ****/
`define CR_DEPTH		5
`define CR_WIDTH		32
`define CR0_WIDTH		4
`define CR_BF_WIDTH		3
`define CR_BFA_WIDTH	3

/**** About GPR ****/
`define GPR_SIZE		32
`define GPR_DEPTH		5
`define GPR_WIDTH		32

/**** About ALU ****/
`define ROTL_WIDTH 		5 
`define ALU_D_WIDTH		3

/**** About MDU ****/
`define ROTL_WIDTH 		5 
`define MDU_D_WIDTH		3
`define MDU_CYCLE		8		// must great than 1
`define MDU_CNT_WIDTH	3

/**** About MSR ****/
`define MSR_WIDTH		32



/**** About NPC ****/
`define NPC_BO_WIDTH	5
`define NPC_BI_WIDTH	5
`define NPC_BD_WIDTH	14
`define NPC_LI_WIDTH	24
`define NPC_AA_WIDTH	1
`define NPC_LK_WIDTH	1
`define NPC_LI_RANGE	[0:23]
`define NPC_BO_RANGE	[0:4]
`define NPC_BI_RANGE	[5:9]
`define NPC_BD_RANGE	[10:23]
`define NPC_AA_RANGE	[24]
`define NPC_LK_RANGE	[25]

/**** About PC ****/
`define PC_WIDTH		32


/**** About IM ****/
`define IM_SIZE			1024
`define IM_DEPTH		10
`define IM_WIDTH		32
`define IM_BASE_ADDR	32'h1000_0000


/**** About DM ****/
`define DM_SIZE			1024
`define DM_DEPTH		10
`define DM_WIDTH		32
`define DMBE_WIDTH		4
`define DM_BASE_ADDR	32'h1001_0000


/**** About IO ****/
`define IO_SIZE			1024
`define IO_DEPTH		10
`define IO_WIDTH		32
`define IOBE_WIDTH		4
`define	IO_SEL_RANGE	[16:23]
`define IO_BASE_ADDR	32'h1002_0000
`define TC0_BASE_ADDR	32'h1002_0000
`define TC0_HIGH_ADDR	8'h00
`define LED_BASE_ADDR	32'h1002_0100
`define LED_HIGH_ADDR	8'h01
`define KBD_BASE_ADDR	32'h1002_0200
`define KBD_HIGH_ADDR	8'h02
`define VGA_BASE_ADDR	32'h1002_0300
`define VGA_HIGH_ADDR	8'h03
`define GCM_BASE_ADDR	32'h1002_1000
`define GCM_HIGH_ADDR	8'h10


/**** About INT ****/
`define INT_ENTRY_ADDR	32'h10000100


/**** About TOP ****/
`define INSTR_WIDTH		32
`define ARCH_WIDTH		32
`define ARCH_GE			1


/**** About CONST ****/
`define CONST_NEG1		32'hffff_ffff
`define CONST_ZERO		32'h0
