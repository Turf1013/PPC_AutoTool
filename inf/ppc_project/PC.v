`include "arch_def.v"

module PC (
	clk, rst_n, wr, NPC, PC
); 

	parameter RESET = 32'h0000_3000;

	input 				   clk;
	input				   rst_n;
	input				   wr;
	input  [`PC_WIDTH-1:0] NPC;
	output [`PC_WIDTH-1:0] PC;
	
	reg [`PC_WIDTH-1:0] PC;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			PC <= RESET;
		else if (wr)
			PC <= NPC;
	end // end always

endmodule
