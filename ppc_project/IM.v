/*
 * Description: This module is all about definition of IM.
 *		1. IM: Instruction Memory;
 * Author: ZengYX
 * Date:   2015.12.7
 */
`include "arch_def.v"

module IM (
	clk, addr, dout
);
    
	input clk;
    input  [`ARCH_WIDTH-1:0] addr;
    output [0:`IM_WIDTH-1] dout;
    
	wire [`ARCH_WIDTH-1:0] addr_;
	wire [`IM_DEPTH-1:0] im_addr;
    reg [`IM_WIDTH-1:0] imem[`IM_SIZE-1:0];
	
	assign addr_ = addr - `IM_BASE_ADDR;
	assign im_addr = addr_[`IM_DEPTH+1:2];
	assign dout = imem[im_addr];
    
endmodule
