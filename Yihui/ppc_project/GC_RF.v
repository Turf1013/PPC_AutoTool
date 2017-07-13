module GC_RF(
	clk, rst_n, we, addr, wd, rd, cursor_x, cursor_y
);
	
	input clk;
	input rst_n;
	input we;
	input [11:0] addr;
	input [31:0] wd;
	output [31:0] rd;
	output [31:0] cursor_x;
	output [31:0] cursor_y;

	reg [31:0] RF[3:0];
	
	integer i;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			RF[0] <= 32'd0;
			RF[1] <= 32'd0;
			RF[2] <= 32'd0;
		end
		else if (we) begin
			RF[addr[3:2]] <= wd;
		end
	end // end always
	
	assign cursor_x = RF[1];
	assign cursor_y = RF[2];
	assign rd = RF[addr[3:2]];

endmodule
