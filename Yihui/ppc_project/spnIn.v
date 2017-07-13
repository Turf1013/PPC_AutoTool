`include "SPR_def.v"

module sprnIn (
	din, dout
);

	input 	[0:`SPR_DEPTH-1] din;
	output	[0:`SPR_DEPTH-1] dout;
	
	assign dout = {din[`SPR_DEPTH/2:`SPR_DEPTH-1], din[0:`SPR_DEPTH/2-1]};
	
endmodule

module spwnIn (
	din, dout
);

	input 	[0:`SPR_DEPTH-1] din;
	output	[0:`SPR_DEPTH-1] dout;
	
	assign dout = {din[`SPR_DEPTH/2:`SPR_DEPTH-1], din[0:`SPR_DEPTH/2-1]};
	
endmodule


