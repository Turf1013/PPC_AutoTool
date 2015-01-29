#ifndef PPC_ARCH_H
#define PPC_ARCH_H

#include "ppc_type.h"

#define PPC_GPR_LEN u64
#define PPC_GPR_N 32
#define PPC_SPR_N 128

#define BE2LE_32(val) En_trans_32(val)
#define BE2LE_64(val) En_trans_64(val)
#define LE2BE_32(val) En_trans_32(val)
#define LE2BE_64(val) En_trans_64(val)

extern u32 En_trans_32(u32);
extern u64 En_trans_64(u64);

#endif