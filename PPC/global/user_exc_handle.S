#include "regdef.h"

.text
.global _save_context
_save_context:
	/* save SPR */
	mflr	r12
	stw		r12, 0(sp)
	/* Save GPR */
	stw  	r0, 4(sp)    
    stw  	r2, 8(sp)    
    stw  	r3, 12(sp)    
    stw  	r4, 16(sp)    
    stw  	r5, 20(sp)    
    stw  	r6, 24(sp)    
    stw  	r7, 28(sp)    
    stw  	r8, 32(sp)    
    stw  	r9, 36(sp)    
    stw  	r10, 40(sp)    
    stw  	r11, 44(sp)    
    stw  	r12, 48(sp)    
    stw  	r13, 52(sp)    
    stw  	r14, 56(sp)    
    stw  	r15, 60(sp)    
    stw  	r16, 64(sp)    
    stw  	r17, 68(sp)    
    stw  	r18, 72(sp)    
    stw  	r19, 76(sp)    
    stw  	r20, 80(sp)    
    stw  	r21, 84(sp)    
    stw  	r22, 88(sp)    
    stw  	r23, 92(sp)    
    stw  	r24, 96(sp)    
    stw  	r25, 100(sp)    
    stw  	r26, 104(sp)    
    stw  	r27, 108(sp)    
    stw  	r28, 112(sp)    
    stw  	r29, 116(sp)    
    stw  	r30, 120(sp)    
    stw  	r31, 124(sp)
    b _int_entry_save_context
    
.global _restore_context
_restore_context:
	/* restore SPR */
	lwz		r12, 0(sp)
	mtlr	r12
	/* restore GPR */
	lwz  r0, 4(sp)
	lwz  r2, 8(sp)
    lwz  r3, 12(sp)    
    lwz  r4, 16(sp)    
    lwz  r5, 20(sp)    
    lwz  r6, 24(sp)    
    lwz  r7, 28(sp)    
    lwz  r8, 32(sp)    
    lwz  r9, 36(sp)    
    lwz  r10, 40(sp)    
    lwz  r11, 44(sp)    
    lwz  r12, 48(sp)    
    lwz  r13, 52(sp)    
    lwz  r14, 56(sp)    
    lwz  r15, 60(sp)    
    lwz  r16, 64(sp)    
    lwz  r17, 68(sp)    
    lwz  r18, 72(sp)    
    lwz  r19, 76(sp)    
    lwz  r20, 80(sp)    
    lwz  r21, 84(sp)    
    lwz  r22, 88(sp)    
    lwz  r23, 92(sp)    
    lwz  r24, 96(sp)    
    lwz  r25, 100(sp)    
    lwz  r26, 104(sp)    
    lwz  r27, 108(sp)    
    lwz  r28, 112(sp)    
    lwz  r29, 116(sp)    
    lwz  r30, 120(sp)    
    lwz  r31, 124(sp)    
    b _int_entry_restore_context
