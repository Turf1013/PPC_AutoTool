
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

	# nnnnn regid = 17
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# nnnnr regid = 18
	nop
	nop
	nop
	nop
	sh $1, 2784($18)
	nop
	nop
	nop
	nop
	nop


	# nnnnw regid = 25
	nop
	nop
	nop
	nop
	sra $25, $9, 18
	nop
	nop
	nop
	nop
	nop


	# nnnrn regid = 15
	nop
	nop
	nop
	nor $3, $7, $15
	nop
	nop
	nop
	nop
	nop
	nop


	# nnnrr regid = 12
	nop
	nop
	nop
	addiu $21, $12, -20826
	srlv $5, $12, $17
	nop
	nop
	nop
	nop
	nop


	# nnnrw regid = 3
	nop
	nop
	nop
	addi $18, $3, -20386
	sub $3, $17, $19
	nop
	nop
	nop
	nop
	nop


	# nnnwn regid = 21
	nop
	nop
	nop
	or $21, $2, $22
	nop
	nop
	nop
	nop
	nop
	nop


	# nnnwr regid = 14
	nop
	nop
	nop
	sltiu $14, $13, -7101
	sltiu $11, $14, -22874
	nop
	nop
	nop
	nop
	nop


	# nnnww regid = 4
	nop
	nop
	nop
	lui $4, 31322
	andi $4, $24, -28104
	nop
	nop
	nop
	nop
	nop


	# nnrnn regid = 17
	nop
	nop
	bgtz $17, _label_1
	nop
	nop
	nop
	nop
	nop
	_label_1:
	nop
	nop
	nop


	# nnrnr regid = 19
	nop
	nop
	ori $20, $19, -106
	nop
	bltz $19, _label_2
	nop
	nop
	nop
	_label_2:
	nop
	nop
	nop


	# nnrnw regid = 10
	nop
	nop
	andi $17, $10, -5239
	nop
	ori $10, $17, -29733
	nop
	nop
	nop
	nop
	nop


	# nnrrn regid = 16
	nop
	nop
	add $16, $16, $7
	andi $15, $16, -10120
	nop
	nop
	nop
	nop
	nop
	nop


	# nnrrr regid = 22
	nop
	nop
	andi $16, $22, -26039
	andi $1, $22, -17762
	andi $19, $22, -29220
	nop
	nop
	nop
	nop
	nop


	# nnrrw regid = 5
	nop
	nop
	andi $10, $5, -12814
	andi $16, $5, -27802
	lw $5, 1640($0)
	nop
	nop
	nop
	nop
	nop


	# nnrwn regid = 9
	nop
	nop
	andi $15, $9, -8142
	sra $9, $13, 2
	nop
	nop
	nop
	nop
	nop
	nop


	# nnrwr regid = 19
	nop
	nop
	andi $5, $19, -16227
	sra $19, $16, 31
	andi $5, $19, -22838
	nop
	nop
	nop
	nop
	nop


	# nnrww regid = 3
	nop
	nop
	andi $24, $3, -10382
	sra $3, $21, 12
	sra $3, $21, 5
	nop
	nop
	nop
	nop
	nop


	# nnwnn regid = 3
	nop
	nop
	sra $3, $23, 0
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# nnwnr regid = 12
	nop
	nop
	sra $12, $12, 12
	nop
	andi $18, $12, -9113
	nop
	nop
	nop
	nop
	nop


	# nnwnw regid = 25
	nop
	nop
	sra $25, $3, 22
	nop
	xori $25, $17, -11044
	nop
	nop
	nop
	nop
	nop


	# nnwrn regid = 17
	nop
	nop
	sltu $17, $8, $17
	andi $13, $17, -17311
	nop
	nop
	nop
	nop
	nop
	nop


	# nnwrr regid = 13
	nop
	nop
	sra $13, $9, 1
	andi $10, $13, -23010
	andi $14, $13, -26346
	nop
	nop
	nop
	nop
	nop


	# nnwrw regid = 22
	nop
	nop
	sra $22, $6, 29
	andi $1, $22, -177
	sra $22, $6, 2
	nop
	nop
	nop
	nop
	nop


	# nnwwn regid = 10
	nop
	nop
	sra $10, $13, 12
	sra $10, $21, 9
	nop
	nop
	nop
	nop
	nop
	nop


	# nnwwr regid = 3
	nop
	nop
	sra $3, $17, 20
	sra $3, $21, 20
	andi $24, $3, -9569
	nop
	nop
	nop
	nop
	nop


	# nnwww regid = 19
	nop
	nop
	sra $19, $7, 30
	addi $19, $25, -6350
	sra $19, $1, 12
	nop
	nop
	nop
	nop
	nop


	# nrnnn regid = 3
	nop
	addiu $4, $3, -17875
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# nrnnr regid = 24
	nop
	addiu $8, $24, -30347
	nop
	nop
	addiu $18, $24, -9955
	nop
	nop
	nop
	nop
	nop


	# nrnnw regid = 15
	nop
	addiu $17, $15, -13833
	nop
	nop
	sra $15, $1, 1
	nop
	nop
	nop
	nop
	nop


	# nrnrn regid = 20
	nop
	addiu $24, $20, -2465
	nop
	addiu $9, $20, -26924
	nop
	nop
	nop
	nop
	nop
	nop


	# nrnrr regid = 10
	nop
	addiu $3, $10, -29573
	nop
	addiu $19, $10, -18425
	addiu $13, $10, -3454
	nop
	nop
	nop
	nop
	nop


	# nrnrw regid = 4
	nop
	addiu $1, $4, -19310
	nop
	addiu $6, $4, -12972
	sra $4, $7, 5
	nop
	nop
	nop
	nop
	nop


	# nrnwn regid = 24
	nop
	addiu $8, $24, -12296
	nop
	sra $24, $14, 4
	nop
	nop
	nop
	nop
	nop
	nop


	# nrnwr regid = 14
	nop
	addiu $16, $14, -3111
	nop
	sra $14, $17, 7
	addiu $7, $14, -21257
	nop
	nop
	nop
	nop
	nop


	# nrnww regid = 3
	nop
	addiu $23, $3, -12713
	nop
	sra $3, $22, 26
	sra $3, $1, 17
	nop
	nop
	nop
	nop
	nop


	# nrrnn regid = 20
	nop
	addiu $20, $20, -31352
	addiu $24, $20, -22446
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# nrrnr regid = 2
	nop
	addiu $25, $2, -29211
	addiu $18, $2, -8379
	nop
	addiu $13, $2, -30168
	nop
	nop
	nop
	nop
	nop


	# nrrnw regid = 11
	nop
	addiu $20, $11, -14907
	addiu $2, $11, -22979
	nop
	sra $11, $24, 10
	nop
	nop
	nop
	nop
	nop


	# nrrrn regid = 11
	nop
	addiu $11, $11, -5680
	addiu $18, $11, -9011
	addiu $8, $11, -28599
	nop
	nop
	nop
	nop
	nop
	nop


	# nrrrr regid = 5
	nop
	addiu $15, $5, -12792
	addiu $19, $5, -4076
	addiu $6, $5, -29334
	addiu $17, $5, -23256
	nop
	nop
	nop
	nop
	nop


	# nrrrw regid = 21
	nop
	addiu $19, $21, -29015
	addiu $24, $21, -16489
	addiu $13, $21, -20239
	sra $21, $13, 26
	nop
	nop
	nop
	nop
	nop


	# nrrwn regid = 25
	nop
	addi $21, $25, -29471
	addi $12, $25, -16663
	sra $25, $8, 7
	nop
	nop
	nop
	nop
	nop
	nop


	# nrrwr regid = 10
	nop
	addi $2, $10, -1452
	addi $12, $10, -20505
	sra $10, $6, 17
	addi $13, $10, -21960
	nop
	nop
	nop
	nop
	nop


	# nrrww regid = 8
	nop
	addi $14, $8, -5012
	addi $9, $8, -9122
	sra $8, $7, 16
	sra $8, $23, 25
	nop
	nop
	nop
	nop
	nop


	# nrwnn regid = 12
	nop
	addi $1, $12, -21595
	sra $12, $20, 27
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# nrwnr regid = 18
	nop
	addi $4, $18, -12744
	sra $18, $11, 9
	nop
	addi $12, $18, -24455
	nop
	nop
	nop
	nop
	nop


	# nrwnw regid = 25
	nop
	addi $19, $25, -18750
	sra $25, $6, 6
	nop
	sra $25, $3, 9
	nop
	nop
	nop
	nop
	nop


	# nrwrn regid = 3
	nop
	addi $15, $3, -6944
	sra $3, $25, 20
	addi $9, $3, -4698
	nop
	nop
	nop
	nop
	nop
	nop


	# nrwrr regid = 13
	nop
	addi $19, $13, -24591
	sra $13, $21, 3
	addi $18, $13, -18783
	addi $6, $13, -3555
	nop
	nop
	nop
	nop
	nop


	# nrwrw regid = 3
	nop
	addi $25, $3, -2241
	sub $3, $19, $25
	addi $23, $3, -19707
	sub $3, $4, $8
	nop
	nop
	nop
	nop
	nop


	# nrwwn regid = 6
	nop
	addi $1, $6, -19737
	sub $6, $18, $23
	sub $6, $15, $1
	nop
	nop
	nop
	nop
	nop
	nop


	# nrwwr regid = 13
	nop
	addi $14, $13, -1794
	sub $13, $21, $11
	sub $13, $12, $11
	addi $18, $13, -25483
	nop
	nop
	nop
	nop
	nop


	# nrwww regid = 1
	nop
	addi $20, $1, -30073
	sub $1, $20, $1
	sub $1, $20, $9
	sub $1, $22, $17
	nop
	nop
	nop
	nop
	nop


	# nwnnn regid = 4
	nop
	sub $4, $2, $10
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# nwnnr regid = 19
	nop
	sub $19, $20, $3
	nop
	nop
	addi $13, $19, -1708
	nop
	nop
	nop
	nop
	nop


	# nwnnw regid = 2
	nop
	sub $2, $8, $21
	nop
	nop
	sub $2, $2, $3
	nop
	nop
	nop
	nop
	nop


	# nwnrn regid = 19
	nop
	sub $19, $15, $10
	nop
	addi $12, $19, -3203
	nop
	nop
	nop
	nop
	nop
	nop


	# nwnrr regid = 13
	nop
	sub $13, $25, $1
	nop
	addi $5, $13, -840
	addi $21, $13, -25866
	nop
	nop
	nop
	nop
	nop


	# nwnrw regid = 13
	nop
	addi $13, $22, -29031
	nop
	addi $21, $13, -243
	addi $13, $11, -26566
	nop
	nop
	nop
	nop
	nop


	# nwnwn regid = 17
	nop
	addi $17, $2, -3757
	nop
	addi $17, $12, -7221
	nop
	nop
	nop
	nop
	nop
	nop


	# nwnwr regid = 4
	nop
	addi $4, $16, -17844
	nop
	addi $4, $14, -27828
	addi $13, $4, -18939
	nop
	nop
	nop
	nop
	nop


	# nwnww regid = 1
	nop
	addi $1, $9, -15190
	nop
	addi $1, $8, -21291
	addi $1, $9, -26329
	nop
	nop
	nop
	nop
	nop


	# nwrnn regid = 4
	nop
	addi $4, $8, -30444
	addi $9, $4, -11655
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# nwrnr regid = 13
	nop
	addi $13, $1, -18308
	addi $19, $13, -5384
	nop
	addi $16, $13, -1657
	nop
	nop
	nop
	nop
	nop


	# nwrnw regid = 5
	nop
	addi $5, $7, -26696
	addi $24, $5, -18283
	nop
	addi $5, $17, -31142
	nop
	nop
	nop
	nop
	nop


	# nwrrn regid = 8
	nop
	addi $8, $8, -3431
	addi $20, $8, -3407
	addi $23, $8, -3151
	nop
	nop
	nop
	nop
	nop
	nop


	# nwrrr regid = 13
	nop
	addi $13, $22, -21183
	addi $24, $13, -8639
	addi $16, $13, -26209
	addi $22, $13, -2913
	nop
	nop
	nop
	nop
	nop


	# nwrrw regid = 4
	nop
	addi $4, $10, -3034
	addi $23, $4, -11311
	addi $8, $4, -29805
	addi $4, $9, -31857
	nop
	nop
	nop
	nop
	nop


	# nwrwn regid = 11
	nop
	addi $11, $24, -28093
	addi $24, $11, -10626
	addi $11, $12, -10027
	nop
	nop
	nop
	nop
	nop
	nop


	# nwrwr regid = 1
	nop
	addi $1, $1, -29547
	addi $2, $1, -834
	addi $1, $9, -8918
	addi $5, $1, -10067
	nop
	nop
	nop
	nop
	nop


	# nwrww regid = 19
	nop
	addi $19, $13, -6234
	addi $19, $19, -22592
	addi $19, $13, -22220
	addi $19, $1, -18355
	nop
	nop
	nop
	nop
	nop


	# nwwnn regid = 17
	nop
	addi $17, $6, -19626
	addi $17, $12, -1891
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# nwwnr regid = 25
	nop
	addi $25, $3, -14325
	addi $25, $24, -22728
	nop
	addi $1, $25, -12696
	nop
	nop
	nop
	nop
	nop


	# nwwnw regid = 19
	nop
	addi $19, $18, -17836
	addi $19, $21, -19599
	nop
	addi $19, $16, -6280
	nop
	nop
	nop
	nop
	nop


	# nwwrn regid = 11
	nop
	addi $11, $23, -30179
	addi $11, $21, -13415
	addi $2, $11, -6028
	nop
	nop
	nop
	nop
	nop
	nop


	# nwwrr regid = 20
	nop
	addi $20, $11, -24009
	addi $20, $6, -7504
	addi $4, $20, -28939
	addi $9, $20, -3476
	nop
	nop
	nop
	nop
	nop


	# nwwrw regid = 23
	nop
	addi $23, $7, -7207
	addi $23, $18, -3227
	addi $16, $23, -4955
	addi $23, $2, -26691
	nop
	nop
	nop
	nop
	nop


	# nwwwn regid = 16
	nop
	addi $16, $14, -8776
	addi $16, $2, -9376
	addi $16, $21, -6340
	nop
	nop
	nop
	nop
	nop
	nop


	# nwwwr regid = 3
	nop
	addi $3, $1, -13982
	addi $3, $21, -26481
	addi $3, $5, -32265
	addi $14, $3, -27062
	nop
	nop
	nop
	nop
	nop


	# nwwww regid = 14
	nop
	addi $14, $22, -5279
	addi $14, $15, -7226
	addi $14, $14, -25177
	addi $14, $19, -23536
	nop
	nop
	nop
	nop
	nop


	# rnnnn regid = 1
	addi $1, $1, -31229
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# rnnnr regid = 4
	addi $24, $4, -21521
	nop
	nop
	nop
	addi $24, $4, -29797
	nop
	nop
	nop
	nop
	nop


	# rnnnw regid = 15
	addi $1, $15, -11223
	nop
	nop
	nop
	addi $15, $22, -14090
	nop
	nop
	nop
	nop
	nop


	# rnnrn regid = 20
	addi $20, $20, -18783
	nop
	nop
	addi $20, $20, -29903
	nop
	nop
	nop
	nop
	nop
	nop


	# rnnrr regid = 16
	addi $9, $16, -4450
	nop
	nop
	addi $2, $16, -4445
	addi $23, $16, -5616
	nop
	nop
	nop
	nop
	nop


	# rnnrw regid = 13
	addi $14, $13, -2867
	nop
	nop
	addi $24, $13, -29241
	addi $13, $20, -18753
	nop
	nop
	nop
	nop
	nop


	# rnnwn regid = 16
	addi $19, $16, -7421
	nop
	nop
	addi $16, $19, -20131
	nop
	nop
	nop
	nop
	nop
	nop


	# rnnwr regid = 10
	addi $25, $10, -28087
	nop
	nop
	addi $10, $18, -32160
	addi $22, $10, -31010
	nop
	nop
	nop
	nop
	nop


	# rnnww regid = 5
	addi $22, $5, -32078
	nop
	nop
	addi $5, $19, -11338
	addi $5, $24, -5701
	nop
	nop
	nop
	nop
	nop


	# rnrnn regid = 12
	addi $11, $12, -542
	nop
	addi $14, $12, -22915
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# rnrnr regid = 5
	addi $24, $5, -12845
	nop
	addi $8, $5, -8002
	nop
	addi $6, $5, -9450
	nop
	nop
	nop
	nop
	nop


	# rnrnw regid = 2
	addi $1, $2, -12413
	nop
	addi $25, $2, -23272
	nop
	addi $2, $16, -14804
	nop
	nop
	nop
	nop
	nop


	# rnrrn regid = 18
	addi $14, $18, -16626
	nop
	addi $24, $18, -7696
	addi $7, $18, -6595
	nop
	nop
	nop
	nop
	nop
	nop


	# rnrrr regid = 5
	addi $6, $5, -12142
	nop
	addi $1, $5, -2675
	addi $12, $5, -18032
	addi $15, $5, -26774
	nop
	nop
	nop
	nop
	nop


	# rnrrw regid = 7
	addi $12, $7, -1930
	nop
	addi $6, $7, -11753
	addi $6, $7, -14927
	addi $7, $12, -131
	nop
	nop
	nop
	nop
	nop


	# rnrwn regid = 12
	addi $1, $12, -27106
	nop
	addi $19, $12, -22415
	addi $12, $3, -18760
	nop
	nop
	nop
	nop
	nop
	nop


	# rnrwr regid = 13
	addi $5, $13, -16465
	nop
	addi $4, $13, -18512
	addi $13, $25, -20451
	addi $10, $13, -8740
	nop
	nop
	nop
	nop
	nop


	# rnrww regid = 1
	addi $19, $1, -15910
	nop
	addi $6, $1, -1407
	addi $1, $4, -29092
	addi $1, $10, -17866
	nop
	nop
	nop
	nop
	nop


	# rnwnn regid = 12
	addi $24, $12, -31486
	nop
	addi $12, $25, -30548
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# rnwnr regid = 3
	addi $7, $3, -13399
	nop
	addi $3, $10, -13760
	nop
	addi $22, $3, -2765
	nop
	nop
	nop
	nop
	nop


	# rnwnw regid = 21
	addi $5, $21, -20376
	nop
	addi $21, $14, -26070
	nop
	addi $21, $23, -26830
	nop
	nop
	nop
	nop
	nop


	# rnwrn regid = 13
	addi $12, $13, -26534
	nop
	addi $13, $12, -28809
	addi $16, $13, -7499
	nop
	nop
	nop
	nop
	nop
	nop


	# rnwrr regid = 13
	addi $9, $13, -18068
	nop
	addi $13, $15, -17651
	addi $6, $13, -24953
	addi $15, $13, -2556
	nop
	nop
	nop
	nop
	nop


	# rnwrw regid = 14
	addi $5, $14, -16683
	nop
	addi $14, $10, -7994
	addi $16, $14, -6817
	addi $14, $16, -31089
	nop
	nop
	nop
	nop
	nop


	# rnwwn regid = 11
	addi $24, $11, -31980
	nop
	addi $11, $8, -2812
	addi $11, $14, -22760
	nop
	nop
	nop
	nop
	nop
	nop


	# rnwwr regid = 17
	addi $24, $17, -11405
	nop
	addi $17, $10, -7990
	addi $17, $22, -30883
	addi $22, $17, -21435
	nop
	nop
	nop
	nop
	nop


	# rnwww regid = 18
	addi $21, $18, -600
	nop
	addi $18, $2, -17139
	addi $18, $24, -29459
	addi $18, $12, -2688
	nop
	nop
	nop
	nop
	nop


	# rrnnn regid = 17
	addi $18, $17, -31240
	addi $15, $17, -3347
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# rrnnr regid = 6
	addi $17, $6, -25252
	addi $17, $6, -3681
	nop
	nop
	addi $15, $6, -31428
	nop
	nop
	nop
	nop
	nop


	# rrnnw regid = 12
	addi $13, $12, -18047
	addi $10, $12, -12353
	nop
	nop
	addi $12, $24, -15644
	nop
	nop
	nop
	nop
	nop


	# rrnrn regid = 17
	addi $13, $17, -4345
	addi $7, $17, -20500
	nop
	addi $3, $17, -861
	nop
	nop
	nop
	nop
	nop
	nop


	# rrnrr regid = 8
	addi $13, $8, -11632
	addi $15, $8, -5959
	nop
	addi $7, $8, -20478
	addi $22, $8, -3616
	nop
	nop
	nop
	nop
	nop


	# rrnrw regid = 5
	addi $9, $5, -32520
	addi $13, $5, -27637
	nop
	addi $15, $5, -24810
	addi $5, $5, -25773
	nop
	nop
	nop
	nop
	nop


	# rrnwn regid = 3
	addi $5, $3, -14530
	addi $19, $3, -21902
	nop
	addi $3, $24, -4282
	nop
	nop
	nop
	nop
	nop
	nop


	# rrnwr regid = 22
	addi $9, $22, -20610
	addi $22, $22, -14376
	nop
	addi $22, $1, -22121
	addi $3, $22, -1961
	nop
	nop
	nop
	nop
	nop


	# rrnww regid = 24
	addi $18, $24, -18168
	addi $25, $24, -14416
	nop
	addi $24, $8, -32228
	addi $24, $1, -24006
	nop
	nop
	nop
	nop
	nop


	# rrrnn regid = 18
	addi $23, $18, -1350
	addi $4, $18, -18917
	addi $6, $18, -28319
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# rrrnr regid = 1
	addi $5, $1, -8248
	addi $11, $1, -17621
	addi $6, $1, -12093
	nop
	addi $12, $1, -1014
	nop
	nop
	nop
	nop
	nop


	# rrrnw regid = 24
	addi $15, $24, -5822
	addi $20, $24, -24130
	addi $1, $24, -8253
	nop
	addi $24, $1, -17153
	nop
	nop
	nop
	nop
	nop


	# rrrrn regid = 4
	addi $21, $4, -31863
	addi $8, $4, -3806
	addi $25, $4, -20219
	addi $6, $4, -845
	nop
	nop
	nop
	nop
	nop
	nop


	# rrrrr regid = 1
	addi $1, $1, -21858
	addi $12, $1, -14431
	addi $19, $1, -25132
	addi $15, $1, -1177
	addi $11, $1, -30263
	nop
	nop
	nop
	nop
	nop


	# rrrrw regid = 13
	addi $13, $13, -30145
	addi $21, $13, -7160
	addi $7, $13, -25683
	addi $24, $13, -4116
	addi $13, $2, -8942
	nop
	nop
	nop
	nop
	nop


	# rrrwn regid = 22
	addi $25, $22, -18128
	addi $20, $22, -31825
	addi $17, $22, -12479
	addi $22, $16, -28963
	nop
	nop
	nop
	nop
	nop
	nop


	# rrrwr regid = 11
	addi $1, $11, -31153
	addi $15, $11, -23602
	addi $25, $11, -19259
	addi $11, $21, -23195
	addi $12, $11, -1596
	nop
	nop
	nop
	nop
	nop


	# rrrww regid = 19
	addi $7, $19, -6500
	addi $11, $19, -22346
	addi $5, $19, -1858
	addi $19, $8, -7377
	addi $19, $15, -31894
	nop
	nop
	nop
	nop
	nop


	# rrwnn regid = 15
	addi $6, $15, -28308
	addi $23, $15, -5947
	addi $15, $23, -11191
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# rrwnr regid = 15
	addi $21, $15, -5174
	addi $19, $15, -32014
	addi $15, $13, -21096
	nop
	addi $4, $15, -26856
	nop
	nop
	nop
	nop
	nop


	# rrwnw regid = 13
	addi $9, $13, -28353
	addi $24, $13, -21009
	addi $13, $5, -3282
	nop
	addi $13, $9, -26823
	nop
	nop
	nop
	nop
	nop


	# rrwrn regid = 7
	addi $1, $7, -21401
	addi $13, $7, -4236
	addi $7, $25, -29321
	addi $9, $7, -6546
	nop
	nop
	nop
	nop
	nop
	nop


	# rrwrr regid = 7
	addi $9, $7, -5820
	addi $8, $7, -10750
	addi $7, $21, -1657
	addi $7, $7, -13278
	addi $25, $7, -26282
	nop
	nop
	nop
	nop
	nop


	# rrwrw regid = 3
	addi $19, $3, -25234
	addi $19, $3, -1700
	addi $3, $22, -24985
	addi $3, $3, -3342
	addi $3, $23, -15156
	nop
	nop
	nop
	nop
	nop


	# rrwwn regid = 4
	addi $9, $4, -27223
	addi $11, $4, -2530
	addi $4, $19, -11455
	addi $4, $1, -7640
	nop
	nop
	nop
	nop
	nop
	nop


	# rrwwr regid = 12
	addi $25, $12, -21576
	addi $20, $12, -32087
	addi $12, $18, -15055
	addi $12, $10, -7296
	addi $6, $12, -7867
	nop
	nop
	nop
	nop
	nop


	# rrwww regid = 18
	addi $3, $18, -6998
	addi $15, $18, -31387
	addi $18, $24, -30531
	addi $18, $5, -16173
	addi $18, $3, -20726
	nop
	nop
	nop
	nop
	nop


	# rwnnn regid = 11
	addi $9, $11, -24842
	addi $11, $21, -240
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# rwnnr regid = 2
	addi $14, $2, -22908
	addi $2, $12, -30026
	nop
	nop
	addi $23, $2, -25640
	nop
	nop
	nop
	nop
	nop


	# rwnnw regid = 10
	addi $19, $10, -29265
	addi $10, $16, -21830
	nop
	nop
	addi $10, $8, -10018
	nop
	nop
	nop
	nop
	nop


	# rwnrn regid = 15
	addi $9, $15, -30107
	addi $15, $7, -11961
	nop
	addi $15, $15, -13333
	nop
	nop
	nop
	nop
	nop
	nop


	# rwnrr regid = 16
	addi $12, $16, -31382
	addi $16, $11, -19438
	nop
	addi $4, $16, -3276
	addi $16, $16, -26002
	nop
	nop
	nop
	nop
	nop


	# rwnrw regid = 11
	addi $25, $11, -20931
	addi $11, $8, -25440
	nop
	addi $20, $11, -1524
	addi $11, $9, -23516
	nop
	nop
	nop
	nop
	nop


	# rwnwn regid = 23
	addi $11, $23, -25560
	addi $23, $23, -9525
	nop
	addi $23, $16, -5927
	nop
	nop
	nop
	nop
	nop
	nop


	# rwnwr regid = 15
	addi $13, $15, -2120
	addi $15, $2, -8294
	nop
	addi $15, $17, -5568
	addi $16, $15, -7071
	nop
	nop
	nop
	nop
	nop


	# rwnww regid = 20
	addi $4, $20, -19837
	addi $20, $16, -19281
	nop
	addi $20, $1, -24285
	addi $20, $18, -26575
	nop
	nop
	nop
	nop
	nop


	# rwrnn regid = 3
	addi $11, $3, -16934
	addi $3, $23, -29983
	addi $16, $3, -13963
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# rwrnr regid = 17
	addi $11, $17, -19219
	addi $17, $5, -1797
	addi $24, $17, -12575
	nop
	addi $23, $17, -18942
	nop
	nop
	nop
	nop
	nop


	# rwrnw regid = 2
	addi $8, $2, -19190
	addi $2, $19, -6279
	addi $25, $2, -19844
	nop
	addi $2, $6, -5760
	nop
	nop
	nop
	nop
	nop


	# rwrrn regid = 18
	addi $3, $18, -14265
	addi $18, $8, -18572
	addi $23, $18, -20157
	addi $12, $18, -21712
	nop
	nop
	nop
	nop
	nop
	nop


	# rwrrr regid = 16
	addi $9, $16, -19052
	addi $16, $3, -30027
	addi $14, $16, -29906
	addi $11, $16, -12153
	addi $25, $16, -12632
	nop
	nop
	nop
	nop
	nop


	# rwrrw regid = 6
	addi $8, $6, -18381
	addi $6, $16, -29251
	addi $21, $6, -32527
	addi $25, $6, -29245
	addi $6, $6, -3147
	nop
	nop
	nop
	nop
	nop


	# rwrwn regid = 21
	addi $17, $21, -17090
	addi $21, $5, -7710
	addi $1, $21, -18761
	addi $21, $7, -29773
	nop
	nop
	nop
	nop
	nop
	nop


	# rwrwr regid = 4
	addi $4, $4, -11869
	addi $4, $16, -29675
	addi $23, $4, -21525
	addi $4, $15, -22600
	addi $17, $4, -26795
	nop
	nop
	nop
	nop
	nop


	# rwrww regid = 23
	addi $2, $23, -21782
	addi $23, $22, -1191
	addi $5, $23, -2852
	addi $23, $17, -17299
	addi $23, $22, -2075
	nop
	nop
	nop
	nop
	nop


	# rwwnn regid = 17
	addi $25, $17, -5911
	addi $17, $3, -32532
	addi $17, $13, -1542
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# rwwnr regid = 13
	addi $9, $13, -24374
	addi $13, $23, -29703
	addi $13, $14, -23507
	nop
	addi $4, $13, -15890
	nop
	nop
	nop
	nop
	nop


	# rwwnw regid = 16
	addi $23, $16, -30323
	addi $16, $1, -19279
	addi $16, $25, -29435
	nop
	addi $16, $15, -15486
	nop
	nop
	nop
	nop
	nop


	# rwwrn regid = 8
	addi $22, $8, -16401
	addi $8, $8, -958
	addi $8, $7, -30581
	addi $5, $8, -26447
	nop
	nop
	nop
	nop
	nop
	nop


	# rwwrr regid = 14
	addi $23, $14, -8560
	addi $14, $2, -7009
	addi $14, $23, -5102
	addi $6, $14, -30740
	addi $11, $14, -3515
	nop
	nop
	nop
	nop
	nop


	# rwwrw regid = 3
	addi $4, $3, -21907
	addi $3, $8, -20313
	addi $3, $7, -24016
	addi $22, $3, -6487
	addi $3, $6, -16821
	nop
	nop
	nop
	nop
	nop


	# rwwwn regid = 25
	addi $11, $25, -21392
	addi $25, $10, -7770
	addi $25, $4, -25846
	addi $25, $19, -3880
	nop
	nop
	nop
	nop
	nop
	nop


	# rwwwr regid = 4
	addi $23, $4, -4088
	addi $4, $4, -26318
	addi $4, $12, -18569
	addi $4, $14, -27052
	addi $12, $4, -9523
	nop
	nop
	nop
	nop
	nop


	# rwwww regid = 24
	addi $1, $24, -8415
	addi $24, $13, -30069
	addi $24, $19, -15303
	addi $24, $5, -22787
	addi $24, $2, -28387
	nop
	nop
	nop
	nop
	nop


	# wnnnn regid = 23
	addi $23, $22, -23963
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# wnnnr regid = 23
	addi $23, $15, -23448
	nop
	nop
	nop
	addi $7, $23, -23110
	nop
	nop
	nop
	nop
	nop


	# wnnnw regid = 19
	addi $19, $4, -15820
	nop
	nop
	nop
	addi $19, $22, -14602
	nop
	nop
	nop
	nop
	nop


	# wnnrn regid = 22
	addi $22, $21, -9074
	nop
	nop
	addi $14, $22, -2659
	nop
	nop
	nop
	nop
	nop
	nop


	# wnnrr regid = 10
	addi $10, $4, -11151
	nop
	nop
	addi $2, $10, -29084
	addi $7, $10, -6840
	nop
	nop
	nop
	nop
	nop


	# wnnrw regid = 23
	addi $23, $16, -17569
	nop
	nop
	addi $12, $23, -13569
	addi $23, $11, -14497
	nop
	nop
	nop
	nop
	nop


	# wnnwn regid = 14
	addi $14, $11, -32450
	nop
	nop
	addi $14, $7, -25501
	nop
	nop
	nop
	nop
	nop
	nop


	# wnnwr regid = 13
	addi $13, $12, -18261
	nop
	nop
	addi $13, $3, -4694
	addi $3, $13, -2497
	nop
	nop
	nop
	nop
	nop


	# wnnww regid = 19
	addi $19, $11, -32431
	nop
	nop
	addi $19, $5, -20091
	addi $19, $19, -3746
	nop
	nop
	nop
	nop
	nop


	# wnrnn regid = 14
	addi $14, $18, -15231
	nop
	addi $14, $14, -25413
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# wnrnr regid = 15
	addi $15, $7, -19675
	nop
	addi $13, $15, -22007
	nop
	addi $18, $15, -23267
	nop
	nop
	nop
	nop
	nop


	# wnrnw regid = 8
	addi $8, $16, -22015
	nop
	addi $10, $8, -13673
	nop
	addi $8, $22, -28804
	nop
	nop
	nop
	nop
	nop


	# wnrrn regid = 7
	addi $7, $7, -29112
	nop
	addi $19, $7, -5688
	addi $19, $7, -11357
	nop
	nop
	nop
	nop
	nop
	nop


	# wnrrr regid = 14
	addi $14, $2, -5552
	nop
	addi $19, $14, -15728
	addi $9, $14, -8989
	addi $10, $14, -6115
	nop
	nop
	nop
	nop
	nop


	# wnrrw regid = 12
	addi $12, $16, -20894
	nop
	addi $11, $12, -7088
	addi $6, $12, -27043
	addi $12, $9, -19209
	nop
	nop
	nop
	nop
	nop


	# wnrwn regid = 7
	addi $7, $8, -24863
	nop
	addi $1, $7, -11206
	addi $7, $13, -11688
	nop
	nop
	nop
	nop
	nop
	nop


	# wnrwr regid = 12
	addi $12, $3, -22260
	nop
	addi $16, $12, -20692
	addi $12, $19, -25028
	addi $25, $12, -7995
	nop
	nop
	nop
	nop
	nop


	# wnrww regid = 23
	addi $23, $11, -21696
	nop
	addi $8, $23, -9813
	addi $23, $17, -9180
	addi $23, $19, -4453
	nop
	nop
	nop
	nop
	nop


	# wnwnn regid = 22
	addi $22, $10, -10756
	nop
	addi $22, $6, -14006
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# wnwnr regid = 19
	addi $19, $22, -14846
	nop
	addi $19, $24, -6750
	nop
	addi $18, $19, -23054
	nop
	nop
	nop
	nop
	nop


	# wnwnw regid = 1
	addi $1, $11, -20009
	nop
	addi $1, $21, -27465
	nop
	addi $1, $5, -8569
	nop
	nop
	nop
	nop
	nop


	# wnwrn regid = 6
	addi $6, $12, -24087
	nop
	addi $6, $4, -8735
	addi $13, $6, -25726
	nop
	nop
	nop
	nop
	nop
	nop


	# wnwrr regid = 4
	addi $4, $21, -16954
	nop
	addi $4, $20, -1705
	addi $3, $4, -13904
	addi $21, $4, -17763
	nop
	nop
	nop
	nop
	nop


	# wnwrw regid = 23
	addi $23, $13, -8442
	nop
	addi $23, $24, -26228
	addi $16, $23, -180
	addi $23, $22, -14823
	nop
	nop
	nop
	nop
	nop


	# wnwwn regid = 22
	addi $22, $9, -9179
	nop
	addi $22, $4, -7989
	addi $22, $13, -12633
	nop
	nop
	nop
	nop
	nop
	nop


	# wnwwr regid = 13
	addi $13, $9, -30680
	nop
	addi $13, $5, -16775
	addi $13, $13, -13803
	addi $6, $13, -20961
	nop
	nop
	nop
	nop
	nop


	# wnwww regid = 18
	addi $18, $10, -97
	nop
	addi $18, $24, -29223
	addi $18, $19, -23930
	addi $18, $23, -24205
	nop
	nop
	nop
	nop
	nop


	# wrnnn regid = 4
	addi $4, $2, -18045
	addi $5, $4, -1167
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# wrnnr regid = 3
	addi $3, $18, -12997
	addi $2, $3, -10405
	nop
	nop
	addi $16, $3, -15347
	nop
	nop
	nop
	nop
	nop


	# wrnnw regid = 21
	addi $21, $21, -16027
	addi $13, $21, -3617
	nop
	nop
	addi $21, $6, -29375
	nop
	nop
	nop
	nop
	nop


	# wrnrn regid = 14
	addi $14, $8, -31160
	addi $23, $14, -61
	nop
	addi $14, $14, -32624
	nop
	nop
	nop
	nop
	nop
	nop


	# wrnrr regid = 16
	addi $16, $5, -8164
	addi $1, $16, -12690
	nop
	addi $7, $16, -30438
	addi $24, $16, -12174
	nop
	nop
	nop
	nop
	nop


	# wrnrw regid = 6
	addi $6, $13, -3323
	addi $17, $6, -27018
	nop
	addi $14, $6, -10805
	addi $6, $23, -559
	nop
	nop
	nop
	nop
	nop


	# wrnwn regid = 6
	addi $6, $9, -6031
	addi $21, $6, -5396
	nop
	addi $6, $6, -26034
	nop
	nop
	nop
	nop
	nop
	nop


	# wrnwr regid = 12
	addi $12, $7, -24584
	addi $8, $12, -18649
	nop
	addi $12, $8, -8084
	addi $5, $12, -14485
	nop
	nop
	nop
	nop
	nop


	# wrnww regid = 18
	addi $18, $1, -8650
	addi $4, $18, -649
	nop
	addi $18, $13, -18677
	addi $18, $21, -16708
	nop
	nop
	nop
	nop
	nop


	# wrrnn regid = 2
	addi $2, $8, -30632
	addi $1, $2, -26861
	addi $25, $2, -24049
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# wrrnr regid = 16
	addi $16, $17, -29417
	addi $16, $16, -9794
	addi $17, $16, -20579
	nop
	addi $16, $16, -29529
	nop
	nop
	nop
	nop
	nop


	# wrrnw regid = 19
	addi $19, $14, -22087
	addi $6, $19, -8592
	addi $21, $19, -26629
	nop
	addi $19, $24, -11685
	nop
	nop
	nop
	nop
	nop


	# wrrrn regid = 15
	addi $15, $22, -2775
	addi $23, $15, -8930
	addi $7, $15, -8369
	addi $17, $15, -31745
	nop
	nop
	nop
	nop
	nop
	nop


	# wrrrr regid = 19
	addi $19, $19, -25419
	addi $8, $19, -12266
	addi $13, $19, -24422
	addi $13, $19, -14355
	addi $17, $19, -1078
	nop
	nop
	nop
	nop
	nop


	# wrrrw regid = 13
	addi $13, $2, -13358
	addi $8, $13, -6508
	addi $6, $13, -18894
	addi $23, $13, -573
	addi $13, $11, -26730
	nop
	nop
	nop
	nop
	nop


	# wrrwn regid = 14
	addi $14, $21, -23301
	addi $18, $14, -19579
	addi $14, $14, -11221
	addi $14, $18, -23669
	nop
	nop
	nop
	nop
	nop
	nop


	# wrrwr regid = 24
	addi $24, $4, -2720
	addi $21, $24, -24132
	addi $18, $24, -24312
	addi $24, $7, -2806
	addi $1, $24, -22212
	nop
	nop
	nop
	nop
	nop


	# wrrww regid = 7
	addi $7, $20, -2177
	addi $14, $7, -13853
	addi $20, $7, -26496
	addi $7, $9, -22635
	addi $7, $18, -9199
	nop
	nop
	nop
	nop
	nop


	# wrwnn regid = 1
	addi $1, $4, -29183
	addi $9, $1, -31875
	addi $1, $4, -28018
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# wrwnr regid = 9
	addi $9, $22, -13157
	addi $14, $9, -11127
	addi $9, $23, -30416
	nop
	addi $5, $9, -7466
	nop
	nop
	nop
	nop
	nop


	# wrwnw regid = 9
	addi $9, $3, -17200
	addi $21, $9, -26633
	addi $9, $12, -16026
	nop
	addi $9, $25, -9580
	nop
	nop
	nop
	nop
	nop


	# wrwrn regid = 4
	addi $4, $8, -8827
	addi $20, $4, -16423
	addi $4, $14, -17804
	addi $12, $4, -7383
	nop
	nop
	nop
	nop
	nop
	nop


	# wrwrr regid = 24
	addi $24, $13, -65
	addi $20, $24, -27614
	addi $24, $3, -694
	addi $6, $24, -30524
	addi $25, $24, -18650
	nop
	nop
	nop
	nop
	nop


	# wrwrw regid = 16
	addi $16, $3, -3995
	addi $7, $16, -26021
	addi $16, $20, -18370
	addi $4, $16, -5416
	addi $16, $4, -19725
	nop
	nop
	nop
	nop
	nop


	# wrwwn regid = 23
	addi $23, $14, -6934
	addi $23, $23, -25528
	addi $23, $18, -27117
	addi $23, $3, -5152
	nop
	nop
	nop
	nop
	nop
	nop


	# wrwwr regid = 2
	addi $2, $21, -18153
	addi $24, $2, -589
	addi $2, $8, -29885
	addi $2, $3, -4506
	addi $21, $2, -13746
	nop
	nop
	nop
	nop
	nop


	# wrwww regid = 24
	addi $24, $12, -3880
	addi $18, $24, -30876
	addi $24, $18, -21019
	addi $24, $15, -25836
	addi $24, $7, -30765
	nop
	nop
	nop
	nop
	nop


	# wwnnn regid = 6
	addi $6, $7, -18179
	addi $6, $6, -13596
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# wwnnr regid = 15
	addi $15, $21, -7340
	addi $15, $16, -6158
	nop
	nop
	addi $22, $15, -7532
	nop
	nop
	nop
	nop
	nop


	# wwnnw regid = 10
	addi $10, $16, -5135
	addi $10, $19, -10138
	nop
	nop
	addi $10, $19, -3986
	nop
	nop
	nop
	nop
	nop


	# wwnrn regid = 4
	addi $4, $16, -13106
	addi $4, $23, -1617
	nop
	addi $16, $4, -16051
	nop
	nop
	nop
	nop
	nop
	nop


	# wwnrr regid = 16
	addi $16, $17, -27885
	addi $16, $10, -14523
	nop
	addi $2, $16, -3
	addi $16, $16, -15559
	nop
	nop
	nop
	nop
	nop


	# wwnrw regid = 23
	addi $23, $1, -14710
	addi $23, $1, -2187
	nop
	addi $22, $23, -28481
	addi $23, $5, -7789
	nop
	nop
	nop
	nop
	nop


	# wwnwn regid = 14
	addi $14, $6, -30307
	addi $14, $6, -25228
	nop
	addi $14, $10, -21146
	nop
	nop
	nop
	nop
	nop
	nop


	# wwnwr regid = 24
	addi $24, $24, -19833
	addi $24, $15, -13201
	nop
	addi $24, $22, -13607
	addi $14, $24, -25098
	nop
	nop
	nop
	nop
	nop


	# wwnww regid = 14
	addi $14, $6, -7851
	addi $14, $11, -27016
	nop
	addi $14, $9, -513
	addi $14, $2, -30367
	nop
	nop
	nop
	nop
	nop


	# wwrnn regid = 10
	addi $10, $19, -2220
	addi $10, $18, -16575
	addi $13, $10, -15665
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# wwrnr regid = 16
	addi $16, $20, -8100
	addi $16, $24, -31779
	addi $5, $16, -21121
	nop
	addi $7, $16, -32099
	nop
	nop
	nop
	nop
	nop


	# wwrnw regid = 1
	addi $1, $25, -7332
	addi $1, $24, -31325
	addi $5, $1, -9907
	nop
	addi $1, $11, -8801
	nop
	nop
	nop
	nop
	nop


	# wwrrn regid = 17
	addi $17, $5, -2902
	addi $17, $9, -4545
	addi $18, $17, -10101
	addi $20, $17, -18838
	nop
	nop
	nop
	nop
	nop
	nop


	# wwrrr regid = 12
	addi $12, $16, -27341
	addi $12, $5, -22169
	addi $21, $12, -32262
	addi $15, $12, -22910
	addi $15, $12, -21321
	nop
	nop
	nop
	nop
	nop


	# wwrrw regid = 16
	addi $16, $15, -14793
	addi $16, $15, -30265
	addi $13, $16, -25928
	addi $2, $16, -7373
	addi $16, $12, -15117
	nop
	nop
	nop
	nop
	nop


	# wwrwn regid = 10
	addi $10, $9, -11683
	addi $10, $1, -14082
	addi $7, $10, -4640
	addi $10, $3, -1906
	nop
	nop
	nop
	nop
	nop
	nop


	# wwrwr regid = 25
	addi $25, $23, -31936
	addi $25, $4, -26122
	addi $4, $25, -21885
	addi $25, $16, -1508
	addi $4, $25, -26947
	nop
	nop
	nop
	nop
	nop


	# wwrww regid = 6
	addi $6, $3, -7995
	addi $6, $2, -10093
	addi $10, $6, -11767
	addi $6, $11, -26794
	addi $6, $7, -31697
	nop
	nop
	nop
	nop
	nop


	# wwwnn regid = 6
	addi $6, $21, -15486
	addi $6, $19, -19195
	addi $6, $13, -27770
	nop
	nop
	nop
	nop
	nop
	nop
	nop


	# wwwnr regid = 6
	addi $6, $18, -24076
	addi $6, $23, -21822
	addi $6, $7, -8653
	nop
	addi $9, $6, -11939
	nop
	nop
	nop
	nop
	nop


	# wwwnw regid = 21
	addi $21, $25, -13123
	addi $21, $1, -10906
	addi $21, $24, -30288
	nop
	addi $21, $23, -29226
	nop
	nop
	nop
	nop
	nop


	# wwwrn regid = 9
	addi $9, $3, -26643
	addi $9, $2, -23690
	addi $9, $20, -12032
	addi $15, $9, -11630
	nop
	nop
	nop
	nop
	nop
	nop


	# wwwrr regid = 22
	addi $22, $14, -31091
	addi $22, $25, -6787
	addi $22, $12, -3906
	addi $24, $22, -7673
	addi $17, $22, -17631
	nop
	nop
	nop
	nop
	nop


	# wwwrw regid = 8
	addi $8, $10, -29824
	addi $8, $22, -25710
	addi $8, $19, -22091
	addi $8, $8, -9727
	addi $8, $15, -31145
	nop
	nop
	nop
	nop
	nop


	# wwwwn regid = 16
	addi $16, $5, -31927
	addi $16, $16, -20232
	addi $16, $10, -32068
	addi $16, $19, -8527
	nop
	nop
	nop
	nop
	nop
	nop


	# wwwwr regid = 5
	addi $5, $3, -20970
	addi $5, $25, -20494
	addi $5, $11, -17730
	addi $5, $13, -139
	addi $10, $5, -17890
	nop
	nop
	nop
	nop
	nop


	# wwwww regid = 24
	addi $24, $1, -9744
	addi $24, $6, -23356
	addi $24, $18, -17361
	addi $24, $10, -32064
	addi $24, $10, -21877
	nop
	nop
	nop
	nop
	nop


	jr $ra
	nop
