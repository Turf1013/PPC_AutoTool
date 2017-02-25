`include "ctrl_encode_def.v"

module MDU_tb (

);

	reg clk;
	reg rst_n;
	
	
	reg req;
	wire ack;
	reg [31:0] A, B;
	reg [`MDUOp_WIDTH-1:0] Op, Op_r;
	wire [31:0] C;
	wire [3:0] D;
	wire [5:0] cnt;
	
	initial begin
		A = 0;
		B = 0;
		Op = `MDUOp_NOP;
		Op_r = `MDUOp_NOP;
		clk = 1'b1;
		rst_n = 1'b1;
		#2 rst_n = 1'b0;
		#5 rst_n = 1'b1;
		
		// test MULW
		A = 160;
		B = -20;
		#5 req = 1'b1;
		Op = `MDUOp_MULH;
	end // end initial
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			Op <= `MDUOp_NOP;
		end 
		else if (req==0 && cnt==0) begin
			if (Op == `MDUOp_DIVWU)
				Op <= `MDUOp_NOP;
			else
				Op <= Op + 1;
		end
	end // end always
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			Op_r <= `MDUOp_NOP;
		end
		else begin
			Op_r <= Op;
		end
	end // end always
	
	always @(posedge clk or negedge rst_n) begin
		if (ack==1 && cnt==0) begin
			req <= 1'b1;
			A <= A + 1;
			B <= B + 2;
		end
		else begin
			req <= 1'b0;
			A <= A;
			B <= B;
		end
	end // end always

	always begin
		#5 clk = ~clk;
	end // end always
	
	slowMDU I_MDU (
		.clk(clk),
		.rst_n(rst_n),
		.req(req),
		.ack(ack),
		.A(A),
		.B(B),
		.Op(Op),
		.C(C),
		.D(D),
		.cnt(cnt)
	);
	
endmodule