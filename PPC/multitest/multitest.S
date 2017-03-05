#include "../global/regdef.h"
// using 1 & 2 to initilize the DM

.text
.global main
main:
	
	/* initialize */
	li r1, 4
	li r2, 0
	li r3, 5
	// li r30, 1
	// li r31, 2
	// stw r30, -4(r1)
	// stw r31, 0(r1)

_loop:
	lmw r30, -4(r1)
	add r4, r30, r31
	// mullw r4, r30, r31
	stwu r4, 4(r1)

	/* condition */
	addi r2, r2, 1
	cmpw cr7, r2, r3
	ble cr7, _loop 
	
_end:
	b _end
	nop
