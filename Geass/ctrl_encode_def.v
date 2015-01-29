// NPC control signal
`define NPCOp_WIDTH	  3
`define NPCOp_PLUS4   3'd0
`define NPCOp_BRANCH  3'd1
`define NPCOp_JUMP    3'd2
`define NPCOp_JR      3'd3

// Branch Compare signal
`define BrCmp_Op_WIDTH 3
`define BEQ_CMP		3'b000

/**** About Ext ****/
`define ExtOp_WIDTH		2
`define ExtOp_SIGNED	2'd0
`define ExtOp_UNSIGN	2'd1
`define ExtOp_HIGH16	2'd2

// ALU control signal
`define ALUOp_WIDTH 5
`define ALUOp_NOP   5'b00000 
`define ALUOp_ADDU  5'b00001
`define ALUOp_ADD   5'b00010
`define ALUOp_SUBU  5'b00011
`define ALUOp_SUB   5'b00100 
`define ALUOp_AND   5'b00101
`define ALUOp_OR    5'b00110
`define ALUOp_NOR   5'b00111
`define ALUOp_XOR   5'b01000
`define ALUOp_SLT   5'b01001
`define ALUOp_SLTU  5'b01010 
`define ALUOp_EQL   5'b01011
`define ALUOp_NEQ   5'b01100
`define ALUOp_GT0   5'b01101
`define ALUOp_GE0   5'b01110
`define ALUOp_LT0   5'b01111
`define ALUOp_LE0   5'b10000
`define ALUOp_SLL   5'b10001
`define ALUOp_SRL   5'b10010
`define ALUOp_SRA   5'b10011

/**** About DM ****/
`define DMIn_BEOp_WIDTH		2
`define DMIn_BEOp_SW		2'd0
`define DMIn_BEOp_SH		2'd1
`define DMIn_BEOp_SB		2'd2

`define DMOut_MEOp_WIDTH 	3
`define DMOut_MEOp_LW		3'd0
`define DMOut_MEOp_LH		3'd1
`define DMOut_MEOp_LHU		3'd2
`define DMOut_MEOp_LB		3'd3
`define DMOut_MEOp_LBU		3'd4

// Wr with
`define PCWr_WIDTH  1
`define GPRWr_WIDTH 1
`define DMWr_WIDTH  1