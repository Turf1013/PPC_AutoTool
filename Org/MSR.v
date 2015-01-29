/*
 * Description: This module is all about MSR.
 *		1. XER
 *		2. MSR
 * Author: ZengYX
 * Date:   2014.8.2
 */
`include "arch_def.v"

module MSR(
	clk, rst_n, MSRWr, MSRWd, MSR
);
	
	input 					clk;
	input 					rst_n;
	input					MSRWr;
	input  [0:`MSR_WIDTH-1] MSRWd;
	output [0:`MSR_WIDTH-1] MSR;
	
	/*******************/
	// 16: EE, External enable;
	// 19: ME, Machine Check Enable;
	// 31: LE, Little-Endian Mode;
	// Others: Reserved
	
	reg EE, ME, LE;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			EE <= 0;
			ME <= 0;
			LE <= 0;
		end
		else if (MSRWr) begin
			EE <= MSRWd[16];
			ME <= MSRWd[19];
			LE <= MSRWd[31];
		end
	end // end always
	
	assign MSR = {16'h0, EE, 2'h0, ME, 11'h0, LE};
	
endmodule