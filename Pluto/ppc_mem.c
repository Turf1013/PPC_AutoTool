#include "ppc_mem.h"
#include "ppc_arch.h"

#define IERR_OUTOFRANGE 1
#define DERR_OUTOFRANGE 1

typedef union {
	u8 byte[4];
	u16 hword[2];
	u32 word;
} mem_st;

static mem_st imem[PPC_IMEM_SIZE];
static mem_st dmem[PPC_DMEM_SIZE];
static u8 Reserve=0, Reserve_Length=0;
static u32 Reserve_Addr=0;
/*
 * 0: normal
 * 1: IMem Address out of Range
 * 2: DMem Address out of Range
 */
static int ierr, derr;

void initial_imem(u32 val) {
	int i;
	for (i=0; i<PPC_IMEM_SIZE; ++i)
		imem.word = val;
}

void initial_dmem(u32 val) {
	int i;
	for (i=0; i<PPC_DMEM_SIZE; ++i)
		dmem.word = val;
}

void set_imem(u32 addr, u32 val) {
	u32 raddr;
    addr -= PPC_IMEM_BASE;
	raddr = addr>>2;
    if (raddr<0 || raddr >= PPC_IMEM_SIZE) {
        ierr = IERR_OUTOFRANGE;
        return ;
    }
	imem[raddr].word = val;
}

u32 get_imem(u32 addr) {
	u32 raddr;
    addr -= PPC_IMEM_BASE;
	raddr = addr>>2;
    if (raddr<0 || raddr >= PPC_IMEM_SIZE) {
        ierr = IERR_OUTOFRANGE;
        return ;
    }
	return imem[raddr].word;
}

void set_dmem(u32 addr, u32 val, u8 op) {
	u32 tmp, index;
	u8 wd8;
	u16 wd16;
	u32 wd32;
	u32 raddr;
	u8 perform_store=0, undefined_case=0;
	

    addr -= PPC_DMEM_BASE;
    raddr = addr>>2;
	if (raddr<0 || raddr >= PPC_DMEM_SIZE) {
        derr = DERR_OUTOFRANGE;
        return ;
    }
	wd8 = (u8)(val>>24);
	wd16 = (u16)(val>>16);
	wd32 = val;
	
	switch (op) {
		DMOp_STB:
			index = addr & 0x3;
			dmem[raddr].byte[index] = wd8;
			break;
			
		DMOp_STH:
			index = addr & 0x2;
			index >>= 1;
			dmem[raddr].hword[index] = wd16;
			break;
			
		DMOp_STW:
			dmem[raddr].word = wd32;
			break;

		DMOp_STHBR:
			index = addr & 0x2;
			index >>= 1;
			tmp = BE2LE_32(val);
			wd16 = (u16)(tmp>>16);
			dmem[raddr].hword[index] = wd16;
			break;			
			
		DMOp_STWBR:
			wd32 = BE2LE_32(val);
			dmem[raddr].word = wd32;
			break;

		DMOp_STWCX:
			if (Reserve) {
				if (Reserve_Length == 4) {
					if (Reserve_Addr == addr) {
						perform_store = 1;
						undefined_case = 0;
					} else {
						undefined_case = 1;
					}
				} else {
					undefined_case = 1;
				}
			} else {
				perform_store = 0;
				undefined_case = 0;
			}
			if (undefined_case) {
				dmem[raddr].word = wd32;
				/* DO NOT Write CR0 until now.*/
			} else {
				if (perform_store) {
					dmem[raddr].word = wd32;
				}
			}
			Reserve = 0;
			break;
	}
}

u32 get_dmem(u32 addr, u8 op) {
	u32 rd, tmp;
    u32 raddr;

    addr -= PPC_DMEM_BASE;
    raddr = addr>>2;
	if (raddr<0 || raddr >= PPC_DMEM_SIZE) {
        derr = DERR_OUTOFRANGE;
        return ;
    }
	rd = dmem[raddr].word;
	
	switch (op) {
		DMOp_LBZ:
			return rd & 0xf000;
			
		DMOp_LHZ:
			return rd & 0xff00;
			
		DMOp_LWZ:
			return rd;
			
		DMOp_LHA: 
			if (rd & 0x0800)
				return (rd&0xff00) | 0xff;
			else
				return rd & 0xff00;	
				
		DMOp_LHBRX:
			tmp = (rd & 0xf000)>>24;
			tmp |= ((rd & 0x0f00)>>16);
			return tmp;

		DMOp_LWARX:
			Reserve = 1;
			Reserve_Length = 1;
			Reserve_Addr = addr;
			return rd;
			
		DMOp_LWBRX:
			rd = BE2LE_32(rd);
			return rd;
			
		default:
			printf("Wrong GET_DMEM OP\n");
			return 0;
	}
}
