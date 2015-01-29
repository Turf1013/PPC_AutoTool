`include "arch_def.v"

module IM (
	addr, dout
);
    
    input [`IM_DEPTH+1:2] addr;
    input [`IM_WIDTH-1:0] dout;
    
    reg [`IM_WIDTH-1:0] imem[`IM_SIZE-1:0];
    
    assign dout = imem[addr];
    
endmodule    
