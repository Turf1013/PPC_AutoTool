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
	assign lbzux = (instr[0:5] == `LBZUX_OPCD) && (instr[21:30] == `LBZUX_XO) ;
	assign ldux = (instr[0:5] == `LDUX_OPCD) && (instr[21:30] == `LDUX_XO) ;
	assign lhaux = (instr[0:5] == `LHAUX_OPCD) && (instr[21:30] == `LHAUX_XO) ;
	assign lhzux = (instr[0:5] == `LHZUX_OPCD) && (instr[21:30] == `LHZUX_XO) ;
	assign lwzux = (instr[0:5] == `LWZUX_OPCD) && (instr[21:30] == `LWZUX_XO) ;
	assign lwaux = (instr[0:5] == `LWAUX_OPCD) && (instr[21:30] == `LWAUX_XO) ;
	assign stbu = (instr[0:5] == `STBU_OPCD) ;
	assign stdu = (instr[0:5] == `STDU_OPCD) ;
	assign sthu = (instr[0:5] == `STHU_OPCD) ;
	assign stwu = (instr[0:5] == `STWU_OPCD) ;
	assign stbux = (instr[0:5] == `STBUX_OPCD) && (instr[21:30] == `STBUX_XO) ;
	assign stdux = (instr[0:5] == `STDUX_OPCD) && (instr[21:30] == `STDUX_XO) ;
	assign sthux = (instr[0:5] == `STHUX_OPCD) && (instr[21:30] == `STHUX_XO) ;
	assign stwux = (instr[0:5] == `STWUX_OPCD) && (instr[21:30] == `STWUX_XO) ;
	assign lmw = (instr[0:5] == `LMW_OPCD) ;
	assign stmw = (instr[0:5] == `STMW_OPCD) ;
	
	
	/*
	*	parse the insn
	*/
	// wire D-Form
	wire [0:`D_RT_WIDTH-1] D_RT;
	wire [0:`D_D_WIDTH-1] D_D;
	wire [0:`D_RS_WIDTH-1] D_RS;
	wire [0:`D_RD_WIDTH-1] D_RD;
	wire [0:`D_SI_WIDTH-1] D_SI;
	wire [0:`D_RA_WIDTH-1] D_RA;
	wire [0:`D_OPCD_WIDTH-1] D_OPCD;

	// wire DS-Form
	wire [0:`DS_RT_WIDTH-1] DS_RT;
	wire [0:`DS_XO_WIDTH-1] DS_XO;
	wire [0:`DS_RS_WIDTH-1] DS_RS;
	wire [0:`DS_RD_WIDTH-1] DS_RD;
	wire [0:`DS_RA_WIDTH-1] DS_RA;
	wire [0:`DS_OPCD_WIDTH-1] DS_OPCD;
	wire [0:`DS_DS_WIDTH-1] DS_DS;

	// wire X-Form
	wire [0:`X_RT_WIDTH-1] X_RT;
	wire [0:`X_RS_WIDTH-1] X_RS;
	wire [0:`X_OPCD_WIDTH-1] X_OPCD;
	wire [0:`X_RA_WIDTH-1] X_RA;
	wire [0:`X_RB_WIDTH-1] X_RB;
	wire [0:`X_XO_WIDTH-1] X_XO;

	// wire XO-Form
	wire [0:`XO_RT_WIDTH-1] XO_RT;
	wire [0:`XO_XO_WIDTH-1] XO_XO;
	wire [0:`XO_OE_WIDTH-1] XO_OE;
	wire [0:`XO_RA_WIDTH-1] XO_RA;
	wire [0:`XO_RB_WIDTH-1] XO_RB;
	wire [0:`XO_Rc_WIDTH-1] XO_Rc;
	wire [0:`XO_OPCD_WIDTH-1] XO_OPCD;
	
	// assign D-Form
	assign D_RT = instr`D_RT;
	assign D_D = instr`D_D;
	assign D_RS = instr`D_RS;
	assign D_RD = instr`D_RD;
	assign D_SI = instr`D_SI;
	assign D_RA = instr`D_RA;
	assign D_OPCD = instr`D_OPCD;

	// assign DS-Form
	assign DS_RT = instr`DS_RT;
	assign DS_XO = instr`DS_XO;
	assign DS_RS = instr`DS_RS;
	assign DS_RD = instr`DS_RD;
	assign DS_RA = instr`DS_RA;
	assign DS_OPCD = instr`DS_OPCD;
	assign DS_DS = instr`DS_DS;

	// assign X-Form
	assign X_RT = instr`X_RT;
	assign X_RS = instr`X_RS;
	assign X_OPCD = instr`X_OPCD;
	assign X_RA = instr`X_RA;
	assign X_RB = instr`X_RB;
	assign X_XO = instr`X_XO;

	// assign XO-Form
	assign XO_RT = instr`XO_RT;
	assign XO_XO = instr`XO_XO;
	assign XO_OE = instr`XO_OE;
	assign XO_RA = instr`XO_RA;
	assign XO_RB = instr`XO_RB;
	assign XO_Rc = instr`XO_Rc;
	assign XO_OPCD = instr`XO_OPCD;
	
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
	reg [0:`D_RT_WIDTH-1] D_RT_r;
	reg [0:`D_D_WIDTH-1] D_D_r;
	
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
				dout_r = {`LBZX_OPCD, X_RT, X_RA, X_RB, `LBZX_XO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XO, 1'b0};
			end
		end
		
		else if ( ldux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LDX_OPCD, X_RT, X_RA, X_RB, `LDX_XO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XO, 1'b0};
			end
		end
		
		else if ( lhaux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LHAX_OPCD, X_RT, X_RA, X_RB, `LHAX_XO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XO, 1'b0};
			end
		end
		
		else if ( lhzux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LHZX_OPCD, X_RT, X_RA, X_RB, `LHZX_XO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XO, 1'b0};
			end
		end
		
		else if ( lwzux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LWZX_OPCD, X_RT, X_RA, X_RB, `LWZX_XO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XO, 1'b0};
			end
		end
		
		else if ( lwaux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`LWAX_OPCD, X_RT, X_RA, X_RB, `LWAX_XO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RT, X_RA, X_RB, 1'b0, `ADD_XO, 1'b0};
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
				dout_r = {`STBX_OPCD, X_RS, X_RA, X_RB, `STBX_XO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RA, X_RA, X_RB, 1'b0, `ADD_XO, 1'b0};
			end
		end
		
		else if ( stdux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STDX_OPCD, X_RS, X_RA, X_RB, `STDX_XO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RA, X_RA, X_RB, 1'b0, `ADD_XO, 1'b0};
			end
		end
		
		else if ( sthux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STHX_OPCD, X_RS, X_RA, X_RB, `STHX_XO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RA, X_RA, X_RB, 1'b0, `ADD_XO, 1'b0};
			end
		end
		
		else if ( stwux ) begin
			if ( ~stall_update_r ) begin
				dout_r = {`STWX_OPCD, X_RS, X_RA, X_RB, `STWX_XO, 1'b0};
			end
			else begin
				dout_r = {`ADD_OPCD, X_RA, X_RA, X_RB, 1'b0, `ADD_XO, 1'b0};
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
