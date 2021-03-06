module GPR (
	clk, rst_n, raddr1, raddr2, waddr, GPRWd, GPRWr, rd1, rd2
);
    
	input         clk;
	input		  rst_n;	
	input  [4:0]  raddr1, raddr2;
	input  [4:0]  waddr;
	input  [31:0] GPRWd;
	input         GPRWr;
	output [31:0] rd1, rd2;

	reg [31:0] GPR[31:0];

	integer i;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			for (i=0; i<32; i=i+1)
				GPR[i] <= 0;
		end
		else if (GPRWr)
			GPR[waddr] <= GPRWd;
	end // end always

	assign rd1 = (raddr1 == 0) ? 32'd0 : GPR[raddr1];
	assign rd2 = (raddr2 == 0) ? 32'd0 : GPR[raddr2];
   
endmodule


