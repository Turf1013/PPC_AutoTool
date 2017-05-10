/**
	\author: 	Trasier
	\date: 		2017/5/10
	\brief: 	TOY of the MSR
*/
module toyMSR (
	clk, rst, 
	wr, wd, MSR
);

	input clk, rst;
	input wr;
	input [0:31] wd;
	output [0:31] MSR;
	
	reg [0:31] MSR_r;
	
	always @(posedge clk) begin
		if (rst)
			MSR_r <= 0;
		else if (wr)
			MSR_r <= wd;
	end // end always
	
	assign MSR = (wr) ? wd : MSR_r;

endmodule