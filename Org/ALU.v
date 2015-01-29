/*
 * Description: This module is all about definition of ALU.
 *		1. ROTL32: Rotate Left 32-bit.
 *		2. MASK:   Generate proper Mask for rotate/shift instructions.	
 * Author: ZengYX
 * Date:   2014.8.1
 */

`include "arch_def.v"
`include "cu_def.v"

module MASK(
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
	assign mask = (MB > ME) ? ~mtmp:mtmp;
	
endmodule

module ROTL32(
	rotn, din, dout
);

	input  [0:`ROTL_WIDTH-1] rotn;
	input  [0:`ARCH_WIDTH-1] din;
	output [0:`ARCH_WIDTH-1] dout;
	
	wire [0:`ARCH_WIDTH-1] useless;
	
	assign {dout, useless} = {din, din} << rotn;

endmodule

module ALU (
	A, B, ALUOp, C, rotn, MB, ME,
	XER_CA, XER_SO, ALU_CA, ALU_OV, ALU_SO, CR0
);
	
	input signed [0:`ARCH_WIDTH-1]  A, B;
	input signed [0:`ALUOp_WIDTH-1] ALUOp;
	input  [0:`ROTL_WIDTH-1] 		rotn, MB, ME;
	input					 		XER_CA, XER_SO;
	output [0:`ARCH_WIDTH-1] 		C;
	output					  		ALU_CA, ALU_OV, ALU_SO;
	output [0:3]         CR0;
	
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
		.rotn(rotn), .din(A), .dout(rotv)
	);
	
	// ALU
	reg signed [0:`ARCH_WIDTH-1] C_r;
	reg	ALU_CA_r, ALU_OV_r;
	
	wire signed [0:`ARCH_WIDTH] srca;
	wire signed [0:`ARCH_WIDTH] srcb;
	reg [0:`ARCH_WIDTH] tmp;
	reg [0:`ARCH_WIDTH-1] shift_tmp;
	
	always @(*) begin
		case (ALUOp)
			`ALUOp_NOP: begin
				C_r = A;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_AND: begin
				C_r = A & B;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_ANDC: begin
				C_r = A & ~B;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_CMP: begin
				if (A <  B)	C_r = 32'h4;
				if (A >  B)	C_r = 32'h2;
				if (A == B)	C_r = 32'h1;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_CMPU: begin
				if ({1'b0, A} <  {1'b0, B})	C_r = 32'h4;
				if ({1'b0, A} >  {1'b0, B})	C_r = 32'h2;
				if (A == B)	C_r = 32'h1;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_EXTSB: begin
				C_r = {24'h0, A[`ARCH_WIDTH-8:`ARCH_WIDTH-1]};
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_EXTSH: begin
				C_r = {16'h0, A[`ARCH_WIDTH-16:`ARCH_WIDTH-1]};
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_ADDU: begin
				C_r = A + B;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_NAND: begin
				C_r = ~(A & B);
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_OR: begin
				C_r = A | B;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_ORC: begin
				C_r = A | ~B;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_SLL: begin
				if (B[`ARCH_WIDTH-6] == 0)
					C_r = A>>shiftn;
				else
					C_r = 32'h0;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_SRA: begin
				if (B[`ARCH_WIDTH-6] == 0) begin
					if ( A[0] )
						{shift_tmp, C_r} = {32'hffff_ffff, A}>>shiftn;
					else
						C_r = A>>shiftn;
				end
				else
					C_r = 32'h0;
				ALU_CA_r = A[0] && (B[`ARCH_WIDTH-6:`ARCH_WIDTH-1] != 0);
				ALU_OV_r = 0;
			end
			`ALUOp_SRL: begin
				if (B[`ARCH_WIDTH-6] == 0)
					C_r = A<<shiftn;
				else
					C_r = 32'h0;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_XOR: begin
				C_r = A ^ B;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_NOR: begin
				C_r = ~(A | B);
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_ADD: begin
				tmp = srca + srcb;
				C_r = tmp[1:`ARCH_WIDTH];
				ALU_CA_r = tmp[1];
				ALU_OV_r = tmp[0] ^ tmp[1];
			end
			`ALUOp_ADDE: begin
				tmp = srca + srcb + XER_CA;
				C_r = tmp[1:`ARCH_WIDTH];
				ALU_CA_r = tmp[1];
				ALU_OV_r = tmp[0] ^ tmp[1];
			end
			`ALUOp_SUBF: begin
				tmp = ~srca + srcb + 1;
				C_r = tmp[1:`ARCH_WIDTH];
				ALU_CA_r = tmp[1];
				ALU_OV_r = tmp[0] ^ tmp[1];
			end
			`ALUOp_SUBFE: begin
				tmp = ~srca + srcb + XER_CA;
				C_r = tmp[1:`ARCH_WIDTH];
				ALU_CA_r = tmp[1];
				ALU_OV_r = tmp[0] ^ tmp[1];
			end
			`ALUOp_RLNM: begin
				C_r = rotv & mask;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_RLIM: begin
				C_r = (rotv & mask) | (B & ~mask);
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			`ALUOp_CNTZ: begin
				casex ( A )
					`CNTZ_00: C_r = 32'd0;
					`CNTZ_01: C_r = 32'd1;
					`CNTZ_02: C_r = 32'd2;
					`CNTZ_03: C_r = 32'd3;
					`CNTZ_04: C_r = 32'd4;
					`CNTZ_05: C_r = 32'd5;
					`CNTZ_06: C_r = 32'd6;
					`CNTZ_07: C_r = 32'd7;
					`CNTZ_08: C_r = 32'd8;
					`CNTZ_09: C_r = 32'd9;
					`CNTZ_10: C_r = 32'd10;
					`CNTZ_11: C_r = 32'd11;
					`CNTZ_12: C_r = 32'd12;
					`CNTZ_13: C_r = 32'd13;
					`CNTZ_14: C_r = 32'd14;
					`CNTZ_15: C_r = 32'd15;
					`CNTZ_16: C_r = 32'd16;
					`CNTZ_17: C_r = 32'd17;
					`CNTZ_18: C_r = 32'd18;
					`CNTZ_19: C_r = 32'd19;
					`CNTZ_20: C_r = 32'd20;
					`CNTZ_21: C_r = 32'd21;
					`CNTZ_22: C_r = 32'd22;
					`CNTZ_23: C_r = 32'd23;
					`CNTZ_24: C_r = 32'd24;
					`CNTZ_25: C_r = 32'd25;
					`CNTZ_26: C_r = 32'd26;
					`CNTZ_27: C_r = 32'd27;
					`CNTZ_28: C_r = 32'd28;
					`CNTZ_29: C_r = 32'd29;
					`CNTZ_30: C_r = 32'd30;
					`CNTZ_31: C_r = 32'd31;
					`CNTZ_32: C_r = 32'd32;
					default: C_r = 32'd0;
                endcase
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
			default: begin
				C_r = 32'hffff_ffff;
				ALU_CA_r = 0;
				ALU_OV_r = 0;
			end
		endcase	   
	end // end always
	
	assign C = C_r;
	assign ALU_CA = ALU_CA_r;
	assign ALU_OV = ALU_OV_r;
	assign ALU_SO = XER_SO | ALU_OV_r;
	// logic of CR0
	wire LT, GT, EQ;
	
	assign LT = (C_r <  0) ? 1'b1:1'b0;
	assign GT = (C_r >  0) ? 1'b1:1'b0;
	assign EQ = (C_r == 0) ? 1'b1:1'b0;
	assign CR0 = {LT, GT, EQ, ALU_SO};
	
endmodule
