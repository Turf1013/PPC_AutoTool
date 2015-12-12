`include "arch_def.v"

module IOU (
	clk, rst_n, addr, wr, BE, din, dout, LED_dis, hw_int
);

    
    input clk;
    input rst_n;
    input [0:`ARCH_WIDTH-1] addr;
    input wr;
	input [0:`DMBE_WIDTH-1] BE;
    input [0:`ARCH_WIDTH-1] din;
    output [0:`ARCH_WIDTH-1] dout;
    output [7:0] LED_dis;
	output hw_int;
    
	reg [0:`ARCH_WIDTH-1] dout;
    
    ///////////////////////////////////////////////////
    /*                 Timer/Counter 0               */          
    wire we_TC0;
    wire [0:`ARCH_WIDTH-1] TC0_data;
    wire TC0_out;
	wire TC0_int;
	wire [0:`ARCH_WIDTH-1] TC0_BASE_ADDR; 
	
	assign TC0_BASE_ADDR = `TC0_BASE_ADDR;
    assign we_TC0 = wr && (addr`IO_SEL_RANGE == TC0_BASE_ADDR`IO_SEL_RANGE);
    
    TC8253 TC0 (
		.clk(clk),
		.rst_n(rst_n),
        .addr(addr[`ARCH_WIDTH-4:`ARCH_WIDTH-3]),
		.we(we_TC0),
		.wd(din),
        .TC8253_data(TC0_data),
        .TC8253_out(TC0_out)
	);
	 
	assign TC0_int = TC0_out;	
	 
               
    ///////////////////////////////////////////////////
    /*                      LED                      */
    wire [0:`ARCH_WIDTH-1] LED_data;
    wire we_LED;
    wire [0:`ARCH_WIDTH-1] LED_BASE_ADDR; 
	
	assign LED_BASE_ADDR = `LED_BASE_ADDR;
    assign we_LED = wr && (addr`IO_SEL_RANGE == LED_BASE_ADDR`IO_SEL_RANGE);
    assign LED_dis = LED_data[`ARCH_WIDTH-8:`ARCH_WIDTH-1];
               
    LED LED (
		.clk(clk),
		.rst_n(rst_n),
        .we(we_LED),
		.wd(din),
        .LED_data(LED_data)
	);
	
    
    always @( * ) begin
		case ( addr`IO_SEL_RANGE )
		
			TC0_BASE_ADDR`IO_SEL_RANGE: begin
				dout = TC0_data;
			end
			
			LED_BASE_ADDR`IO_SEL_RANGE: begin
				dout = LED_data;
			end
			
			default: begin
				dout = `CONST_NEG1;
			end
		
		endcase
	end // end always
    
    assign hw_int = TC0_int;
    
endmodule    
