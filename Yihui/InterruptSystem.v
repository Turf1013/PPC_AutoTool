/**
	\author: 	Trasier
	\date: 		2017/5/9
	\brief: 	Circuit of the Exception System
*/
`include "Interrupt_def.v"
module InterruptEncoder (

);

endmodule

module InterruptRegister (
	
);
	input clk, rst;
	input [9:0] addr0, addr1, addr2;
	input [31:0] wd0, wd1, wd2;
	input wr0, wr1, wr2;
	output [31:0] rd0, rd1, rd2;
	input [`ExcepCode_WIDTH-1:0] excepCode;
	output [31:0] intrEntryAddr;
	
	reg [31:0] SRR0, SRR1, ESR, DEAR;
		

endmodule

