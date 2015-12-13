module ps2_top (
	clk, rst_n, we, addr, wd, ps2_clk, ps2_data, rd, intr
);
	 
	input clk;
	input rst_n;
	input we;
	input [3:0] addr;
	input [31:0] wd;
	input ps2_clk;
	input ps2_data;
	output intr;
	output [31:0] rd;

	 
	wire caps_flg;
	wire ps2_intp;	
	wire [7:0] ps2_byte;
	wire ps2_state;
	wire caps;
	
	// PS/2 scanning logic
	ps2_scan ps2_scan(.clk(clk), .rst_n(rst_n),
						   .ps2_clk(ps2_clk), .ps2_data(ps2_data),
						   .ps2_byte(ps2_byte), .ps2_state(ps2_state),
							.caps_flg(caps_flg), .ps2_intp(ps2_intp));	
	// PS/2 Registers
	ps2_RF ps2_RF(.clk(clk), .rst_n(rst_n),
					  .we(we), .addr(addr[3:0]),
					  .wd(wd), .rd(rd), 
					  .ps2_byte(ps2_byte), .caps_flg(caps_flg),
					  .intp(ps2_intp), .intr(intr), .caps(caps));	
endmodule
