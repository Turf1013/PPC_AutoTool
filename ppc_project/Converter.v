`include "instruction_def.v"
`include "instruction_format_def.v"
`include "arch_def.v"

module insnConverter (
	clk, rst_n, PC, 
	din, ext_stall,
	dout
);

	input 						clk;
	input						rst_n;
	input [0:`PC_WIDTH-1]		PC;
	input [0:`INSTR_WIDTH-1] 	din;
	output 						ext_stall;
	output [0:`INSTR_WIDTH-1] 	dout;
	
	reg [0:`INSTR_WIDTH-1] dout_r;
	
	wire [0:`INSTR_WIDTH-1] instr;
	assign instr = din;
	
	wire lbzu, ldu, lhau, lhzu, lwzu;
	wire lbzux, ldux, lhaux, lhzux, lwzux, lwaux;
	wire stbu, stdu, sthu, stwu;
	wire stbux, stdux, sthux, stwux;
	wire lmw, stmw;
	
	
	//// handle the logic of insn
	assign lbzu = (instr[0:5] == `LBZU_OPCD) ;
	assign ldu = (instr[0:5] == `LDU_OPCD) ;
	assign lhau = (instr[0:5] == `LHAU_OPCD) ;
	assign lhzu = (instr[0:5] == `LHZU_OPCD) ;
	assign lwzu = (instr[0:5] == `LWZU_OPCD) ;
	assign lbzux = (instr[0:5] == `LBZUX_OPCD) && (instr[21:30] == `LBZUX_XXO) ;
	assign ldux = (instr[0:5] == `LDUX_OPCD) && (instr[21:30] == `LDUX_XXO) ;
	assign lhaux = (instr[0:5] == `LHAUX_OPCD) && (instr[21:30] == `LHAUX_XXO) ;
	assign lhzux = (instr[0:5] == `LHZUX_OPCD) && (instr[21:30] == `LHZUX_XXO) ;
	assign lwzux = (instr[0:5] == `LWZUX_OPCD) && (instr[21:30] == `LWZUX_XXO) ;
	assign lwaux = (instr[0:5] == `LWAUX_OPCD) && (instr[21:30] == `LWAUX_XXO) ;
	assign stbu = (instr[0:5] == `STBU_OPCD) ;
	assign stdu = (instr[0:5] == `STDU_OPCD) ;
	assign sthu = (instr[0:5] == `STHU_OPCD) ;
	assign stwu = (instr[0:5] == `STWU_OPCD) ;
	assign stbux = (instr[0:5] == `STBUX_OPCD) && (instr[21:30] == `STBUX_XXO) ;
	assign stdux = (instr[0:5] == `STDUX_OPCD) && (instr[21:30] == `STDUX_XXO) ;
	assign sthux = (instr[0:5] == `STHUX_OPCD) && (instr[21:30] == `STHUX_XXO) ;
	assign stwux = (instr[0:5] == `STWUX_OPCD) && (instr[21:30] == `STWUX_XXO) ;
	assign lmw = (instr[0:5] == `LMW_OPCD) ;
	assign stmw = (instr[0:5] == `STMW_OPCD) ;
	
	
	/*
	*	parse the insn
	*/
	// wire D-Form
	wire [0:`DRT_WIDTH-1] DRT;
	wire [0:`DD_WIDTH-1] DD;
	wire [0:`DRS_WIDTH-1] DRS;
	wire [0:`DRD_WIDTH-1] DRD;
	wire [0:`DSI_WIDTH-1] DSI;
	wire [0:`DRA_WIDTH-1] DRA;
	wire [0:`DOPCD_WIDTH-1] DOPCD;

	// wire DS-Form
	wire [0:`DSRT_WIDTH-1] DSRT;
	wire [0:`DSXO_WIDTH-1] DSXO;
	wire [0:`DSRS_WIDTH-1] DSRS;
	wire [0:`DSRD_WIDTH-1] DSRD;
	wire [0:`DSRA_WIDTH-1] DSRA;
	wire [0:`DSOPCD_WIDTH-1] DSOPCD;
	wire [0:`DSDS_WIDTH-1] DSDS;

	// wire X-Form
	wire [0:`XRT_WIDTH-1] XRT;
	wire [0:`XRS_WIDTH-1] XRS;
	wire [0:`XOPCD_WIDTH-1] XOPCD;
	wire [0:`XRA_WIDTH-1] XRA;
	wire [0:`XRB_WIDTH-1] XRB;
	wire [0:`XXO_WIDTH-1] XXO;

	// wire XO-Form
	wire [0:`XORT_WIDTH-1] XORT;
	wire [0:`XOXO_WIDTH-1] XOXO;
	wire [0:`XOOE_WIDTH-1] XOOE;
	wire [0:`XORA_WIDTH-1] XORA;
	wire [0:`XORB_WIDTH-1] XORB;
	wire [0:`XORc_WIDTH-1] XORc;
	wire [0:`XOOPCD_WIDTH-1] XOOPCD;
	
	// assign D-Form
	assign DRT = instr`DRT;
	assign DD = instr`DD;
	assign DRS = instr`DRS;
	assign DRD = instr`DRD;
	assign DSI = instr`DSI;
	assign DRA = instr`DRA;
	assign DOPCD = instr`DOPCD;

	// assign DS-Form
	assign DSRT = instr`DSRT;
	assign DSXO = instr`DSXO;
	assign DSRS = instr`DSRS;
	assign DSRD = instr`DSRD;
	assign DSRA = instr`DSRA;
	assign DSOPCD = instr`DSOPCD;
	assign DSDS = instr`DSDS;

	// assign X-Form
	assign XRT = instr`XRT;
	assign XRS = instr`XRS;
	assign XOPCD = instr`XOPCD;
	assign XRA = instr`XRA;
	assign XRB = instr`XRB;
	assign XXO = instr`XXO;

	// assign XO-Form
	assign XORT = instr`XORT;
	assign XOXO = instr`XOXO;
	assign XOOE = instr`XOOE;
	assign XORA = instr`XORA;
	assign XORB = instr`XORB;
	assign XORc = instr`XORc;
	assign XOOPCD = instr`XOOPCD;
	
	//// handle load or store with update insn
	wire update, mw;
	wire updateFir, mwFir;
	reg [0:`PC_WIDTH-1] PC_r;
	reg [0:`DRT_WIDTH-1] DRT_r;
	reg [0:`DD_WIDTH-1] DD_r;
	
	assign update = lbzu || ldu || lhau || lhzu || lwzu ||
					lbzux || ldux || lhaux || lhzux || lwzux || lwaux ||
					stbu || stdu || sthu || stwu ||
					stbux || stdux || sthux || stwux ;
	assign mw = lmw || stmw;
	assign updateFir = update && (PC_r != PC);
	assign mwFir = mw && (PC_r != PC);
	
	
	always @( * ) begin
		if ( lbzu ) begin
			if ( updateFir ) begin
				dout_r = {`LBZ_OPCD, DRT, DRA, DD};
			end
			else begin
				dout_r = {`ADDI_OPCD, DRA, DRA, DD};
			end
		end
		
		else if ( ldu ) begin
			if ( updateFir ) begin
				dout_r = {`LD_OPCD, DRT, DRA, DD};
			end
			else begin
				dout_r = {`ADDI_OPCD, DRA, DRA, DD};
			end
		end
		
		else if ( lhau ) begin
			if ( updateFir ) begin
				dout_r = {`LHA_OPCD, DRT, DRA, DD};
			end
			else begin
				dout_r = {`ADDI_OPCD, DRA, DRA, DD};
			end
		end
		
		else if ( lhzu ) begin
			if ( updateFir ) begin
				dout_r = {`LHZ_OPCD, DRT, DRA, DD};
			end
			else begin
				dout_r = {`ADDI_OPCD, DRA, DRA, DD};
			end
		end
		
		else if ( lwzu ) begin
			if ( updateFir ) begin
				dout_r = {`LWZ_OPCD, DRT, DRA, DD};
			end
			else begin
				dout_r = {`ADDI_OPCD, DRA, DRA, DD};
			end
		end
		
		else if ( lbzux ) begin
			if ( updateFir ) begin
				dout_r = {`LBZX_OPCD, XRT, XRA, XRB, `LBZX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, XRA, XRA, XRB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( ldux ) begin
			if ( updateFir ) begin
				dout_r = {`LDX_OPCD, XRT, XRA, XRB, `LDX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, XRA, XRA, XRB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( lhaux ) begin
			if ( updateFir ) begin
				dout_r = {`LHAX_OPCD, XRT, XRA, XRB, `LHAX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, XRA, XRA, XRB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( lhzux ) begin
			if ( updateFir ) begin
				dout_r = {`LHZX_OPCD, XRT, XRA, XRB, `LHZX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, XRA, XRA, XRB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( lwzux ) begin
			if ( updateFir ) begin
				dout_r = {`LWZX_OPCD, XRT, XRA, XRB, `LWZX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, XRA, XRA, XRB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( lwaux ) begin
			if ( updateFir ) begin
				dout_r = {`LWAX_OPCD, XRT, XRA, XRB, `LWAX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, XRA, XRA, XRB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( stbu ) begin
			if ( updateFir ) begin
				dout_r = {`STB_OPCD, DRS, DRA, DD};
			end
			else begin
				dout_r = {`ADDI_OPCD, DRA, DRA, DD};
			end
		end
		
		else if ( stdu ) begin
			if ( updateFir ) begin
				dout_r = {`STD_OPCD, DRS, DRA, DD};
			end
			else begin
				dout_r = {`ADDI_OPCD, DRA, DRA, DD};
			end
		end
		
		else if ( sthu ) begin
			if ( updateFir ) begin
				dout_r = {`STH_OPCD, DRS, DRA, DD};
			end
			else begin
				dout_r = {`ADDI_OPCD, DRA, DRA, DD};
			end
		end
		
		else if ( stwu ) begin
			if ( updateFir ) begin
				dout_r = {`STW_OPCD, DRS, DRA, DD};
			end
			else begin
				dout_r = {`ADDI_OPCD, DRA, DRA, DD};
			end
		end
		
		else if ( stbux ) begin
			if ( updateFir ) begin
				dout_r = {`STBX_OPCD, XRS, XRA, XRB, `STBX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, XRA, XRA, XRB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( stdux ) begin
			if ( updateFir ) begin
				dout_r = {`STDX_OPCD, XRS, XRA, XRB, `STDX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, XRA, XRA, XRB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( sthux ) begin
			if ( updateFir ) begin
				dout_r = {`STHX_OPCD, XRS, XRA, XRB, `STHX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, XRA, XRA, XRB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( stwux ) begin
			if ( updateFir ) begin
				dout_r = {`STWX_OPCD, XRS, XRA, XRB, `STWX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, XRA, XRA, XRB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( lmw ) begin
			if ( mwFir ) begin
				dout_r = {`LWZ_OPCD, DRT, DRA, DD};
			end
			else begin
				dout_r = {`LWZ_OPCD, DRT_r, DRA, DD_r};
			end
		end
		
		else if ( stmw ) begin
			if ( mwFir ) begin
				dout_r = {`STW_OPCD, DRT, DRA, DD};
			end
			else begin
				dout_r = {`STW_OPCD, DRT_r, DRA, DD_r};
			end
		end
		
		else begin
			dout_r = din;
		end
		
	end // end always
	
	//// handle stmw & lmw
	always @(posedge clk or negedge rst_n) begin
		if ( ~rst_n ) begin
			PC_r <= 32'hffff_ffff;
		end
		else begin
			PC_r <= PC;
		end
	end	// end always
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			DRT_r <= 0;
			DD_r <= 0;
		end
		else if (mw && PC_r!=PC) begin
			DRT_r <= DRT + 1;
			DD_r <= DD + 4;
		end
		else begin
			DRT_r <= DRT_r + 1;
			DD_r <= DD_r + 4;
		end
	end	// end always
	
	wire [4:0] ini_cnt;
	
	assign ini_cnt = (update) ? 5'd1:
					 (mw) ? 5'd31 - DRT:
					 5'd0;
	
	wire cnt_wr;
	reg [4:0] cnt_r;
	
	always @(posedge clk or negedge rst_n) begin
		if ( ~rst_n ) begin
			cnt_r <= 5'd0;
		end 
		else if ( cnt_wr ) begin
			if (ini_cnt == 0)
				cnt_r <= 5'd0;
			else
				cnt_r <= ini_cnt - 5'd1;
		end
		else if ( cnt_r != 0) begin
			cnt_r <= cnt_r - 5'd1;
		end
	end // end always
	
	assign cnt_wr = mwFir;
	assign dout = dout_r;
	assign ext_stall = updateFir || (mwFir && ini_cnt!=0) || (cnt_r!=0);


endmodule



module fastConverter (
	din, dout
);
	input [0:`INSTR_WIDTH-1] 	din;
	output [0:`INSTR_WIDTH-1] 	dout;
	
	assign dout = din;

endmodule