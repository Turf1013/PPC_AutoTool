#include "regdef.h"

.text
.global _start
_start:
	nop
	lis		r3, 0x4080
	ori		r3, r3, 0x0500
    subi 	r3, r3, 2048
    mr 		sp, r3
    bl   	main
_loop:
    b		_loop
	nop


