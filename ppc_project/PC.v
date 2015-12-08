/*
 * Description: This module is all about definition of control signal in CU.
 * Author: ZengYX
 * Date:   2014.8.3
 */
`include "arch_def.v"

module PC (
	clk, rst_n, wr, NPC, PC
); 

	parameter RESET = 0;

	input 				   clk;
	input				   rst_n;
	input				   wr;
	input  [0:`PC_WIDTH-1] NPC;
	output [0:`PC_WIDTH-1] PC;
	
	reg [0:`PC_WIDTH-1] PC;
	
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n )
			PC <= RESET;
		else if ( wr )
			PC <= NPC;
	end // end always

endmodule
