`include "arch_def.v"
`include "ctrl_encode_def.v"

module ppc_tb;
    
	reg clk, rst_n;
	reg wr;
	reg [31:0] instr;
	integer i, j;
	 
	ppc I_PPC(
		.clk(clk), .rst_n(rst_n)
	);
    
	initial begin
		$readmemh( "code.txt" , I_PPC.I_IM.imem );
		$readmemh( "data.txt" , I_PPC.I_DM.dmem );
		wr = 0;
		instr = 0;
		clk = 1;
		rst_n = 1;
		#5;
		rst_n = 0;
		#20;
		rst_n = 1;
	end
   
	always
		#(50) clk = ~clk;
	
	wire [31:0] addr_;
	reg [31:0] addr;
	wire [`DM_DEPTH-1:0] dm_addr;
	
	assign addr_ = addr - `DM_ADDR_BASE;
	assign dm_addr = addr_[`DM_DEPTH+1:2];
	   
	always @(posedge clk) begin
		if ( wr ) begin
			$display("instr = %h, DM[%8h] = %h\n", instr, {addr[31:2],2'b0}, I_PPC.I_DM.dmem[dm_addr]);
		end
		
		wr <= 1'b0;
		
		if (I_PPC.I_GPR.wr) begin
			$display("instr = %h, GPR[%2d] = %h\n", I_PPC.Instr_W, I_PPC.I_GPR.waddr, I_PPC.I_GPR.wd);
		end
		
		if (I_PPC.I_CR.wr) begin
			$display("instr = %h, CR = %h\n", I_PPC.Instr_W, I_PPC.I_CR.wd);
		end
		
		if (I_PPC.I_MSR.wr) begin
			$display("instr = %h, MSR = %h\n", I_PPC.Instr_W, I_PPC.I_MSR.wd);
		end
		
		if (I_PPC.I_DM.wr) begin
			wr <= 1'b1;
			instr <= I_PPC.Instr_M;
			addr <= I_PPC.I_DM.addr;
		end
		
		if (I_PPC.I_SPR.wr0 && I_PPC.I_SPR.wr1) begin
			$display("instr = %h, SPR[%2d] = %h, SPR[%2d] = %h\n", I_PPC.Instr_W, I_PPC.I_SPR.waddr0, I_PPC.I_SPR.wd0, I_PPC.I_SPR.waddr1, I_PPC.I_SPR.wd1);
		end
		else if (I_PPC.I_SPR.wr0) begin
			$display("instr = %h, SPR[%2d] = %h\n", I_PPC.Instr_W, I_PPC.I_SPR.waddr0, I_PPC.I_SPR.wd0);
		end
		else if (I_PPC.I_SPR.wr1) begin
			$display("instr = %h, SPR[%2d] = %h\n", I_PPC.Instr_W, I_PPC.I_SPR.waddr1, I_PPC.I_SPR.wd1);
		end
		
	end // end always
   
endmodule
