`include "arch_def.v"

module rotnIn (
	din, dout
);
	input [0:`ARCH_WIDTH-1] din;
	output [0:4] dout;
	
	assign dout = din[27:31];
	
endmodule
