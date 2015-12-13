module GC_CRTctrl (
	clk_50M, rst_n, low_8bit, cursor_x, cursor_y, hsync, vsync, vga_rgb, GC_mem_addr_in
);
	
	input clk_50M;
	input rst_n;
	input [7:0] low_8bit;
	input [31:0] cursor_x, cursor_y;
	output hsync, vsync;
	output [7:0] vga_rgb;
	output [11:0] GC_mem_addr_in;
	
	/*
	 * The VGA is 800 * 600 @75MHz, so we need a 50MHz clk.	
	 * some parameters about VGA refresh 
	 */
	parameter SCREEN_WIDTH	    = 11'd800;
	parameter SCREEN_HEGIT	    = 10'd600;	
	parameter LINE_SCANNING     = 11'd1056;
	parameter  ROW_SCANNING     = 10'd625;
	parameter VALID_LEFT_PIX    = 11'd240;
	parameter VALID_RIGHT_PIX   = 11'd1040;
	parameter VALID_TOP_PIX     = 10'd24;
 	parameter VALID_BOTTOM_PIX  = 10'd624;
	parameter LINE_SYNC_PULSE   = 11'd80;
	parameter  ROW_SYNC_PULSE   = 10'd3;
	parameter FREE_HORIZONTAL   = 11'd80;   // each of left & right 
	parameter FREE_VERTICAL     = 10'd100;   // each of top & bottom
	// following parameters is just about the border of the graphics
	parameter BORDER_LEFT_BEG   = 11'd0;
	parameter BORDER_LEFT_END   = 11'd80;    // BORDER_LEFT_BEG + FREE_HORIZONTAL;
	parameter BORDER_RIGHT_BEG  = 11'd720;   // SCREEN_WIDTH - FREE_HORIZONTAL;
	parameter BORDER_RIGHT_END  = 11'd800;	 // SCREEN_WIDTH
	parameter BORDER_TOP_BEG    = 10'd0;		
	parameter BORDER_TOP_END    = 10'd100;	 // BORDER_TOP_BEG  + FREE_VERTICAL;
	parameter BORDER_BOTTOM_BEG = 10'd500;   // SCREEN_HEIGHT - FREE_VERTICAL;	
	parameter BORDER_BOTTOM_END = 10'd600;	 // SCREEN_HEIGHT
	// the cursor counter
	// CURSOR_LIGHT_CNT = 0.5s / GC_CLK
	parameter CURSOR_LIGHT_CNT  = 26'h17d7840;
	// CURSOR_DARK_CNT = 1s / GC_CLK - 1
	parameter CURSOR_DARK_CNT	 = 26'h2faf07f;
	
	
	wire clk;
	assign clk = clk_50M;
	
	//-------------------------------------
	reg [10:0] x_cnt;	// x-coordinate
	reg [9:0]  y_cnt;	// y-coordinate
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			x_cnt <= 11'd0;
		else if (x_cnt == LINE_SCANNING)
			x_cnt <= 11'd0;
		else
			x_cnt <= x_cnt + 1'b1;
	end // end always
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			y_cnt <= 10'd0;
		else if (y_cnt == ROW_SCANNING)
			y_cnt <= 10'd0;
		else if (x_cnt == LINE_SCANNING)
			y_cnt <= y_cnt + 1'b1;
		else
			;
	end // end always
	
	
	//////////////////////////////////////////
	// valid area for screen
	wire valid;
	wire [10:0] x_pos;
	wire [9:0]  y_pos;
	
	assign valid = (x_cnt >= VALID_LEFT_PIX) && (x_cnt < VALID_RIGHT_PIX) &&
				   (y_cnt >= VALID_TOP_PIX ) && (y_cnt < VALID_BOTTOM_PIX);

	assign x_pos = x_cnt - VALID_LEFT_PIX;
	assign y_pos = y_cnt - VALID_TOP_PIX;
	
	
	//////////////////////////////////////////
	// sync signal
	reg hsync_r, vsync_r;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			hsync_r <= 1'b0;
		else if (x_cnt == 11'd0)
			hsync_r <= 1'b0;
		else if (x_cnt == LINE_SYNC_PULSE)
			hsync_r <= 1'b1;
		else
			;
	end // end always
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			vsync_r <= 1'b0;
		else if (y_cnt == 10'd0)
			vsync_r <= 1'b0;
		else if (y_cnt == ROW_SYNC_PULSE)
			vsync_r <= 1'b1;
		else
			;
	end // end always
	
	assign hsync = hsync_r;
	assign vsync = vsync_r;
	
	
	/////////////////////////////////////////////////////
	// show a rectangle border
	wire left_rec, right_rec, top_rec, bottom_rec;
	wire rec_en;

	assign   left_rec = (x_pos >= BORDER_LEFT_BEG)   && (x_pos < BORDER_LEFT_END)  ;
	assign  right_rec = (x_pos >= BORDER_RIGHT_BEG)  && (x_pos < BORDER_RIGHT_END) ;
	assign    top_rec = (y_pos >= BORDER_TOP_BEG)	 && (y_pos < BORDER_TOP_END)   ;
	assign bottom_rec = (y_pos >= BORDER_BOTTOM_BEG) && (y_pos < BORDER_BOTTOM_END);	

	assign rec_en = left_rec || right_rec || top_rec || bottom_rec;

	
	//////////////////////////////////////////////////
	/*
     *	the controller about chars in the TextArea
	 */
	
	// notepad valid position
	wire [11:0] pad_x_pos;
	wire [10:0] pad_y_pos;
	wire [2:0] char_x_pos;		// the x-coordinate of every char in the TextArea
	wire [3:0] char_y_pos;  	// the y-coordinate of every char in the TextArea
	wire pad_en;					// the pad-enable signal when the scanning line is in the TextArea
	wire [31:0] cursor_x_pos;	// the cursor x (NO.x word)
	wire [31:0] cursor_y_pos;	// the cursor y (Line.y word)
	wire cursor_en;				// the cursor-enable signal when meets the cursor.
	
	assign pad_x_pos    = x_pos - FREE_HORIZONTAL;
	assign pad_y_pos    = y_pos - FREE_VERTICAL;
	assign char_x_pos   = pad_x_pos[2:0];
	assign char_y_pos   = pad_y_pos[3:0];
	assign cursor_x_pos = { 23'd0, pad_x_pos[11:3] };		// cursor_x_pos = pad_x_pos / 8
	assign cursor_y_pos = { 25'd0, pad_y_pos[10:4] };		// cursor_y_pos = pad_y_pos / 16	
	assign pad_en       = (x_pos >= BORDER_LEFT_END) && (x_pos < BORDER_RIGHT_BEG) &&
						       (y_pos >= BORDER_TOP_END ) && (y_pos < BORDER_BOTTOM_BEG);
	assign cursor_en	  = (cursor_x_pos == cursor_x) && (cursor_y_pos == cursor_y);				 
						 
	
	// the charbit of each char
	reg [2:0] char_bit;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			char_bit <= 3'b0;
		else if (pad_en)
			char_bit <= char_bit + 1'b1;
		else
			char_bit <= 3'b0;
	end // end always
	
	// use the CharDec to translate the ascii to point-array.
	wire [7:0] ascii;
	wire [7:0] lattice;
	
	assign ascii = low_8bit;
	
	GC_CharDec GC_CharDec(.ascii(ascii), .char_y_pos(char_y_pos),
						  .lattice(lattice));
						  
						  
	///////////////////////////////////////////////////////					  
	// The Cursor of the Grpahic Card
	reg [25:0] cursor_cnt;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			cursor_cnt <= 26'd0;
		else if (cursor_cnt < CURSOR_DARK_CNT)
			cursor_cnt <= cursor_cnt + 1'b1;
		else
			cursor_cnt <= 26'd0;
	end // end always
	
	reg cursor_light_en; // light the cursor-enable signal
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			cursor_light_en <= 1'b0;
		else if (cursor_cnt < CURSOR_LIGHT_CNT)
			cursor_light_en <= 1'b1;
		else
			cursor_light_en <= 1'b0;
	end // end always
	
						  
	///////////////////////////////////////////////////////
	// RGB Logic
	// RGB  Color	|  RGB  Color
	// 000  black	|  100	red
	// 001  blue	|  101	purple
	// 010	green	|  110	yellow
	// 011	cyan	|  111	white
	parameter COLOR_BLACK  = 8'b000_000_00;
	parameter COLOR_BLUE   = 8'b000_000_11;
	parameter COLOR_GREEN  = 8'b000_111_00;
	parameter COLOR_CYAN   = 8'b000_111_11;
	parameter COLOR_RED    = 8'b111_000_00;
	parameter COLOR_PURPLE = 8'b111_000_11;
	parameter COLOR_YELLOW = 8'b111_111_00;
	parameter COLOR_WHITE  = 8'b111_111_11;
	
	reg [7:0] vga_rgb_r;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			vga_rgb_r <= 8'b0;
		else if (!valid)
			vga_rgb_r <= 8'b0;
		else if (rec_en)
			vga_rgb_r <= COLOR_GREEN;
		else if (cursor_en) begin
			if (cursor_light_en)
				vga_rgb_r <= COLOR_WHITE;
			else	
				vga_rgb_r <= COLOR_BLACK;
		end
		else if (pad_en) begin
			if (lattice[char_bit])
				vga_rgb_r <= COLOR_WHITE;
			else
				vga_rgb_r <= COLOR_BLACK;
		end	
		else
			vga_rgb_r <= COLOR_BLACK;
	end
	
	assign vga_rgb = vga_rgb_r;
	
	// In the end, you need to calculate the address of the CG-Memory and the address of CharDec.
	/*
	 *  The address of the GC-Memory.
	 *
	 */
	// one char is 8 * 16 /8 = 16B;
	// The Memory Data Width is 8bit
	// MEM_DATA_WIDTH = 8;
	// PIX_PER_LINE = 8;
	// PIX_PER_ROW  = 16
	// SIZE_PER_CHAR = 2B;
	// CHAR_PER_LINE = 80;
	// GC_mem_base_addr_in   = [ pad_y_pos / PIX_PER_ROW  ] * CHAR_PER_LINE * SIZE_PER_CHAR
	// GC_mem_offset_addr_in = [ pad_x_pos / PIX_PER_LINE ] * SIZE_PER_CHAR;
	/*
	 *  Pay attention to this:
	 *  (1 / 2) * 4 (= 0) <> 1 * 2 (= 2)
	 */
	wire [11:0] GC_mem_base_addr_in;
	wire [11:0] GC_mem_offset_addr_in;
	
	// GC_mem_base_addr_in = (pad_y_pos / 16) * 80 * 2B = (pad_y_pos / 16) * (64 + 16) * 2B
	assign GC_mem_base_addr_in   = { pad_y_pos[8:4], 7'd0 } + { pad_y_pos[10:4], 5'd0 }; // just for simple
	// GC_mem_offset_addr_in = (pad_x_pos)
	assign GC_mem_offset_addr_in = { 2'd0, pad_x_pos[11:3], 1'd0 };						 // just for simple
	assign GC_mem_addr_in = GC_mem_base_addr_in + GC_mem_offset_addr_in;
	
	// always @(posedge clk) begin
	    // $display("GC_mem_base_addr_in = %h", GC_mem_base_addr_in);
	    // $display("GC_mem_offset_addr_in = %h", GC_mem_offset_addr_in);
	// end // end always    
	
	
endmodule	
