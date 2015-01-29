/*
 * Description: This module is all about Ext.
 * Author: ZengYX
 * Date:   2014.8.1
 */
`include "cu_def.v"

module Ext (
	Imm16, ExtOp, Imm32
);

	input  [0:15] 			  Imm16;
	input  [0:`ExtOp_WIDTH-1] ExtOp;
	output [0:31]			  Imm32;
	
	reg [0:31] Imm32_r;
	
	always @(*)	begin
		case (ExtOp)
			`ExtOp_SIGNED: Imm32_r = {{16{Imm16[0]}}, Imm16};
			`ExtOp_UNSIGN: Imm32_r = {16'h0, Imm16};
			`ExtOp_HIGH16: Imm32_r = {Imm16, 16'h0};
			default:	   Imm32_r = 32'd0;
		endcase
	end	// end always
	
	assign Imm32 = Imm32_r;
	
endmodule
