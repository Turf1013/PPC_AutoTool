/*
 * Description: This module is all about definition of NPC.
 * Author: ZengYX
 * Date:   2014.8.1
 */
`include "ctrl_encode_def.v" 
`include "arch_def.v"
`include "SPR_def.v"

module NPC (
	Imm26, Op, PC, PCB, CRrd,
	CTRrd, LRrd, NPC, CTRwd, LRwd
);

	input  [0:25] 				Imm26;
	input  [0:`NPCOp_WIDTH-1] 	Op;
	input  [0:`PC_WIDTH-1]    	PC;
	input  [0:`PC_WIDTH-1]    	PCB;	// PC of Branch Insn
	input  [0:`CR_WIDTH-1]	  	CRrd;
	input  [0:`CTR_WIDTH-1]	  	CTRrd;
	input  [0:`LR_WIDTH-1]	  	LRrd;
	output [0:`PC_WIDTH-1]    	NPC;
	output [0:`CTR_WIDTH-1]   	CTRwd;
	output [0:`LR_WIDTH-1]	  	LRwd;
	
	
	reg [0:`PC_WIDTH-1] NPC;
	
	
	wire [0:`NPC_LI_WIDTH-1] LI;
	wire [0:`NPC_BO_WIDTH-1] BO;
	wire [0:`NPC_BI_WIDTH-1] BI;
	wire [0:`NPC_BD_WIDTH-1] BD;
	wire [0:`NPC_AA_WIDTH-1] AA;
	wire [0:`NPC_LK_WIDTH-1] LK;
	
	assign LI = Imm26`NPC_LI_RANGE;
	assign BO = Imm26`NPC_BO_RANGE;
	assign BI = Imm26`NPC_BI_RANGE;
	assign BD = Imm26`NPC_BD_RANGE;
	assign AA = Imm26`NPC_AA_RANGE;
	assign LK = Imm26`NPC_LK_RANGE;
	
	/*
	* Logic of NPC consists of 4 Insn:
		(1) B;
		(2) BC;
		(3) BCCTR;
		(4) BCLR.
	*/
	
	wire [0:`PC_WIDTH-1] PC_PLUS4, PCB_PLUS4;
	
	assign PC_PLUS4 = PC + 32'd4;
	assign PCB_PLUS4 = PCB + 32'd4;
	
	// logic of ctr_ok & cond_ok
	wire ctr_ok, cond_ok;
	
	assign ctr_ok = BO[2] | ((CTRwd != 0) ^ BO[3]);
	assign cond_ok = BO[0] | (CRrd[BI] == BO[1]);
	
	// logic of Ext-Imm & handle AA
	wire [0:`PC_WIDTH-1] Ext_LI, Ext_BD, NPC_Base;
	
	assign Ext_LI = {{ 6{LI[0]}}, LI, 2'b00};
	assign Ext_BD = {{16{BD[0]}}, BD, 2'b00};
	assign NPC_Base = (AA == 1'b1) ? 32'd0 : PCB;
	
	// logic of NPC
	
	always @( * ) begin
		case ( Op )
		
			`NPCOp_PLUS4: begin
				NPC = PC_PLUS4;
			end
			
			`NPCOp_B: begin
				NPC = NPC_Base + Ext_LI;
			end
			
			`NPCOp_BC: begin
				if (ctr_ok & cond_ok)
					NPC = NPC_Base + Ext_BD;
				else
					NPC = PCB_PLUS4;
			end
			
			`NPCOp_BCCTR: begin
				if (cond_ok)
					NPC = {CTRrd[0:`CTR_WIDTH-3], 2'b00};
				else
					NPC = PCB_PLUS4;
			end
			
			`NPCOp_BCLR: begin
				if (ctr_ok & cond_ok)
					NPC = {LRrd[0:`LR_WIDTH-3], 2'b00};
				else
					NPC = PCB_PLUS4;
			end
			
			default: begin
				NPC = PC_PLUS4;	// wrong
			end
			
		endcase
	end // end always
	
	assign LRwd = PCB_PLUS4;
	assign CTRwd = (BO[2]) ? CTRrd : CTRrd - 32'd1;
	
	
endmodule
