`include "arch_def.v"
`include "SPR_def.v"
`include "instruction_def.v"
`include "instruction_format_def.v"
`include "ctrl_encode_def.v"

module INTE (
	clk, rst_n, clr,
	intReq, EE, hw_int
);
	
	input clk, rst_n, clr;
	input EE;
	input hw_int;
	output intReq;
	
	reg intReq_r;
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			intReq_r <= 0;
		end
		else if (clr) begin
			intReq_r <= 0;
		end
		else begin
			intReq_r <= (intReq_r) || (hw_int & EE);
		end
	end // end always
	
	assign intReq = intReq_r;
	
endmodule

module intEntry (
	IVPR, IVOR, intAddr
);

	input [0:`SPR_WIDTH-1] IVPR;
	input [0:`SPR_WIDTH-1] IVOR;
	output [0:`PC_WIDTH-1] intAddr;
	
	assign intAddr = {IVPR[0:`SPR_WIDTH/2-1], IVOR[`SPR_WIDTH/2:`SPR_WIDTH-5], 4'h0};

endmodule

module intEncode (
	intReq, instr, intOp
);
	
	input					 intReq;
	input [0:`INSTR_WIDTH-1] instr;
	output [0:`INTOp_WIDTH-1] intOp;
	
	wire trap, sc;
	
	assign sc = instr`SCOPCD == `SC_OPCD;
	assign trap = 	(instr`DOPCD == `TWI_OPCD) || 
					(instr`XOPCD == `TW_OPCD && instr`XXO == `TW_XXO);
	
	assign intOp = 	(trap)		?	`INTOp_TRAP		:
					(sc) 		?	`INTOp_SC		:
					(intReq)	?	`INTOp_EXT		:
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

