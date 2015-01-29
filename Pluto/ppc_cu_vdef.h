#ifndef PPC_CU_VDEF_H
#define PPC_CU_VDEF_H

#define CR_ALUOP_NOP 0
#define CR_ALUOP_AND 1
#define CR_ALUOP_NOR 2
#define CR_ALUOP_XOR 3

#define ALUOp_NOP	0
#define ALUOp_AND	1
#define ALUOp_ANDC	2
#define ALUOp_CMP	3
#define ALUOp_CMPU	4
#define ALUOp_CNTZ	5
#define ALUOp_EXTSB	6
#define ALUOp_EXTSH	7
#define ALUOp_ADDU	8
#define ALUOp_NAND	9
#define ALUOp_OR	10
#define ALUOp_ORC	11
#define ALUOp_SLL	12
#define ALUOp_SRA	13
#define ALUOp_SRL	14
#define ALUOp_XOR	15
#define ALUOp_NOR	16
#define ALUOp_ADD	17
#define ALUOp_ADDE	18
#define ALUOp_SUBF	17
#define ALUOp_SUBFE	18


#define MDUOp_DIVW	1
#define MDUOp_DIVWU	2
#define MDUOp_MULT	3
#define MDUOp_MULH	4
#define MDUOp_MULHU	5


#define DMOp_LBZ	1
#define DMOp_LHZ	2
#define DMOp_LWZ	3
#define DMOp_LHBRX	4
#define DMOp_LWARX	5
#define DMOp_LWBRX	6
#define DMOp_LHA	7

#define DMOp_STB	1
#define DMOp_STH	2
#define DMOp_STW	3
#define DMOp_STHBR	4
#define DMOp_STWBR	5



#endif
