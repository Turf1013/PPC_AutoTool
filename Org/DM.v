/*
 * Description: This module is all about definition of DM.
 *		1. DM: Data-Memory
 *		2. DM_BE: byte, half-word, word to be written.
 *		3. DMOut_ME: Extend the data of DM_dout.
 *		4. DMIn_ME: Extend the data of DM_din.
 * Author: ZengYX
 * Date:   2014.8.3
 */
`include "arch_def.v"
`include "cu_def.v"

module DM (
	clk, DMBE, DMWr, addr, din, dout
);
   
	input         		     clk;
	input  [0:`DMBE_WIDTH-1] DMBE;
	input         		     DMWr;
	input  [0:`DM_DEPTH-1]   addr;
	input  [0:`DM_WIDTH-1]   din;
	output [0:`DM_WIDTH-1]   dout;
     
	reg [`DM_WIDTH-1:0] DM[`DM_SIZE-1:0];
   
	wire [0:`DM_DEPTH-3] haddr;
   
	assign haddr = addr[0:`DM_DEPTH-3];
   
	wire [0:`DM_WIDTH-1] rdin;
   
	always @(posedge clk) begin
		if (DMWr) begin
			if (DMBE[0]) DM[haddr][31:24] <= rdin[24:31];
			if (DMBE[1]) DM[haddr][23:16] <= rdin[16:23];
			if (DMBE[2]) DM[haddr][15:8 ] <= rdin[ 8:15];
			if (DMBE[3]) DM[haddr][ 7:0 ] <= rdin[ 0:7 ];
		end
	end // end always
   
	assign dout = DM[haddr];
    
endmodule

module DMIn_BE (
	laddr, DMIn_BEOp, DMBE, din, dout
);

	input  [0:1] 				laddr;
	input  [0:`DMIn_BEOp_WIDTH-1] DMIn_BEOp;
	input  [0:`DM_WIDTH-1] 		din;
	output [0:`DM_WIDTH-1] 		dout;
	output [0:`DMBE_WIDTH-1]	DMBE;
	
	reg [0:`DMBE_WIDTH-1] DMBE;
	reg [0:`DM_WIDTH-1] dout;
	
	// logic of dout
	reg [0:`DM_WIDTH-1] rdin;
	
	always @(*) begin
		`ifdef ARCH_GE
			rdin = {din[24:31], din[16:23], din[8:15], din[0:7]};
		`else
			rdin = din;
		`endif
	end // end always
	
	always @(*) begin
		if (DMIn_BEOp == `DMIn_BEOp_SW)
			dout = rdin;
		else if (DMIn_BEOp == `DMIn_BEOp_SH)
			dout = {2{rdin[0:15]}};
		else if (DMIn_BEOp == `DMIn_BEOp_SB)	
			dout = {3{rdin[0:7 ]}};
		else if (DMIn_BEOp == `DMIn_BEOp_SHBR)	
			dout = {2{rdin[8:15], rdin[0:7]}};
		else if (DMIn_BEOp == `DMIn_BEOp_SWBR)	
			dout = {rdin[24:31], rdin[16:23], rdin[8:15], rdin[0:7]};
	end // end always
	
	// logic of dout
	always @(*) begin
		if (DMIn_BEOp == `DMIn_BEOp_SW)
			DMBE = 4'b1111;
		else if (DMIn_BEOp == `DMIn_BEOp_SH || DMIn_BEOp == `DMIn_BEOp_SHBR) begin
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

	input  [0:1] 		   laddr;
	input  [0:`DMOut_MEOp_WIDTH-1] DMOut_MEOp;
	input  [0:`DM_WIDTH-1] din;
	output [0:`DM_WIDTH-1] dout;
	
	
	reg [0:`DM_WIDTH-1] dout;
	reg [0:`DM_WIDTH-1] rdin;
	
	always @(din) begin
		`ifdef ARCH_GE
			rdin = {din[24:31], din[16:23], din[8:15], din[0:7]};
		`else
			rdin = din;
		`endif	
	end // end always
	
	always @(*) begin
		case (DMOut_MEOp)
			`DMOut_MEOp_LW: dout = rdin;
			`DMOut_MEOp_LWBR: dout = {rdin[24:31], rdin[16:23], rdin[8:15], rdin[0:7]};
			`DMOut_MEOp_LH: begin
				if (laddr[0])
					dout = {{16{1'b0}}, rdin[16:31]};
				else
					dout = {{16{1'b0}}, rdin[0:15]};
			end
			`DMOut_MEOp_LHBR: begin
				if (laddr[0])
					dout = {{16{1'b0}}, rdin[24:31], rdin[16:23]};
				else
					dout = {{16{1'b0}}, rdin[8:15], rdin[0:7]};
			end
			`DMOut_MEOp_LHA: begin
				if (laddr[0])
					dout = {{16{rdin[16]}}, rdin[16:31]};
				else
					dout = {{16{rdin[0] }}, rdin[0:15]};
			end
			`DMOut_MEOp_LB: begin
				case (laddr)
					2'd0: dout = {{16{1'b0}}, rdin[ 0:7 ]};
					2'd1: dout = {{16{1'b0}}, rdin[ 8:15]};
					2'd2: dout = {{16{1'b0}}, rdin[16:23]};
					2'd3: dout = {{16{1'b0}}, rdin[24:31]};
				endcase
			end
			default: ;
		endcase
	end // end always
	
endmodule


