#include "ppc_alu.h"
#include "ppc_cu_vdef.h"
#include "ppc_arch.h"
#include <stdio.h>

static u8 ALU_CA=0, ALU_OV=0;

static void DecodeWrong(char str[]) {
	printf("%s Decode WRONG!!!\n", str);
}

void ALU_initial() {
    ALU_CA = ALU_OV = 0;
}

u8 CR_ALU(u8 a, u8 b, u32 op) {
	switch (op) {
        CR_ALUOp_NOP: return a;
        CR_ALUOp_AND: return a & b;
        CR_ALUOp_NOR: return ~(a | b);
        CR_ALUOp_XOR: return a ^ b;
		default: 
			DecodeWrong("CR_ALU");
			return -1;
	}
}

u32 ALU(u32 srca, u32 srcb, u32 op) {
	u32 ret, tmp;
	u32 ua, ub;
	u64 ua64, ub64, tmp64=0, tmp31, tmp32;
	int ia, ib, itmp;
	u32 i, mask;
	u8 le = 0;
	
	ua = BE2LE_32(srca);
	ub = BE2LE_32(srcb);
	ia = ua;
	ib = ub;
	ua64 = ua;
	ub64 = ub;
	
	switch(op) {
        case ALUOp_NOP:
			tmp = ua;
			le = 1;
			break;
			
        case ALUOp_AND:
			tmp = ua & ub;
			le = 1;
			break;
			
        case ALUOp_ANDC:
			tmp = ua & ~ub;
			le = 1;
			break;
			
        case ALUOp_CMP:
			if (ia < ib)	tmp = 4;
			if (ia > ib)	tmp = 2;
			if (ia == ib)	tmp = 1;
			break;
			
        case ALUOp_CMPU:
			if (ua < ub)	tmp = 4;
			if (ua > ub)	tmp = 2;
			if (ua == ub)	tmp = 1;
			break;
			
        case ALUOp_CNTZ:
			i = 0;
			while (i < 32) {
				if (srca & (1<<i)) {
					break;
				}
				++i;
			}
			tmp = i;
			le = 1;
			break;
			
        case ALUOp_EXTSB:
			tmp = srca & 0x1000;
			if (tmp)
				tmp = 0x0fff | (srca & 0xf000);
			else
				tmp = srca & 0x0f;
			break;
			
        case ALUOp_EXTSH:
			tmp = srca & 0x100;
			if (tmp)
				tmp = 0x00ff | (srca & 0xff00);
			else
				tmp = srca & 0xff00;
			break;
			
        case ALUOp_ADDU:
			tmp = ua + ub;
			le = 1;
			break;	
			
        case ALUOp_NAND:
			tmp = ~(ua & ub);
			le = 1;
			break;
			
        case ALUOp_NOR:
			tmp = ~(ua | ub);
			le = 1;
			break;
			
        case ALUOp_OR:
			tmp = ua | ub;
			le = 1;
			break;
			
        case ALUOp_ORC:
			tmp = ua | ~ub;
			le = 1;
			break;
			
        case ALUOp_SLL:
			tmp = ua>>ub;
			le = 1;
			break;
			
        case ALUOp_SRA:
			tmp = ia<<ib;
			le =1;
			break;
			
        case ALUOp_SRL:
			tmp = ua<<ub;
			le = 1;
			break;
			
        case ALUOp_XOR:
			tmp = ua ^ ub;
			le = 1;
			break;
		
        case ALUOp_ADD:
			tmp64 = ua64 + ub64;
			tmp = tmp64;
			le = 1;
			break;	
			
        case ALUOp_ADDE:
			tmp64 = ua64 + ub64 + CA;
			tmp = tmp64;
			le = 1;
			break;
		
        case ALUOp_SUBF:
			tmp64 = ~ua64 + ub64 + 1;
			tmp = tmp64;
			le = 1;
			break;
			
		
        case ALUOp_SUBFE:
			tmp64 = ~ua64 + ub64 + CA;
			tmp = tmp64;
			le = 1;
			break;	
			
		default:	
			DecodeWrong("ALU");
			return -1;
	}
	
	if (le)
		ret = LE2BE_32(tmp);
	
	tmp31 = tmp64 & 0x08000;
	tmp31 >>= 31;
	tmp32 = tmp64 & 0x10000;
	tmp32 >>= 32;
	ALU_OV = (tmp31 ^ tmp32) ? 1:0;
	ALU_CA = (tmp31) ? 1:0;
	
	return ret;
}

u32 MDU(u32 srca, u32 srcb, u32 op) {
	u32 ua, ub, utmp, ret;
	int ia, ib, itmp;
	u64 ua64, ub64, utmp64;
	__int64 ia64, ib64, itmp64;
	
	ua = BE2LE_32(srca);
	ub = BE2LE_32(srcb);
	ia = ua;
	ib = ub;
	ua64 = ua;
	ub64 = ub;
	ia64 = ia;
	ib64 = ib;
	
	switch (op) {
        case MDUOp_DIVW:
			if ((ua==0x80000000 && ub==0xffffffff) || (ub==0)) {
				ALU_OV = 1;
				ret = 0;
				break;
			}
			ret = (u32)(ia/ib);
			break;
			
        case MDUOp_DIVWU:
			if (ub == 0) {
				ALU_OV = 1;
				ret = 0;
			}
			ret = ua/ub;
			break;
			
        case MDUOp_MULT:
			ret = ua * ub;
			break;
			
        case MDUOp_MULHU:
			utmp64 = ua64 * ub64;
			ret = (u32)(utmp64 >> 32);
			break;
		
        case MDUOp_MULH:
			itmp64 = ia64 * ib64;
			ret = (u32)(itmp64 >> 32);
			break;
			
		default:
			DecodeWrong("MDU");
			return -1;
	}
	
	ret = LE2BE_32(ret);
	
	return ret;
}

u8 get_ALU_CA(void) {
	return ALU_CA;
}

u8 get_ALU_OV(void) {
	return ALU_OV;
}
