/*
 * Description: This module is all about definition of GPR.
 * Author: ZengYX
 * Date:   2014.8.1
 */
`include "arch_def.v"
 
module GPR (
	clk, rst_n, wr, raddr0, raddr1, raddr2
	waddr, wd, rd0, rd1
);

	input 					  	clk;
	input 					  	rst_n;
	input					  	wr;				// wrte-enable	
	input  [0:`GPR_DEPTH-1]   	raddr0, raddr1, raddr2;	// read address
	input  [0:`GPR_DEPTH-1]		waddr;			// write-back address
	input  [0:`GPR_WIDTH-1] 	wd;				// write-back data
	output [0:`GPR_WIDTH-1] 	rd0, rd1, rd2;		// source data
	
	reg [0:`GPR_WIDTH-1] GPR[`GPR_SIZE-1:0];
	
	integer i;
	
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			for (i=0; i<`GPR_SIZE; i=i+1)
				GPR[i] <= 0;
		end
		else if ( wr ) begin
			GPR[waddr] <= wd;
		end
	end // end always
	
	assign rd0 = GPR[raddr0];
	assign rd1 = GPR[raddr1];
	assign rd2 = GPR[raddr2];

endmodule
