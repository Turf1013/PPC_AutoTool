/*
 * Description: This module is all about definition of ALU.
 *		1. ROTL32: Rotate Left 32-bit.
 *		2. MASK:   Generate proper Mask for rotate/shift instructions.	
 * Author: ZengYX
 * Date:   2014.8.1
 */

`include "arch_def.v"
`include "ctrl_encode_def.v"
`include "SPR_def.v"

module MASK (
	MB, ME, mask
);

	input  [0:`ROTL_WIDTH-1] MB;
	input  [0:`ROTL_WIDTH-1] ME;
	output [0:`ARCH_WIDTH-1] mask;
	
	wire [0:`ROTL_WIDTH-1] from;
	wire [0:`ROTL_WIDTH-1] to;
	wire [0:`ARCH_WIDTH-1] mtmp;
	
	// make sure from <= to always.
	assign {from, to} = (MB > ME) ? {ME, MB}:{MB, ME};
	
	// use shift to get correct mask In the conditon of From & To
	assign mtmp = (32'hffff_ffff << from) & (32'hffff_ffff >> (31-to));
	
	// Get correct mask In the condition of MB & ME;
	assign mask = (MB > ME) ? ~mtmp : mtmp;
	
endmodule

module ROTL32 (
	rotn, din, dout
);

	input  [0:`ROTL_WIDTH-1] rotn;
	input  [0:`ARCH_WIDTH-1] din;
	output [0:`ARCH_WIDTH-1] dout;
	
	wire [0:`ARCH_WIDTH-1] useless;
	
	assign {dout, useless} = {din, din} << rotn;

endmodule

module ALU (
	A, B, Op, C, D, 
	rotn, MB, ME,
	XERrd, CRrd
);
	
	input 	[0:`ARCH_WIDTH-1]  	A, B;
	input	[0:`ALUOp_WIDTH-1] 	Op;
	input	[0:`ROTL_WIDTH-1]	rotn, MB, ME;
	input	[0:`XER_WIDTH-1]	XERrd;
	input 	[0:`CR_WIDTH-1]		CRrd;
	output	[0:`ARCH_WIDTH-1] 	C;
	output	[0:`ALU_D_WIDTH-1]	D;
	
	reg  signed [0:`ARCH_WIDTH-1] C;
	wire signed [0:`ARCH_WIDTH-1] srcA, srcB;
	wire signed [0:`ARCH_WIDTH] srcA_, srcB_;
	wire [0:`CR0_WIDTH-1] CR0;
	wire XER_CA, XER_SO;
	
	assign srcA = A;
	assign srcB = B;
	assign srcA_ = {srcA[0], srcA};
	assign srcB_ = {srcB[0], srcB};
	assign XER_CA = XERrd`XER_CA_RANGE;
	assign XER_SO = XERrd`XER_SO_RANGE;
	
	// Mask
	wire [0:`ARCH_WIDTH-1] mask;
	
	MASK U_MASK (
		.MB(MB), .ME(ME), .mask(mask)
	);
	
	// ROTL32 (same as sra)
	wire [0:`ROTL_WIDTH-1] shiftn;
	wire [0:`ARCH_WIDTH-1] rotv;
	
	assign shiftn = rotn;//B[`ARCH_WIDTH-5:`ARCH_WIDTH-1];
	
	ROTL32 U_ROTL32(
		.rotn(rotn), .din(srcA), .dout(rotv)
	);
	
	// ALU
	reg	CA_r, OV_r;
	
	reg [0:`ARCH_WIDTH] tmp;
	reg [0:`ARCH_WIDTH-1] shift_tmp;
	
	always @(*) begin
		case ( Op )
			`ALUOp_MOVA: begin
				C = srcA;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_MOVB: begin
				C = srcB;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_AND: begin
				C = srcA & srcB;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_ANDC: begin
				C = srcA & ~srcB;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_EXTSB: begin
				C = {{24{srcA[24]}}, srcA[24:31]};
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_EXTSH: begin
				C = {{16{srcA[16]}}, srcA[16:31]};
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_ADDU: begin
				C = srcA + srcB;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_NAND: begin
				C = ~(srcA & srcB);
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_NEG: begin
				C = ~srcA + 32'd1;
				CA_r = 0;
				if (srcA == 32'h8000_0000) begin
					OV_r = 1;
				end
				else begin
					OV_r = 0;
				end
			end
			`ALUOp_OR: begin
				C = srcA | srcB;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_ORC: begin
				C = srcA | ~srcB;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_SLL: begin
				if (srcB[`ARCH_WIDTH-6] == 0)
					C = srcA >> shiftn;
				else
					C = 32'h0;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_SRA: begin
				if (srcB[`ARCH_WIDTH-6] == 0) begin
					if ( srcA[0] )
						{shift_tmp, C} = {32'hffff_ffff, srcA} >> shiftn;
					else
						C = srcA>>shiftn;
				end
				else
					C = 32'h0;
				CA_r = srcA[0] && (srcB[`ARCH_WIDTH-6:`ARCH_WIDTH-1] != 0);
				OV_r = 0;
			end
			`ALUOp_SRL: begin
				if (srcB[`ARCH_WIDTH-6] == 0)
					C = srcA << shiftn;
				else
					C = 32'h0;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_XOR: begin
				C = srcA ^ srcB;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_NOR: begin
				C = ~(srcA | srcB);
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_ADD: begin
				tmp = srcA_ + srcB_;
				C = tmp[1:`ARCH_WIDTH];
				CA_r = tmp[1];
				OV_r = tmp[0] ^ tmp[1];
			end
			`ALUOp_ADDE: begin
				tmp = srcA_ + srcB_ + XER_CA;
				C = tmp[1:`ARCH_WIDTH];
				CA_r = tmp[1];
				OV_r = tmp[0] ^ tmp[1];
			end
			`ALUOp_SUBF: begin
				tmp = ~srcA_ + srcB_ + 1;
				C = tmp[1:`ARCH_WIDTH];
				CA_r = tmp[1];
				OV_r = tmp[0] ^ tmp[1];
			end
			`ALUOp_SUBFE: begin
				tmp = ~srcA_ + srcB_ + XER_CA;
				C = tmp[1:`ARCH_WIDTH];
				CA_r = tmp[1];
				OV_r = tmp[0] ^ tmp[1];
			end
			`ALUOp_RLNM: begin
				C = rotv & mask;
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_RLIM: begin
				C = (rotv & mask) | (srcB & ~mask);
				CA_r = 0;
				OV_r = 0;
			end
			`ALUOp_CNTZ: begin
				casex ( srcA )
					`CNTZ_00: C = 32'd0;
					`CNTZ_01: C = 32'd1;
					`CNTZ_02: C = 32'd2;
					`CNTZ_03: C = 32'd3;
					`CNTZ_04: C = 32'd4;
					`CNTZ_05: C = 32'd5;
					`CNTZ_06: C = 32'd6;
					`CNTZ_07: C = 32'd7;
					`CNTZ_08: C = 32'd8;
					`CNTZ_09: C = 32'd9;
					`CNTZ_10: C = 32'd10;
					`CNTZ_11: C = 32'd11;
					`CNTZ_12: C = 32'd12;
					`CNTZ_13: C = 32'd13;
					`CNTZ_14: C = 32'd14;
					`CNTZ_15: C = 32'd15;
					`CNTZ_16: C = 32'd16;
					`CNTZ_17: C = 32'd17;
					`CNTZ_18: C = 32'd18;
					`CNTZ_19: C = 32'd19;
					`CNTZ_20: C = 32'd20;
					`CNTZ_21: C = 32'd21;
					`CNTZ_22: C = 32'd22;
					`CNTZ_23: C = 32'd23;
					`CNTZ_24: C = 32'd24;
					`CNTZ_25: C = 32'd25;
					`CNTZ_26: C = 32'd26;
					`CNTZ_27: C = 32'd27;
					`CNTZ_28: C = 32'd28;
					`CNTZ_29: C = 32'd29;
					`CNTZ_30: C = 32'd30;
					`CNTZ_31: C = 32'd31;
					`CNTZ_32: C = 32'd32;
					default: C = 32'd0;
                endcase
				CA_r = 0;
				OV_r = 0;
			end
			default: begin
				C = 32'hffff_ffff;
				CA_r = 0;
				OV_r = 0;
			end
		endcase	   
	end // end always
	
	wire CA, OV;
	wire [0:2] CR0_3;
	
	assign CA = CA_r;
	assign OV = OV_r;
	
	// logic of CR0
	wire LT0, GT0, EQ0;
	
	assign LT0 = (C <  0) ? 1'b1 : 1'b0;
	assign GT0 = (C >  0) ? 1'b1 : 1'b0;
	assign EQ0 = (C == 0) ? 1'b1 : 1'b0;
	assign CR0_3 = {LT0, GT0, EQ0};
	
	// logic of CRX
	reg [0:2] CRX_3;
	
	always @( * ) begin
		case ( Op )
		
			`ALUOp_CMP: begin
				if (srcA == srcB)
					CRX_3 = 3'b001;
				else if (srcA < srcB)
					CRX_3 = 3'b100;
				else
					CRX_3 = 3'b010;
			end
			
			`ALUOp_CMPL: begin
				if (srcA == srcB)
					CRX_3 = 3'b001;
				else if ({1'b0,srcA} < {1'b0,srcB})
					CRX_3 = 3'b100;
				else
					CRX_3 = 3'b010;
			end
			
			default: begin
				CRX_3 = 3'b000;
			end
			
		endcase
	end // end always
	
	assign D = {CA, OV, CR0_3, CRX_3};
	
endmodule
