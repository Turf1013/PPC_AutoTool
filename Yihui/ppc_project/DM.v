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
`include "ctrl_encode_def.v"
`include "global_def.v"

module DM (
	clk, BE, wr, addr, din, dout
);
   
	input         		     clk;
	input  [0:`DMBE_WIDTH-1] BE;
	input         		     wr;
	input  [`ARCH_WIDTH-1:0] addr;
	// input  [0:`DM_WIDTH-1]   din;
	input  [`DM_WIDTH-1:0]   din;
	output [0:`DM_WIDTH-1]   dout;
     
`ifdef USE_RAMIP	

	wire [3:0] wea;
	
	assign wea = {4{wr}} & BE;
	//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
	dram dram (
	  .clka(clk), // input clka
	  .wea(wea), // input [3 : 0] wea
	  .addra(addr[11:2]), // input [9 : 0] addra
	  .dina(din), // input [31 : 0] dina
	  .douta(dout) // output [31 : 0] douta
	);
	// INST_TAG_END ------ End INSTANTIATION Template ---------	
	
`else

	reg [`DM_WIDTH-1:0] dmem[`DM_SIZE-1:0];
	
	wire [`ARCH_WIDTH-1:0] addr_;
	wire [`DM_DEPTH-1:0] haddr;
   
	assign addr_ = addr - `DM_BASE_ADDR;
	assign haddr = addr_[`DM_DEPTH+1:2];
	
	integer i;
	initial begin
		for (i=0; i<`DM_SIZE; i=i+1)
			dmem[i] = 0;
	end
   
	always @( posedge clk ) begin
		if ( wr ) begin
			// if (BE[0]) dmem[haddr][31:24] <= din[24:31];
			// if (BE[1]) dmem[haddr][23:16] <= din[16:23];
			// if (BE[2]) dmem[haddr][15:8 ] <= din[ 8:15];
			// if (BE[3]) dmem[haddr][ 7:0 ] <= din[ 0:7 ];
			if (BE[0]) dmem[haddr][31:24] <= din[31:24];
			if (BE[1]) dmem[haddr][23:16] <= din[23:16];
			if (BE[2]) dmem[haddr][15:8 ] <= din[15:8 ];
			if (BE[3]) dmem[haddr][ 7:0 ] <= din[ 7:0 ];
		end
	end // end always
  
	wire [`DM_WIDTH-1:0] tmp;
  
	assign tmp = dmem[haddr];
	// assign dout = {tmp[7:0], tmp[15:8], tmp[23:16], tmp[31:24]};
    assign dout = tmp;
	
`endif	
	
endmodule

module DMIn_BE (
	addr, Op, BE, din, dout
);

	input  [0:`ARCH_WIDTH-1] 		addr;
	input  [0:`DMIn_BEOp_WIDTH-1]	Op;
	input  [0:`DM_WIDTH-1] 			din;
	output [0:`DM_WIDTH-1] 			dout;
	output [0:`DMBE_WIDTH-1]		BE;
	
	reg [0:`DMBE_WIDTH-1] BE;
	reg [0:`DM_WIDTH-1] dout;
	wire [0:1] laddr;
	
	assign laddr = addr[`ARCH_WIDTH-2:`ARCH_WIDTH-1];
	
	always @( * ) begin
		case ( Op ) 
		
			`DMIn_BEOp_SW: begin
				dout = din;
			end
			
			`DMIn_BEOp_SH: begin
				dout = {2{din[16:31]}};
			end
			
			`DMIn_BEOp_SB: begin
				dout = {4{din[24:31]}};
			end
			
			`DMIn_BEOp_SHBR: begin
				dout = {2{din[24:31], din[16:23]}};
			end
			
			`DMIn_BEOp_SWBR: begin
				dout = {din[24:31], din[16:23], din[8:15], din[0:7]};
			end
			
			default: begin
				dout = din;
			end
			
		endcase
	end // end always
	
	// logic of BE
	always @(*) begin
		if (Op == `DMIn_BEOp_SW || Op == `DMIn_BEOp_SWBR) begin
			BE = 4'b1111;
		end
		else if (Op == `DMIn_BEOp_SH || Op == `DMIn_BEOp_SHBR) begin
			if (laddr[0])
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
		else begin
			BE = 4'b0000;
		end
	end // end always

endmodule

module DMOut_ME (
	addr, Op, din, dout
);
	
	input	[0:`ARCH_WIDTH-1]		addr;
	input  	[0:`DMOut_MEOp_WIDTH-1] Op;
	input  	[0:`DM_WIDTH-1] 		din;
	output 	[0:`DM_WIDTH-1] 		dout;
	
	reg [0:`DM_WIDTH-1] dout;
	wire [0:1] laddr;
	
	assign laddr = addr[`ARCH_WIDTH-2:`ARCH_WIDTH-1];
	
	always @(*) begin
		case ( Op )
		
			`DMOut_MEOp_LW: begin
				dout = din;
			end
			
			`DMOut_MEOp_LWBR: begin
				dout = {din[24:31], din[16:23], din[8:15], din[0:7]};
			end
			
			`DMOut_MEOp_LH: begin
				if (laddr[0])
					dout = {16'd0, din[0:15]};
				else
					dout = {16'd0, din[16:31]};
			end
			
			`DMOut_MEOp_LHA: begin
				if (laddr[0])
					dout = {{16{din[0 ]}}, din[0:15]};
				else
					dout = {{16{din[16]}}, din[16:31]};
			end
			
			`DMOut_MEOp_LHBR: begin
				if (laddr[0])
					dout = {16'd0, din[24:31], din[16:23]};
				else
					dout = {16'd0, din[8:15], din[0:7]};
			end
			
			`DMOut_MEOp_LB: begin
				case (laddr)
					2'd3: dout = {24'd0, din[ 0:7 ]};
					2'd2: dout = {24'd0, din[ 8:15]};
					2'd1: dout = {24'd0, din[16:23]};
					2'd0: dout = {24'd0, din[24:31]};
				endcase
			end
			
			default: begin
				dout = din;
			end
			
		endcase
	end // end always
	
endmodule


