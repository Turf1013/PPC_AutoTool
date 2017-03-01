#include "regdef.h"

.text
.global _start
_start:
	nop
	lis		r3, 0x1001
	ori		r3, r3, 0x1000
    subi 	r3, r3, 512
    mr 		sp, r3
    b   	main
    nop
    nop
	nop


