/*********************
	\author: Trasier
	\brief:  basic module of cache, only considering the entry and structure of cache,
		without further discussion about how to implemnt write-back, hit or anyother functions.
	\motive: test the performance of CACHE in different structures, then choose the most appropriate one.
	\date: 	 2016.11.13	
*********************/

module baseCache (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);
	
	parameter CACHE_SIZE = 12;					// 2^CACHE_SIZE B
	parameter BLOCK_SIZE = 8;	
	parameter BLOCK_WIDTH = BLOCK_SIZE * 32;
	parameter TAG_WIDTH = 32 - CACHE_SIZE;		// direct map
	parameter STAT_WIDTH = 3;
	
	parameter WIDTH = TAG_WIDTH + STAT_WIDTH + BLOCK_WIDTH;
	parameter BLOCK_POS = ( BLOCK_SIZE == 8 ? 3:
							BLOCK_SIZE == 4 ? 2:
							BLOCK_SIZE == 2 ? 1:0 );
	parameter DEPTH = 1 << (CACHE_SIZE - BLOCK_POS);
										
	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	
	reg [WIDTH-1:0] mem[DEPTH-1:0];
	
	wire [STAT_WIDTH-1:0]  status;
	wire [TAG_WIDTH-1:0]   tag;
	wire [BLOCK_WIDTH-1:0] block;
	
	assign {tag, status, block} = dout;
	
	always @(posedge clk or negedge rst_n) begin
		if ( ~rst_n ) begin
			dout <= 0;
		end 
		else if ( wr ) begin 
			dout <= din;
		end
	end // end always
	
	assign hit = tag == addr[31:CACHE_SIZE];
	

endmodule