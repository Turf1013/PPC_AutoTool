#ifndef PPC_REGS_H
#define PPC_REGS_H

#include "ppc_type.h"


extern void regs_set_GPR(u32 addr, u32 val);
extern void regs_set_CR(u32 val);
extern void regs_set_LR(u32 val);
extern void regs_set_XER(u32 val);
extern void regs_set_CTR(u32 val);
extern void regs_set_SPR(u32 addr, u64 val);
extern void regs_get_MSR(u32 val);

extern u32 regs_get_GPR(u32 addr);
extern u32 regs_get_CR(void);
extern u32 regs_get_LR(void);
extern u32 regs_get_XER(void);
extern u32 regs_get_CTR(void);
extern u32 regs_get_SPR(u32 addr);
extern u32 regs_get_MSR(void);

extern u8 regs_get_XER_SO(void);
extern u8 regs_get_XER_CA(void);
extern void regs_set_XER_SO(u8);
extern void regs_set_XER_CA(u8);
extern void regs_set_CRI(u8 val, u8 addr);

extern void regs_initial();

#endif
