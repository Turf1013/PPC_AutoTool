
#include "regdef.h"

#define LEAF(symbol)                                    \
                .globl  symbol;                         \
                .align  2;                              \
                .type   symbol,@function;               \
                .ent    symbol,0;                       \
symbol:         .frame  29,0,31

#define END(function)                                   \
                .end    function;                       \
                .size   function,.-function
			
				
.section .text.entry


LEAF(MOD)
	nop
END(MOD)

LEAF(DIV)
	nop
END(DIV)
