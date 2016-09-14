`include "arch_def.v"

module IM (
	clk, addr, dout
);
    
	input clk;
    input [`PC_WIDTH-1:0] addr;
    output [`IM_WIDTH-1:0] dout;
	
    wire [`IM_DEPTH-1:0] im_addr;
	
    reg [`IM_WIDTH-1:0] imem[`IM_SIZE-1:0];
	
    assign im_addr = addr[`IM_DEPTH+1:2];
	
    assign dout = imem[im_addr];
    
endmodule    
