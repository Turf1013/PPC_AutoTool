/*
 * Description: This module is all about definition of NPC.
 * Author: ZengYX
 * Date:   2014.8.1
 */
`include "cu_def.v" 
`include "arch_def.v"

module NPC (
	AA, Imm24, NPCOp, PC, CR,
	CTR, LR, NPC, NPC_CTRWd, NPC_LRWd
);

	//input  [0:`BO_WIDTH-1]    BO;
	input					  AA;
	input  [0:`IMM24_WIDTH-1] Imm24;
	input  [0:`NPCOp_WIDTH-1] NPCOp;
	input  [0:`PC_WIDTH-1]    PC;
	input  [0:`CR_WIDTH-1]	  CR;
	input  [0:`CTR_WIDTH-1]	  CTR;
	input  [0:`LR_WIDTH-1]	  LR;
	output [0:`PC_WIDTH-1]    NPC;
	output [0:`CTR_WIDTH-1]   NPC_CTRWd;
	output [0:`LR_WIDTH-1]	  NPC_LRWd;
	
	wire [0:`LI_WIDTH-1] LI;
	wire [0:`BO_WIDTH-1] BO;
	wire [0:`BI_WIDTH-1] BI;
	wire [0:`BD_WIDTH-1] BD;
	
	assign BO = Imm24[0:`BO_WIDTH-1];
	
	// logic of ctr_ok & cond_ok
	wire ctr_ok, cond_ok;
	
	assign ctr_ok = BO[2] | ((NPC_CTRWd != 0) ^ BO[3]);
	assign cond_ok = BO[0] | (CR[BI] == BO[1]);
	
	// logic of Ext-Imm & handle AA
	wire [0:`PC_WIDTH-1] Ext_LI, Ext_BD, NPC_Base;
	
	assign Ext_LI = {{ 6{LI[0]}}, LI, 2'b00};
	assign Ext_BD = {{16{LI[0]}}, BD, 2'b00};
	assign NPC_Base = (AA) ? 0:PC;
	
	// logic of NPC
	reg [0:`PC_WIDTH-1]  NPC;
	
	wire [0:`PC_WIDTH-1] PC_PLUS4;
	
	assign PC_PLUS4 = PC + 4;
	
	always @(*) begin
		case (NPCOp)
			`NPCOp_PLUS4: begin
				NPC = PC_PLUS4;
			end
			`NPCOp_JUMP: begin
				NPC = NPC_Base + Ext_LI;
			end
			`NPCOp_BRANCH: begin
				if (ctr_ok & cond_ok)
					NPC = NPC_Base + Ext_BD;
				else
					NPC = PC;
			end
			`NPCOp_CTR: begin
				if (ctr_ok)
					NPC = {CTR[0:`CTR_WIDTH-3], 2'b00};
				else
					NPC = PC;
			end
			`NPCOp_LR: begin
				if (ctr_ok & cond_ok)
					NPC = {CTR[0:`LR_WIDTH-3], 2'b00};
				else
					NPC = PC;
			end
			default: begin
				NPC = PC + 4;	// wrong
			end
		endcase
	end // end always
	
	assign NPC_LRWd = PC_PLUS4;
	assign NPC_CTRWd = (BO[2]) ? CTR:CTR-1;
	
	
endmodule
