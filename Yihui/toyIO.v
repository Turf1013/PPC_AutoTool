/**
	\author: 	Trasier
	\date: 		2017/5/9
	\brief: 	TOY of the IO device
*/
module toyIO (
	intrIn, intr,
	ack, clk, rst
);
	input intrIn;
	output intr;
	input ack;
	input clk, rst;
	
	reg intr_r;
	
	always @(posedge clk) begin
		if (rst) begin
			intr_r <= 1'b0;
		end
		else if (ack) begin
			intr_r <= 1'b0;
		end
		else begin
			intr_r <= intr_r | intrIn;
		end
	end // end always
	
	assign intr = intr_r;

endmodule

module toyDev1 (
	intrIn, intr,
	ack, clk, rst
);

	input intrIn;
	output intr;
	input ack;
	input clk, rst;
	
	toyIO toyDev1 (
		.intrIn(intrIn),
		.intr(intr),
		.ack(ack),
		.clk(clk),
		.rst(rst)
	);

endmodule

module toyDev0 (
	intrIn, intr,
	ack, clk, rst
);

	input intrIn;
	output intr;
	input ack;
	input clk, rst;
	
	toyIO toyDev0 (
		.intrIn(intrIn),
		.intr(intr),
		.ack(ack),
		.clk(clk),
		.rst(rst)
	);

endmodule