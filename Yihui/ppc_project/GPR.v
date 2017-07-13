/*
 * Description: This module is all about definition of GPR.
 * Author: ZengYX
 * Date:   2014.8.1
 */
`include "arch_def.v" 

/*
module GPR (
	clk, rst_n, wr, raddr0, raddr1, raddr2,
	waddr, wd, rd0, rd1, rd2
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
*/

module GPR (
	clk, rst_n, raddr0, raddr1, raddr2,
	rd0, rd1, rd2,
	wr0, waddr0, wd0, 
	wr1, waddr1, wd1 
);

	input 					  	clk;
	input 					  	rst_n;
	input					  	wr0, wr1;				// wrte-enable	
	input  [0:`GPR_DEPTH-1]   	raddr0, raddr1, raddr2;	// read address
	input  [0:`GPR_DEPTH-1]		waddr0, waddr1;			// write-back address
	input  [0:`GPR_WIDTH-1] 	wd0, wd1;				// write-back data
	output [0:`GPR_WIDTH-1] 	rd0, rd1, rd2;		// source data
	
	reg [0:`GPR_WIDTH-1] GPR[`GPR_SIZE-1:0];
	
	integer i;
	
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			for (i=0; i<`GPR_SIZE; i=i+1)
				GPR[i] <= 0;
		end
		else begin
			if (wr0) begin
				GPR[waddr0] <= wd0;
			end
			if (wr1) begin
				GPR[waddr1] <= wd1;
			end
		end
	end // end always
	
	assign rd0 = 	(waddr0==raddr0) ? wd0 : 
					(waddr1==raddr0) ? wd1 : GPR[raddr0];
	assign rd1 = 	(waddr0==raddr1) ? wd0 : 
					(waddr1==raddr1) ? wd1 : GPR[raddr1];
	assign rd2 = 	(waddr0==raddr2) ? wd0 : 
					(waddr1==raddr2) ? wd1 : GPR[raddr2];

endmodule
