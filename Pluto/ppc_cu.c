#include "ppc_cu.h"
#include "ppc_opcode.h"
#include "ppc_type.h"
#include "ppc_format.h"
#include "ppc_regs.h"
#include "ppc_arch.h"
#include "ppc_vdef.h"

#define get_bit(v, n) ((v & (1<<n))>>n)

typedef void (*fun_ptr) (unsigned int);

static u16 cu_opcd;
static u16 cu_xo;
static int cu_index;
static u8  cu_CRWr, cu_CTRWr, cu_XERWr;
static u32 cu_pc, cu_npc;
static fun_ptr fptrs[PPC_FORM_N];


u16 cu_get_OPCD(void) {
	return cu_opcd;
}

u16 cu_get_XO(void) {
	return cu_xo;
}

void cu_set_OPCD(u32 val) {
	cu_opcd = (u16)(val & 0x3f);
}

void cu_set_XO(u32 val) {
	PPC_Instr_st instr;
	instr.val = val;
	
	cu_set_OPCD(val);
	if (cu_opcd == 19)
		cu_xo = (u16)(instr.Format.XL_Form.XO);
	if (cu_opcd == 31)	
		cu_xo = (u16)(instr.Format.X_Form.XO & (1<<9));	
}

static int bs_check(int in) {
    if (Primary_Op[in] != cu_opcd)
		return cu_opcd - Primary_Op[in];
	return cu_xo - Extend_Op[in];	
}

static int binary_search(void) {
	int l = 0, r = OP_N-1, mid, tmp;
	
	while (l <= r) {
		mid = (l+r) >> 1;
		tmp = bs_check(mid);
		if (tmp == 0)
			return mid;
		if (tmp > 0)
			l = mid + 1;
		else
			r = mid - 1;
	}
	return -1;
}

int cu_find_mnemonic(u32 val, char *to) {
    cu_set_XO(val);
	cu_index = binary_search();
	
	if (cu_index == -1)
		return False;
		
    strcpy(to, mnemonics[cu_index]);
	return True;
}

/*
 * Signed-Extend 16-bit to 32-bit
 */
static u32 ExtS16(u16 val) {
	u32 ret = val;
	
	if (get_bit(val, 15) == 1) {
		ret |= 0xffff0000;
	} else {
		ret &= 0x0ffff;
	}
	return ret;
}

/*
 * Unsigned-Extend 16-bit to 32-bit
 */
static u32 ExtU16(u16 val) {
	u32 ret = val;
	
	ret &= 0x0ffff;
	
	return ret;
}

/*
 * get_bits of 32-bits from ??? to ??? (included).
 */

static u32 get_bits(u32 val, u8 from, u8 to) {
	u32 mask = -1, ret = 0;
	
	if (from <= to) {
		mask = (mask<<from) & (mask>>(31-to));
		ret = val & mask;
	}
	return ret>>from;
}

static u32 get_mask(u8 from, u8 to) {
	u32 mask = -1;
	
	if (from <= to) {
		mask = (mask<<from) & (mask>>(31-to));
	} else {
		mask = (mask<<to) & (mask>>(31-from));
		mask = ~mask;
	}
	return mask;
}

/*
 * Decode wrong debug Info.
 */
static void DecodeWrong(u32 val) {
	prinf("You Decode WRONG!!!\t[0x%032x]: %032x\n", cu_pc, val);
}

/*
 * if Rc then Update CR0.
 */
static void WrCR0(u32 val) {
	u8 tmp = 0;
	
	tmp |= regs_get_XER_CA();
	
	if (val < 0) tmp |= 0x8;
	if (val > 0) tmp |= 0x4;
	if (val == 0) tmp |= 0x2;
	
	regs_set_CRI(tmp, 0);
}

/*
 * handle I-Form Instructions: B
 * TOTAL: 1
 */
void cu_handle_I_Form(u32 val) {
	PPC_Instr_st instr;
    u32 LI;
	u8 AA, LK;
	int a, b;
	
	instr.val = val;
	LI = instr.Format.I_Form.LI;
	AA = instr.Format.I_Form.AA;
	LK = instr.Format.I_Form.LK;
	
    if (LK) {
		regs_set_LR( LE2BE_32(cu_pc + 4) );
    }
	
	if (AA) {
		a = 0; 
	} else {
		a = cu_pc;
	}
	b = (int)(LI << 2);
	cu_npc = (u32)(a + b);
}

/*
 * handle B-Form Instructions: BC
 * TOTAL: 1
 */
void cu_handle_B_Form(u32 val) {
	PPC_Instr_st instr;
	u16 BD;
	u8 BO, BI, AA, LK;
	u32 ctr, cr;
	u8 ctrl_ok, cond_ok;
	int a, b;
	
	instr.val = val;
	BO = instr.Format.B_Form.BO;
	BI = instr.Format.B_Form.BI;
	BD = instr.Format.B_Form.BD;
	AA = instr.Format.B_Form.AA;
	LK = instr.Format.B_Form.LK;

	// Get ctr then Transfer to real VALUE.
	ctr = regs_get_CTR();
	ctr = BE2LE_32(ctr);
	cr = regs_get_CR();
	
	if ( get_bit(BO, 2) == 0 ) {
		--ctr;
		// need to write back.
		regs_set_CTR( LE2BE_32(ctr) );
		ctr_ok = (ctr != 0);
	} else {
		ctr_ok = 1;
	}
	
	cond_ok = get_bit(BO, 0) || (get_bit(cr, BI) == get_bit(BO, 1));
	
	if (ctr_ok && cond_ok) {
		if (AA) {
			a = 0;
		} else {
			a = cu_pc;
		}
		BD <<= 2;
		cu_npc = a + (int)( Ext16(BD) );
	}
	
	if (LK)	 {
		regs_set_LR( LE2BE_32(cu_pc + 4) );
	}
}

/*
 * handle SC-Form Instructions: SC
 * TOTAL: 1
 */
void cu_handle_SC_Form(u32 val) {
	PPC_Instr_st instr;
	u8 LEV;
	
	instr.val = val;
	LEV = instr.Format.SC_Form.LEV;
	
	/* do nothing */
	printf("I'm a SC.\n");
}

/*
 * handle D-Form Instructions: addi/addic/addic./addis/andi./andis./cmpi/cmpli/
 *							   lbz/lha/lhz/lmw/lwz/mulli/ori/oris/stb/sth/stmw/
 *							   stw/subfic/twi/xori
 * TOTAL: 23 
 */
void cu_handle_D_Form(u32 val) {
    PPC_Instr_st instr;
    u8 RT, RA, GPRWr=0, CAWr=0, Rc=0, CRWr=0, DMOp=0, MDSel=0, DMWr=0;
	u32 srca, srcb;
	u32 wr, ALUOut, DMOut;
	u16 D;
	
    instr.val = val;
	RT = instr.Format.D_Form.RT;
	RA = instr.Format.D_Form.RT;
	D  = instr.Format.D_Form.D;
	
	switch (cu_opcd) {					
		case PPC_STMW_OPCD:
            /* DO Nothing for trap. */
            printf("I'm a STMW.\n");
			break;
			
        case PPC_LMW_OPCD:
            /* DO Nothing for trap. */
            printf("I'm a LMW.\n");
			break;
			
		case PPC_TRAP_OPCD:
			/* DO Nothing for trap. */
			printf("It's a trap.\n");
			break;	
			
		case PPC_MULLI_OPCD:
			srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			MDUOp = MDUOp_MULW;
			wr = RT;
			GPRWr = MDUSel = 1;
			break;
			
		case PPC_XORI_OPCD:
			srca = regs_get_GPR(RS);
			srcb = EXTU16(D);
			ALUOp = ALUOp_XOR;
			wr = RA;
			GPRWr = 1;
			break;		
			
		case PPC_ORI_OPCD:
			srca = regs_get_GPR(RT);
			srcb = EXTU16(D);
			ALUOp = ALUOp_OR;
			wr = RA;
			GPRWr = 1;
			break;
			
		case PPC_SUBFIC_OPCD:
			srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_SUBF;
			wr = RT;
			GPRWr = CAWr = 1;
			break;
		
		case PPC_STB_OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_ADD;
			DMOp = DMOp_STB;
			DMWr = 1;
			break;
			
		case PPC_STH_OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_ADD;
			DMOp = DMOp_STH;
			DMWr = 1;
			break;
			
		case PPC_STW_OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_ADD;
			DMOp = DMOp_STW;
			DMWr = 1;
			break;			
		
		case PPC_LWZ_OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_ADD;
			DMOp = DMOp_LWZ;
			wr = RT;
			GPRWr = 1;
			break;
			
		case PPC_LHA_OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_ADD;
			DMOp = DMOp_LHZ;
			wr = RT;
			GPRWr = 1;
			break;
			
		case PPC_LHA_OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_ADD;
			DMOp = DMOp_LHA;
			wr = RT;
			GPRWr = 1;
			break;
			
		case PPC_LBZ_OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_ADD;
			DMOp = DMOp_LBZ;
			wr = RT;
			GPRWr = 1;
			break;
			
		case PPC_CMPI_OPCD:
			srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_CMPU;
			CRWr = 1;
			break;
			
		case PPC_CMPI_OPCD:
			srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_CMP;
			CRWr = 1;
			break;
			
		case PPC_ANDIS__OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = D;
			srcb <<= 16;
			ALUOp = ALUOp_AND;
			wr = RT;
			GPRWr = Rc = 1;
			break;
			
		case PPC_ANDI__OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_AND;
			wr = RT;
			GPRWr = Rc = 1;
			break;
			
		case PPC_ADDIS_OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = D;
			srcb <<= 16;
			ALUOp = ALUOp_ADD;
			wr = RT;
			GPRWr = 1;
			break;
			
		case PPC_ADDIC__OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_ADD;
			wr = RT;
			GPRWr = CAWr = Rc = 1;
			break;
			
		case PPC_ADDIC_OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_ADD;
			wr = RT;
			GPRWr = CAWr = 1;
			break;
			
		case PPC_ADDI_OPCD:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = EXTS16(D);
			ALUOp = ALUOp_ADD;
			wr = RT;
			GPRWr = 1;
			break;
			
		default:
			DecodeWrong(val);
			return ;
	}
	
	ALUOut = ALU(srca, srcb, ALUOp);
	MDUOut = MDU(srca, srcb, MDUOp);
	
	if (DMOp) {
		if (GPRWr) {
			// Load
			DMOut = get_dmem(ALUOut, DMOp);
			regs_set_GPR(wr, DMOut);
		} else {
			// Store
			set_dmem(regs_set_GPR(RT), DMOp);
		}
	} else if (GPRWr) {
		if (MDUSel)
			regs_set_GPR(wr, MDUOut);
		else
			regs_set_GPR(wr, ALUOut);
	}
	
	if (CAWr) {
		regs_set_XER_CA(get_ALU_CA());
	}
	
	if (CRWr) {
		regs_set_CRI((u8)ALUOut, RT>>2);
	}
	
	if (Rc)	
		WrCR0(ALUout);
}

/*
 * handle DS-Form Instructions: NONE
 */
void cu_handle_DS_Form(u32 val) {
    PPC_Instr_st instr;
	u8 RT, RA;
	u16 DS;
	
    instr.val = val;
	RT = instr.Format.DS_Form.RT;
	RA = instr.Format.DS_Form.RA;
	DS = instr.Format.DS_Form.DS;
	
	/*
	 * We DO NOT support any DS-Form instructions,
	 * so definitely you fetch wrong or decode wrong.
	 */
	DecodeWrong(val);
}

/*
 * handle X-Form Instructions: and/andc/cmp/cmpl/cntlzw/extsb/extsh/lbzx/lhax/
 *							   lhbrx/lhzx/lwarx/lwbrx/lwzx/mfmsr/mtmsr/nand/
 *							   nor/or/orc/slw/sraw/srawi/srw/stbx/sthbrx/sthx/
 *							   stwbrx/stwcx./stwx/sync/wrteei/xor/
 * TOTAL: 33
 */
void cu_handle_X_Form(u32 val) {
	PPC_Instr_st instr;
	u8 RT, RA, RB, Rc, GPRWr=0, CRWr=0, DMWr=0, DMOp;
	u32 ALUOp=0, srca, srcb, wr, ALUOut, DMOut;
	
	instr.val = val;
	RT = instr.Format.X_Form.RT;
	RA = instr.Format.X_Form.RA;
	RB = instr.Format.X_Form.RB;
	Rc = instr.Format.X_Form.Rc;
	
	if (cu_opcd != PPC_AND_OPCD) {
		DecodeWrong(val);
		return ;
	}
	
	switch(cu_xo) {
		case PPC_AND_XO:
			ALUOp = ALUOp_AND;
			srca = regs_get_GPR(RT);
			srcb = regs_get_GPR(RB);
			wr = RA;
			GPRWr = 1;
			break;
			
		case PPC_ANDC_XO:
			ALUOp = ALUOp_ANDC;
			srca = regs_get_GPR(RT);
			srcb = regs_get_GPR(RB);
			wr = RA;
			GPRWr = 1;
			break;
			
		case PPC_CMP_XO:
			/* Need to check L==0 const ? */
			ALUOp = ALUOp_CMP;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			CRWr = 1;
			break;
			
		case PPC_CMPL_XO:
			/* Need to check L==0 const ? */
			ALUOp = ALUOp_CMPU;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			CRWr = 1;
			break;
			
		case PPC_CNTLZW_XO:
			ALUOp = ALUOp_CNTZ;
			srca = regs_get_GPR(RT);
			wr = RA;
			GPRWr = 1;
			break;
			
		case PPC_EXTSB_XO:
			ALUOp = ALUOp_EXTSB;
			srca = regs_get_GPR(RT);
			wr = RA;
			GPRWr = 1;
			break;
			
		case PPC_EXTSH_XO:
			ALUOp = ALUOp_EXTSH;
			srca = regs_get_GPR(RT);
			wr = RA;
			GPRWr = 1;
			break;
			
		case PPC_LBZX_XO:
			if (RA == 0)
				srca = 0;
			else	
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			wr = RT;
			GPRWr = 1;
			DMOp = DMOp_LBZ;
			break;
			
		case PPC_LHAX_XO:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			wr = RT;
			GPRWr = 1;
			DMOp = DMOp_LHA;
			break;
			
		case PPC_LHBRX_XO:
			if (RA == 0)
				srca = 0;
			else
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			wr = RT;
			GPRWr = 1;
			DMOp = DMOp_LHBRX;
			break;
			
		case PPC_LHZX_XO:
			if (RA == 0)
				srca = 0;
			else	
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			wr = RT;
			GPRWr = 1;
			DMOp = DMOp_LHZ;
			break;
		
		case PPC_LWARX_XO:
			if (RA == 0)
				srca = 0;
			else	
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			wr = RT;
			GPRWr = 1;
			DMOp = DMOp_LWARX;
			break;
			
		case PPC_LWBRX_XO:
			if (RA == 0)
				srca = 0;
			else	
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			wr = RT;
			GPRWr = 1;
			DMOp = DMOp_LWBRX;
			break;

		case PPC_LWZX_XO:
			if (RA == 0)
				srca = 0;
			else	
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			wr = RT;
			GPRWr = 1;
			DMOp = DMOp_LWZ;
			break;
			
		case PPC_MFMSR_XO:
			srca = regs_get_MSR();
			ALUOp = ALUOp_NOP;
			wr = RT;
			GPRWr = 1;
			break;
			
		case PPC_MTMSR_XO:
			srca = regs_get_GPR(RT);
			regs_set_MSR(srca);
			break;
			
		case PPC_NAND_XO:
			ALUOp = ALUOp_NAND;
			srca = regs_get_GPR(RT);
			srcb = regs_get_GPR(RB);
			wr = RA;
			GPRWr = 1;
			break;
			
		case PPC_NOR_XO:
			ALUOp = ALUOp_NOR;
			srca = regs_get_GPR(RT);
			srcb = regs_get_GPR(RB);
			wr = RA;
			GPRWr = 1;
			break;	
			
		case PPC_OR_XO:
			ALUOp = ALUOp_OR;
			srca = regs_get_GPR(RT);
			srcb = regs_get_GPR(RB);
			wr = RA;
			GPRWr = 1;
			break;
			
		case PPC_ORC_XO:
			ALUOp = ALUOp_ORC;
			srca = regs_get_GPR(RT);
			srcb = regs_get_GPR(RB);
			wr = RA;
			GPRWr = 1;
			break;	
			
		case PPC_SLW_XO:
			ALUOp = ALUOp_SLL;
			srca = regs_get_GPR(RT);
			srcb = regs_get_GPR(RB);
			wr = RA;
			GPRWr = 1;
			break;	
			
		case PPC_SRA_XO:
			ALUOp = ALUOp_SRA;
			srca = regs_get_GPR(RT);
			srcb = regs_get_GPR(RB);
			wr = RA;
			GPRWr = 1;
			break;

		case PPC_SRAWI_XO:
			ALUOp = ALUOp_SRA;
			srca = regs_get_GPR(RT);
			srcb = rRB;
			wr = RA;
			GPRWr = 1;
			break;
			
		case PPC_SRW_XO:
			ALUOp = ALUOp_SRL;
			srca = regs_get_GPR(RT);
			srcb = regs_get_GPR(RB);
			wr = RA;
			GPRWr = 1;
			break;		

		case PPC_STBX_XO:
			if (RA == 0)
				srca = 0;
			else	
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			DMWr = 1;
			DMOp = DMOp_STB;
			break;
			
		case PPC_STHBRX_XO:
			if (RA == 0)
				srca = 0;
			else	
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			DMWr = 1;
			DMOp = DMOp_STHBR;
			break;	
			
		case PPC_STWBRX_XO:
			if (RA == 0)
				srca = 0;
			else	
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			DMWr = 1;
			DMOp = DMOp_STWBR;
			break;	
			
		case PPC_STWCX__XO:
			if (RA == 0)
				srca = 0;
			else	
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			DMWr = 1;
			DMOp = DMOp_STHBR;
			break;

		case PPC_STWX_XO:
			if (RA == 0)
				srca = 0;
			else	
				srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			ALUOp = ALUOp_ADDU;
			DMWr = 1;
			DMOp = DMOp_STW;
			break;
			
		case PPC_SYNC_XO:
			/* DO NOTHING. */
			break;			
		
		case PPC_WRTEEI_XO:
			/* DO NOTHING. */
			break;				
			
		case PPC_XOR_XO:
			ALUOp = ALUOp_XOR;
			srca = regs_get_GPR(RT);
			srcb = regs_get_GPR(RB);
			wr = RA;
			GPRWr = 1;
			break;
			
		default:	
			DecodeWrong(val);
			return ;
	}
	
	ALUOut = ALU(srca, srcb, ALUOp);
	
	// Read from DM MUST in front of Write-back GPR
	if (DMOp) {
		if (GPRWr) {
			// Load
			DMOut = (ALUOut, DMOp);
			regs_set_GPR(wr, DMout);
		} else if (DMWr) {
			// Store
			set_dmem(ALUOut, regs_get_GPR(RT), DMOp);
		}
	} else if (GPRWr) {
		regs_set_GPR(wr, ALUout);
	}
	
	if (Rc)
		WrCR0(ALUout);
}

/*
 * handle XL-Form Instructions: bcctr/bclr/crand/crxor/crnor/mcrf/rfi
 * TOTAL: 7
 */
void cu_handle_XL_Form(u32 val) {
	PPC_Instr_st instr;
	u8 BT, BA, BB, LK;
	u8 a, b, c;
	u8 CRWr = 0, from, to;
	u8 cond_ok;
	u32 cr, ctr;
	u32 mask = -1, op;
	
	instr.val = val;
	BT = instr.Format.XL_Form.BT;
	BA = instr.Format.XL_Form.BA;
	BB = instr.Format.XL_Form.BB;
	LK = instr.Format.XL_Form.LK;
	
	cr = regs_get_cr();
	from = to = BT;
	
	if (cu_opcd != PPC_BCCTR_OPCD) {
		DecodeWrong(val);
		return ;
	}
	
	switch (cu_xo) {
		PPC_CRAND_XO:
			op = CR_ALUOP_AND;
			a = get_bit(cr, BA);
			b = get_bit(cr, BB);
			c = CR_ALU(a, b, op);
			CRWr = 1;
			break;
			
		PPC_CRXOR_XO:
			op = CR_ALUOP_XOR;
			a = get_bit(cr, BA);
			b = get_bit(cr, BB);
			c = CR_ALU(a, b, op);
			CRWr = 1;
			break;
		
		PPC_CRNOR_XO:
			op = CR_ALUOP_NOR;
			a = get_bit(cr, BA);
			b = get_bit(cr, BB);
			c = CR_ALU(a, b, op);
			CRWr = 1;
			break;
			
		PPC_MCRF_XO:
			from = BT<<2;
			to = BT<<2+3;
			c = (u8)get_bits(cr, BA<<2, BA<<2+3);
			CRWr = 1;
			break;
			
		PPC_BCLR_XO:
			if (get_bit(BO, 2) == 0) {
				ctr = regs_get_ctr();
				--ctr;
				regs_set_ctr(ctr);
				ctr_ok = (ctr!=0) ^ get_bit(BO, 3);
			} else {
				ctr_ok = 1;
			}
			cond_ok = get_bit(BO, 0) | (get_bit(CR, BA) == get(BO, 1));
			if cond_ok && ctr_ok {
				cu_npc = BE2LE_32(regs_get_lr() && 0xfffc);
			}
			break;
			
		PPC_BCCTR_XO:
			cond_ok = get_bit(BO, 0) | (get_bit(CR, BA) == get(BO, 1));
			if cond_ok {
				cu_npc = BE2LE_32(regs_get_ctr() && 0xfffc);
			}
			break;
			
		default:
			DecodeWrong(val);
			return ;
	}
	
	if (LK)	 {
		regs_set_LR( LE2BE_32(cu_pc + 4) );
	}
	
	if (CRWr) {
		mask = get_mask(from, to);
		cr = (c&mask) | (cr&~mask);
		regs_set_cr(cr);
	}
}

/*
 * handle XFX-Form Instructions: mfcr/mfspr/mtcrf/mtspr
 * TOTAL: 4
 */
void cu_handle_XFX_Form(u32 val) {
	PPC_Instr_st instr;
	u8 RT;
	u16 SPR, FXM;
	u32 tmp, cr, mask;
    u32 wd = 0, addr;
	int i;
	
	instr.val = val;
	RT = instr.Format.XFX_Form.RT;
	SPR = instr.Format.XFX_Form.SPR;
	
	if (cu_opcd != PPC_MFCR_OPCD) {
		DecodeWrong(val);
		return ;
	}
	
	switch (cu_xo) {
		case PPC_MFCR_XO:
			addr = RT;
            wd |= regs_get_CR();
			regs_set_GPR(addr, wd);
			break;
			
		case PPC_MFSPR_XO:
			addr = (get_bits((u32)SPR, 5, 9)<<5) | get_bits((u32)SPR, 0, 4);
			/* Treat all SPR as 64-bit mode.*/
			wd = regs_get_SPR(addr);
			addr = RT;
			regs_set_GPR(addr, wd);
			break;
			
		case PPC_MTCRF_XO:
			FXM = SPR>>1;
			addr = RT;
			wd = regs_get_GPR(addr);
			// we only want the highest part.
			tmp = (wd>>32);
			cr = regs_get_CR();
			i = 0;
			while (i<8) {
				if ( get_bit((u32)FXM, i) == 0 ) {
					mask = 0xffffffff;
					mask = (mask<<(i<<2)) & (mask>>(31-(i<<2+3)));
					tmp = (cr&mask) | (tmp&~mask);
				}
				++i;
			}
            wd = tmp;
			regs_set_CR(wd);
			break;
			
		case PPC_MTSPR_XO:
			addr = RT;
			wd = regs_get_GPR(addr);
			addr = (get_bits((u32)SPR, 5, 9)<<5) | get_bits((u32)SPR, 0, 4);
			regs_set_SPR(addr, wd);
			break;
			
		default:
			DecodeWrong(val);
			return ;
	}	
}

/*
 * handle XO-Form Instructions: add/addc/adde/addme/addze/divw/divwu/
 *								mullhw/mullhwu/mullw/neg/subf/subfc/
 *								subfe/subme/subfze
 * TOTAL: 16			
 */
void cu_handle_XO_Form(u32 val) {
    PPC_Instr_st instr;
	u8 RT, RA, RB, OE, Rc;
	u8 wr, GPRWr=0, CAWr=0, MDUSel=0;
	u32 srca, srcb, ALUOp, MDUOp, MDUOut, ALUOut;
	
    instr.val = val;
	RT = instr.Format.XO_Form.RT;
	RA = instr.Format.XO_Form.RA;
	RB = instr.Format.XO_Form.RB;
	OE = instr.Format.XO_Form.OE;
	Rc = instr.Format.XO_Form.Rc;
	
	if (cu_opcd != PPC_ADD_OPCD) {
		DecodeWrong(val);
		return ;	
	}
	
	switch (cu_xo) {
		case PPC_SUBFZE_XO:
			MDUOp = MDUOp_SUBFE;
			srca = regs_get_GPR(RA);
			srcb = 0;
			wr = RT;
			GPRWr = CAWr = 1;
			break;

		case PPC_SUBFME_XO:
			MDUOp = MDUOp_SUBFE;
			srca = regs_get_GPR(RA);
			srcb = 0xffffffff;
			wr = RT;
			GPRWr = CAWr = 1;
			break;

		case PPC_SUBFE_XO:
			MDUOp = MDUOp_SUBFE;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = CAWr = 1;
			break;

		case PPC_SUBFC_XO:
			MDUOp = MDUOp_SUBF;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = CAWr = 1;
			break;

		case PPC_SUBF_XO:
			MDUOp = MDUOp_SUBF;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = 1;
			break;

		case PPC_NEG_XO:
			ALUOp = MDUOp_SUBF;
			srca = regs_get_GPR(RA);
			srcb = 0;
			wr = RT;
			GPRWr = 1;
			break;
	
		case PPC_MULLW_XO:
			MDUOp = MDUOp_MULLW;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = MDUSel = 1;
			break;
			
		case PPC_MULHWU_XO:
			MDUOp = MDUOp_MULWU;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = MDUSel = 1;
			break;
			
		case PPC_MULHW_XO:
			MDUOp = MDUOp_MULW;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = MDUSel = 1;
			break;
			
		case PPC_DIVWU_XO:
			MDUOp = MDUOp_DIVWU;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = MDUSel = 1;
			break;
			
		case PPC_DIVW_XO:
			MDUOp = MDUOp_DIVW;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = MDUSel = 1;
			break;
			
		case PPC_ADDZE_XO:
			ALUOp = ALUOp_ADDE;
			srca = regs_get_GPR(RA);
			srcb = 0;
			wr = RT;
			GPRWr = CAWr = 1;
			break;
			
		case PPC_ADDME_XO:
			ALUOp = ALUOp_ADDE;
			srca = regs_get_GPR(RA);
			srcb = 0xffffffff;
			wr = RT;
			GPRWr = CAWr = 1;
			break;
			
		case PPC_ADDE_XO:
			ALUOp = ALUOp_ADDE;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = CAWr = 1;
			break;
			
		case PPC_ADDC_XO:
			ALUOp = ALUOp_ADD;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = CAWr = 1;
			break;
			
		case PPC_ADD_XO:
			ALUOp = ALUOp_ADD;
			srca = regs_get_GPR(RA);
			srcb = regs_get_GPR(RB);
			wr = RT;
			GPRWr = 1;
			break;
			
		default:
			DecodeWrong();
			return ;
	}
	
	ALUOut = ALU(srca, srcb, ALUOp);
	MDUOut = MD(srca, srcb, MDUOp);
	
	if (GPRWr) {
		if (MDUSel)
			reg_set_GPR(wr, MDUOut);
		else	
			reg_set_GPR(wr, ALUOut);
	}
	
	if (CAWr) {
		regs_set_XER_CA(get_ALU_CA());
	}
	
	if (OE) {
		regs_set_XER_SO(get_ALU_OV());
	}
	
	if (Rc) {
		if (MDUSel)
			WrCR0(MDUOut);
		else	
			WrCR0(ALUOut);
	}
}

/*
 * handle XFL-Form Instructions: NONE
 */
void cu_handle_XFL_Form(u32 val) {
    PPC_Instr_st instr;
	u16 FLM, FRB;
	
    instr.val = val;
	FLM = instr.Format.XFL_Form.FLM;
	FRB = instr.Format.XFL_Form.FRB;
	
	/*
	 * We DO NOT support any XFL-Form instructions,
	 * so definitely you fetch wrong or decode wrong.
	 */
	DecodeWrong(val);
}

/*
 * handle XS-Form Instructions: NONE
 */
void cu_handle_XS_Form(u32 val) {
    PPC_Instr_st instr;
	u8 RS, RA, SH0, SH1, Rc;
	
    instr.val = val;
	RS = instr.Format.XS_Form.RS;
	RA = instr.Format.XS_Form.RA;
	SH0 = instr.Format.XS_Form.SH0;
	SH1 = instr.Format.XS_Form.SH1;
	Rc = instr.Format.XS_Form.Rc;
	
	/*
	 * We DO NOT support any XS-Form instructions,
	 * so definitely you fetch wrong or decode wrong.
	 */
	DecodeWrong(val);
}

/*
 * handle A-Form Instructions: NONE
 */
void cu_handle_A_Form(u32 val) {
    PPC_Instr_st instr;
	u8 FRT, FRA, FRB, FRC, Rc;
	
    instr.val = val;
	FRT = instr.Format.A_Form.FRT;
	FRA = instr.Format.A_Form.FRA;
	FRB = instr.Format.A_Form.FRB;
	Rc = instr.Format.A_Form.Rc;
	
	/*
	 * We DO NOT support any A-Form instructions,
	 * so definitely you fetch wrong or decode wrong.
	 */
	DecodeWrong(val);
}

/*
 * handle M-Form Instructions: rlwimi/rlwinm/rlwnm
 * TOTAL: 3
 */
void cu_handle_M_Form(u32 val) {
    PPC_Instr_st instr;
	u8 RS, RA, RB, MB, ME, Rc;
	u32 n, b, e, r, k, tmp;
    u32 rd, wd;
	
    instr.val = val;
	RS = instr.Format.M_Form.RS;
	RA = instr.Format.M_Form.RA;
	RB = instr.Format.M_Form.RB;
	MB = instr.Format.M_Form.MB;
	ME = instr.Format.M_Form.ME;
	Rc = instr.Format.M_Form.Rc;
	
	b = MB + 32;
	e = ME + 32;
	k = get_mask(b, e);
    rd = regs_get_GPR(RS);
	
	switch (cu_opcd) {
		case PPC_RLWIMI_OPCD:
			n = RB;
			r = (rd>>n);
			tmp = (r & k) | (rd & ~k);
            wd = tmp;
			regs_set_GPR(RA, wd);
			break;
			
		case PPC_RLWINM_OPCD:
			n = RB;
			r = (rd>>n);
			tmp = (r & k);
            wd = tmp;
			regs_set_GPR(RA, wd);
			break;
			
		case PPC_RLWNM_OPCD:
			tmp = (regs_get_GPR(RB)>>32);
			n = get_bits(tmp, 27, 31);
			r = (rd>>n);
			tmp = (r & k);
            wd = tmp;
			regs_set_GPR(RA, wd);
			break;
			
		default:
			DecodeWrong(val);
			return ;	
	}
	if (Rc)
		WrCR0(tmp);
}

/*
 * handle MD-Form Instructions: NONE
 */
void cu_handle_MD_Form(u32 val) {
    PPC_Instr_st instr;
	u8 RS, RA, RB, MB, SH0, SH1, Rc;
	
    instr.val = val;
	RS = instr.Format.MD_Form.RS;
	RA = instr.Format.MD_Form.RA;
	RB = instr.Format.MD_Form.RB;
	MB = instr.Format.MD_Form.MB;
	SH0 = instr.Format.MD_Form.SH0;
	SH1 = instr.Format.MD_Form.SH1;
	Rc = instr.Format.MD_Form.Rc;
	
	/*
	 * We DO NOT support any MD-Form instructions,
	 * so definitely you fetch wrong or decode wrong.
	 */
	DecodeWrong(val);
}

/*
 * handle MDS-Form Instructions: NONE
 */
void cu_handle_MDS_Form(u32 val) {
    PPC_Instr_st instr;
	u8 RS, RA, RB, MB, Rc;
	
    instr.val = val;
	RS = instr.Format.M_Form.RS;
	RA = instr.Format.M_Form.RA;
	RB = instr.Format.M_Form.RB;
	MB = instr.Format.M_Form.MB;
	Rc = instr.Format.M_Form.Rc;
	
	/*
	 * We DO NOT support any MDS-Form instructions,
	 * so definitely you fetch wrong or decode wrong.
	 */
	DecodeWrong(val);
}

/*
 * Intial the CU.
 */
void cu_initial() {
    fptrs[0] = cu_handle_I_Form;
    fptrs[1] = cu_handle_B_Form;
    fptrs[2] = cu_handle_SC_Form;
    fptrs[3] = cu_handle_D_Form;
    fptrs[4] = cu_handle_DS_Form;
    fptrs[5] = cu_handle_X_Form;
    fptrs[6] = cu_handle_XL_Form;
    fptrs[7] = cu_handle_XFX_Form;
    fptrs[8] = cu_handle_XFL_Form;
    fptrs[9] = cu_handle_XS_Form;
    fptrs[10] = cu_handle_XO_Form;
    fptrs[11] = cu_handle_A_Form;
    fptrs[12] = cu_handle_M_Form;
    fptrs[13] = cu_handle_MD_Form;
    fptrs[14] = cu_handle_MDS_Form;
}

/*
 * Connect all part and begin to work.
 */
void cu_work() {
    u32 instr;
    int index;

    // PC -> IMEM and Update NPC
    cu_pc = get_pc();
    cu_npc = cu_pc + 4;

    // Get instruction from imem.
    instr = get_imem(cu_pc);

    // Set XO and OPCD then search the instruction.
    cu_set_XO(instr);
    index = binary_search();

    // Use Index very thoughtfully to Decode the instruction.
    fptrs[index](instr);

    // Update PC;
    set_pc(cu_npc);
}

u32 cu_get_instr() {
	return get_imem(cu_pc);
}

u32 cu_get_pc() {
	return cu_pc;
}