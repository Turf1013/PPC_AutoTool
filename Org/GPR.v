/*
 * Description: This module is all about definition of GPR.
 * Author: ZengYX
 * Date:   2014.8.1
 */
`include "arch_def.v"
 
module GPR (
	clk, rst_n, GPRWr, raddr1, raddr2, raddr3,
	waddr1, GPRWd1, rd1, rd2, rd3,
);

	input 					  clk;
	input 					  rst_n;
	input					  GPRWr;			// wrte-enable	
	input  [0:`GPR_DEPTH-1]   raddr1, raddr2, raddr3;	// read address
	input  [0:`GPR_DEPTH-1]   waddr1;				// write-back address
	input  [0:`GPR_WIDTH-1] GPRWd1;			// write-back data
	output [0:`GPR_WIDTH-1] rd1, rd2, rd3;	// source data
	
	reg [0:`GPR_WIDTH-1] RF[`GPR_N-1:0];
	
	integer i;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			for (i=0; i<`GPR_N; i=i+1)
				RF[i] <= 0;
		end
		else if (GPRWr) begin
			RF[waddr1] <= GPRWd1;
		end
	end // end always
	
	assign rd1 = RF[raddr1];
	assign rd2 = RF[raddr2];
	assign rd3 = RF[raddr3];

endmodule
