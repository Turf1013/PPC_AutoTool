#ifndef PPC_CU_H
#define PPC_CU_H

#include "ppc_type.h"

/*
 * 1. PPC_CU means the CU module of the Software. Main function is analysing the binary
 *	   Code for simulation.
 * 2. Tips:
 *		(1) All X-Form has the same OPCD ( XL:OPCD = 19, Others: OPCD = 31 );
 *		(2) XO-Form XO has only 9 bits, we can add 1 bit(=0) to make complete XO. More than that,
 *			9-bits is unique, means no XO with the highest bit=1;
 *		(3) All PPC Instrcution OPCD is 6 bits.
 */
 
extern u16 cu_get_OPCD(void);
extern u16 cu_get_XO(void);
extern void cu_set_OPCD(u32);
extern void cu_set_XO(u32);
extern int cu_find_mnemonic(u32 val, char *to);

extern void cu_handle_I_Form(u32 val);
extern void cu_handle_B_Form(u32 val);
extern void cu_handle_SC_Form(u32 val);
extern void cu_handle_D_Form(u32 val);
extern void cu_handle_DS_Form(u32 val);
extern void cu_handle_X_Form(u32 val);
extern void cu_handle_XL_Form(u32 val);
extern void cu_handle_XFX_Form(u32 val);
extern void cu_handle_XFL_Form(u32 val);
extern void cu_handle_XS_Form(u32 val);
extern void cu_handle_XO_Form(u32 val);
extern void cu_handle_A_Form(u32 val);
extern void cu_handle_M_Form(u32 val);
extern void cu_handle_MD_Form(u32 val);
extern void cu_handle_MDS_Form(u32 val);

extern u32 cu_get_instr(void);
extern u32 cu_get_pc(void);
extern void cu_initial();
extern void cu_work();

#endif
