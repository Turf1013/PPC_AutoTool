module GC_top (
	clk, rst_n, BE,	GC_we, GC_addr_cpu, GC_wd, GC_rd,
	hsync, vsync, vga_r, vga_g, vga_b
);

	input clk;	// 50MHz
	input rst_n;
	input [3:0] BE;
	input GC_we;
	input [15:0] GC_addr_cpu;
	input [31:0] GC_wd;
	output [31:0] GC_rd;
	output hsync, vsync;
	output [2:0] vga_r;
	output [2:0] vga_g;
	output [1:0] vga_b;
	
	
	// We need to solve the hazard of read and write,
	// I just assume the write operation is more important than reading.
	wire [11:0] GC_mem_addr;
	wire [11:0] GC_mem_addr_in;
	wire GC_mem_we, GC_RF_we;
	wire [31:0] GC_mem_rd, GC_RF_rd;
	wire mem_valid;
	
	assign mem_valid   = (GC_addr_cpu[12]) ? 1'b1 : 1'b0;
	assign GC_mem_addr = (GC_mem_we) ? GC_addr_cpu[11:0] : GC_mem_addr_in;
	assign GC_rd       = (mem_valid) ? GC_mem_rd   : GC_RF_rd;
	assign GC_mem_we   = GC_we && mem_valid;
	assign GC_RF_we    = GC_we && (~mem_valid);

	
	/*
	 * Pay attention to the GC-Memory Data Width is 32bits, but we just need
	 * 16-bits to show on the screen once, then we have to use the addr[1] to MUX.
	 */
	wire [15:0] valid_word_16bit;
	wire [7:0] word_high_8bit, word_low_8bit;
	
	mux2 #(16) valid_word_mux2(.din0(GC_mem_rd[15:0]), .din1(GC_mem_rd[31:16]),
									   .sel(GC_mem_addr[1]), .dout(valid_word_16bit));

	assign { word_high_8bit, word_low_8bit } = valid_word_16bit;
	
	/*
	 *  bg_rgb short for back-ground RGB
	 *  fg_rgb short for forword-ground RGB
	 *  blink & light has not solved yet.
	 *
	 */
	wire [2:0] bg_rgb, fg_rgb;
	wire blink, light;
	wire [7:0] vga_rgb;
	
	assign {vga_r, vga_g, vga_b} = vga_rgb;
	
	wire clk_50M;
	
	assign clk_50M = clk;
	
	// the Graphic Card Memory stores at most 4KB words.
	GC_mem GC_mem(.clk(clk), .BE(BE), .we(GC_mem_we),
					  .addr(GC_mem_addr), .wd(GC_wd),
					  .rd(GC_mem_rd));
				  
	// About the Attr-Decoder, to tell you the truth, I still have no idea about
	// the blink and light, How can it work ???
	GC_AttrDec GC_AttrDec(.high_8bit(word_high_8bit), 
						  .bg_rgb(bg_rgb), .fg_rgb(fg_rgb),
						  .blink(blink), .light(light));

	// The Grpahic Card CRT-control module is such tough with many complicated logic,
	// and you must be cautious and careful enough.
	wire [31:0] cursor_x, cursor_y;
	
   GC_CRTctrl GC_CRTctrl(.clk_50M(clk_50M), .rst_n(rst_n),
			                .low_8bit(word_low_8bit),	
			                .hsync(hsync), .vsync(vsync),
			                .vga_rgb(vga_rgb), 
			                .GC_mem_addr_in(GC_mem_addr_in),
								 .cursor_x(cursor_x), .cursor_y(cursor_y));
	
	// The Register of the Graphic Card
	// we need to differ from write the memory
	wire [11:0] GC_RF_addr;
	
	assign GC_RF_addr = GC_addr_cpu[11:0];
	
	GC_RF	GC_RF(.clk(clk), .rst_n(rst_n),
				   .we(GC_RF_we), .addr(GC_RF_addr),
					.wd(GC_wd), .rd(GC_RF_rd),
					.cursor_x(cursor_x), .cursor_y(cursor_y));

endmodule