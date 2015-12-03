`include "instruction_def.v"

module insnConverter (
	clk, rst_n, pc, 
	din, ext_stall,
	dout
);

	input 						clk;
	input						rst_n;
	input						pc;
	input [0:`INSTR_WIDTH-1] 	din;
	output 						ext_stall;
	output [0:`INSTR_WIDTH-1] 	dout;
	
	wire [0:`INSTR_WIDTH-1] instr;
	assign instr = din;
	
	reg [0:`INSTR_WIDTH-1] dout_r;
	wire lbzu, ldu, lhau, lhzu, lwzu;
	wire lbzux, ldux, lhaux, lhzux, lwzux, lwaux;
	wire stbu, stdu, sthu, stwu;
	wire stbux, stdux, sthux, stwux;
	wire lmw, stmw;
	
	//// handle load or store with update insn
	wire update;
	
	assign update = lbzu || ldu || lhau || lhzu || lwzu ||
					lbzux || ldux || lhaux || lhzux || lwzux || lwaux ||
					stbu || stdu || sthu || stwu ||
					stbux || stdux || sthux || stwux ;
	
	reg stall_update_r, stall_update;
	
	always @( * ) begin
		
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
			stall_upddate = 1'b0;
		end
	end // end always
	
	
	
	//// handle lmw or stmw
	reg [4:0] cnt;
	reg [4:0] wd;
	reg fill;
	
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			cnt <= 5'd0;
		end
		else if ( fill ) begin
			cnt <= wd;
		end
		else if ( cnt ) begin
			cnt <= cnt - 5'd1;
		end
	end // end always
	
	assign dout = dout_r;
	assign ext_stall = stall_update;
	
	
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
	assign stm = (instr[0:5] == `STM_OPCD) ;


endmodule
