`include "arch_def.v"
`include "ctrl_encode_def.v"
`include "default_def.v"
`include "instruction_def.v"

module control (
	clk, rst_n, Instr_D, Instr_E, 
	Instr_M, Instr_W, ALUOp, GPR_rd1_E_Bp_Sel, 
	pipeRegWr_E, ALU_B_Sel, pipeRegWr_M, GPR_rd1_D_Bp_Sel, 
	ExtOp, PCWr, DMWr, DMOut_MEOp, 
	GPR_rd2_E_Bp_Sel, NPCOp, BrCmp_Op, pipeRegWr_F, 
	pipeRegWr_W, GPR_waddr_Sel, pipeRegWr_D, GPRWd_Sel, 
	GPR_rd2_D_Bp_Sel, DMIn_BEOp, GPRWr
);

	input clk;
	input rst_n;
	input [`INSTR_WIDTH-1:0] Instr_D;
	input [`INSTR_WIDTH-1:0] Instr_E;
	input [`INSTR_WIDTH-1:0] Instr_M;
	input [`INSTR_WIDTH-1:0] Instr_W;
	output [`NPCOp_WIDTH-1:0] NPCOp;
	output [`BrCmp_Op_WIDTH-1:0] BrCmp_Op;
	output [`ALUOp_WIDTH-1:0] ALUOp;
	output [`ExtOp_WIDTH-1:0] ExtOp;
	output [1:0] ALU_B_Sel;
	output [`DMWr_WIDTH-1:0] DMWr;
	output [`DMIn_BEOp_WIDTH-1:0] DMIn_BEOp;
	output [`DMOut_MEOp_WIDTH-1:0] DMOut_MEOp;
	output [2:0] GPR_waddr_Sel;
	output [2:0] GPRWd_Sel;
	output [`GPRWr_WIDTH-1:0] GPRWr;
	output PCWr;
	output pipeRegWr_F;
	output pipeRegWr_D;
	output pipeRegWr_E;
	output pipeRegWr_M;
	output pipeRegWr_W;
	output [2:0] GPR_rd2_D_Bp_Sel;
	output [2:0] GPR_rd1_D_Bp_Sel;
	output [2:0] GPR_rd1_E_Bp_Sel;
	output [2:0] GPR_rd2_E_Bp_Sel;

	wire [`NPCOp_WIDTH-1:0] NPCOp;
	wire [`BrCmp_Op_WIDTH-1:0] BrCmp_Op;
	wire [`ALUOp_WIDTH-1:0] ALUOp;
	wire [`ExtOp_WIDTH-1:0] ExtOp;
	wire [1:0] ALU_B_Sel;
	wire [`DMWr_WIDTH-1:0] DMWr;
	wire [`DMIn_BEOp_WIDTH-1:0] DMIn_BEOp;
	wire [`DMOut_MEOp_WIDTH-1:0] DMOut_MEOp;
	wire [2:0] GPR_waddr_Sel;
	wire [2:0] GPRWd_Sel;
	wire [`GPRWr_WIDTH-1:0] GPRWr;
	wire stall_D;
	wire flush_F;
	wire flush_D;
	wire flush_E;
	wire flush_M;
	wire flush_W;
	wire pipeRegWr_F;
	wire pipeRegWr_D;
	wire pipeRegWr_E;
	wire pipeRegWr_M;
	wire pipeRegWr_W;
	wire GPR_rd2_D_rGrp_0;
	wire GPR_rd2_D_rGrp_1;
	wire GPR_rd2_E_rGrp_1;
	wire GPR_rd1_D_rGrp_0;
	wire GPR_rd1_D_rGrp_1;
	wire GPR_rd1_E_rGrp_1;
	wire GPRWd_E_wGrp_0;
	wire GPRWd_M_wGrp_0;
	wire GPRWd_W_wGrp_0;
	wire GPRWd_E_wGrp_1;
	wire GPRWd_M_wGrp_1;
	wire GPRWd_W_wGrp_1;
	wire GPRWd_E_wGrp_2;
	wire GPRWd_M_wGrp_2;
	wire GPRWd_W_wGrp_2;
	wire GPRWd_E_wGrp_3;
	wire GPRWd_M_wGrp_3;
	wire GPRWd_W_wGrp_3;
	wire [2:0] GPR_rd2_D_Bp_Sel;
	wire [2:0] GPR_rd1_D_Bp_Sel;
	wire [2:0] GPR_rd1_E_Bp_Sel;
	wire [2:0] GPR_rd2_E_Bp_Sel;

	reg flush_F_r;
	reg flush_D_r;
	reg flush_E_r;
	reg flush_M_r;
	reg flush_W_r;

	assign NPCOp = flush_D ? 0 :
		((Instr_D[`OP] ==  `BEQ_OP)) ? `NPCOp_BRANCH :
		((Instr_D[`OP] ==  `JAL_OP)) ? `NPCOp_JUMP :
		((Instr_D[`OP] == `SUBU_OP) || (Instr_D[`OP] ==  `ORI_OP) || 
		 (Instr_D[`OP] ==  `LUI_OP) || (Instr_D[`OP] ==   `LW_OP) || (Instr_D[`OP] ==   `SW_OP) || (Instr_D[`OP] ==   `SW_OP)) ? `NPCOp_PLUS4 :
		((Instr_D[`OP] ==   `JR_OP)) ? `NPCOp_JR : 0;

	assign BrCmp_Op = flush_D ? 0 :
		((Instr_D[`OP] ==  `BEQ_OP)) ? `BEQ_CMP : 0;

	assign ALUOp = flush_E ? 0 :
		((Instr_E[`OP] == `SUBU_OP)) ? `ALUOp_SUBU :
		((Instr_E[`OP] ==  `LUI_OP) || (Instr_E[`OP] ==   `LW_OP) || 
		 (Instr_E[`OP] ==   `SW_OP) || (Instr_E[`OP] ==   `SW_OP)) ? `ALUOp_ADDU :
		((Instr_E[`OP] ==  `ORI_OP)) ? `ALUOp_OR : 0;

	assign ExtOp = flush_E ? 0 :
		((Instr_E[`OP] ==  `LUI_OP)) ? `ExtOp_HIGH16 :
		((Instr_E[`OP] ==   `LW_OP) || (Instr_E[`OP] ==   `SW_OP) || (Instr_E[`OP] ==   `SW_OP)) ? `ExtOp_UNSIGN : 0;

	assign ALU_B_Sel = 
		((Instr_E[`OP] == `SUBU_OP) || (Instr_E[`OP] == `SUBU_OP)) ? 2'd0 :
		((Instr_E[`OP] ==  `LUI_OP) || (Instr_E[`OP] ==   `LW_OP) || 
		 (Instr_E[`OP] ==   `SW_OP) || (Instr_E[`OP] ==   `SW_OP)) ? 2'd1 : 0;

	assign DMWr = flush_M ? 0 :
		((Instr_M[`OP] ==   `SW_OP)) ? 1'b1 : 0;

	assign DMIn_BEOp = flush_M ? 0 :
		((Instr_M[`OP] ==   `SW_OP)) ? `DMIn_BEOp_SW : 0;

	assign DMOut_MEOp = flush_M ? 0 :
		((Instr_M[`OP] ==   `LW_OP)) ? `DMOut_MEOp_LW : 0;

	assign GPR_waddr_Sel = 
		((Instr_W[`OP] ==  `JAL_OP)) ? 3'd0 :
		((Instr_W[`OP] == `SUBU_OP) || (Instr_W[`OP] == `SUBU_OP)) ? 3'd1 :
		((Instr_W[`OP] ==  `LUI_OP) || (Instr_W[`OP] ==   `LW_OP) || (Instr_W[`OP] ==   `LW_OP)) ? 3'd2 : 0;

	assign GPRWd_Sel = 
		((Instr_W[`OP] ==   `LW_OP)) ? 3'd0 :
		((Instr_W[`OP] == `SUBU_OP) || (Instr_W[`OP] ==  `ORI_OP) || 
		 (Instr_W[`OP] ==  `LUI_OP) || (Instr_W[`OP] ==  `LUI_OP)) ? 3'd1 :
		((Instr_W[`OP] ==  `JAL_OP)) ? 3'd2 : 0;

	assign GPRWr = flush_W ? 0 :
		((Instr_W[`OP] == `SUBU_OP) || (Instr_W[`OP] ==  `ORI_OP) || 
		 (Instr_W[`OP] ==  `LUI_OP) || (Instr_W[`OP] ==   `LW_OP) || (Instr_W[`OP] ==  `JAL_OP) || (Instr_W[`OP] ==  `JAL_OP)) ? 1'b1 : 0;

	assign PCWr = ~(stall_D);
	assign flush_F = flush_F_r;
	assign flush_D = stall_D || flush_D_r;
	assign flush_E = flush_E_r;
	assign flush_M = flush_M_r;
	assign flush_W = flush_W_r;

	assign pipeRegWr_F = ~(stall_D);
	assign pipeRegWr_D = ~(stall_D);
	assign pipeRegWr_E = 1'b1;
	assign pipeRegWr_M = 1'b1;
	assign pipeRegWr_W = 1'b1;

	assign GPR_rd2_D_rGrp_0 = ~flush_D && (
		(Instr_D[`OP] ==  `BEQ_OP)
	);

	assign GPR_rd2_D_rGrp_1 = ~flush_D && (
		(Instr_D[`OP] == `ADDU_OP) || 
		(Instr_D[`OP] == `SUBU_OP) || 
		(Instr_D[`OP] ==   `SW_OP)
	);

	assign GPR_rd2_E_rGrp_1 = ~flush_E && (
		(Instr_E[`OP] == `ADDU_OP) || 
		(Instr_E[`OP] == `SUBU_OP) || 
		(Instr_E[`OP] ==   `SW_OP)
	);

	assign GPR_rd1_D_rGrp_0 = ~flush_D && (
		(Instr_D[`OP] ==  `BEQ_OP) || 
		(Instr_D[`OP] ==   `JR_OP)
	);

	assign GPR_rd1_D_rGrp_1 = ~flush_D && (
		(Instr_D[`OP] == `ADDU_OP) || 
		(Instr_D[`OP] == `SUBU_OP) || 
		(Instr_D[`OP] ==   `SW_OP) || 
		(Instr_D[`OP] ==   `LW_OP) || 
		(Instr_D[`OP] ==  `ORI_OP) || 
		(Instr_D[`OP] ==  `LUI_OP)
	);

	assign GPR_rd1_E_rGrp_1 = ~flush_E && (
		(Instr_E[`OP] == `ADDU_OP) || 
		(Instr_E[`OP] == `SUBU_OP) || 
		(Instr_E[`OP] ==   `SW_OP) || 
		(Instr_E[`OP] ==   `LW_OP) || 
		(Instr_E[`OP] ==  `ORI_OP) || 
		(Instr_E[`OP] ==  `LUI_OP)
	);

	assign GPRWd_E_wGrp_0 = ~flush_E && (
		(Instr_E[`OP] ==   `LW_OP)
	);

	assign GPRWd_M_wGrp_0 = ~flush_M && (
		(Instr_M[`OP] ==   `LW_OP)
	);

	assign GPRWd_W_wGrp_0 = ~flush_W && (
		(Instr_W[`OP] ==   `LW_OP)
	);

	assign GPRWd_E_wGrp_1 = ~flush_E && (
		(Instr_E[`OP] == `ADDU_OP) || 
		(Instr_E[`OP] == `SUBU_OP)
	);

	assign GPRWd_M_wGrp_1 = ~flush_M && (
		(Instr_M[`OP] == `ADDU_OP) || 
		(Instr_M[`OP] == `SUBU_OP)
	);

	assign GPRWd_W_wGrp_1 = ~flush_W && (
		(Instr_W[`OP] == `ADDU_OP) || 
		(Instr_W[`OP] == `SUBU_OP)
	);

	assign GPRWd_E_wGrp_2 = ~flush_E && (
		(Instr_E[`OP] ==  `LUI_OP) || 
		(Instr_E[`OP] ==  `ORI_OP)
	);

	assign GPRWd_M_wGrp_2 = ~flush_M && (
		(Instr_M[`OP] ==  `LUI_OP) || 
		(Instr_M[`OP] ==  `ORI_OP)
	);

	assign GPRWd_W_wGrp_2 = ~flush_W && (
		(Instr_W[`OP] ==  `LUI_OP) || 
		(Instr_W[`OP] ==  `ORI_OP)
	);

	assign GPRWd_E_wGrp_3 = ~flush_E && (
		(Instr_E[`OP] ==  `JAL_OP)
	);

	assign GPRWd_M_wGrp_3 = ~flush_M && (
		(Instr_M[`OP] ==  `JAL_OP)
	);

	assign GPRWd_W_wGrp_3 = ~flush_W && (
		(Instr_W[`OP] ==  `JAL_OP)
	);

	assign GPR_rd2_D_Bp_Sel = 
		(        GPR_rd2_D_rGrp_0 && GPRWd_E_wGrp_3 && Instr_D[20:16]==32'd31) ? 4 :
		(GPR_rd2_D_rGrp_0 && GPRWd_M_wGrp_1 && Instr_D[20:16]==Instr_M[15:11]) ? 2 :
		(GPR_rd2_D_rGrp_0 && GPRWd_M_wGrp_2 && Instr_D[20:16]==Instr_M[20:16]) ? 2 :
		(        GPR_rd2_D_rGrp_0 && GPRWd_M_wGrp_3 && Instr_D[20:16]==32'd31) ? 5 :
		(GPR_rd2_D_rGrp_0 && GPRWd_W_wGrp_0 && Instr_D[20:16]==Instr_W[20:16]) ? 1 :
		(GPR_rd2_D_rGrp_0 && GPRWd_W_wGrp_1 && Instr_D[20:16]==Instr_W[15:11]) ? 3 :
		(GPR_rd2_D_rGrp_0 && GPRWd_W_wGrp_2 && Instr_D[20:16]==Instr_W[20:16]) ? 3 :
		(        GPR_rd2_D_rGrp_0 && GPRWd_W_wGrp_3 && Instr_D[20:16]==32'd31) ? 6 :
		                                                                         0 ;

	assign GPR_rd1_D_Bp_Sel = 
		(        GPR_rd1_D_rGrp_0 && GPRWd_E_wGrp_3 && Instr_D[25:21]==32'd31) ? 4 :
		(GPR_rd1_D_rGrp_0 && GPRWd_M_wGrp_1 && Instr_D[25:21]==Instr_M[15:11]) ? 2 :
		(GPR_rd1_D_rGrp_0 && GPRWd_M_wGrp_2 && Instr_D[25:21]==Instr_M[20:16]) ? 2 :
		(        GPR_rd1_D_rGrp_0 && GPRWd_M_wGrp_3 && Instr_D[25:21]==32'd31) ? 5 :
		(GPR_rd1_D_rGrp_0 && GPRWd_W_wGrp_0 && Instr_D[25:21]==Instr_W[20:16]) ? 1 :
		(GPR_rd1_D_rGrp_0 && GPRWd_W_wGrp_1 && Instr_D[25:21]==Instr_W[15:11]) ? 3 :
		(GPR_rd1_D_rGrp_0 && GPRWd_W_wGrp_2 && Instr_D[25:21]==Instr_W[20:16]) ? 3 :
		(        GPR_rd1_D_rGrp_0 && GPRWd_W_wGrp_3 && Instr_D[25:21]==32'd31) ? 6 :
		                                                                         0 ;

	assign GPR_rd1_E_Bp_Sel = 
		(GPR_rd1_D_rGrp_1 && GPRWd_M_wGrp_1 && Instr_E[25:21]==Instr_M[15:11]) ? 2 :
		(GPR_rd1_D_rGrp_1 && GPRWd_M_wGrp_2 && Instr_E[25:21]==Instr_M[20:16]) ? 2 :
		(        GPR_rd1_D_rGrp_1 && GPRWd_M_wGrp_3 && Instr_E[25:21]==32'd31) ? 4 :
		(GPR_rd1_D_rGrp_1 && GPRWd_W_wGrp_0 && Instr_E[25:21]==Instr_W[20:16]) ? 1 :
		(GPR_rd1_D_rGrp_1 && GPRWd_W_wGrp_1 && Instr_E[25:21]==Instr_W[15:11]) ? 3 :
		(GPR_rd1_D_rGrp_1 && GPRWd_W_wGrp_2 && Instr_E[25:21]==Instr_W[20:16]) ? 3 :
		(        GPR_rd1_D_rGrp_1 && GPRWd_W_wGrp_3 && Instr_E[25:21]==32'd31) ? 5 :
		                                                                         0 ;

	assign GPR_rd2_E_Bp_Sel = 
		(GPR_rd2_D_rGrp_1 && GPRWd_M_wGrp_1 && Instr_E[20:16]==Instr_M[15:11]) ? 2 :
		(GPR_rd2_D_rGrp_1 && GPRWd_M_wGrp_2 && Instr_E[20:16]==Instr_M[20:16]) ? 2 :
		(        GPR_rd2_D_rGrp_1 && GPRWd_M_wGrp_3 && Instr_E[20:16]==32'd31) ? 4 :
		(GPR_rd2_D_rGrp_1 && GPRWd_W_wGrp_0 && Instr_E[20:16]==Instr_W[20:16]) ? 1 :
		(GPR_rd2_D_rGrp_1 && GPRWd_W_wGrp_1 && Instr_E[20:16]==Instr_W[15:11]) ? 3 :
		(GPR_rd2_D_rGrp_1 && GPRWd_W_wGrp_2 && Instr_E[20:16]==Instr_W[20:16]) ? 3 :
		(        GPR_rd2_D_rGrp_1 && GPRWd_W_wGrp_3 && Instr_E[20:16]==32'd31) ? 5 :
		                                                                         0 ;


	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			flush_F_r <= 1'b1;
			flush_D_r <= 1'b1;
			flush_E_r <= 1'b1;
			flush_M_r <= 1'b1;
			flush_W_r <= 1'b1;
		end
		else begin
			flush_F_r <= 1'b0;
			flush_D_r <= flush_F;
			flush_E_r <= flush_D;
			flush_M_r <= flush_E;
			flush_W_r <= flush_M;
		end
	end // end always

endmodule
