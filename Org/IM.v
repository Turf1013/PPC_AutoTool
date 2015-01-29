/*
 * Description: This module is all about definition of IM.
 *		1. IM: Instruction Memory;
 *		2. IMIn_ME: Extend of IM_din.
 *		3. IMOut_ME: Extend of IM_dout.
 * Author: ZengYX
 * Date:   2014.8.3
 */
`include "arch_def.v"

module IM (
	addr, dout
);
    
    input  [0:`IM_DEPTH-1] addr;
    output [0:`IM_WIDTH-1] dout;
    
    reg [`IM_WIDTH-1:0] IM[`IM_SIZE-1:0];
    
	wire [0:`IM_WIDTH-1] rdout;
	
    assign rdout = IM[addr[0:`IM_DEPTH-3]];
	
	IMOut_ME U_IMOut_ME (
		.din(rdout), .dout(dout)
	);
    
endmodule

module IMOut_ME (
	din, dout
);

	input  [0:`DM_WIDTH-1] din;
	output [0:`DM_WIDTH-1] dout;
	
	reg [0:`DM_WIDTH-1] dout;
	
	always @(*) begin
		`ifdef ARCH_GE
			dout = {din[24:31], din[16:23], din[8:15], din[0:7]};
		`else
			dout = din;
		`endif
	end // end always
	
endmodule

module IMIn_ME (
	din, dout
);

	input  [0:`DM_WIDTH-1] din;
	output [0:`DM_WIDTH-1] dout;
	
	reg [0:`DM_WIDTH-1] dout;
	
	always @(*) begin
		`ifdef ARCH_GE
			dout = {din[24:31], din[16:23], din[8:15], din[0:7]};
		`else
			dout = din;
		`endif
	end // end always

endmodule
