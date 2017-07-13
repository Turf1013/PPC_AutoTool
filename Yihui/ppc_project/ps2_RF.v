module ps2_RF (
	clk, rst_n, we, addr,  rd, wd, caps_flg, ps2_byte, intp, intr, caps
);

			  
	input clk;
	input rst_n;
	input we;
	input intp;
	input [3:0] addr;
	input caps_flg;
	input [7:0] ps2_byte;
	input [31:0] wd;
	output [31:0] rd;
	output intr;
	output caps;

	reg [31:0] RF[3:0];
	wire [31:0] wd;
	
	// the SR Register
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) 
			RF[0] <= 32'd0;
		else if (intp)
			RF[0] <= 32'd1;
		else if (we && addr == 4'h0)
			RF[0] <= wd;
		else
			;
	end // end always
	
	// the Sum Register
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			RF[1] <= 32'd0;
		else if (we && addr == 4'h4)
			RF[1] <= wd;
		else
			;
	end // end always
	
	// the Data Register
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			RF[2] <= 32'd0;
		else
			RF[2] <= { 24'd0, ps2_byte };
	end // end always
	
	// the Flag Register
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			RF[3] <= 32'd0;
		else
			RF[3] <= { 31'd0, caps_flg };
	end // end always
	
	assign rd = RF[addr[3:2]];
	assign intr = RF[0][0];
	assign caps = RF[3][0];

endmodule