#include "regdef.h"

.text
.global main
main:
	nop
	lis		r3, 0x4080
	ori		r3, r3, 0x0500
    subi 	r3, r3, 2048
    mr 		sp, r3
	nop
	nop
	nop

