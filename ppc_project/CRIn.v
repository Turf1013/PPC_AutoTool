/*
 * Description: This module is all about CR.
 *		1. CRIn: Extender of CR_din;
 *		2. ALU_CRIn: Extender of CR_ALU_C;
 *		3. Mov_CRIn: Extender of mcrf value;
 * Author: ZengYX
 * Date:   2014.9.6
 */

`include "cu_def.v"
`include "arch_def.v"
module CRIn (
   ALU_CR0, CR_ALU_C, CR, BF, BT, BFA, Mov_CRWd, ALU_CRWd, CR0_CRWd, Cmp_CRWd
);

   input CR_ALU_C;
   input [0:`CR0_WIDTH-1] ALU_CR0;
   input [0:`CR_WIDTH-1] CR;
   input [0:4] BT;
   input [0:2] BF;
   input [0:2] BFA;
   output [0:`CR_WIDTH-1] Mov_CRWd;
   output [0:`CR_WIDTH-1] ALU_CRWd;
   output [0:`CR_WIDTH-1] CR0_CRWd;
   output [0:`CR_WIDTH-1] Cmp_CRWd;
      
   ALU_CRIn U_ALU_CRIn (
      .CR_ALU_C(CR_ALU_C), .CR(CR), .BT(BT), .ALU_CRWd(ALU_CRWd)
   );
   
   Mov_CRIn U_Mov_CRIn (
      .BF(BF), .BFA(BFA), .CR(CR), .Mov_CRWd(Mov_CRWd)
   );
   
   Cmp_CRIn U_Cmp_CRIn (
	  .BF(BF), .CR0(ALU_CR0), .CR(CR)
   );
   
   assign CR0_CRWd = {ALU_CR0, CR[8:`CR_WIDTH-1]};

endmodule

module Cmp_CRIn (
	BF, CR0, CR, Cmp_CRWd
);

	input [0:2] BF;
	input [0:`CR0_WIDTH-1] CR0;
	input [0:`CR_WIDTH-1] CR;
	output [0:`CR_WIDTH-1] Cmp_CRWd;
	
	wire [0:`CR_WIDTH-1] Cmp_Mask;
	wire [0:`CR_WIDTH-1] Cmp_tmp;
	
	assign Cmp_Mask = 32'hf000_0000>>{BF, 2'b00};
	assign Cmp_tmp = {CR0, 24'd0}>>{BF,2'b00};
	assign Cmp_CRWd = (CR & ~Cmp_Mask) | Cmp_tmp;

endmodule

module ALU_CRIn (
   CR_ALU_C, CR, BT, ALU_CRWd
);
   input CR_ALU_C;
   input [0:`CR_WIDTH-1] CR;
   input [0:4] BT;
   output [0:`CR_WIDTH-1] ALU_CRWd;
      
   wire [0:`CR_WIDTH-1] ALU_Mask, ALU_tmp;
   
   assign ALU_Mask = 32'h8000_0000>>BT;
   assign ALU_tmp = {CR_ALU_C, 31'h0}>>BT;
   assign ALU_CRWd = (CR & ~ALU_Mask) | ALU_tmp;
   
endmodule

module Mov_CRIn (
   BF, BFA, CR, Mov_CRWd
);
   input [0:2] BF;
   input [0:2] BFA;
   input [0:`CR_WIDTH-1] CR;
   output [0:`CR_WIDTH-1] Mov_CRWd;
   
   wire [0:`CR_WIDTH-1] Mov_Mask;
   wire [0:`CR_WIDTH-1] Movf_tmp, Movt_tmp;
   
   assign Mov_Mask = 32'hf000_0000>>{BF, 2'b00};
   assign Movf_tmp = CR<<{BFA, 2'b00};
   assign Movt_tmp = Movf_tmp>>{BF, 2'b00};
   assign Mov_CRWd = (CR & ~Mov_Mask) | (Movt_tmp & Mov_Mask);
   
endmodule

