#include <stdio.h>
#include "ppc_format.h"
#include "ppc_regs.h"

unsigned __int64 x = 0x7654765476547654;

int main()
{
    printf("%I64x\n", x);
    //printf("int=%d\n", sizeof(instr));
    return 0;
}

