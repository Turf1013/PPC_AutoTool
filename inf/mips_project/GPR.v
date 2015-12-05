module GPR (
	clk, rst_n, raddr0, raddr1, waddr, wd, wr, rd0, rd1
);
    
	input         clk;
	input		  rst_n;	
	input  [4:0]  raddr0, raddr1;
	input  [4:0]  waddr;
	input  [31:0] wd;
	input         wr;
	output [31:0] rd0, rd1;

	reg [31:0] GPR[31:0];

	integer i;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			for (i=0; i<32; i=i+1)
				GPR[i] <= 0;
		end
		else if (wr)
			GPR[waddr] <= wd;
	end // end always

	assign rd0 = (raddr0 == 0) ? 32'd0 : GPR[raddr0];
	assign rd1 = (raddr1 == 0) ? 32'd0 : GPR[raddr1];
   
endmodule


