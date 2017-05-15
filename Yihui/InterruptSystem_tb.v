/**
	\author: 	Trasier
	\date: 		2017/5/10
	\brief: 	TestBench of the Interrupt System
*/
`include "Interrupt_def.v"
`include "sprn_def.v"

module InterruptSystem_tb (
);

	reg clk;

	always begin
		clk = 1'b1; #5;
		clk = 1'b0; #5;
	end // end always
	
	reg rst;
	reg [9:0] SPR_addr0, SPR_addr1, SPR_addr2;
	reg [0:31] SPR_wd0, SPR_wd1, SPR_wd2;
	reg SPR_wr0, SPR_wr1, SPR_wr2;
	reg isTrapedIn, isUndefinedIn, isPrivelegedIn, scIn; 
	reg MSR_wr;
	reg [0:31] MSR_wd;
	reg Dev1_intrIn, Dev0_intrIn;
	reg ITLB_missIn, DTLB_missIn;
	reg isLoadIn, isStoreIn, isMoveSprIn, isFetchIn;
	reg [9:0] sprn;
	reg [5:0] entry;
	
	initial begin
		SPR_addr0 = 10'd0;
		SPR_addr1 = 10'd0;
		SPR_addr2 = 10'd0;
		SPR_wd0 = 0;
		SPR_wd1 = 0;
		SPR_wd2 = 0;
		isTrapedIn = 0;
		isUndefinedIn = 0;
		isPrivelegedIn = 0;
		scIn = 0;
		Dev1_intrIn = 0;
		Dev0_intrIn = 0;
		ITLB_missIn = 0;
		DTLB_missIn = 0;
		isLoadIn = 0;
		isStoreIn = 0;
		isMoveSprIn = 0;
		isFetchIn = 0;
		SPR_wr0 = 0;
		SPR_wr1 = 0;
		SPR_wr2 = 0;
		MSR_wr = 0;
		MSR_wd = 0;
		sprn = 0;
		
		entry = 6'b111111;
		rst = 1;
		#12;
		rst = 0;
		
		// initialize MSR
		#12;
		MSR_wr = 1;
		MSR_wd = 32'h0000_c000;
		#10
		MSR_wr = 0;
		
		// check read SPR
		#6;
		SPR_wr0 = 1;
		SPR_wr1 = 1;
		SPR_wr2 = 1;
		SPR_addr0 = `SPRN_IVOR2;
		SPR_addr1 = `SPRN_IVOR3;
		SPR_addr2 = `SPRN_IVOR13;
		SPR_wd0 = 2;
		SPR_wd1 = 3;
		SPR_wd2 = 13;
		#10;
		SPR_wr0 = 1;
		SPR_wr1 = 1;
		SPR_wr2 = 1;
		SPR_addr0 = `SPRN_IVOR14;
		SPR_addr1 = `SPRN_IVOR6;
		SPR_addr2 = `SPRN_IVOR8;
		SPR_wd0 = 14;
		SPR_wd1 = 6;
		SPR_wd2 = 8;
		#10;
		SPR_wr0 = 1;
		SPR_wr1 = 1;
		SPR_wr2 = 0;
		SPR_addr0 = `SPRN_IVOR4;
		SPR_addr1 = `SPRN_IVOR5;
		SPR_wd0 = 4;
		SPR_wd1 = 5;
		#10;
		SPR_wr0 = 0;
		SPR_wr1 = 0;
		SPR_addr0 = `SPRN_IVOR2;
		SPR_addr1 = `SPRN_IVOR3;
		SPR_addr2 = `SPRN_IVOR13;
		#5;
		SPR_addr0 = `SPRN_IVOR14;
		SPR_addr1 = `SPRN_IVOR6;
		SPR_addr2 = `SPRN_IVOR8;
		#5;
		SPR_addr0 = `SPRN_IVOR14;
		SPR_addr1 = `SPRN_IVOR0;
		SPR_addr2 = `SPRN_IVOR0;
		#5;
		SPR_addr0 = `SPRN_IVOR0;
		
		// check with interrupt
		Dev0_intrIn = 1;
		#10;
		Dev0_intrIn = 0;
		#5;
		#40;
		Dev1_intrIn = 1;
		#12;
		Dev1_intrIn = 0;
		#8;
		#40;
		
		// check with TLB Miss
		ITLB_missIn = 1;
		#10;
		ITLB_missIn = 0;
		#10;
		#40;
		DTLB_missIn = 1;
		#12;
		DTLB_missIn = 0;
		#8;
		#40;
		
		// check with Error Exception & SystemCall
		isTrapedIn = 1;
		#10;
		isTrapedIn = 0;
		#10;
		#40;
		isUndefinedIn = 1;
		#12;
		isUndefinedIn = 0;
		#8;
		#40;
		isPrivelegedIn = 1;
		#10;
		isPrivelegedIn = 0;
		#10;
		#40;
		scIn = 1;
		#12;
		scIn = 0;
		#8;
		#40;
		sprn = `SPRN_IVPR;
		isMoveSprIn = 1;
		#10;
		sprn = 0;
		isMoveSprIn = 0;
		#10;
		#40;
		
		// check with storage exception & MSR_PR=1
		entry = 6'b111111;
		isLoadIn = 1;
		#10;
		isLoadIn = 0;
		entry = 6'b011111;
		#10;
		#40;
		entry = 6'b111111;
		isStoreIn = 1;
		#10;
		isStoreIn = 0;
		entry = 6'b110111;
		#10;
		#40;
		entry = 6'b111111;
		isFetchIn = 1;
		#10;
		isFetchIn = 0;
		entry = 6'b111101;
		#10;
		#40;
		
	end // end initial
	
	wire [0:31] SPR_rd0, SPR_rd1, SPR_rd2;
	wire [`ExcepCode_WIDTH-1:0] excepCode;
	wire DSI_req, ISI_req, ITLB_req, DTLB_req, DEV0_req, DEV1_req, progErr_req, SC_req;
	wire [0:31] intrEntryAddr;
	wire DSI_ack, ISI_ack, ITLB_ack, DTLB_ack, Dev0_ack, Dev1_ack, progErr_ack, SC_ack, CU_ack;
	wire [2:0] progErrCode;
	wire [0:31] MSR;
	wire [3:0] entry_RW;
	wire [1:0] entry_X;
	wire isLoad, isStore, isFetch, isMoveSpr;
	
	assign {entry_RW, entry_X} = entry;
	
	InterruptSystem U_InterruptSystem (
		.clk(clk), 
		.rst(rst),
		.addr0(SPR_addr0), 
		.addr1(SPR_addr1), 
		.addr2(SPR_addr2),
		.wd0(SPR_wd0), 
		.wd1(SPR_wd1), 
		.wd2(SPR_wd2),
		.wr0(SPR_wr0), 
		.wr1(SPR_wr1), 
		.wr2(SPR_wr2),
		.rd0(SPR_rd0), 
		.rd1(SPR_rd1), 
		.rd2(SPR_rd2),
		.excepCode(excepCode), 
		.intrEntryAddr(intrEntryAddr),
		.DSI_req(DSI_req), 
		.ISI_req(ISI_req), 
		.ITLB_req(ITLB_req), 
		.DTLB_req(DTLB_req),
		.DEV0_req(DEV0_req), 
		.DEV1_req(DEV1_req), 
		.progErr_req(progErr_req), 
		.SC_req(SC_req),
		.DSI_ack(DSI_ack), 
		.ISI_ack(ISI_ack), 
		.ITLB_ack(ITLB_ack), 
		.DTLB_ack(DTLB_ack),
		.DEV0_ack(Dev0_ack), 
		.DEV1_ack(Dev1_ack), 
		.progErr_ack(progErr_ack), 
		.SC_ack(SC_ack),
		.ack(CU_ack), 
		.MSR(MSR), 
		.progErrCode(progErrCode)
	);
	
	wire isTraped, isUndefined, isPriveleged;
	
	toyCU U_toyCU (
		.isTrapedIn(isTrapedIn), 
		.isTraped(isTraped),
		.isUndefinedIn(isUndefinedIn), 
		.isUndefined(isUndefined),
		.isPrivelegedIn(isPrivelegedIn), 
		.isPriveleged(isPriveleged),
		.isLoadIn(isLoadIn),
		.isLoad(isLoad),
		.isStoreIn(isStoreIn),
		.isStore(isStore),
		.isFetchIn(isFetchIn),
		.isFetch(isFetch),
		.isMoveSprIn(isMoveSprIn),
		.isMoveSpr(isMoveSpr),
		.scIn(scIn), 
		.sc(SC_req),
		.excepCode(excepCode), 
		.ack(CU_ack),
		.clk(clk), 
		.rst(rst)
	);
	
	toyMSR U_toyMSR (
		.clk(clk), 
		.rst(rst), 
		.wr(MSR_wr), 
		.wd(MSR_wd), 
		.MSR(MSR)
	);
	
	toyDev1 U_toyDev1 (
		.intrIn(Dev1_intrIn), 
		.intr(DEV1_req),
		.ack(Dev1_ack), 
		.clk(clk), 
		.rst(rst)
	);
	
	toyDev0 U_toyDev0 (
		.intrIn(Dev0_intrIn), 
		.intr(DEV0_req),
		.ack(Dev0_ack), 
		.clk(clk), 
		.rst(rst)
	);
	
	toyITLB U_toyITLB (
		.missIn(ITLB_missIn),
		.miss(ITLB_req),
		.ack(ITLB_ack),
		.clk(clk),
		.rst(rst)
	);
	
	toyDTLB U_toyDTLB (
		.missIn(DTLB_missIn),
		.miss(DTLB_req),
		.ack(DTLB_ack),
		.clk(clk),
		.rst(rst)
	);
	
	DSI U_DSI (
		.MSR(MSR), 
		.entry_RW(entry_RW),
		.isLoad(isLoad), 
		.isStore(isStore),
		.dsi(DSI_req), 
		.ack(DSI_ack), 
		.clk(clk), 
		.rst(rst)
	);
	
	ISI U_ISI (
		.MSR(MSR), 
		.entry_X(entry_X),
		.isFetch(isFetch),
		.isi(ISI_req), 
		.ack(ISI_ack), 
		.clk(clk), 
		.rst(rst)
	);
	
	programError U_programError (
		.isUndefined(isUndefined), 
		.isPriveleged(isPriveleged), 
		.isTraped(isTraped),
		.isMoveSpr(isMoveSpr), 
		.sprn(sprn), 
		.MSR(MSR), 
		.progErrCode(progErrCode), 
		.progErr(progErr_req), 
		.ack(progErr_ack), 
		.clk(clk), 
		.rst(rst)
	);
	
endmodule

