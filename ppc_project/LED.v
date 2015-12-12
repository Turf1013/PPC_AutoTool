`include "arch_def.v"

module LED (
	clk, rst_n, we, wd, LED_data
);
    
    input clk;
    input rst_n;
    input we;
    input [31:0] wd;
    output [31:0] LED_data;
    
    reg [31:0] LED_data_r;
    
    always @( posedge clk or negedge rst_n ) begin
       if (!rst_n)
          LED_data_r <= `CONST_NEG1;
       else if (we)
          LED_data_r <= wd;
       else   ;    
    end
    
    assign LED_data = LED_data_r[7:0];
    
endmodule
