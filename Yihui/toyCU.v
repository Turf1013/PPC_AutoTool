/**
	\author: 	Trasier
	\date: 		2017/5/10
	\brief: 	TOY of the Controller
*/
`include "Interrupt_def.v"

module toyCU (
	isTrapedIn, isTraped,
	isUndefinedIn, isUndefined,
	isPrivelegedIn, isPriveleged,
	scIn, sc,
	excepCode, ack,
	clk, rst
);
	input isTrapedIn;
	output isTraped;
	input isUndefinedIn;
	output isUndefined;
	input isPrivelegedIn;
	output isPriveleged;
	input [`ExcepCode_WIDTH-1:0] excepCode;
	output ack;
	input clk, rst;
	input scIn;
	output sc;

	reg isTraped, isUndefined, isPriveledged;
	
	always @(posedge clk) begin
		if (rst) 
			isTraped <= 0;
		else
			isTraped <= isTrapedIn;
	end // end always
	
	always @(posedge clk) begin
		if (rst)
			isUndefined <= 0;
		else
			isUndefined <= isUndefinedIn;
	end // end always
	
	always @(posedge clk) begin
		if (rst)
			isPriveleged <= 0;
		else
			isPriveleged <= isPrivelegedIn;
	end // end always
	
	reg sc;
	always @(posedge clk) begin
		if (rst)
			sc <= 0;
		else
			sc <= scIn;
	end // end always
	
	wire req;
	
	assign req = (excepCode != `ExcepCode_NONE);
	
	always @(posedge clk) begin
		if (rst)
			ack <= 0;
		else if (req)
			ack <= 1;
		else
			ack <= 0;
	end // end always

endmodule
