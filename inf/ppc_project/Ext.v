`include "ctrl_encode_def.v"

module Ext (
	Imm16, Op, Imm32
);

	input  [15:0] 			  Imm16;
	input  [`ExtOp_WIDTH-1:0] Op;
	output [31:0]			  Imm32;
	
	reg [31:0] Imm32_r;
	
	always @(*)	begin
		case (Op)
			`ExtOp_SIGNED: Imm32_r = {{16{Imm16[0]}}, Imm16};
			`ExtOp_UNSIGN: Imm32_r = {16'h0, Imm16};
			`ExtOp_HIGH16: Imm32_r = {Imm16, 16'h0};
			default:	   Imm32_r = 32'd0;
		endcase
	end	// end always
	
	assign Imm32 = Imm32_r;
	
endmodule
