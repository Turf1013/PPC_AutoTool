/**
	\author: 	Trasier
	\date: 		2017/5/10
	\brief: 	TestBench of the Interrupt System
*/
`include "Interrupt_def.v"
`include "sprn_def.v"

module toyDev0_tb(
);

	reg clk, rst;
	reg intrIn;
	wire intr;
	reg ack;
	
	toyDev0 U_toyDev0 (
		.clk(clk),
		.rst(rst),
		.intrIn(intrIn),
		.intr(intr),
		.ack(ack)
	);
	
	initial begin
		ack = 1'b0;
		intrIn = 1'b0;
		rst = 1'b1;
		#6
		rst = 1'b0;
		
		#2
		intrIn = 1'b1;
		#12;
		intrIn = 1'b0;
		#12
		ack = 1'b1;
		#9
		ack = 1'b0;
	end
	
	always begin
		clk = 1'b1; #5;
		clk = 1'b0; #5;
	end


endmodule
