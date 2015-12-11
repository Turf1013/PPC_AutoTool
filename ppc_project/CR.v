/*
 * Description: This module is all about CR.
 *		1. CR_ALU: one bit calculater;
 *		2. CR_BE:  1bit, 4bits or 32bits and which bits to be write;
 *		3. CR_Reg_4bit: 4bit of CR.
 *		4. CR_Reg: read and write logic of CR;
 *		5. CR:	   Top module, connect Upper modules.	
 * Author: ZengYX
 * Date:   2014.8.1
 */

`include "ctrl_encode_def.v"
`include "arch_def.v"

module CR (
	clk, rst_n, wr, rd, wd
);

	input 					clk, rst_n;
	input 					wr;
	input 	[0:`CR_WIDTH-1] wd;
	output 	[0:`CR_WIDTH-1] rd;
	
	reg [0:`CR_WIDTH-1] CR;
	
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			CR <= 0;
		end
		else if (wr) begin
			CR <= wd;
		end
	end // end always
	
	assign rd = CR;

endmodule

module CR_ALU (
	BT, BA, BB, CRrd, Op, C
);

	input 	[0:`CR_DEPTH-1]			BT;
	input 	[0:`CR_DEPTH-1]			BA;
	input 	[0:`CR_DEPTH-1]			BB;
	input 	[0:`CR_WIDTH-1]			CRrd;
	input 	[0:`CR_ALUOp_WIDTH-1] 	Op;
	output 	[0:`CR_WIDTH-1]			C;
	
	reg [0:`CR_WIDTH-1] C;
	
	wire [0:`CR_WIDTH-1] mask;
	wire [0:`CR0_WIDTH-1] CRX;
	
	//wire [0:`CR_DEPTH-1] BF;
	//wire [0:`CR_DEPTH-1] BFA;
	
	//assign BF  = {BT[0:`CR_BF_WIDTH-1],  2'b00};
	//assign BFA = {BA[0:`CR_BFA_WIDTH-1], 2'b00};
	//assign BF = BT;
	//assign BFA = BA;
	//assign mask = (Op == `CR_ALUOp_MOV) ? (32'hf << BF): (32'h1 << BT);
	//assign CRX = (CRrd >> BFA) & 32'hf;
	
	wire [0:`CR_DEPTH-1] BA_, BT_;
	
	assign BA_ = 5'd31 - BA;
	assign BT_ = 5'd31 - BT;
	assign mask = ((Op == `CR_ALUOp_MOV) ? 32'hf : 32'h1) << BT_;
	assign CRX = (CRrd >> BA_) & 32'hf;
	
	wire A, B;
	reg Y;
	
	assign A = CRrd[BA];
	assign B = CRrd[BB];
	
	always @( * ) begin
		case ( Op )
		
			`CR_ALUOp_AND: begin
				Y = A & B;
				C = (CRrd & ~mask) | ({31'd0, Y} << BT_);
			end
			
			`CR_ALUOp_OR: begin
				Y = A | B;
				C = (CRrd & ~mask) | ({31'd0, Y} << BT_);
			end
			
			`CR_ALUOp_XOR: begin
				Y = A ^ B;
				C = (CRrd & ~mask) | ({31'd0, Y} << BT_);
			end
			
			`CR_ALUOp_NAND: begin
				Y = ~(A & B);
				C = (CRrd & ~mask) | ({31'd0, Y} << BT_);
			end
			
			`CR_ALUOp_NOR: begin
				Y = ~(A | B);
				C = (CRrd & ~mask) | ({31'd0, Y} << BT_);
			end
			
			`CR_ALUOp_EQV: begin
				Y = A == B;
				C = (CRrd & ~mask) | ({31'd0, Y} << BT_);
			end
			
			`CR_ALUOp_ANDC: begin
				Y = A & ~B;
				C = (CRrd & ~mask) | ({31'd0, Y} << BT_);
			end
			
			`CR_ALUOp_ORC: begin
				Y = A | ~B;
				C = (CRrd & ~mask) | ({31'd0, Y} << BT_);
			end
			
			`CR_ALUOp_MOV: begin
				C = (CRrd & ~mask) | (CRX << BT_);
			end
			
			default: begin
				C = 0;
			end
			
		endcase
	end // end always

endmodule

