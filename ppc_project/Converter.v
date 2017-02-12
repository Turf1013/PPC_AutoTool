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
	wire [0:`DRT_WIDTH-1] D_RT;
	wire [0:`DD_WIDTH-1] D_D;
	wire [0:`DRS_WIDTH-1] D_RS;
	wire [0:`DRD_WIDTH-1] D_RD;
	wire [0:`DSI_WIDTH-1] D_SI;
	wire [0:`DRA_WIDTH-1] D_RA;
	wire [0:`DOPCD_WIDTH-1] D_OPCD;

	// wire DS-Form
	wire [0:`DSRT_WIDTH-1] DS_RT;
	wire [0:`DSXO_WIDTH-1] DS_XO;
	wire [0:`DSRS_WIDTH-1] DS_RS;
	wire [0:`DSRD_WIDTH-1] DS_RD;
	wire [0:`DSRA_WIDTH-1] DS_RA;
	wire [0:`DSOPCD_WIDTH-1] DS_OPCD;
	wire [0:`DSDS_WIDTH-1] DS_DS;

	// wire X-Form
	wire [0:`XRT_WIDTH-1] X_RT;
	wire [0:`XRS_WIDTH-1] X_RS;
	wire [0:`XOPCD_WIDTH-1] X_OPCD;
	wire [0:`XRA_WIDTH-1] X_RA;
	wire [0:`XRB_WIDTH-1] X_RB;
	wire [0:`XXO_WIDTH-1] X_XO;

	// wire XO-Form
	wire [0:`XORT_WIDTH-1] XO_RT;
	wire [0:`XOXO_WIDTH-1] XO_XO;
	wire [0:`XOOE_WIDTH-1] XO_OE;
	wire [0:`XORA_WIDTH-1] XO_RA;
	wire [0:`XORB_WIDTH-1] XO_RB;
	wire [0:`XORc_WIDTH-1] XO_Rc;
	wire [0:`XOOPCD_WIDTH-1] XO_OPCD;
	
	// assign D-Form
	assign D_RT = instr`DRT;
	assign D_D = instr`DD;
	assign D_RS = instr`DRS;
	assign D_RD = instr`DRD;
	assign D_SI = instr`DSI;
	assign D_RA = instr`DRA;
	assign D_OPCD = instr`DOPCD;

	// assign DS-Form
	assign DS_RT = instr`DSRT;
	assign DS_XO = instr`DSXO;
	assign DS_RS = instr`DSRS;
	assign DS_RD = instr`DSRD;
	assign DS_RA = instr`DSRA;
	assign DS_OPCD = instr`DSOPCD;
	assign DS_DS = instr`DSDS;

	// assign X-Form
	assign X_RT = instr`XRT;
	assign X_RS = instr`XRS;
	assign X_OPCD = instr`XOPCD;
	assign X_RA = instr`XRA;
	assign X_RB = instr`XRB;
	assign X_XO = instr`XXO;

	// assign XO-Form
	assign XO_RT = instr`XORT;
	assign XO_XO = instr`XOXO;
	assign XO_OE = instr`XOOE;
	assign XO_RA = instr`XORA;
	assign XO_RB = instr`XORB;
	assign XO_Rc = instr`XORc;
	assign XO_OPCD = instr`XOOPCD;
	
	//// handle load or store with update insn
	wire update, mw;
	
	assign update = lbzu || ldu || lhau || lhzu || lwzu ||
					lbzux || ldux || lhaux || lhzux || lwzux || lwaux ||
					stbu || stdu || sthu || stwu ||
					stbux || stdux || sthux || stwux ;
	
	reg stall_update_r, stall_update;
	reg [4:0] cnt, cnt_r;
	reg mw_r;
	reg [0:`PC_WIDTH-1] PC_r;
	reg [0:`DRT_WIDTH-1] D_RT_r;
	reg [0:`DD_WIDTH-1] D_D_r;
	
	always @( * ) begin
		if ( lbzu ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LBZ_OPCD, D_RT, D_RA, D_D};
			end
			else begin
				dout_r = {`ADDI_OPCD, D_RT, D_RA, D_D};
			end
		end
		
		else if ( ldu ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LD_OPCD, D_RT, D_RA, D_D};
			end
			else begin
				dout_r = {`ADDI_OPCD, D_RT, D_RA, D_D};
			end
		end
		
		else if ( lhau ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LHA_OPCD, D_RT, D_RA, D_D};
			end
			else begin
				dout_r = {`ADDI_OPCD, D_RT, D_RA, D_D};
			end
		end
		
		else if ( lhzu ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LHZ_OPCD, D_RT, D_RA, D_D};
			end
			else begin
				dout_r = {`ADDI_OPCD, D_RT, D_RA, D_D};
			end
		end
		
		else if ( lwzu ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LWZ_OPCD, D_RT, D_RA, D_D};
			end
			else begin
				dout_r = {`ADDI_OPCD, D_RT, D_RA, D_D};
			end
		end
		
		else if ( lbzux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LBZX_OPCD, X_RT, X_RA, X_RB, `LBZX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( ldux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LDX_OPCD, X_RT, X_RA, X_RB, `LDX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( lhaux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LHAX_OPCD, X_RT, X_RA, X_RB, `LHAX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( lhzux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LHZX_OPCD, X_RT, X_RA, X_RB, `LHZX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( lwzux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LWZX_OPCD, X_RT, X_RA, X_RB, `LWZX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( lwaux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LWAX_OPCD, X_RT, X_RA, X_RB, `LWAX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( stbu ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STB_OPCD, D_RS, D_RA, D_D};
			end
			else begin
				dout_r = {`ADDI_OPCD, D_RA, D_RA, D_D};
			end
		end
		
		else if ( stdu ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STD_OPCD, D_RS, D_RA, D_D};
			end
			else begin
				dout_r = {`ADDI_OPCD, D_RA, D_RA, D_D};
			end
		end
		
		else if ( sthu ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STH_OPCD, D_RS, D_RA, D_D};
			end
			else begin
				dout_r = {`ADDI_OPCD, D_RA, D_RA, D_D};
			end
		end
		
		else if ( stwu ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STW_OPCD, D_RS, D_RA, D_D};
			end
			else begin
				dout_r = {`ADDI_OPCD, D_RA, D_RA, D_D};
			end
		end
		
		else if ( stbux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STBX_OPCD, X_RS, X_RA, X_RB, `STBX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RA, X_RA, X_RB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( stdux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STDX_OPCD, X_RS, X_RA, X_RB, `STDX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RA, X_RA, X_RB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( sthux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STHX_OPCD, X_RS, X_RA, X_RB, `STHX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RA, X_RA, X_RB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( stwux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STWX_OPCD, X_RS, X_RA, X_RB, `STWX_XXO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RA, X_RA, X_RB, 1'b0, `ADD_XOXO, 1'b0};
			end
		end
		
		else if ( lmw ) begin
			if (~mw_r || PC_r!=PC) begin
				dout_r = `NOP;
			end
			else begin
				dout_r = {`LWZ_OPCD, D_RT_r, D_RA, D_D_r};
			end
		end
		
		else if ( stmw ) begin
			if (~mw_r || PC_r!=PC) begin
				dout_r = `NOP;
			end
			else begin
				dout_r = {`STW_OPCD, D_RT_r, D_RA, D_D_r};
			end
		end
		
		else begin
			dout_r = din;
		end
		
	end // end always
	
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			stall_update_r <= 1'b0;
		end
		else begin
			stall_update_r <= stall_update;
		end
	end // end alway
	
	always @( * ) begin
		if ( update ) begin
			stall_update = ~stall_update_r;
		end
		else begin
			stall_update = 1'b0;
		end
	end // end always
	
	
	//// handle stmw & lmw
	always @(posedge clk or negedge rst_n) begin
		if ( ~rst_n ) begin
			PC_r <= 0;
		end
		else begin
			PC_r <= PC;
		end
	end	// end always
	
	always @(posedge clk or negedge rst_n) begin
		if ( ~rst_n ) begin
			mw_r <= 0;
		end
		else begin
			mw_r <= mw;
		end
	end	// end always
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			D_RT_r <= 0;
			D_D_r <= 0;
		end
		else if (mw && (~mw_r || PC_r!=PC)) begin
			D_RT_r <= D_RT;
			D_D_r <= D_D;
		end
		else begin
			D_RT_r <= D_RT_r + 1;
			D_D_r <= D_D_r + 4;
		end
	end	// end always
	
	assign mw = lmw || stmw;
	assign stall_mw = mw && (D_RT_r != 5'd31);
	
	assign dout = dout_r;
	assign ext_stall = stall_update || stall_mw;


endmodule



module fastConverter (
	din, dout
);
	input [0:`INSTR_WIDTH-1] 	din;
	output [0:`INSTR_WIDTH-1] 	dout;
	
	assign dout = din;

endmodule