`include "ctrl_encode_def.v"

module MDU (
	A, B, Op, hi, lo
);

	input [31:0] A, B;
	input [`MDUOp_WIDTH-1:0] Op;
	output [31:0] hi, lo;
	
	reg [31:0] hi_r, lo_r;
	
	wire signed [31:0] signA, signB;
	reg [1:0] useless;
	
	assign signA = A;
	assign signB = B;
	
	always @( * ) begin
		case ( Op )
			`MDUOp_MULT: begin
				{hi_r, lo_r} = signA * signB;
			end
			
			`MDUOp_MULTU: begin
				{useless, hi_r, lo_r} = {1'b0, signA} * {1'b0, signB};
			end
			
			`MDUOp_DIV: begin
				lo_r = signA / signB;
				hi_r = signA % signB;
			end
			
			`MDUOp_DIVU: begin
				lo_r = {1'b0, signA} / {1'b0, signB};
				hi_r = {1'b0, signA} % {1'b0, signB};
			end
		
		endcase
	end // end always
	
	assign hi = hi_r;
	assign lo = lo_r;

endmodule

module HI (
	clk, rst_n, wr, wd, rd
);

	input clk, rst_n;
	input wr;
	input [31:0] wd;
	output [31:0] rd;
	
	reg [31:0] hi;
	
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			hi <= 0;
		end
		else if ( wr ) begin
			hi <= wd;
		end
	end // end always
	
	assign rd = hi;

endmodule


module LO (
	clk, rst_n, wr, wd, rd
);

	input clk, rst_n;
	input wr;
	input [31:0] wd;
	output [31:0] rd;
	
	reg [31:0] lo;
	
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			lo <= 0;
		end
		else if ( wr ) begin
			lo <= wd;
		end
	end // end always
	
	assign rd = lo;

endmodule
