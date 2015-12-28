#include "../global/regdef.h"

.text
.global handle_hw_int
handle_hw_int:
	
	// led's value += 1
	lis r11, 0x1002
	ori r11, r11, 0x100
	lwz r12, 0(r11)
	addi r12, r12, 1
	stw r12, 0(r11)
	// Timer restart
	lis r11, 0x1002
	li r0, 0
	ori r0, r0, 1
	stw r0, 0(r11)
	lis r12, 0x1001
	lwz r0, 0(r12)
	stw r0, 4(r11)
	
	blr
	nop
	
	


