`include "arch_def.v"

module IOU (
	clk, rst_n, addr, wr, BE, din, dout, hw_int,
	LED_dis, rgb, ps2_clk, ps2_data, hsync, vsync
);

    
    input clk;
    input rst_n;
    input [0:`ARCH_WIDTH-1] addr;
    input wr;
	input [0:`DMBE_WIDTH-1] BE;
    input [0:`ARCH_WIDTH-1] din;
    output [0:`ARCH_WIDTH-1] dout;
    output [7:0] LED_dis;
    output [7:0] rgb;
	output hsync;
	output vsync;
	output hw_int;
	output [7:0] rgb;
	input ps2_clk;
	input ps2_data;
	
	
	reg [0:`ARCH_WIDTH-1] dout;
    
    ///////////////////////////////////////////////////
    /*                 Timer/Counter 0               */          
    wire we_TC0;
    wire [0:`ARCH_WIDTH-1] TC0_data;
    wire TC0_out;
	wire TC0_int;
	
    assign we_TC0 = wr && (addr`IO_SEL_RANGE == `TC0_HIGH_ADDR);
    
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
	
    assign we_LED = wr && (addr`IO_SEL_RANGE == `LED_HIGH_ADDR);
    assign LED_dis = LED_data[`ARCH_WIDTH-8:`ARCH_WIDTH-1];
               
    LED LED (
		.clk(clk),
		.rst_n(rst_n),
        .we(we_LED),
		.wd(din),
        .LED_data(LED_data)
	);
	
	
	///////////////////////////////////////////////////			
	/*                Graphic Card                   */
	wire [0:`ARCH_WIDTH-1] GC_data;
	wire we_GC;
	wire [2:0] vga_r;
	wire [2:0] vga_g;
	wire [1:0] vga_b;
	
	assign we_GC = wr && (addr`IO_SEL_RANGE == `VGA_HIGH_ADDR || addr`IO_SEL_RANGE == `GCM_HIGH_ADDR);
	 
	GC_top GC (
		.clk(clk),				// need 50MHz
		.rst_n(rst_n),
		.BE(BE),	
		.GC_we(we_GC),
		.GC_addr_cpu(addr[`ARCH_WIDTH/2:`ARCH_WIDTH-1]),
		.GC_wd(din),
		.GC_rd(GC_data),
		.hsync(hsync),
		.vsync(vsync),
		.vga_r(vga_r),
		.vga_g(vga_g),
		.vga_b(vga_b)
	);
	
	assign rgb = {vga_r, vga_g, vga_b};
	
	///////////////////////////////////////////////////					
	/*               USB KeyBoard					     */
	wire [0:`ARCH_WIDTH-1] KeyBoard_data;
	wire we_KeyBoard;
	wire KeyBoard_int;
	 
	assign we_KeyBoard = wr && (addr`IO_SEL_RANGE == `KBD_HIGH_ADDR);
	 
	ps2_top KBD (
		.clk(clk),
		.rst_n(rst_n),
		.we(we_KeyBoard),
		.addr(addr[`ARCH_WIDTH-4:`ARCH_WIDTH-1]), 
		.wd(din),
		.rd(KeyBoard_data),
		.ps2_clk(ps2_clk),
		.ps2_data(ps2_data),
		.intr(KeyBoard_int)
	);
    
    always @( * ) begin
		case ( addr`IO_SEL_RANGE )
		
			`TC0_BASE_ADDR: begin
				dout = TC0_data;
			end
			
			`LED_BASE_ADDR: begin
				dout = LED_data;
			end
			
			`VGA_BASE_ADDR: begin
				dout = GC_data;
			end
			
			`GCM_BASE_ADDR: begin
				dout = GC_data;
			end
			
			`KBD_HIGH_ADDR: begin
				dout = KeyBoard_data;
			end
			
			default: begin
				dout = `CONST_NEG1;
			end
		
		endcase
	end // end always
    
    assign hw_int = TC0_int | KeyBoard_int;
    
endmodule    
