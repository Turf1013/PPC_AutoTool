`include "arch_def.v"

module SysBridge (
	clk, rst_n, addr, din, BE, dout, wr, LED_dis, hw_int
);

	input						clk;
	input						rst_n;
	input						wr;
	input	[0:`ARCH_WIDTH-1]	addr;
	input 	[0:`ARCH_WIDTH-1] 	din;
	input 	[0:`DMBE_WIDTH-1] 	BE;
	output	[0:`ARCH_WIDTH-1] 	dout;
	output	[7:0]				LED_dis;
	output						hw_int;
	
 
	reg [0:`ARCH_WIDTH-1]	dout;
	wire [0:`ARCH_WIDTH-1]	IOrd;
	wire [0:`ARCH_WIDTH-1]	DMrd;
	wire [0:`ARCH_WIDTH-1]	DM_BASE_ADDR;
	wire [0:`ARCH_WIDTH-1]	IO_BASE_ADDR;
	reg IOwr;
	reg DMwr;
	
	assign DM_BASE_ADDR = `DM_BASE_ADDR;
	assign IO_BASE_ADDR = `IO_BASE_ADDR;
	
	always @( * ) begin
		if (addr[0:`ARCH_WIDTH/2-1] == DM_BASE_ADDR[0:`ARCH_WIDTH/2-1]) begin
			IOwr = 1'b0;
			DMwr = wr;
			dout = DMrd;
		end
		else if (addr[0:`ARCH_WIDTH/2-1] == IO_BASE_ADDR[0:`ARCH_WIDTH/2-1]) begin
			IOwr = wr;
			DMwr = 1'b0;
			dout = IOrd;
		end
		else begin
			IOwr = 1'b0;
			DMwr = 1'b0;
			dout = `CONST_NEG1;
		end
	end // end always
	
	DM I_DM (
		.BE(BE),
		.din(din),
		.dout(DMrd),
		.addr(addr),
		.clk(clk),
		.wr(DMwr)
	);
	
	IOU I_IOU (
		.clk(clk),
		.rst_n(rst_n), 
		.addr(addr),
		.wr(IOwr),
		.BE(BE),
		.din(din), 
		.dout(IOrd),
		.LED_dis(LED_dis), 
		.hw_int(hw_int)
	);

endmodule
