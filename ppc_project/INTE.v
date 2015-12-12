module INTE (
	INT, EE, hw_int
);
	
	input EE;
	input hw_int;
	output INT;
	
	assign INT = hw_int & EE;
	
endmodule