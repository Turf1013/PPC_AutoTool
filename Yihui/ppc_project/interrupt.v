`include "arch_def.v"
`include "SPR_def.v"
`include "instruction_def.v"
`include "instruction_format_def.v"
`include "ctrl_encode_def.v"

module INTE (
	clk, rst_n,
	ack, req, 
	EE, hw_int
);
	
	input clk, rst_n;
	input ack;
	input EE;
	input hw_int;
	output req;
	
	reg req_r;
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			req_r <= 0;
		end
		else if (ack) begin
			req_r <= 0;
		end
		else begin
			req_r <= (req_r) || (hw_int & EE);
		end
	end // end always
	
	assign req = req_r;
	
endmodule

module intEntry (
	IVPR, IVOR, intAddr
);

	input [0:`SPR_WIDTH-1] IVPR;
	input [0:`SPR_WIDTH-1] IVOR;
	output [0:`PC_WIDTH-1] intAddr;
	
	// assign intAddr = {IVPR[0:`SPR_WIDTH/2-1], IVOR[`SPR_WIDTH/2:`SPR_WIDTH-5], 4'h0};
	assign intAddr = `INT_ENTRY_ADDR;

endmodule

module intEncode (
	instr, intOp
);
	
	input [0:`INSTR_WIDTH-1] instr;
	output [0:`INTOp_WIDTH-1] intOp;
	
	wire trap, sc;
	
	assign sc = instr`SCOPCD == `SC_OPCD;
	assign trap = 	(instr`DOPCD == `TWI_OPCD) || 
					(instr`XOPCD == `TW_OPCD && instr`XXO == `TW_XXO);
	assign intr = instr`DOPCD == `INTR_OPCD;
	
	assign intOp = 	(trap)		?	`INTOp_TRAP		:
					(sc) 		?	`INTOp_SC		:
					(intr)		?	`INTOp_EXT		:
									`INTOp_NONE		;

endmodule

module IVORaddr (
	intOp, addr
);

	input [0:`INTOp_WIDTH-1] intOp;
	output [0:3] addr;
	
	assign addr = 	(intOp == `INTOp_TRAP)	?	6 :
					(intOp == `INTOp_SC)	?	8 :
					(intOp == `INTOp_EXT)	?	4 :
												0 ;

endmodule

module intCtrl (
	clk, rst_n,
	intAck, intReq,
	EE, hw_int,
	instr, intAddr
);
	input						clk;
	input						rst_n;
	input						EE;
	input						hw_int;
	input 	[0:`INSTR_WIDTH-1] 	instr;
	input						intAck;
	output	 [0:`PC_WIDTH-1]	intAddr;
	output						intReq;
	
	
	wire [0:3] IVOR_addr;
	wire [0:`INTOp_WIDTH-1] intOp;
	
	// IVOR select
	IVORaddr I_IVORaddr (
		.intOp(intOp),
		.addr(IVOr_addr)
	);
	
	// interrupt entry
	intEntry I_intEntry (
		.IVPR(0),
		.IVOR(0),
		.intAddr(intAddr)
	);
	
	// interrupt_op encode
	intEncode I_intEncode (
		.instr(instr),
		.intOp(intOp)
	);
	
	// interrupt request latch
	INTE I_INTE (
		.clk(clk), 
		.rst_n(rst_n),
		.ack(intAck), 
		.req(intReq), 
		.EE(EE), 
		.hw_int(hw_int)
	);

endmodule


