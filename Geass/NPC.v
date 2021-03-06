`include "ctrl_encode_def.v"

module NPC (
	PC, Rs, NPCOp, Imm26, Comp, NPC, NPC_Laddr
);
    
   input  [31:0] PC;
   input  [31:0] Rs;
   input  [`NPCOp_WIDTH-1:0]  NPCOp;
   input  [25:0] Imm26;
   input		 Comp;
   output [31:0] NPC;
   output [31:0] NPC_Laddr;
   
   reg [31:2] NPC;
   
   wire [31:0] PC_PLUS4, PC_BRNACH, PC_JUMP, PC_Rs;
   
   assign PC_PLUS4 = PC + 4;
   assign PC_JUMP = {PC[31:28], Imm26[25:0], 2'b00};
   assign PC_BRANCH = PC + {{14{Imm26[15]}}, Imm26[15:0], 2'b00};
   assign PC_Rs = Rs;
   assign NPC_Laddr = PC + 8;
   
   always @(*) begin
      case (NPCOp)
          `NPCOp_PLUS4:		NPC = PC_PLUS4;
          `NPCOp_BRANCH: 	NPC = (Comp) ? PC_BRANCH : PC_PLUS4;
          `NPCOp_JUMP: 		NPC = PC_JUMP;
		  `NPCOp_JR: 		NPC = PC_Rs;
          default: ;
      endcase
   end // end always
   
endmodule

module BrCmp (
	A, B, Op, Comp
);
	input [31:0] A, B;
	input [`BrCmp_Op_WIDTH-1:0] Op;
	output Comp;
	
	reg Comp;
	
	always @( * ) begin
		case (Op)
			`BEQ_CMP: Comp = (A == B);
			default: Comp = 0;
		endcase
	end
	
endmodule

