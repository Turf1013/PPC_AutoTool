/*********************
	\author: Trasier
	\brief:  basic module of cache, only considering the entry and structure of cache,
		without further discussion about how to implemnt write-back, hit or anyother functions.
	\motive: test the performance of CACHE in different structures, then choose the most appropriate one.
	\date: 	 2016.12.3	
*********************/
`include "lib.v"

module cacheRam (
	clk
	wr, addr, din, dout,
	tag, Dirty, ValidNew, DirtyNew
);
	
	parameter CACHE_SIZE = 12;					// 2^CACHE_SIZE B
	parameter BLOCK_SIZE = 8;	
	parameter BLOCK_WIDTH = BLOCK_SIZE * 32;
	parameter TAG_WIDTH = 32 - CACHE_SIZE;		// direct map
	parameter STAT_WIDTH = 2;
	
	parameter WIDTH = TAG_WIDTH + STAT_WIDTH + BLOCK_WIDTH;
	parameter BLOCK_POS = LOG2(BLOCK_SIZE) + 2;
	parameter ADDR_WIDTH = CACHE_SIZE - BLOCK_POS;
	parameter DEPTH = 1 << ADDR_WIDTH;
										
	input 					 clk;
	input					 wr;
	input  [ADDR_WIDTH-1:0]	 addr;
	input  [BLOCK_WIDTH-1:0] din;
	output [BLOCK_WIDTH-1:0] dout;
	output [31:CACHE_SIZE]	 tag;
	output					 Valid;
	output					 Dirty;
	input					 ValidNew, DirtyNew;
	
	
	reg [WIDTH-1:0] mem[DEPTH-1:0];
	
	wire [STAT_WIDTH-1:0]  status;
	wire [TAG_WIDTH-1:0]   tag;
	wire [BLOCK_WIDTH-1:0] block;
	
	assign {tag, status, block} = dout;
	
	wire [STAT_WIDHT] StatusNew;
	
	assign StatusNew = {ValidNew, DirtyNew};
	
	always @(posedge clk) begin
		if (wr)
			mem[addr] <= {tag, StatusNew, din};
	end // end always
	
	assign dout = mem[addr];
	// assign hit = tag == addr[31:CACHE_SIZE];
	

endmodule

module cacheCtrl (
	clk, rst_n,
	A_CPU, A_Low_Cache,
	Hit, Dirty,
	Rdy_CPU, Req_CPU, Wr_CPU, 
	Rdy_Low, Req_Low, Wr_Low,
	W, En, ValidNew, DirtyNew,
	A_Sel, Wr_Cache
);
	parameter CACHE_SIZE = 12;					// 2^CACHE_SIZE B
	parameter BLOCK_SIZE = 8;	
	parameter BLOCK_WIDTH = BLOCK_SIZE * 32;
	parameter TAG_WIDTH = 32 - CACHE_SIZE;		// direct map
	parameter STAT_WIDTH = 3;
	
	parameter Z32 = 32'd0;
	parameter ZERO = Z32[BLOCK_SIZE-1:0];
	parameter MASK = ~ZERO;
	parameter ONE = ZERO + 1'b1;
	parameter BLOCK_LOG2 = LOG2(BLOCK_SIZE);
	
	input clk, rst_n;

	input [31:0] A_CPU;
	input [TAG_WIDTH:0] A_Low_Cache;
	input Hit;
	input Dirty;
	
	output Rdy_CPU;
	input Req_CPU;
	input Wr_CPU;
	
	input Rdy_Low;
	output Req_Low;
	output Wr_Low;
	
	output W[BLOCK_SIZE-1:0];
	output En[BLOCK_SIZE-1:0];
	output ValidNew;
	output DirtyNew;
	output A_Sel;
	output Wr_Cache;
	
	
	parameter INIT = 2'b00;
	parameter TAG  = 2'b01;
	parameter MB   = 2'b10;
	parameter WB   = 2'b11;
	
	reg [1:0] state;
	reg [1:0] nextstate;
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			state <= INIT;
		else begin
			state <= nextstate;
		end
	end // end always
	
	
	always @( * ) begin
		case (state)
		INIT: begin
			nextstate = TAG;
		end
		
		TAG: begin
			if (Req_CPU && ~Hit && Dirty)
				nextstate = WB;
			else if (Req_CPU && ~Hit && ~Dirty)
				nextstate = MB;
			else
				nextstate = TAG;
		end
		
		WB: begin
			if (Rdy_Low)
				nextstate = MB;
			else
				nextstate = WB;
		end
		
		MB: begin
			if (Rdy_Low)
				nextstate = TAG
			else
				nextstate = MB;
		end
		
		default: begin
			nextstate = INIT;
		end
		endcase
	end // end always
	
	wire [BLOCK_LOG2-1:0] block_offset;
	
	assign block_offset = A_CPU[1+BLOCK_LOG2:2];
	
	// logic of Wr
	assign Wr_Cache = ((state==TAG) && Wr_CPU) || (state==MB && Rdy_Low);
	
	// logic of En[3:0]
	assign En = (state==TAG) ? (ONE << block_offset) :
				(state== MB) ? MASK : ZERO;
	
	// logic of W[3:0]
	assign W = (state==TAG) ? ZERO : 
				(state==MB) ? ((Wr_CPU) ? MASK : (ONE << block_offset)) : ZERO; 
				
	
	// logic of ValidNew
	assign ValidNew = (state == TAG) || (state == MB);
	
	// logic of DirtyNew
	assign DirtyNew = (state == TAG) || (state==MB && Wr_CPU);
	
	// logic of A_Sel
	assign A_Sel = (state == WB);
	
	// logic of Req_Low
	assign Req_Low = (state == WB);
	
	// logic of Wr_Low
	assign Wr_Low = (state == WB) && Rdy_Low;
	
	// logic of Rdy_CPU
	assign Rdy_CPU = (state == TAG) || ((state==MB) && Rdy_Low);
	
endmodule



module baseCache (
	clk, rst_n,
	A_CPU, Req_CPU, Wr_CPU, Rdy_CPU,
	Req_Low, Wr_Low, Rdy_Low,
	A_Low, DI_Low, DO_Low, DO_CPU
);
	parameter CACHE_SIZE = 12;					// 2^CACHE_SIZE B
	parameter BLOCK_SIZE = 8;	
	parameter BLOCK_WIDTH = BLOCK_SIZE * 32;
	parameter TAG_WIDTH = 32 - CACHE_SIZE;		// direct map
	parameter STAT_WIDTH = 3;
	
	parameter LOW_SIZE = 2 + LOG2(BLOCK_SIZE);
	
	input clk;
	input rst_n;
	
	input [31:0] A_CPU;
	input Req_CPU;
	input Wr_CPU;
	output Rdy_CPU;
	
	input Req_Low;
	output Wr_Low;
	output Rdy_Low;
	
	output [31:LOW_SIZE] A_Low;
	output [31:0] DO_CPU;
	
	input [BLOCK_WIDTH-1:0] DI_Low;
	
	wire [BLOCK_WIDTH-1:0] DO_Low;
	wire [31:CACHE_SIZE] tag;
	wire Wr_Cache;
	wire Hit, Valid, Dirty;
	wire DirtyNew, ValidNew;
	
	wire [CACHE_SIZE-1:LOW_SIZE] A_Cache;
	assign A_Cache = A_CPU[CACHE_SIZE-1:LOW_SIZE];
	
	wire [BLOCK_WIDHT-1:0] Din_Cache;
	wire [BLOCK_WIDHT-1:0] Dout_Cache;
	
	cacheRam  #(CACHE_SIZE=CACHE_SIZE, BLOCK_SIZE=BLOCK_SIZE) 
	I_cacheRam (
		.clk(clk),
		.wr(Wr_Cache),
		.addr(A_Cache),
		.din(Din_Cache),
		.dout(Dout_Cache),
		.tag(tag),
		.Valid(Valid),
		.Dirty(Dirty),
		.ValidNew(ValidNew),
		.DirtyNew(DirtyNew)
	);
	
	wire Hit;
	
	assign Hit = Valid && (A_CPU[31:CACHE_SIZE] == tag);
	
	cacheCtrl #(CACHE_SIZE=CACHE_SIZE, BLOCK_SIZE=BLOCK_SIZE) 
	I_cacheCtrl (
		.clk(clk), 
		.rst_n(rst_n),
		.A_CPU(A_CPU), 
		.Hit(Hit), 
		.Dirty(Dirty),
		.Rdy_CPU(Rdy_CPU), 
		.Req_CPU(Req_CPU), 
		.Wr_CPU(Wr_CPU), 
		.Rdy_Low(Rdy_Low), 
		.Req_Low(Req_Low), 
		.Wr_Low(Wr_Low),
		.W(W), 
		.En(En), 
		.ValidNew(ValidNew), 
		.DirtyNew(DirtyNew),
		.A_Sel(A_Sel), 
		.Wr_Cache(Wr_Cache),
		.A_Low_Cache(A_Low_Cache),	//????
	);
	
	assign A_Low = A_Sel ? {tag, A_CPU[CACHE_SIZE-1:LOW_SIZE]} : A_CPU[31:LOW_SIZE];
	

endmodule
