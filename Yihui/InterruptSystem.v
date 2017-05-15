/**
	\author: 	Trasier
	\date: 		2017/5/9
	\brief: 	Circuit of the Exception System
*/
`include "Interrupt_def.v"
`include "MSR_def.v"
`include "sprn_def.v"
`include "zyx_global.v"

module InterruptEncoder (
	DSI_req, ISI_req, ITLB_req, DTLB_req,
	DEV0_req, DEV1_req, progErr_req, SC_req,
	DSI_ack, ISI_ack, ITLB_ack, DTLB_ack,
	DEV0_ack, DEV1_ack, progErr_ack, SC_ack,
	ack, MSR_EE, progErrCode, excepCode,
	clk, rst
);

	input DSI_req;
	input ISI_req;
	input ITLB_req;
	input DTLB_req;
	input DEV0_req;
	input DEV1_req;
	input progErr_req;
	input SC_req;
	
	output SC_ack;
	output progErr_ack;
	output DEV1_ack;
	output DEV0_ack;
	output DTLB_ack;
	output ITLB_ack;
	output ISI_ack;
	output DSI_ack;
	
	input ack;
	input MSR_EE;
	input [2:0] progErrCode;
	output [`ExcepCode_WIDTH-1:0] excepCode;
	
	input clk, rst;
	
	/**
		According to the index of stage, interrupt priority is defined as follows:
		DSI > DMISS > PRIV > ILLE > TRAP > SC > ISI > IMISS > DEV0 > DEV1
	*/
	wire illegalError, privelegeError, isTraped;
	
	assign {illegalError, privelegeError, isTraped} = progErrCode;
	
	reg [`ExcepCode_WIDTH-1:0] excepCode_in;
	always @(*) begin
		if (DSI_req) begin
			excepCode_in <= `ExcepCode_DSI;
		end
		else if (DTLB_req) begin
			excepCode_in <= `ExcepCode_DMISS;
		end
		else if (progErr_req) begin
			if (privelegeError)
				excepCode_in <= `ExcepCode_PRIV;
			else if (illegalError)
				excepCode_in <= `ExcepCode_ILLE;
			else
				excepCode_in <= `ExcepCode_TRAP;
		end
		else if (SC_req) begin
			excepCode_in <= `ExcepCode_SC;
		end
		else if (ISI_req) begin
			excepCode_in <= `ExcepCode_ISI;
		end
		else if (ITLB_req) begin
			excepCode_in <= `ExcepCode_IMISS;
		end
		else if (DEV0_req && MSR_EE) begin
			excepCode_in <= `ExcepCode_DEV0;
		end
		else if (DEV1_req && MSR_EE) begin
			excepCode_in <= `ExcepCode_DEV1;
		end
		else begin
			excepCode_in <= `ExcepCode_NONE;
		end
	end // end always
	
	reg [`ExcepCode_WIDTH-1:0] excepCode_r;
	
	always @(posedge clk) begin
		if (rst) begin
			excepCode_r <= `ExcepCode_NONE;
		end
		else if (ack) begin
			excepCode_r <= `ExcepCode_NONE;
		end
		else if (excepCode_r != `ExcepCode_NONE) begin
			excepCode_r <= excepCode_r;
		end
		else begin
			excepCode_r <= excepCode_in;
		end
	end // end always
	
	assign excepCode = excepCode_r;
	
	// the logic of XXX_ack
	assign SC_ack = ack && (excepCode==`ExcepCode_SC);
	assign progErr_ack = ack && (excepCode==`ExcepCode_TRAP || excepCode==`ExcepCode_PRIV || excepCode==`ExcepCode_ILLE);
	assign DEV1_ack = ack && (excepCode==`ExcepCode_DEV1);
	assign DEV0_ack = ack && (excepCode==`ExcepCode_DEV0);
	assign DTLB_ack = ack && (excepCode==`ExcepCode_DMISS);
	assign ITLB_ack = ack && (excepCode==`ExcepCode_IMISS);
	assign ISI_ack  = ack && (excepCode==`ExcepCode_ISI);
	assign DSI_ack  = ack && (excepCode==`ExcepCode_DSI);

endmodule

module InterruptRegister (
	clk, rst,
	addr0, addr1, addr2,
	wd0, wd1, wd2,
	wr0, wr1, wr2,
	rd0, rd1, rd2,
	excepCode, intrEntryAddr
);

	input clk, rst;
	input [9:0] addr0, addr1, addr2;
	input [0:31] wd0, wd1, wd2;
	input wr0, wr1, wr2;
	output [0:31] rd0, rd1, rd2;
	input [`ExcepCode_WIDTH-1:0] excepCode;
	output [0:31] intrEntryAddr;
	
	reg [0:31] SRR0, SRR1, ESR, DEAR, IVPR;
	reg [0:31] IVOR[15:0];
	
	integer i;
	initial begin
		for (i=0; i<16; i=i+1)
			IVOR[i] = 0;
	end // end initial
	
	wire [9:0] IVOR_addr0, IVOR_addr1, IVOR_addr2;
	assign IVOR_addr0 = addr0 - 10'd400;
	assign IVOR_addr1 = addr1 - 10'd400;
	assign IVOR_addr2 = addr2 - 10'd400;
	
	// Logic of write
	always @(posedge clk) begin
		if (rst) begin
			SRR0 <= 0;
			SRR1 <= 0;
			ESR <= 0;
			DEAR <= 0;
			IVPR <= 32'hffff_0000;
		end
		else begin
			if (wr0) begin
				if (addr0>=10'd400 && addr0<=10'd415) begin
					IVOR[IVOR_addr0[4:0]] <= wd0;
				end
				else begin
					case(addr0)
						`SPRN_SRR0: SRR0 <= wd0;
						`SPRN_SRR1: SRR1 <= wd0;
						// `SPRN_ESR: 	ESR  <= wd0;
						`SPRN_DEAR: DEAR <= wd0;
						`SPRN_IVPR: IVPR <= wd0;
					endcase
				end
			end
			if (wr1) begin
				if (addr1>=10'd400 && addr1<=10'd415) begin
					IVOR[IVOR_addr1[4:0]] <= wd1;
				end
				else begin
					case(addr1)
						`SPRN_SRR0: SRR0 <= wd1;
						`SPRN_SRR1: SRR1 <= wd1;
						// `SPRN_ESR: 	ESR  <= wd1;
						`SPRN_DEAR: DEAR <= wd1;
						`SPRN_IVPR: IVPR <= wd1;
					endcase
				end
			end
			if (wr2) begin
				if (addr2>=10'd400 && addr2<=10'd415) begin
					IVOR[IVOR_addr2[4:0]] <= wd2;
				end
				else begin
					case(addr1)
						`SPRN_SRR0: SRR0 <= wd2;
						`SPRN_SRR1: SRR1 <= wd2;
						// `SPRN_ESR: 	ESR  <= wd2;
						`SPRN_DEAR: DEAR <= wd2;
						`SPRN_IVPR: IVPR <= wd2;
					endcase
				end
			end
		end
	end // end always
	
	//// logic of ESR
	always @(posedge clk) begin
		if (excepCode != `ExcepCode_NONE) begin
			case (excepCode)
				`ExcepCode_DSI: ESR[`SPR_ESR_ST] <= 1;
				`ExcepCode_ISI: ESR[`SPR_ESR_ST] <= 1;
				`ExcepCode_ILLE: ESR[`SPR_ESR_PIL] <= 1;
				`ExcepCode_TRAP: ESR[`SPR_ESR_PTR] <= 1;
				`ExcepCode_PRIV: ESR[`SPR_ESR_PPR] <= 1;
			endcase
		end
		else if (wr0 && addr0==`SPRN_ESR) begin
			ESR <= wd0;
		end
		else if (wr1 && addr1==`SPRN_ESR) begin
			ESR <= wd1;
		end
		else if (wr2 && addr2==`SPRN_ESR) begin
			ESR <= wd2;
		end
	end // end always
	
	// logic of read
	reg [0:31] rd0_r;
	
	always @(addr0) begin
		if (addr0>=10'd400 && addr0<=10'd415) begin
			rd0_r = IVOR[IVOR_addr0[4:0]];
		end
		else begin
			case (addr0)
				`SPRN_SRR0: rd0_r = SRR0;
				`SPRN_SRR1: rd0_r = SRR1;
				`SPRN_ESR: 	rd0_r = ESR;
				`SPRN_DEAR: rd0_r = DEAR;
				`SPRN_IVPR: rd0_r = IVPR;
				default:	rd0_r = 32'd0;
			endcase
		end
	end // end always
	
	assign rd0 = (wr0) ? wd0 : rd0_r;
	
	reg [0:31] rd1_r;
	
	always @(addr1) begin
		if (addr1>=10'd400 && addr1<=10'd415) begin
			rd1_r = IVOR[IVOR_addr1[4:0]];
		end
		else begin
			case (addr1)
				`SPRN_SRR0: rd1_r = SRR0;
				`SPRN_SRR1: rd1_r = SRR1;
				`SPRN_ESR: 	rd1_r = ESR;
				`SPRN_DEAR: rd1_r = DEAR;
				`SPRN_IVPR: rd1_r = IVPR;
				default:	rd1_r = 32'd0;
			endcase
		end
	end // end always
	
	assign rd1 = (wr1) ? wd1 : rd1_r;
	
	reg [0:31] rd2_r;
	
	always @(addr2) begin
		if (addr2>=10'd400 && addr2<=10'd415) begin
			rd2_r = IVOR[IVOR_addr2[4:0]];
		end
		else begin
			case (addr2)
				`SPRN_SRR0: rd2_r = SRR0;
				`SPRN_SRR1: rd2_r = SRR1;
				`SPRN_ESR: 	rd2_r = ESR;
				`SPRN_DEAR: rd2_r = DEAR;
				`SPRN_IVPR: rd2_r = IVPR;
				default:	rd2_r = 32'd0;
			endcase
		end
	end // end always
	
	assign rd2 = (wr2) ? wd2 : rd2_r;
	
	
	// Logic of interrupt Entry
	reg [0:31] intrEntryAddr;
	
	always @(excepCode) begin
		case(excepCode)
			`ifdef ZYX_DEBUG
			
			`ExcepCode_DSI: 	intrEntryAddr = {IVPR[0:15], IVOR[2][16:31]};
			`ExcepCode_ISI: 	intrEntryAddr = {IVPR[0:15], IVOR[3][16:31]};
			`ExcepCode_DMISS: 	intrEntryAddr = {IVPR[0:15], IVOR[13][16:31]};
			`ExcepCode_IMISS: 	intrEntryAddr = {IVPR[0:15], IVOR[14][16:31]};
			`ExcepCode_TRAP: 	intrEntryAddr = {IVPR[0:15], IVOR[6][16:31]};
			`ExcepCode_PRIV: 	intrEntryAddr = {IVPR[0:15], IVOR[6][16:31]};
			`ExcepCode_ILLE: 	intrEntryAddr = {IVPR[0:15], IVOR[6][16:31]};
			`ExcepCode_SC:		intrEntryAddr = {IVPR[0:15], IVOR[8][16:31]};
			`ExcepCode_DEV0:	intrEntryAddr = {IVPR[0:15], IVOR[4][16:31]};
			`ExcepCode_DEV1:	intrEntryAddr = {IVPR[0:15], IVOR[5][16:31]};
			
			`else
			
			`ExcepCode_DSI: 	intrEntryAddr = {IVPR[0:15], IVOR[2][16:27], 4'd0};
			`ExcepCode_ISI: 	intrEntryAddr = {IVPR[0:15], IVOR[3][16:27], 4'd0};
			`ExcepCode_DMISS: 	intrEntryAddr = {IVPR[0:15], IVOR[13][16:27], 4'd0};
			`ExcepCode_IMISS: 	intrEntryAddr = {IVPR[0:15], IVOR[14][16:27], 4'd0};
			`ExcepCode_TRAP: 	intrEntryAddr = {IVPR[0:15], IVOR[6][16:27], 4'd0};
			`ExcepCode_PRIV: 	intrEntryAddr = {IVPR[0:15], IVOR[6][16:27], 4'd0};
			`ExcepCode_ILLE: 	intrEntryAddr = {IVPR[0:15], IVOR[6][16:27], 4'd0};
			`ExcepCode_SC:		intrEntryAddr = {IVPR[0:15], IVOR[8][16:27], 4'd0};
			`ExcepCode_DEV0:	intrEntryAddr = {IVPR[0:15], IVOR[4][16:27], 4'd0};
			`ExcepCode_DEV1:	intrEntryAddr = {IVPR[0:15], IVOR[5][16:27], 4'd0};
			
			`endif
			default:			intrEntryAddr = 32'hffff_ffff;
		endcase
	end // end always

endmodule

module InterruptSystem (
	clk, rst,
	addr0, addr1, addr2,
	wd0, wd1, wd2,
	wr0, wr1, wr2,
	rd0, rd1, rd2,
	excepCode, intrEntryAddr,
	DSI_req, ISI_req, ITLB_req, DTLB_req,
	DEV0_req, DEV1_req, progErr_req, SC_req,
	DSI_ack, ISI_ack, ITLB_ack, DTLB_ack,
	DEV0_ack, DEV1_ack, progErr_ack, SC_ack,
	ack, MSR, progErrCode
);

	input clk, rst;
	input [9:0] addr0, addr1, addr2;
	input [0:31] wd0, wd1, wd2;
	input wr0, wr1, wr2;
	output [0:31] rd0, rd1, rd2;
	output [`ExcepCode_WIDTH-1:0] excepCode;
	output [0:31] intrEntryAddr;
	
	input DSI_req;
	input ISI_req;
	input ITLB_req;
	input DTLB_req;
	input DEV0_req;
	input DEV1_req;
	input progErr_req;
	input SC_req;
	
	output SC_ack;
	output progErr_ack;
	output DEV1_ack;
	output DEV0_ack;
	output DTLB_ack;
	output ITLB_ack;
	output ISI_ack;
	output DSI_ack;
	
	input ack;
	input [0:31] MSR;
	input [2:0] progErrCode;
	
	wire MSR_EE;
	
	assign MSR_EE = MSR[`MSR_EE];
	
	InterruptEncoder U_InterruptEncoder (
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
		.ack(ack), 
		.MSR_EE(MSR_EE), 
		.progErrCode(progErrCode), 
		.excepCode(excepCode),
		.clk(clk), 
		.rst(rst)
);
	
	InterruptRegister U_InterruptRegister (
		.clk(clk), 
		.rst(rst),
		.addr0(addr0),
		.addr1(addr1),
		.addr2(addr2),
		.wd0(wd0),
		.wd1(wd1),
		.wd2(wd2),
		.wr0(wr0),
		.wr1(wr1),
		.wr2(wr2),
		.rd0(rd0),
		.rd1(rd1),
		.rd2(rd2),
		.excepCode(excepCode), 
		.intrEntryAddr(intrEntryAddr)
	);

endmodule
