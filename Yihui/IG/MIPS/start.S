
.text
.global _start
_start:
	nop
	# initial GPR
	move $1, $0
	move $2, $0
	move $3, $0
	move $4, $0
	move $5, $0
	move $6, $0
	move $7, $0
	move $8, $0
	move $9, $0
	move $10, $0
	move $11, $0
	move $12, $0
	move $13, $0
	move $14, $0
	move $15, $0
	move $16, $0
	move $17, $0
	move $18, $0
	move $19, $0
	move $20, $0
	move $21, $0
	move $22, $0
	move $23, $0
	move $24, $0
	move $25, $0
	
	# special function
	move $k0, $0
	move $k1, $0
	move $gp, $0
	addiu  $sp, $0, 4092
	move $fp, $0
	move $ra, $0

	
    jal   	main
    nop
_loop:
    b		_loop
	nop
	
main:
