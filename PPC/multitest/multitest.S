#include "../global/regdef.h"
// using 1 & 2 to initilize the DM

.text
.global main
main:
	
	/* initialize */
	lis r1, 4
	lis r2, 0
	lis r3, 5
	// lis r30, 1
	// lis r31, 2
	// stw r30, -4(r1)
	// stw r31, 0(r1)

_loop:
	lmw r30, -4(r1)
	add r2, r30, r31
	stwu r2, 4(r1)

	/* condition */
	addi r2, r2, 1
	cmpw cr7, r2, r3
	ble _loop 
	
_end:
	b _end
	nop