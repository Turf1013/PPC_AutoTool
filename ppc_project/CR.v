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

`include "cu_def.v"
`include "arch_def.v"

module CR_BE (
	Op, wr, addr, lsel, hsel, FXM
);

	input  [0:`CR_BEOp_WIDTH-1]   Op;
	input					    wr;	
	input  [0:`CR_DEPTH-1]  	addr;
	input  [0:`CR_Hsel_WIDTH-1] FXM;
	output [0:`CR_Lsel_WIDTH-1] lsel;
	output [0:`CR_Hsel_WIDTH-1] hsel;
	
	reg [0:`CR_Lsel_WIDTH-1] lsel_r;
	reg [0:`CR_Hsel_WIDTH-1] hsel_r;
	
	wire [0:`CR_Lsel_WIDTH-1] lsel_tmp;
	wire [0:`CR_Hsel_WIDTH-1] hsel_tmp;
	
	decoder2to4 U_decoder2to4(.din(addr[3:4]), .dout(lsel_tmp));
	decoder3to8 U_decoder3to8(.din(addr[0:2]), .dout(hsel_tmp));
	
	always @(*) begin
		if (wr) begin
			case (Op)
				`CR_BEOp_1bits: begin
					hsel_r = hsel_tmp;
					lsel_r = lsel_tmp;
				end
				`CR_BEOp_4bits: begin
					hsel_r = hsel_tmp;
					lsel_r = 4'hf;
				end
				`CR_BEOp_32bits: begin
					hsel_r = FXM;
					lsel_r = 4'hf;
				end
				default: begin
					hsel_r = 0;
					lsel_r = 0;
				end
			endcase
		end
		else begin
			hsel_r = 0;
			lsel_r = 0;
		end
	end // end always
	
	assign hsel = hsel_r;
	assign lsel = lsel_r;
	
endmodule

module CR_ALU (
	A, B, Op, C
);

	input 					  A;
	input 					  B;
	input [0:`CR_ALUOp_WIDTH-1] Op;
	output 					  C;
	
	reg C;
	
	always @(*) begin
		case (Op)
			`CR_ALUOp_AND: C = A & B;
			`CR_ALUOp_NOR: C = ~(A | B);
			`CR_ALUOp_XOR: C = A ^ B;
			default:	   C = 0;
		endcase
	end // end always

endmodule

module CR_Reg_4bit(
	clk, rst_n, hsel, lsel, d, q
);

	input 	 				    clk;
	input 	 				    rst_n;
	input					    hsel;	
	input  [0:`CR_Lsel_WIDTH-1] lsel;
	input  [0:`CR_Lsel_WIDTH-1] d;
	output [0:`CR_Lsel_WIDTH-1] q;
	
	wire [0:`CR_Lsel_WIDTH-1] wr;
	
	assign wr = lsel & {4{hsel}};
	
	FFW #(1, 0) U_FFW_0bit (
		.clk(clk), .rst_n(rst_n), .wr(wr[0]), .d(d[0]), .q(q[0])
	);
	
	FFW #(1, 0) U_FFW_1bit (
		.clk(clk), .rst_n(rst_n), .wr(wr[1]), .d(d[1]), .q(q[1])
	);
	
	FFW #(1, 0) U_FFW_2bit (
		.clk(clk), .rst_n(rst_n), .wr(wr[2]), .d(d[2]), .q(q[2])
	);
	
	FFW #(1, 0) U_FFW_3bit (
		.clk(clk), .rst_n(rst_n), .wr(wr[3]), .d(d[3]), .q(q[3])
	);
	
endmodule


module CR_Reg (
	clk, rst_n, hsel, lsel, din, dout
);

	input 					    clk;
	input 					    rst_n;
	input  [0:`CR_Hsel_WIDTH-1] hsel;
	input  [0:`CR_Lsel_WIDTH-1] lsel;
	input  [0:`CR_WIDTH-1]  	din;
	output [0:`CR_WIDTH-1]  	dout;
	
	CR_Reg_4bit U_CR0 (
		.clk(clk), .rst_n(rst_n), .hsel(hsel[7]), 
		.lsel(lsel), .d(din[0:3]), .q(dout[0:3])
	);
	
	CR_Reg_4bit U_CR1 (
		.clk(clk), .rst_n(rst_n), .hsel(hsel[6]), 
		.lsel(lsel), .d(din[4:7]), .q(dout[4:7])
	);
	
	CR_Reg_4bit U_CR2 (
		.clk(clk), .rst_n(rst_n), .hsel(hsel[5]), 
		.lsel(lsel), .d(din[8:11]), .q(dout[8:11])
	);
	
	CR_Reg_4bit U_CR3 (
		.clk(clk), .rst_n(rst_n), .hsel(hsel[4]), 
		.lsel(lsel), .d(din[12:15]), .q(dout[12:15])
	);
	
	CR_Reg_4bit U_CR4 (
		.clk(clk), .rst_n(rst_n), .hsel(hsel[3]), 
		.lsel(lsel), .d(din[16:19]), .q(dout[16:19])
	);
	
	CR_Reg_4bit U_CR5 (
		.clk(clk), .rst_n(rst_n), .hsel(hsel[2]), 
		.lsel(lsel), .d(din[20:23]), .q(dout[20:23])
	);
	
	CR_Reg_4bit U_CR6 (
		.clk(clk), .rst_n(rst_n), .hsel(hsel[1]), 
		.lsel(lsel), .d(din[24:27]), .q(dout[24:27])
	);
	
	CR_Reg_4bit U_CR7 (
		.clk(clk), .rst_n(rst_n), .hsel(hsel[0]), 
		.lsel(lsel), .d(din[28:31]), .q(dout[28:31])
	);
	
endmodule

module CR (
	clk, rst_n, CRWr, CR_BEOp, addr, CRWd, FXM, CR
);

	input 						clk;
	input 						rst_n;
	input 						CRWr;
	input  [0:`CR_BEOp_WIDTH-1] CR_BEOp;
	input  [0:`CR_DEPTH-1]  	addr;	// can locate any bit of CR.	
	input  [0:`CR_WIDTH-1]  	CRWd;
	input  [0:`CR_Hsel_WIDTH-1] FXM;
	output [0:`CR_WIDTH-1]  	CR;
	
	
	wire [0:`CR_Hsel_WIDTH-1] hsel;
	wire [0:`CR_Lsel_WIDTH-1] lsel;
	
	CR_Reg U_CR_Reg (
		.clk(clk), .rst_n(rst_n), .hsel(hsel), 
		.lsel(lsel), .din(CRWd), .dout(CR)
	);
	
	CR_BE U_CR_BE (
		.Op(CR_BEOp), .wr(CRWr), .addr(addr),
		.lsel(lsel), .hsel(hsel), .FXM(FXM)
	);
	
endmodule


