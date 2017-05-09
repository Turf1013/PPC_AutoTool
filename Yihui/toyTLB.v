/**
	\author: 	Trasier
	\date: 		2017/5/9
	\brief: 	TOY of the ITLB & DTLB
*/
module toyTLB (
	missIn, miss,
	ack, clk, rst
);
	input  missIn;
	output miss;
	input ack;
	input clk, rst;
	
	reg miss_r;
	
	always @(posedge clk) begin
		if (rst) begin
			miss_r <= 1'b0;
		end
		else if (ack) begin
			miss_r <= 1'b0;
		end
		else begin
			miss_r <= miss_r | missIn;
		end
	end // end always
	
	assign miss = miss_r;

endmodule

module toyITLB (
	missIn, miss,
	ack, clk, rst
);

	input  missIn;
	output miss;
	input ack;
	input clk, rst;
	
	toyTLB toyITLB (
		.missIn(missIn),
		.miss(miss),
		.ack(ack),
		.clk(clk),
		.rst(rst)
	);

endmodule

module toyDTLB (
	missIn, miss,
	ack, clk, rst
);

	input  missIn;
	output miss;
	input ack;
	input clk, rst;
	
	toyTLB toyDTLB (
		.missIn(missIn),
		.miss(miss),
		.ack(ack),
		.clk(clk),
		.rst(rst)
	);

endmodule
