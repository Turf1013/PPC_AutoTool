module BOIn (
	BO, BO_n
);
	
	input BO;
	output BO_n;
	
	assign BO_n = ~BO;
	
endmodule
