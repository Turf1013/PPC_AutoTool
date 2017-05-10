/**
	\author: 	Trasier
	\date: 		2017/5/10
	\brief: 	TestBench of the Interrupt System
*/
`include "Interrupt_def.v"

module InterruptSystem_tb (
);

	reg clk;

	always begin
		clk = 1'b1; #5;
		clk = 1'b0; #5;
	end // end always
	
	reg rst;
	reg [9:0] SPR_addr0, SPR_adrr1, SPR_addr2;
	reg [0:31] SPR_wd0, SPR_wd1, SPR_wd2;
	reg SPR_wr0, SPR_wr1, SPR_wr2;
	reg isTrapedIn, isUndefinedIn, isPrivelegedIn, scIn; 
	reg MSR_wr;
	reg [0:31] MSR_wd;
	
	initial begin
		rst = 1;
		#12;
		rst = 0;
		
		
	end // end initial
	
	wire [0:31] SPR_rd0, SPR_rd1, SPR_rd2;
	wire [`ExcepCode_WIDTH-1:0] excepCode;
	wire DSI_req, ISI_req, ITLB_req, DTLB_req, DEV0_req, DEV1_req, progErr_re, SC_req;
	wire [0:31] intrEntryAddr;
	wire DSI_ack, ISI_ack, ITLB_ack, DTLB_ack, DEV0_ack, DEV1_ack, progErr_ack, SC_ack, CU_ack;
	wire [2:0] progErrCode;
	wire [0:31] MSR;
	
	
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
		.DEV0_ack(DEV0_ack), 
		.DEV1_ack(DEV1_ack), 
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

endmodule

