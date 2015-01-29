/*
 * Description: This module is all about SPR.
 *		1. XER
 *		2. SPR
 * Author: ZengYX
 * Date:   2014.8.2
 */
`include "arch_def.v"

module  XER (
	clk, rst_n, ALU_CA, ALU_SO, ALU_OV,
	CAWr, OVWr, XER
);

	input 					clk;
	input 					rst_n;
	input					ALU_CA, ALU_SO, ALU_OV;
	input					CAWr;
	input					OVWr;	// same as SOWr
	output [0:`XER_WIDTH-1] XER;
	
	/*******************/
	// 0: SO, Summary Overflow
	// 1: OV, Overflow
	// 2: CA, Carry
	// 3~23: Reserved
	// 24~31: SL, String Length.(useless treat as 0)
	
	reg SO, OV, CA;
	wire [0:7] SL;
	
	assign XER = {SO, OV, CA, 21'h0, SL};
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			CA <= 0;
		else if (CAWr)
			CA <= ALU_CA;
	end // end always
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			OV <= 0;
		else if (OVWr)
			OV <= ALU_OV;
	end // end always
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			SO <= 0;
		else if (OVWr)
			SO <= ALU_SO;
	end // end always
	
	assign SL = 0;

endmodule

module SPR (
	clk, rst_n, SPRWr, raddr, waddr, SPRWd, SPR, LR, LRWr, LRWd
);
	input					clk;
	input					rst_n;
	input					SPRWr;
	input					LRWr;
	input  [0:`SPR_WIDTH-1] LRWd;
	input  [0:`SPR_DEPTH-1] raddr;
	input  [0:`SPR_DEPTH-1] waddr;
	input  [0:`SPR_WIDTH-1] SPRWd;
	output [0:`SPR_WIDTH-1] SPR;
	output [0:`SPR_WIDTH-1] LR;
	
	wire [0:`SPR_WIDTH-1] SRR0, SRR1;
	wire [0:`SPR_WIDTH-1] XER, CTR;
	
	// SPR write logic
	wire LR_wr, CTR_wr, SRR0_wr, SRR1_wr, XER_wr;
	
	assign XER_wr  = SPRWr && (waddr == `XER_SPRN);
	assign LR_wr   = (SPRWr && (waddr == `LR_SPRN)) || LRWr;
	assign CTR_wr  = (SPRWr && (waddr == `CTR_SPRN)) ;
	assign SRR0_wr = SPRWr && (waddr == `SRR0_SPRN);
	assign SRR1_wr = SPRWr && (waddr == `SRR1_SPRN);
	
	// SPR read logic
	reg [0:`SPR_WIDTH-1] SPR;
	
	always @(*) begin
		case (raddr)
			`LR_SPRN:   SPR = LR;
			`CTR_SPRN:  SPR = CTR;
			`XER_SPRN:	SPR = XER;
			`SRR0_SPRN: SPR = SRR0;
			`SRR1_SPRN: SPR = SRR1;
			default:	SPR = 0;	// others all zero.
		endcase
	end // end always
	
	// XER
	FFW #(`SPR_WIDTH, 0) U_XER (
		.clk(clk), .rst_n(rst_n), .wr(XER_wr), .d(SPRWd), .q(XER)
	);
	
	// LR
	wire [0:`SPR_WIDTH-1] LR_Wd;
	
	mux2 #(`SPR_WIDTH) U_CTRWd_mux2 (
		.d0(SPRWd), .d1(CTRWd), .s(LRWr), .y(LR_wd)
	);
	
	FFW #(`SPR_WIDTH, 0) U_LR (
		.clk(clk), .rst_n(rst_n), .wr(LR_wr), .d(LR_Wd), .q(LR)
	);
	
	
	// CTR
	FFW #(`SPR_WIDTH, 0) U_CTR (
		.clk(clk), .rst_n(rst_n), .wr(CTR_wr), .d(SPRWd), .q(CTR)
	);
	
	// SRR0
	FFW #(`SPR_WIDTH, 0) U_SRR0 (
		.clk(clk), .rst_n(rst_n), .wr(SRR0_wr), .d(SPRWd), .q(SRR0)
	);
	
	// SRR1
	FFW #(`SPR_WIDTH, 0) U_SRR1 (
		.clk(clk), .rst_n(rst_n), .wr(SRR1_wr), .d(SPRWd), .q(SRR1)
	);
	
endmodule
