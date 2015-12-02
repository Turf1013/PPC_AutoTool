`include "arch_def.v"
`include "ctrl_encode_def.v"
`include "default_def.v"
`include "instruction_def.v"

module control (
	clr_M, clr_W, BrCmp_Op_D, GPR_rd1_D_Bmux_sel, DMOut_ME_Op_M, 
	clr_D, GPR_rd0_E_Bmux_sel, GPR_wr_W, ALU_Op_E, GPR_rd1_E_Bmux_sel, 
	NPC_Op_D, stall, DM_wr_M, clr_E, GPR_rd0_D_Bmux_sel, 
	Ext_Op_E, DMIn_BE_Op_M, 
	Instr_D, Instr_E, Instr_M, Instr_W,
	clk, rst_n
);
	// input statement
	input clk, rst_n;
	input [`INSTR_WIDTH-1:0] Instr_D, Instr_E, Instr_M, Instr_W;

	// output statement
	output [0:0] clr_M;
	output [0:0] clr_W;
	output [`BrCmp_Op_WIDTH-1:0] BrCmp_Op_D;
	output [2:0] GPR_rd1_D_Bmux_sel;
	output [`DMOut_MEOp_WIDTH-1:0] DMOut_ME_Op_M;
	output [0:0] clr_D;
	output [1:0] GPR_rd0_E_Bmux_sel;
	output [0:0] GPR_wr_W;
	output [`ALUOp_WIDTH-1:0] ALU_Op_E;
	output [1:0] GPR_rd1_E_Bmux_sel;
	output [`NPCOp_WIDTH-1:0] NPC_Op_D;
	output [0:0] stall;
	output [0:0] DM_wr_M;
	output [0:0] clr_E;
	output [2:0] GPR_rd0_D_Bmux_sel;
	output [`ExtOp_WIDTH-1:0] Ext_Op_E;
	output [`DMIn_BEOp_WIDTH-1:0] DMIn_BE_Op_M;

	// wire statement
	reg [`ALUOp_WIDTH-1:0] ALU_Op_E;
	reg [`BrCmp_Op_WIDTH-1:0] BrCmp_Op_D;
	reg [`DMIn_BEOp_WIDTH-1:0] DMIn_BE_Op_M;
	reg [`DMOut_MEOp_WIDTH-1:0] DMOut_ME_Op_M;
	reg [0:0] DM_wr_M;
	reg [`ExtOp_WIDTH-1:0] Ext_Op_E;
	reg [2:0] GPR_rd0_D_Bmux_sel;
	reg [1:0] GPR_rd0_E_Bmux_sel;
	reg [2:0] GPR_rd1_D_Bmux_sel;
	reg [1:0] GPR_rd1_E_Bmux_sel;
	reg [0:0] GPR_wr_W;
	reg [`NPCOp_WIDTH-1:0] NPC_Op_D;
	reg [0:0] stall;
	reg [0:0] clr_D;
	reg [0:0] clr_E;
	reg [0:0] clr_M;
	reg [0:0] clr_W;




	// Ctrl Signal
	/*********   Logic of GPR_rd0_D_Bmux_sel   *********/
	always @( * ) begin
		if ( clr_D ) begin
			GPR_rd0_D_Bmux_sel = 3'd0;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd0_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_D_Bmux_sel = 3'd1;
		end
		else begin
			GPR_rd0_D_Bmux_sel = 3'd0;
		end
	end // end always

	/*********   Logic of GPR_rd0_E_Bmux_sel   *********/
	always @( * ) begin
		if ( clr_E ) begin
			GPR_rd0_E_Bmux_sel = 2'd0;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd0_E_Bmux_sel = 2'd1;
		end
		else begin
			GPR_rd0_E_Bmux_sel = 2'd0;
		end
	end // end always

	/*********   Logic of GPR_rd1_D_Bmux_sel   *********/
	always @( * ) begin
		if ( clr_D ) begin
			GPR_rd1_D_Bmux_sel = 3'd0;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_E[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd4;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd2;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd3;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd1;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_W[15:11]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd5;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b000011) && 1'b1 && (Instr_D[25:21] == 32'd31) ) begin
			GPR_rd1_D_Bmux_sel = 3'd6;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_D_Bmux_sel = 3'd1;
		end
		else begin
			GPR_rd1_D_Bmux_sel = 3'd0;
		end
	end // end always

	/*********   Logic of GPR_rd1_E_Bmux_sel   *********/
	always @( * ) begin
		if ( clr_E ) begin
			GPR_rd1_E_Bmux_sel = 2'd0;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_M[31:26]==6'b001001) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_M[31:26]==6'b001101) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_M[31:26]==6'b000000) && 1'b1 && (Instr_E[25:21] == Instr_M[15:11]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_M[31:26]==6'b001111) && 1'b1 && (Instr_E[25:21] == Instr_M[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd2;
		end
		else if ( (Instr_E[31:26]==6'b001111) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b100011) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b001001) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b001101) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b000000) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd1;
		end
		else if ( (Instr_E[31:26]==6'b101011) && (Instr_W[31:26]==6'b100011) && 1'b1 && (Instr_E[25:21] == Instr_W[20:16]) ) begin
			GPR_rd1_E_Bmux_sel = 2'd1;
		end
		else begin
			GPR_rd1_E_Bmux_sel = 2'd0;
		end
	end // end always

	/*********   Logic of stall   *********/
	always @( * ) begin
		if ( clr_D ) begin
			stall = 1'd0;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_E[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_E[15:11]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_E[31:26]==6'b001001) && 1'b1 && (Instr_D[25:21] == Instr_E[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_E[31:26]==6'b001101) && 1'b1 && (Instr_D[25:21] == Instr_E[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_E[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_E[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_E[31:26]==6'b000000) && 1'b1 && (Instr_D[25:21] == Instr_E[15:11]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_E[31:26]==6'b001111) && 1'b1 && (Instr_D[25:21] == Instr_E[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b100011) && (Instr_M[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b001111) && (Instr_M[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b001101) && (Instr_M[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b101011) && (Instr_M[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b000100) && (Instr_M[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b000000) && (Instr_M[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			stall = 1'd1;
		end
		else if ( (Instr_D[31:26]==6'b001001) && (Instr_M[31:26]==6'b100011) && 1'b1 && (Instr_D[25:21] == Instr_M[20:16]) ) begin
			stall = 1'd1;
		end
		else begin
			stall = 1'd0;
		end
	end // end always

	/*********   Logic of BrCmp_Op_D   *********/
	always @( * ) begin
		if ( clr_D ) begin
			BrCmp_Op_D = 0;
		end
		else if ( (Instr_D[31:26]==6'b000100) ) begin
			BrCmp_Op_D = `BEQ_CMP;
		end
		else begin
			BrCmp_Op_D = 0;
		end
	end // end always

	/*********   Logic of NPC_Op_D   *********/
	always @( * ) begin
		if ( clr_D ) begin
			NPC_Op_D = 0;
		end
		else if ( (Instr_D[31:26]==6'b001101) ) begin
			NPC_Op_D = `NPCOp_PLUS4;
		end
		else if ( (Instr_D[31:26]==6'b000000) ) begin
			NPC_Op_D = `NPCOp_PLUS4;
		end
		else if ( (Instr_D[31:26]==6'b100011) ) begin
			NPC_Op_D = `NPCOp_PLUS4;
		end
		else if ( (Instr_D[31:26]==6'b001001) ) begin
			NPC_Op_D = `NPCOp_PLUS4;
		end
		else if ( (Instr_D[31:26]==6'b001111) ) begin
			NPC_Op_D = `NPCOp_PLUS4;
		end
		else if ( (Instr_D[31:26]==6'b101011) ) begin
			NPC_Op_D = `NPCOp_PLUS4;
		end
		else if ( (Instr_D[31:26]==6'b000000) ) begin
			NPC_Op_D = `NPCOp_PLUS4;
		end
		else if ( (Instr_D[31:26]==6'b000100) ) begin
			NPC_Op_D = `NPCOp_BRANCH;
		end
		else if ( (Instr_D[31:26]==6'b000010) ) begin
			NPC_Op_D = `NPCOp_JUMP;
		end
		else if ( (Instr_D[31:26]==6'b000011) ) begin
			NPC_Op_D = `NPCOp_JUMP;
		end
		else begin
			NPC_Op_D = 0;
		end
	end // end always

	/*********   Logic of Ext_Op_E   *********/
	always @( * ) begin
		if ( clr_E ) begin
			Ext_Op_E = 0;
		end
		else if ( (Instr_E[31:26]==6'b001111) ) begin
			Ext_Op_E = `ExtOp_HIGH16;
		end
		else if ( (Instr_E[31:26]==6'b101011) ) begin
			Ext_Op_E = `ExtOp_UNSIGN;
		end
		else if ( (Instr_E[31:26]==6'b100011) ) begin
			Ext_Op_E = `ExtOp_UNSIGN;
		end
		else if ( (Instr_E[31:26]==6'b001101) ) begin
			Ext_Op_E = `ExtOp_UNSIGN;
		end
		else if ( (Instr_E[31:26]==6'b001001) ) begin
			Ext_Op_E = `ExtOp_SIGNED;
		end
		else begin
			Ext_Op_E = 0;
		end
	end // end always

	/*********   Logic of ALU_Op_E   *********/
	always @( * ) begin
		if ( clr_E ) begin
			ALU_Op_E = 0;
		end
		else if ( (Instr_E[31:26]==6'b001111) ) begin
			ALU_Op_E = `ALUOp_ADDU;
		end
		else if ( (Instr_E[31:26]==6'b001101) ) begin
			ALU_Op_E = `ALUOp_OR;
		end
		else if ( (Instr_E[31:26]==6'b001001) ) begin
			ALU_Op_E = `ALUOp_ADDU;
		end
		else if ( (Instr_E[31:26]==6'b000000) ) begin
			ALU_Op_E = `ALUOp_ADDU;
		end
		else if ( (Instr_E[31:26]==6'b101011) ) begin
			ALU_Op_E = `ALUOp_ADDU;
		end
		else if ( (Instr_E[31:26]==6'b000000) ) begin
			ALU_Op_E = `ALUOp_SUBU;
		end
		else if ( (Instr_E[31:26]==6'b100011) ) begin
			ALU_Op_E = `ALUOp_ADDU;
		end
		else begin
			ALU_Op_E = 0;
		end
	end // end always

	/*********   Logic of DM_wr_M   *********/
	always @( * ) begin
		if ( clr_M ) begin
			DM_wr_M = 0;
		end
		else if ( (Instr_M[31:26]==6'b101011) ) begin
			DM_wr_M = 1'b1;
		end
		else begin
			DM_wr_M = 0;
		end
	end // end always

	/*********   Logic of DMOut_ME_Op_M   *********/
	always @( * ) begin
		if ( clr_M ) begin
			DMOut_ME_Op_M = 0;
		end
		else if ( (Instr_M[31:26]==6'b100011) ) begin
			DMOut_ME_Op_M = `DMOut_MEOp_LW;
		end
		else begin
			DMOut_ME_Op_M = 0;
		end
	end // end always

	/*********   Logic of DMIn_BE_Op_M   *********/
	always @( * ) begin
		if ( clr_M ) begin
			DMIn_BE_Op_M = 0;
		end
		else if ( (Instr_M[31:26]==6'b101011) ) begin
			DMIn_BE_Op_M = `DMIn_BEOp_SW;
		end
		else begin
			DMIn_BE_Op_M = 0;
		end
	end // end always

	/*********   Logic of GPR_wr_W   *********/
	always @( * ) begin
		if ( clr_W ) begin
			GPR_wr_W = 0;
		end
		else if ( (Instr_W[31:26]==6'b001111) ) begin
			GPR_wr_W = 1'b1;
		end
		else if ( (Instr_W[31:26]==6'b000000) ) begin
			GPR_wr_W = 1'b1;
		end
		else if ( (Instr_W[31:26]==6'b100011) ) begin
			GPR_wr_W = 1'b1;
		end
		else if ( (Instr_W[31:26]==6'b000011) ) begin
			GPR_wr_W = 1'b1;
		end
		else if ( (Instr_W[31:26]==6'b000000) ) begin
			GPR_wr_W = 1'b1;
		end
		else if ( (Instr_W[31:26]==6'b001001) ) begin
			GPR_wr_W = 1'b1;
		end
		else if ( (Instr_W[31:26]==6'b001101) ) begin
			GPR_wr_W = 1'b1;
		end
		else begin
			GPR_wr_W = 0;
		end
	end // end always





	// Clear Signal
	always @( posedge clk or negedge rst_n ) begin
		if ( !rst_n ) begin
			clr_E <= 1'b1;
			clr_M <= 1'b1;
			clr_W <= 1'b1;
		end
		else begin
			clr_E <= clr_D;
			clr_M <= clr_E;
			clr_W <= clr_M;
		end
	end // end always

	//// same meaning as clr_D = stall;
	always @( * ) begin
		clr_D <= stall;
	end // end always





endmodule

