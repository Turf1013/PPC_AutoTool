`include "arch_def.v"
`include "ctrl_encode_def.v"

module DM (
	clk, BE, wr, addr, din, dout
);
   
	input         		    clk;
	input  [`DMIn_BE_WIDTH-1:0] 	BE;
	input         		    wr;
	input  [31:0]   		addr;
	input  [`DM_WIDTH-1:0]  din;
	output [`DM_WIDTH-1:0]  dout;
     
	reg [`DM_WIDTH-1:0] DM[`DM_SIZE-1:0];
	wire [`DM_DEPTH-1:0]   dm_addr;
	
	assign dm_addr = addr[`DM_DEPTH+1:2];
   
	always @(posedge clk) begin
		if (wr) begin
			if (BE[3]) DM[dm_addr][31:24] <= din[31:24];
			if (BE[2]) DM[dm_addr][23:16] <= din[23:16];
			if (BE[1]) DM[dm_addr][15:8 ] <= din[15:8 ];
			if (BE[0]) DM[dm_addr][ 7:0 ] <= din[ 7:0 ];
		end
	end // end always
   
	assign dout = DM[dm_addr];
    
endmodule

module DMIn_BE (
	addr, Op, BE, din, dout
);

	input  [31:0] 			addr;
	input  [`DMIn_BEOp_WIDTH-1:0] 	Op;
	input  [`DM_WIDTH-1:0] 	din;
	output [`DM_WIDTH-1:0] 	dout;
	output [`DMIn_BE_WIDTH-1:0]	BE;
	
	reg [`DMIn_BE_WIDTH-1:0] BE;
	reg [`DM_WIDTH-1:0] dout;
	wire [1:0] laddr;
	
	assign laddr = addr[1:0];
	
	always @( * ) begin
		if (Op == `DMIn_BEOp_SW)
			dout = din;
		else if (Op == `DMIn_BEOp_SH)
			dout = {2{din[15:0 ]}};
		else if (Op == `DMIn_BEOp_SB)	
			dout = {4{din[ 7:0 ]}};
		else
			dout = din;
	end // end always
	
	// logic of dout
	always @( * ) begin
		if (Op == `DMIn_BEOp_SW)
			BE = 4'b1111;
		else if (Op == `DMIn_BEOp_SH) begin
			if (laddr[1])
				BE = 4'b1100;
			else
				BE = 4'b0011;
		end
		else if (Op == `DMIn_BEOp_SB) begin
			case (laddr)
				2'd0: BE = 4'b0001;
				2'd1: BE = 4'b0010;
				2'd2: BE = 4'b0100;
				2'd3: BE = 4'b1000;
				default: ;
			endcase
		end
		else
			BE = 4'b0000;
	end // end always

endmodule

module DMOut_ME (
	addr, Op, din, dout
);

	input  [31:0] 		   addr;
	input  [`DMOut_MEOp_WIDTH-1:0] Op;
	input  [`DM_WIDTH-1:0] din;
	output [`DM_WIDTH-1:0] dout;
	
	
	reg [`DM_WIDTH-1:0] dout;
	wire [1:0] laddr;
	
	assign laddr = addr[1:0];
	
	always @( * ) begin
		case (Op)
			`DMOut_MEOp_LW: dout = din;
			`DMOut_MEOp_LHU: begin
				if (laddr[1])
					dout = {16'd0, din[31:16]};
				else
					dout = {16'd0, din[15:0 ]};
			end
			`DMOut_MEOp_LH: begin
				if (laddr[1])
					dout = {{16{din[31]}}, din[31:16]};
				else
					dout = {{16{din[15]}}, din[15:0 ]};
			end
			`DMOut_MEOp_LBU: begin
				case (laddr)
					2'd0: dout = {24'd0, din[ 7:0 ]};
					2'd1: dout = {24'd0, din[15:8 ]};
					2'd2: dout = {24'd0, din[23:16]};
					2'd3: dout = {24'd0, din[31:24]};
				endcase
			end
			`DMOut_MEOp_LB: begin
				case (laddr)
					2'd0: dout = {{24{din[7 ]}}, din[ 7:0 ]};
					2'd1: dout = {{24{din[15]}}, din[15:8 ]};
					2'd2: dout = {{24{din[23]}}, din[23:16]};
					2'd3: dout = {{24{din[31]}}, din[31:24]};
				endcase
			end
			default: dout = din;
		endcase
	end // end always
	
endmodule


