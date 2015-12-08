module BOIn (
	din, dout
);
	
	input din;
	output dout;
	
	assign dout = ~din;
	
endmodule
