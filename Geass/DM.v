`include "arch_def.v"
`include "ctrl_encode_def.v"

module DM (
	clk, DMBE, DMWr, addr, din, dout
);
   
	input         		     clk;
	input  [`DMBE_WIDTH-1:0] DMBE;
	input         		     DMWr;
	input  [`DM_DEPTH-1:0]   addr;
	input  [`DM_WIDTH-1:0]   din;
	output [`DM_WIDTH-1:0]   dout;
     
	reg [`DM_WIDTH-1:0] DM[`DM_SIZE-1:0];
   
	always @(posedge clk) begin
		if (DMWr) begin
			if (DMBE[3]) DM[addr][31:24] <= din[31:24];
			if (DMBE[2]) DM[addr][23:16] <= din[23:16];
			if (DMBE[1]) DM[addr][15:8 ] <= din[15:8 ];
			if (DMBE[0]) DM[addr][ 7:0 ] <= din[ 7:0 ];
		end
	end // end always
   
	assign dout = DM[addr];
    
endmodule

module DMIn_BE (
	laddr, DMIn_BEOp, DMBE, din, dout
);

	input  [1:0] 				laddr;
	input  [`DMIn_BEOp_WIDTH-1:0] DMIn_BEOp;
	input  [`DM_WIDTH-1:0] 		din;
	output [`DM_WIDTH-1:0] 		dout;
	output [`DMBE_WIDTH-1:0]	DMBE;
	
	reg [`DMBE_WIDTH-1:0] DMBE;
	reg [`DM_WIDTH-1:0] dout;
	
	always @(*) begin
		if (DMIn_BEOp == `DMIn_BEOp_SW)
			dout = din;
		else if (DMIn_BEOp == `DMIn_BEOp_SH)
			dout = {2{din[15:0 ]}};
		else if (DMIn_BEOp == `DMIn_BEOp_SB)	
			dout = {4{din[ 7:0 ]}};
		else
			dout = din;
	end // end always
	
	// logic of dout
	always @(*) begin
		if (DMIn_BEOp == `DMIn_BEOp_SW)
			DMBE = 4'b1111;
		else if (DMIn_BEOp == `DMIn_BEOp_SH) begin
			if (laddr[0])
				DMBE = 4'b0011;
			else
				DMBE = 4'b1100;
		end
		else if (DMIn_BEOp == `DMIn_BEOp_SB) begin
			case (laddr)
				2'd0: DMBE = 4'b0001;
				2'd1: DMBE = 4'b0010;
				2'd2: DMBE = 4'b0100;
				2'd3: DMBE = 4'b1000;
				default: ;
			endcase
		end
		else
			DMBE = 4'b0000;
	end // end always

endmodule

module DMOut_ME (
	laddr, DMOut_MEOp, din, dout
);

	input  [1:0] 		   laddr;
	input  [`DMOut_MEOp_WIDTH-1:0] DMOut_MEOp;
	input  [`DM_WIDTH-1:0] din;
	output [`DM_WIDTH-1:0] dout;
	
	
	reg [`DM_WIDTH-1:0] dout;
	
	always @(*) begin
		case (DMOut_MEOp)
			`DMOut_MEOp_LW: dout = din;
			`DMOut_MEOp_LHU: begin
				if (laddr[0])
					dout = {{16{1'b0}}, din[31:16]};
				else
					dout = {{16{1'b0}}, din[15:0]};
			end
			`DMOut_MEOp_LH: begin
				if (laddr[0])
					dout = {{16{din[31]}}, din[31:16]};
				else
					dout = {{16{din[15] }}, din[15:0]};
			end
			`DMOut_MEOp_LBU: begin
				case (laddr)
					2'd0: dout = {{16{1'b0}}, din[ 7:0 ]};
					2'd1: dout = {{16{1'b0}}, din[15:8 ]};
					2'd2: dout = {{16{1'b0}}, din[23:16]};
					2'd3: dout = {{16{1'b0}}, din[31:24]};
				endcase
			end
			`DMOut_MEOp_LB: begin
				case (laddr)
					2'd0: dout = {{16{din[7 ]}}, din[ 7:0 ]};
					2'd1: dout = {{16{din[15]}}, din[15:8 ]};
					2'd2: dout = {{16{din[23]}}, din[23:16]};
					2'd3: dout = {{16{din[31]}}, din[31:24]};
				endcase
			end
			default: dout = din;
		endcase
	end // end always
	
endmodule


