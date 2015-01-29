#ifndef PPC_FORMAT_H
#define PPC_FORMAT_H

/*
 * 1. "ppc_format.h" includes all formats of PPC ISA. Using bit-pack is very helpful
 *	  to assemble and disassemble.
 * 2. Unfortunatelly, PPC has so many types of formats with different fields. We choose
 *    the import **ONE** kind of **EACH** format. We still need "<<" or ">>" in some 
 *	  instructions, but very rarely.
 * 3. Reference to IBM Book I: PowerPC User Instruction Set Architecture.
 * 4. Merge Reserved as much as possible even bit is 1 const. Number Reserve? from 0 to 31.
 */

#include "ppc_type.h"
 
// Simplified for typedf struct, learn it from LINUX-2.6.38
#define FORM_STRUCT_4(name, f0, l0, f1, l1, f2, l2, f3, l3)\
typedef struct {\
	unsigned f0: l0;\
	unsigned f1: l1;\
	unsigned f2: l2;\
	unsigned f3: l3;\
}name

#define FORM_STRUCT_5(name, f0, l0, f1, l1, f2, l2, f3, l3, f4, l4)\
typedef struct {\
	unsigned f0: l0;\
	unsigned f1: l1;\
	unsigned f2: l2;\
	unsigned f3: l3;\
	unsigned f4: l4;\
}name

#define FORM_STRUCT_6(name, f0, l0, f1, l1, f2, l2, f3, l3, f4, l4, f5, l5)\
typedef struct {\
	unsigned f0: l0;\
	unsigned f1: l1;\
	unsigned f2: l2;\
	unsigned f3: l3;\
	unsigned f4: l4;\
	unsigned f5: l5;\
}name

#define FORM_STRUCT_7(name, f0, l0, f1, l1, f2, l2, f3, l3, f4, l4, f5, l5, f6, l6)\
typedef struct {\
	unsigned f0: l0;\
	unsigned f1: l1;\
	unsigned f2: l2;\
	unsigned f3: l3;\
	unsigned f4: l4;\
	unsigned f6: l6;\
}name

#define FORM_STRUCT_8(name, f0, l0, f1, l1, f2, l2, f3, l3, f4, l4, f5, l5, f6, l6, f7, l7)\
typedef struct {\
	unsigned f0: l0;\
	unsigned f1: l1;\
	unsigned f2: l2;\
	unsigned f3: l3;\
	unsigned f4: l4;\
	unsigned f6: l6;\
	unsigned f7: l7;\
}name


#define FORM_RESERVED 0

// I-Form: 1 kind
// 6+24+1+1=32
FORM_STRUCT_4(I_Form_st, OPCD, 6, LI, 24, AA, 1, LK, 1);


// B-Form: 1 kind
// 6+5+5+14+1+1=32
FORM_STRUCT_6(B_Form_st, OPCD, 6, BO, 5, BI, 5, BD, 14, AA, 1, LK, 1);


// SC-Form: 1 kind
// 6+14+7+5=32
FORM_STRUCT_4(SC_Form_st, OPCD, 6, Reserve0, 14, LEV, 7, Reserve1, 5);


// D-Form: 9 kinds
// 6+5+5+16=32
FORM_STRUCT_4(D_Form_st, OPCD, 6, RT, 5, RA, 5, D, 16);


// DS-Fomr: 2 kinds
// 6+5+5+14+2=32
FORM_STRUCT_5(DS_Form_st, OPCD, 6, RT, 5, RA, 5, DS, 14, XO, 2);

// X-Form: 32 kinds
// 6+5+5+5+10+1=32
FORM_STRUCT_6(X_Form_st, OPCD, 6, RT, 5, RA, 5, RB, 5, XO, 10, RC, 1);


// XL-Form: 4 kinds
// 6+5+5+5+10+1=32
FORM_STRUCT_6(XL_Form_st, OPCD, 6, BT, 5, BA, 5, BB, 5, XO, 10, LK, 1);


// XFX-Form: 7 kinds
// 6+5+10+10+1=32
FORM_STRUCT_5(XFX_Form_st, OPCD, 6, RT, 5, SPR, 10, XO, 10, Reserve0, 1);


// XFL-Form: 1 kind
// 6+1+8+1+5+10+1=32
FORM_STRUCT_7(XFL_Form_st, OPCD, 6, Reserve0, 1, FLM, 8, Reserve1, 1, FRB, 5, XO, 10, RC, 1);


// XS-Form: 1 kind
// 6+5+5+5+9+1+1=32
FORM_STRUCT_7(XS_Form_st, OPCD, 6, RS, 5, RA, 5, SH0, 5, XO, 9, SH1, 1, RC, 1);


// XO-Form: 3 kinds
// 6+5+5+5+1+9+1=32
FORM_STRUCT_7(XO_Form_st, OPCD, 6, RT, 5, RA, 5, RB, 5, OE, 1, XO, 9, RC, 1);


// A-Form: 4 kinds
// 6+5+5+5+5+5+1=32
FORM_STRUCT_7(A_Form_st, OPCD, 6, FRT, 5, FRA, 5, FRB, 5, FRC, 5, XO, 5, RC, 1);


// M-Form: 2 kinds
// 6+5+5+5+5+5+1=32
FORM_STRUCT_7(M_Form_st, OPCD, 6, RS, 5, RA, 5, RB, 5, MB, 5, ME, 5, RC, 1);


// MD-Form: 2 kinds
// 6+5+5+5+6+3+1+1=32
FORM_STRUCT_8(MD_Form_st, OPCD, 6, RS, 5, RA, 5, SH0, 5, MB, 6, XO, 3, SH1, 1, RC, 1);


// MDS-Form: 2 kinds
// 6+5+5+5+6+4+1=32
FORM_STRUCT_7(MDS_Form_st, OPCD, 6, RS, 5, RA, 5, RB, 5, MB, 6, XO, 4, RC, 1);

typedef union {
    I_Form_st   I_Form;
    B_Form_st   B_Form;
    SC_Form_st  SC_Form;
    D_Form_st   D_Form;
    DS_Form_st  DS_Form;
    X_Form_st   X_Form;
    XL_Form_st  XL_Form;
    XFX_Form_st XFX_Form;
    XFL_Form_st XFL_Form;
    XS_Form_st  XS_Form;
    XO_Form_st  XO_Form;
    A_Form_st   A_Form;
    M_Form_st   M_Form;
    MD_Form_st  MD_Form;
    MDS_Form_st MDS_Form;
} Format_st;

typedef union {
    u32 val;
    u8  parts[4];
    Format_st Format;
} PPC_Instr_st;


#define PPC_FORM_N	15
#define I_FORM_OP	0
#define B_FORM_OP	1
#define SC_FORM_OP	2
#define D_FORM_OP	3
#define DS_FORM_OP	4
#define X_FORM_OP	5
#define XL_FORM_OP	6
#define XFX_FORM_OP	7
#define XFL_FORM_OP	8
#define XS_FORM_OP	9
#define XO_FORM_OP	10
#define A_FORM_OP	11
#define M_FORM_OP	12
#define MD_FORM_OP	13
#define MDS_FORM_OP	14

#endif // PPC_FORMAT_H
