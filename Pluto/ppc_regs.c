#include "ppc_regs.h"
#include "ppc_arch.h"
#include "ppc_type.h"
#include <stdio.h>
#include <string.h>

#define REGS_SET_F(fname, rname)\
void fname(u32 val) {\
	rname = val;\
}

#define REGS_GET_F(fname, rname)\
u32 fname(void) {\
	return rname;\
}

static u32 GPR[PPC_GPR_N];
static u64 SPR[PPC_SPR_N];
static u32 CR, LR, XER, CTR;

REGS_SET_F(regs_set_CR, CR)
REGS_SET_F(regs_set_LR, LR)
REGS_SET_F(regs_set_XER, XER)
REGS_SET_F(regs_set_CTR, CTR)

REGS_GET_F(regs_get_CR, CR)
REGS_GET_F(regs_get_LR, LR)
REGS_GET_F(regs_get_XER, XER)
REGS_GET_F(regs_get_CTR, CTR)

void regs_set_GPR(u32 addr, u32 val) {
	if (addr >= PPC_GPR_N) {
		printf("GPR_addr out of range.\n");
		return ;
	}
	GPR[addr] = val;
}

u32 regs_get_GPR(u32 addr) {
	if (addr >= PPC_GPR_N) {
		printf("GPR_addr out of range.\n");
        return -1;
	}
	return GPR[addr];
}

void regs_set_SPR(u32 addr, u64 val) {
	if (addr >= PPC_SPR_N) {
		printf("GPR_addr out of range.\n");
		return ;
	}
	SPR[addr] = val;
}

u64 regs_get_SPR(u32 addr, u64 val) {
	if (addr >= PPC_SPR_N) {
		printf("GPR_addr out of range.\n");
		return ;
	}
	return SPR[addr];
}

void regs_set_CRI(u32 val, u8 addr) {
	u32 tmp;
	u32 mask = 0xf;
	
	tmp = CR;
	mask <<= addr;
	tmp &= mask;
	val &= 0x0f;
	tmp |= val;
	
	regs_set_CR(tmp);
}

u8 regs_get_XER_SO(void) {

}

u8 regs_get_XER_CA(void) {

}

void regs_set_XER_SO(u8 val) {

}

void regs_set_XER_CA(u8 val) {

}

void regs_initial() {
    memser(GPR, 0, sizeof(GPR));
    memser(SPR, 0, sizeof(SPR));
     CR = LR = XER = CTR = 0;
}
