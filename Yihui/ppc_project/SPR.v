/*
	Description: This module is all about SPR.
		1. SPR:
			(1) 2 read port;
			(2) 2 write port;
	Author: ZengYX
	Date:   2015.12.17
 */
`include "SPR_def.v"
`include "ctrl_encode_def.v"

module SPR (
	clk, rst_n, wr0, wr1, waddr0, waddr1, wd0, wd1, raddr0, raddr1, rd0, rd1
);
	input					clk;
	input					rst_n;
	input					wr0, wr1;
	input  [0:`SPR_DEPTH-1] raddr0, raddr1;
	input  [0:`SPR_DEPTH-1] waddr0, waddr1;
	input  [0:`SPR_WIDTH-1] wd0, wd1;
	output [0:`SPR_WIDTH-1] rd0, rd1;
	
	reg [0:`SPR_WIDTH-1] SPR[`SPR_SIZE-1:0];
	
	integer i;
	
	always @( posedge clk or negedge rst_n ) begin
		if ( ~rst_n ) begin		
			for (i=0; i<`SPR_SIZE; i=i+1)
				SPR[i] <= 0;
		end
		else begin
			if ( wr0 )	SPR[waddr0] <= wd0;
			if ( wr1 )	SPR[waddr1] <= wd1;
		end
	end // end always
	
	assign rd0 = SPR[raddr0];
	assign rd1 = SPR[raddr1];
	
endmodule

