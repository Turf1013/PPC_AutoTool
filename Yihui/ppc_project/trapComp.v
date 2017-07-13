`include "arch_def.v"
`include "ctrl_encode_def.v"
`include "SPR_def.v"

module trapComp (
	TO, A, B, Op, C
);

	input [0:4] TO;
	input [0:`ARCH_WIDTH-1] A;
	input [0:`ARCH_WIDTH-1] B;
	input [0:`trapCompOp_WIDTH-1] Op;
	output [0:0] C;
	
	wire signed [0:`ARCH_WIDTH-1] A;
	wire signed [0:`ARCH_WIDTH-1] B;
	
	assign C = (Op == `trapCompOp_TRAP) && 
				(
					((A < B)  & TO[0]) |
					((A > B)  & TO[1]) |
					((A == B) & TO[2]) |
					(({1'b0,A} < {1'b0,B}) & TO[3]) |
					(({1'b0,A} > {1'b0,B}) & TO[4])
				);


endmodule

module trapExt (
	imm16, imm32
);

	input [0:15] imm16;
	output [0:31] imm32;
	
	assign imm32 = {{16{imm16[0]}}, imm16};

endmodule
