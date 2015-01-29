#include "ppc_pc.h"

static u32 PC;

void set_pc(u32 val) {
	PC = val;
}

u32 get_pc(u32 val) {
	return PC;
}

void initial_pc(u32 val) {
    pc = val;
}
