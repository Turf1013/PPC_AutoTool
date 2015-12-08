/*
 * Description: This module is all about FF(flip-flop).
 *		1. FF: negedge reset, NO write-able.
 *		2. FFW: negedge reset, with write-able.
 * Author: ZengYX
 * Date:   2014.8.1
 */

module FF (
	clk, rst_n, din, dout
);

	parameter WIDTH = 8, RESET = 0;
	
	input              clk;
	input              rst_n;
	input  [0:WIDTH-1] din;
	output [0:WIDTH-1] dout;
	
	reg [0:WIDTH-1] dout_r;
	
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n )
			dout_r <= RESET;
		else
			dout_r <= din;
	end // end always
	
	assign dout = dout_r;
	
endmodule

module FFW (
	clk, rst_n, wr, din, dout
);

	parameter WIDTH = 8, RESET = 0;
	
	input              clk;
	input              rst_n;
	input			   wr;	
	input  [0:WIDTH-1] din;
	output [0:WIDTH-1] dout;
	
	reg [0:WIDTH-1] dout_r;
	
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n )
			dout_r <= RESET;
		else if ( wr )
			dout_r <= din;
	end // end always
	
	assign dout = dout_r;
	
endmodule
