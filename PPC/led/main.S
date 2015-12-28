#include "../global/regdef.h"

.text
.global main
main:
	// initial MSR
	li r0, 0
	ori r0, r0, MSR_EE
	mtmsr r0

	// initial TC0
	lis r11, 0x1002
	li r0, 0
	ori r0, r0, 1
	stw r0, 0(r11)
	lis r9, 0x1001
	lwz r0, 0(r9)
	stw r0, 4(r11)
	
	// deadloop
	nop
	_loop:
    b   	_loop
    nop
    nop
	nop


