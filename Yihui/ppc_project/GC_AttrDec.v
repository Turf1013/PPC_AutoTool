module GC_AttrDec (
	high_8bit, bg_rgb, fg_rgb, light, blink
);

	input [7:0] high_8bit;
	output [2:0] bg_rgb, fg_rgb;
	output light, blink;
	
	assign {blink, bg_rgb, light, fg_rgb} = high_8bit;

endmodule