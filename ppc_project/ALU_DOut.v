`include "SPR_def.v"
`include "ctrl_encode_def.v"
`include "arch_def.v"

module ALU_DOut (
	OE, BF, D, Op, XERrd, CRrd, XERwd, CRwd
);
	
	input							OE;
	input	[0:2]					BF;
	input 	[0:`ALU_D_WIDTH-1]		D;
	input	[0:`ALU_DOutOp_WIDTH-1]	Op;
	input 	[0:`XER_WIDTH-1] 		XERrd;
	input 	[0:`CR_WIDTH-1] 		CRrd;
	output	[0:`XER_WIDTH-1] 		XERwd;
	output	[0:`CR_WIDTH-1] 		CRwd;
	
	
	wire CA, OV, SO;
	wire [0:2] CR0_3, CRX_3;
	wire [0:`CR0_WIDTH-1] CR0, CRX;
	
	assign {CA, OV, CR0_3, CRX_3} = D;
	assign SO = OV | XERrd`XER_SO_RANGE;
	
	// logic of XER
	reg CA_r, SO_r, OV_r;
	
	always @( * ) begin
		case ( Op )
			`ALU_DOutOp_CA: begin
				CA_r = CA;
				OV_r = XERrd`XER_OV_RANGE;
				SO_r = XERrd`XER_SO_RANGE;
			end
			
			`ALU_DOutOp_OV: begin
				CA_r = XERrd`XER_CA_RANGE;
				if ( OE ) begin
					OV_r = OV;
					SO_r = SO;
				end
				else begin
					OV_r = XERrd`XER_OV_RANGE;
					SO_r = XERrd`XER_SO_RANGE;
				end
			end
			
			`ALU_DOutOp_NOP: begin
				CA_r = XERrd`XER_CA_RANGE;
				OV_r = XERrd`XER_OV_RANGE;
				SO_r = XERrd`XER_SO_RANGE;
			end
			
			`ALU_DOutOp_CAOV: begin
				CA_r = CA;
				if ( OE ) begin
					OV_r = OV;
					SO_r = SO;
				end
				else begin
					OV_r = XERrd`XER_OV_RANGE;
					SO_r = XERrd`XER_SO_RANGE;
				end
			end
			
			default: begin
				CA_r = XERrd`XER_CA_RANGE;
				OV_r = XERrd`XER_OV_RANGE;
				SO_r = XERrd`XER_SO_RANGE;
			end
			
		endcase
		
	end // end always
	
	assign XERwd = {CA_r, OV_r, SO_r, XERrd[`XER_SO+1:`SPR_WIDTH-1]};

	wire [0:`CR_WIDTH-1] mask;
	reg [0:`CR_WIDTH-1] CRwd_r;
	
	always @( * ) begin
		if (Op == `ALU_DOutOp_CMP) begin
			CRwd_r = (CRrd & ~mask) | ({28'd0, CRX} << {BF, 2'b0});
		end
		else begin
			CRwd_r = {CR0, CRrd[`CR0_WIDTH:`CR_WIDTH-1]};
		end
	end // end always
	
	assign CRwd = CRwd_r;
	assign CR0 = {CR0_3, SO_r};
	assign CRX = {CRX_3, SO_r};
	assign mask = 32'hf << {BF, 2'b0};

endmodule
