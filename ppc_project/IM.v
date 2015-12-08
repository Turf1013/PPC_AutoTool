/*
 * Description: This module is all about definition of IM.
 *		1. IM: Instruction Memory;
 * Author: ZengYX
 * Date:   2015.12.7
 */
`include "arch_def.v"

module IM (
	addr, dout
);
    
    input  [`ARCH_WIDTH-1:0] addr;
    output [0:`IM_WIDTH-1] dout;
    
	wire [`IM_DEPTH-1:0] im_addr;
    reg [`IM_WIDTH-1:0] IM[`IM_SIZE-1:0];
	
	
	assign im_addr = addr[`IM_DEPTH+1:2];
	assign dout = IM[im_addr];
    
endmodule
