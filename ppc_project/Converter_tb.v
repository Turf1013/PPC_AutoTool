`include "arch_def.v"
/*
	9421ffe0    stwu    r1,-32(r1)
	87fe0004 	lwzu    r31,4(r30)
	7c1f006e 	lwzux   r0,r31,r0
	7d49e16e 	stwux   r10,r9,r28
	9d240001 	stbu    r9,1(r4)
	8d730001 	lbzu    r11,1(r19)
	7c0b00ee 	lbzux   r0,r11,r0
	7ce921ee 	stbux   r7,r9,r4
	a4e80002 	lhzu    r7,2(r8)
	b4e90002 	sthu    r7,2(r9)
	7d635a6e 	lhzux   r11,r3,r11
	bbc10018 	lmw     r30,24(r1)
	bf010010 	stmw    r24,16(r1)
*/
module Converter_tb (

);

	wire [31:0] PC, newInsn;
	wire [31:0] oldInsn;
	wire stall;
	reg clk;
	reg rst_n;
	reg[31:0] addr; 
	
	reg[31:0] imem[15:0];
	
	initial begin
	$readmemh( "code.txt" , imem);
	addr = 0;
	clk = 1'b0;
	rst_n = 1'b1;
	#12 rst_n = 1'b0;
	#4 rst_n = 1'b1;
	end
	
	always begin
		#5 clk = ~clk;
	end // end always
	
	assign PC = addr;
	
	insnConverter I_insnConverter (
		.clk(clk), 
		.rst_n(rst_n), 
		.PC(PC), 
		.din(oldInsn), 
		.ext_stall(stall),
		.dout(newInsn)
	);
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			addr <= 32'd0;
		end
		else if (~stall) begin
			addr <= addr + 32'd4;
		end
	end // end always
	
	assign oldInsn = imem[addr[5:2]];
	
endmodule
