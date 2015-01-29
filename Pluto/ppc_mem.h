#ifndef PPC_MEM_H
#define PPC_MEM_H

#include "ppc_type.h"

#define PPC_DMEM_BASE 0
#define PPC_DMEM_SIZE 1000

#define PPC_IMEM_BASE 0x3000
#define PPC_IMEM_SIZE 1000

extern void set_imem(u32 addr, u32 val);
extern u32 get_imem(u32 addr);
extern void set_dmem(u32 addr, u32 val, op);
extern u32 get_dmem(u32 addr, u8 op);

extern void initial_imem(u32 val);
extern void initial_dmem(u32 val);

#endif
