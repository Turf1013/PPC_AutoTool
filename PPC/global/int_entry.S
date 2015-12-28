#include "regdef.h"

.text
.global _int_entry
.global _int_entry_save_context
.global _int_entry_restore_context


_int_entry:
	// DM: 4KB, 512B could be used to save context
     
    // save sp to system stack top
    lis 	r12, 0x1001
	ori		r12, r12, 0x1000
    stw  	sp, -4(r12) 			// save sp
	mr		sp, r12
	mfsrr0	r12
	stw		r12, -8(sp)				// save SRR0
	mfsrr1	r12
	stw		r12, -12(sp)			// save SRR1
	subi 	sp, sp, 256
	
    /* save context */
    b _save_context

_int_entry_save_context :
    /* call C handle */
	subi 	sp, sp, 256
    bl handle_hw_int
	addi 	sp, sp, 256
    
    /* restore context */
    b _restore_context

_int_entry_restore_context :    
    /* restore sp */
    lis 	sp, 0x1001
	ori		sp, sp, 0x1000
	lwz		r12, -8(sp)
	mtsrr0 	r12						// restore SRR0
	lwz		r12, -12(sp)
	mtsrr1 	r12						// restore SRR1
	ori 	r12, r12, MSR_EE
	mtmsr	r12						// enable MSR[EE]
    lwz  	sp, -4(sp)
    
    /* interrupt return */
    rfi
	nop
	
