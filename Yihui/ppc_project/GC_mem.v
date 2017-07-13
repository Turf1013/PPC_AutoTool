module GC_mem (
	clk, we, BE, addr, wd, rd
);
	
	input clk;
	input we;
	input [3:0] BE;
	input [11:0] addr;
	input [31:0] wd;
	output [31:0] rd;
	
	wire we0, we1, we2, we3;
	wire [7:0] rd0, rd1, rd2, rd3;
	
	assign we0 = we && BE[0];
	assign we1 = we && BE[1];
	assign we2 = we && BE[2];
	assign we3 = we && BE[3];
	
	
	reg [7:0] GC_memRAM_0[1023:0];
	reg [7:0] GC_memRAM_1[1023:0];
	reg [7:0] GC_memRAM_2[1023:0];
	reg [7:0] GC_memRAM_3[1023:0];
	
	// initial begin
	   // $readmemh("GC_mem.txt", GC_memRAM);    
	// end    
	
	// NO.0
	always @(posedge clk) begin
		if ( we0 )
			GC_memRAM_0[addr[11:2]] <= wd[7:0];
	end // end always
	
	assign rd0 = GC_memRAM_0[addr[11:2]];
	
	// NO.1
	always @(posedge clk) begin
		if ( we1 )
			GC_memRAM_1[addr[11:2]] <= wd[15:8];
	end // end always
	
	assign rd1 = GC_memRAM_1[addr[11:2]];
	
	// NO.2
	always @(posedge clk) begin
		if ( we2 )
			GC_memRAM_2[addr[11:2]] <= wd[23:16];
	end // end always
	
	assign rd2 = GC_memRAM_2[addr[11:2]];
	
	// NO.3
	always @(posedge clk) begin
		if ( we3 )
			GC_memRAM_3[addr[11:2]] <= wd[31:24];
	end // end always
	
	assign rd3 = GC_memRAM_3[addr[11:2]];
	
	/*
	//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
	GC_memRAM GC_memRAM_0 (
	  .a(addr[11:2]), // input [9 : 0] a
	  .d(wd[7:0]), // input [7 : 0] d
	  .clk(clk), // input clk
	  .we(we0), // input we
	  .spo(rd0) // output [7 : 0] spo
	);
	// INST_TAG_END ------ End INSTANTIATION Template ---------
	
	//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
	GC_memRAM GC_memRAM_1 (
	  .a(addr[11:2]), // input [9 : 0] a
	  .d(wd[15:8]), // input [7 : 0] d
	  .clk(clk), // input clk
	  .we(we1), // input we
	  .spo(rd1) // output [7 : 0] spo
	);
	// INST_TAG_END ------ End INSTANTIATION Template ---------
	
	//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
	GC_memRAM GC_memRAM_2 (
	  .a(addr[11:2]), // input [9 : 0] a
	  .d(wd[23:16]), // input [7 : 0] d
	  .clk(clk), // input clk
	  .we(we2), // input we
	  .spo(rd2) // output [7 : 0] spo
	);
	// INST_TAG_END ------ End INSTANTIATION Template ---------
	
	//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
	GC_memRAM GC_memRAM_3 (
	  .a(addr[11:2]), // input [9 : 0] a
	  .d(wd[31:24]), // input [7 : 0] d
	  .clk(clk), // input clk
	  .we(we3), // input we
	  .spo(rd3) // output [7 : 0] spo
	);
	// INST_TAG_END ------ End INSTANTIATION Template ---------
	*/
	assign rd = { rd3, rd2, rd1, rd0 };
	
endmodule