/*********************
	\author: Trasier
	\brief:  instance module of different cache
	\motive: test the performance of CACHE in different structures, then choose the most appropriate one.
	\date: 	 2016.11.13	
*********************/

/*********************
!!!Rule of module name: cache_#1_#2_#3
#1: 1) direct: direct-mapped cache
	2) set:    N-way set associative cache
#2: SIZE of the cache (Byte)
#3: SIZE of the block (Words)

**********************/

/******************************  4KB  ******************************/
module cache_direct_4K_1 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 1 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=12, BLOCK_SIZE=1) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule

module cache_direct_4K_2 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 2 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=12, BLOCK_SIZE=2) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


module cache_direct_4K_4 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 4 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=12, BLOCK_SIZE=4) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


module cache_direct_4K_8 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 8 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=12, BLOCK_SIZE=8) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


/******************************  8KB  ******************************/
module cache_direct_8K_1 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 1 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=13, BLOCK_SIZE=1) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule

module cache_direct_8K_2 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 2 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=13, BLOCK_SIZE=2) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


module cache_direct_8K_4 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 4 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=13, BLOCK_SIZE=4) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


module cache_direct_8K_8 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 8 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=13, BLOCK_SIZE=8) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


/******************************  16KB  ******************************/
module cache_direct_16K_1 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 1 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=14, BLOCK_SIZE=1) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule

module cache_direct_16K_2 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 2 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=14, BLOCK_SIZE=2) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


module cache_direct_16K_4 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 4 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=14, BLOCK_SIZE=4) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


module cache_direct_16K_8 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 8 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=14, BLOCK_SIZE=8) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


/******************************  32KB  ******************************/
module cache_direct_32K_1 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 1 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=15, BLOCK_SIZE=1) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule

module cache_direct_32K_2 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 2 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=15, BLOCK_SIZE=2) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


module cache_direct_32K_4 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 4 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=15, BLOCK_SIZE=4) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule


module cache_direct_32K_8 (
	clk, rst_n,
	wr, addr, din, dout,
	hit
);

	parameter BLOCK_WIDTH = 8 * 8;

	input 					 clk;
	input 					 rst_n;
	input					 wr;
	input  [31:0]			 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output					 hit;
	
	baseCache  #(CACHE_SIZE=15, BLOCK_SIZE=8) 
	I_cache (
		.clk(clk),
		.rst_n(rst_n),
		.wr(wr),
		.addr(addr),
		.din(din);
		.dout(dout),
		.hit(hit)
	);
	

endmodule