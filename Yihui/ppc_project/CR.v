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
	
	always @( posedge clk) begin
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
	output 							C;
	
	
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
	wire [0:`CR_WIDTH-1] CRX_tmp;
	
	assign BA_ = 5'd31 - BA;
	assign BT_ = 5'd31 - BT;
	assign mask = ((Op == `CR_ALUOp_MOV) ? 32'hf : 32'h1) << BT_;
	assign CRX_tmp = (CRrd >> BA_) & 32'hf;
	assign CRX = CRX_tmp[`CR_WIDTH-`CR0_WIDTH:`CR_WIDTH-1];
	
	wire A, B;
	reg Y;
	
	assign A = CRrd[BA];
	assign B = CRrd[BB];
	
	always @( * ) begin
		case ( Op )
		
			`CR_ALUOp_AND: begin
				Y = A & B;
			end
			
			`CR_ALUOp_OR: begin
				Y = A | B;
			end
			
			`CR_ALUOp_XOR: begin
				Y = A ^ B;
			end
			
			`CR_ALUOp_NAND: begin
				Y = ~(A & B);
			end
			
			`CR_ALUOp_NOR: begin
				Y = ~(A | B);
			end
			
			`CR_ALUOp_EQV: begin
				Y = (A == B);
			end
			
			`CR_ALUOp_ANDC: begin
				Y = A & ~B;
			end
			
			`CR_ALUOp_ORC: begin
				Y = A | ~B;
			end
			
			`CR_ALUOp_MOV: begin
				Y = CRrd[BT];
			end
			
			default: begin
				Y = 1'b0;
			end
			
		endcase
	end // end always
	
	assign C = Y;

endmodule

module CR_MOVE (
	ALU_D, MDU_D, cmpALU_D,
	BF, BFA, BT,
	crALU_C, rS, Op, CRrd, CRwd
);

	input [0:2] ALU_D;
	input [0:2] MDU_D;
	input [0:2] cmpALU_D;
	input [0:2] BF, BFA;
	input [0:5] BT;
	input		crALU_C;
	input [0:`CR_WIDTH-1] rS;
	input [0:`CR_MOVEOp_WIDTH-1] Op;
	input [0:`CR_WIDTH-1] CRrd;
	output [0:`CR_WIDTH-1] CRwd;
	
	wire [0:31] rd;
	assign rd = CRrd;
	
	reg [0:`CR_WIDTH-1] wd;
	reg [0:`CR_WIDTH-1] mask;
	wire [0:3] cmpALU_CRX, ALU_CR0, MDU_CR0, MCRF_CRX;
	
	assign ALU_CR0 = {ALU_D, 1'b0};
	assign MDU_CR0 = {MDU_D, 1'b0};
	assign cmpALU_CRX = {cmpALU_D, 1'b0};
	wire [27:0] MCRF_CRX_tmp27;
	assign {MCRF_CRX_tmp27, MCRF_CRX} = ((rd >> (5'd28-BFA)) & 32'hf);
	
	always @( * ) begin
		case ( Op )
			`CR_MOVEOp_NOP: begin
				mask = 32'd0;
				wd = rd;
			end
			
			`CR_MOVEOp_ALU0: begin
				mask = 32'd0;
				wd = {ALU_CR0, rd[4:`CR_WIDTH-1]};
			end
			
			`CR_MOVEOp_MDU0: begin
				mask = 32'd0;
				wd = {MDU_CR0, rd[4:`CR_WIDTH-1]};
			end
			
			`CR_MOVEOp_CRX: begin
				mask = 32'd15 << (5'd28 - BF);
				wd = (rd & ~mask) | (cmpALU_CRX << (5'd28-BF));
			end
			
			`CR_MOVEOp_CAL: begin
				mask = 32'b1 << (5'd31 - BT);
				wd = (rd & ~mask) | (crALU_C << (5'd31-BT));
			end
			
			`CR_MOVEOp_CRF: begin
				mask = 32'd15 << (5'd28 - BF);
				wd = (rd & ~mask) | (MCRF_CRX << (5'd28-BF));
			end
			
			`CR_MOVEOp_TCRF: begin
				mask = 32'd0;
				wd = rS;
			end
			
			default: begin
				mask = 32'd0;
				wd = rd;
			end
			
		endcase
	end // end always
	
	assign CRwd = wd;

endmodule
