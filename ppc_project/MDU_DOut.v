`include "SPR_def.v"
`include "ctrl_encode_def.v"
`include "arch_def.v"

module MDU_DOut (
	OE, D, Op, XERrd, CRrd, XERwd, CRwd
);
	
	input							OE;
	input 	[0:`ALU_D_WIDTH-1]		D;
	input	[0:`ALU_DOutOp_WIDTH-1]	Op;
	input 	[0:`XER_WIDTH-1] 		XERrd;
	input 	[0:`CR_WIDTH-1] 		CRrd;
	output	[0:`XER_WIDTH-1] 		XERwd;
	output	[0:`CR_WIDTH-1] 		CRwd;
	
	
	wire OV, SO;
	wire [0:2] CR0_3;
	wire [0:`CR0_WIDTH-1] CR0;
	
	assign {OV, CR0_3} = D;
	assign SO = OV | XERrd`XER_SO_RANGE;
	
	// logic of XER
	reg SO_r, OV_r;
	
	always @( * ) begin
		case ( Op )
			
			`MDU_DOutOp_OV: begin
				if ( OE ) begin
					OV_r = OV;
					SO_r = SO;
				end
				else begin
					OV_r = XERrd`XER_OV_RANGE;
					SO_r = XERrd`XER_SO_RANGE;
				end
			end
			
			`MDU_DOutOp_NOP: begin
				OV_r = XERrd`XER_OV_RANGE;
				SO_r = XERrd`XER_SO_RANGE;
			end
			
			default: begin
				OV_r = XERrd`XER_OV_RANGE;
				SO_r = XERrd`XER_SO_RANGE;
			end
			
		endcase
		
	end // end always
	
	assign XERwd = {XERrd`XER_CA_RANGE, OV_r, SO_r, XERrd[`XER_SO+1:`SPR_WIDTH-1]};
	assign CRwd = {CR0, CRrd[`CR0_WIDTH:`CR_WIDTH-1]};
	assign CR0 = {CR0_3, SO_r};

endmodule

