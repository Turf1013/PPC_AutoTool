`include "ctrl_encode_def.v"

module NPC (
	PC, Rs, Op, Imm26, Comp, NPC, Laddr
);
    
   input  [31:0] PC;
   input  [31:0] Rs;
   input  [`NPCOp_WIDTH-1:0]  Op;
   input  [25:0] Imm26;
   input		 Comp;
   output [31:0] NPC;
   output [31:0] Laddr;
   
   reg [31:0] NPC;
   
   wire [31:0] PC_PLUS4, PC_PLUS8, PC_BRANCH, PC_JUMP, PC_Rs;
   
   assign PC_PLUS4 = PC + 4;
   assign PC_PLUS8 = PC + 8;
   assign PC_JUMP = {PC[31:28], Imm26[25:0], 2'b00};
   assign PC_BRANCH = PC + {{14{Imm26[15]}}, Imm26[15:0], 2'b00};
   assign PC_Rs = Rs;
   assign Laddr = PC_PLUS4;
   
   always @(*) begin
      case (Op)
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
	
	wire signed [31:0] srcA, srcB;
	
	assign srcA = A;
	assign srcB = B;
	
	reg Comp;
	
	always @( * ) begin
		case (Op)
			`BrCmpOp_BEQ: 	Comp = (srcA == srcB);
			`BrCmpOp_BNE: 	Comp = (srcA != srcB);
			`BrCmpOp_BLEZ: 	Comp = (srcA <= 0);
			`BrCmpOp_BGTZ: 	Comp = (srcA >  0);
			`BrCmpOp_BLTZ: 	Comp = (srcA <  0);
			`BrCmpOp_BGEZ: 	Comp = (srcA >= 0);
			default: Comp = 0;
		endcase
	end
	
endmodule

