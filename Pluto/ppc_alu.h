#ifndef PPC_ALU_H
#define PPC_ALU_H

#include "ppc_type.h"

extern u32 CR_ALU(u32, u32, u32);
extern u32 ALU(u32, u32, u32);
extern u32 MDU(u32, u32, u32);
extern u8 get_ALU_CA(void);
extern u8 get_ALU_OV(void);

extern void ALU_initial();

#endif
