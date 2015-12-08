`include "arch_def.v"
`include "ctrl_encode_def.v"

module ALU_AIn (
	Op, RA, din, dout
);

	input 	[0:`ALU_AInOp_WIDTH-1] 	Op;
	input 	[0:5]					RA;
	input 	[0:`ARCH_WIDTH-1] 		din;
	output 	[0:`ARCH_WIDTH-1] 		dout;
	
	reg [0:`ARCH_WIDTH-1] dout_r;
	
	always @( * ) begin
		if (Op == `ALU_AInOp_ZERO) begin
			if (RA == 0)
				dout_r = 0;
			else
				dout_r = din;
		end 
		else begin
			dout_r = din;
		end
	end // end always
	
	assign dout = dout_r;

endmodule
