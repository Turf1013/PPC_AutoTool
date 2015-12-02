/*
 * Description: This module is all about FF(flip-flop).
 *		1. FF: negedge reset, NO write-able.
 *		2. FFW: negedge reset, with write-able.
 * Author: ZengYX
 * Date:   2014.8.1
 */

module FF (
	clk, rst_n, d, q
);

	parameter WIDTH = 8, RESET = 0;
	
	input              clk;
	input              rst_n;
	input  [0:WIDTH-1] d;
	output [0:WIDTH-1] q;
	
	reg [0:WIDTH-1] q_r;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			q_r <= RESET;
		else
			q_r <= d;
	end // end always
	
	assign q = q_r;
	
endmodule

module FFW (
	clk, rst_n, wr, d, q
);

	parameter WIDTH = 8, RESET = 0;
	
	input              clk;
	input              rst_n;
	input			   wr;	
	input  [0:WIDTH-1] d;
	output [0:WIDTH-1] q;
	
	reg [0:WIDTH-1] q_r;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			q_r <= RESET;
		else if (wr)
			q_r <= d;
	end // end always
	
	assign q = q_r;
	
endmodule
