`include "ctrl_encode_def.v"
`include "arch_def.v"
`include "SPR_def.v"
module Reserve (
	clk, rst_n,
	RESERVE_LENGTH, RESERVE_ADDR,
	XERrd, CRrd, CRwd,
	DMWr_mask, Op
);

	input clk;
	input rst_n;
	input [3:0] RESERVE_LENGTH;
	input [0:`DM_WIDTH-1] RESERVE_ADDR;
	input [0:`CR_WIDTH-1] CRrd;
	input [0:`SPR_WIDTH-1] XERrd;
	input [0:`ReserveOp_WIDTH-1] Op;
	output [0:`CR_WIDTH-1] CRwd;
	output DMWr_mask;
 	
 	reg DMWr_mask;
	reg RESERVE_r;
	reg [0:3] RESERVE_LENGTH_r;
	reg [0:`DM_WIDTH-1] RESERVE_ADDR_r;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin 
			RESERVE_r <= 0;
			RESERVE_LENGTH_r <= 0;
			RESERVE_ADDR_r <= 0;
		end
		else begin
			case ( Op )
				`ReserveOp_NONE: begin
					RESERVE_r <= RESERVE_r;
					RESERVE_LENGTH_r <= RESERVE_LENGTH_r;
					RESERVE_ADDR_r <= RESERVE_ADDR_r;
				end
				
				`ReserveOp_ST: begin
					RESERVE_r <= 1'b0;
					RESERVE_LENGTH_r <= RESERVE_LENGTH_r;
					RESERVE_ADDR_r <= RESERVE_ADDR_r;
				end
				
				`ReserveOp_LD: begin
					RESERVE_r <= 1'b1;
					RESERVE_LENGTH_r <= RESERVE_LENGTH;
					RESERVE_ADDR_r <= RESERVE_ADDR;
				end
				
				default: begin
					RESERVE_r <= RESERVE_r;
					RESERVE_LENGTH_r <= RESERVE_LENGTH_r;
					RESERVE_ADDR_r <= RESERVE_ADDR_r;
				end
			endcase
		end
	end // end always
		
	wire peform_store, undefined_case;
	
	assign perform_store = RESERVE_r && (RESERVE_LENGTH_r == RESERVE_LENGTH) && (RESERVE_ADDR_r == RESERVE_ADDR);
	assign undefined_case = RESERVE_r && ~perform_store;
	
	wire XER_SO;
	assign XER_SO = XERrd`XER_SO_RANGE;
	
	reg [0:`CR_WIDTH-1] CRwd_r;
	reg [0:3] CR0;
	
	always @( * ) begin
		if (Op == `ReserveOp_ST) begin
			if (undefined_case) begin
				DMWr_mask = 1'b1;
				CR0 = {2'd0, 1'b1, XER_SO};
			end
			else begin
				DMWr_mask = perform_store;
				CR0 = {2'd0, perform_store, XER_SO};
			end
			
		end 
		else begin
			DMWr_mask = 1'b1;
			CR0 = CRrd[0:3];
		end
	end // end always
	
	assign CRwd = {CR0, CRrd[4:`CR_WIDTH-1]};

endmodule

