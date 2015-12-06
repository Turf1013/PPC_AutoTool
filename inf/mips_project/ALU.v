`include "ctrl_encode_def.v"

module ALU (
	A, B, Op, C
);
           
	input  [31:0] A, B;
	input  [`ALUOp_WIDTH-1:0]  Op;
	output [31:0] C;

	wire signed [31:0] A, B;
	reg signed [31:0] C;

	integer    i;

	always @( * ) begin
		case ( Op )
			`ALUOp_MOVA: C = A;                       	// make C = A
			`ALUOp_MOVB: C = B;                       	// make C = B
			`ALUOp_ADD:  C = A + B;                    	// ADD
			`ALUOp_ADDU: C = A + B;                    	// ADDU
			`ALUOp_SUB:  C = A - B;                    	// SUB
			`ALUOp_SUBU: C = A - B;                    	// SUBU
			`ALUOp_AND:  C = A & B;                    	// AND/ANDI
			`ALUOp_OR:   C = A | B;                    	// OR/ORI
			`ALUOp_XOR:  C = A ^ B;                    	// XOR/XORI
			`ALUOp_NOR:  C = ~(A | B);                 	// NOR
			`ALUOp_SLL:  C = (B << A[4:0]);            	// SLL/SLLV
			`ALUOp_SRL:  C = (B >> A[4:0]);	           	// SRL/SRLV
			`ALUOp_SLT:  C = (A < B) ? 32'd1 : 32'd0;  	// SLT/SLTI
			`ALUOp_SLTU: C = ({1'b0, A} < {1'b0, B}) ? 32'd1 : 32'd0; // SLTU/SLTIU         
			`ALUOp_EQL:  C = (A == B) ? 32'd1 : 32'd0; 	// EQUAL
			`ALUOp_NEQ:  C = (A != B) ? 32'd1 : 32'd0; 	// NOT EQUAL
			`ALUOp_GT0:  C = (A >  0) ? 32'd1 : 32'd0; 	// Great than 0
			`ALUOp_GE0:  C = (A >= 0) ? 32'd1 : 32'd0; 	// Great than & equal 0
			`ALUOp_LT0:  C = (A <  0) ? 32'd1 : 32'd0; 	// Less than 0
			`ALUOp_LE0:  C = (A <= 0) ? 32'd1 : 32'd0; 	// Less than & equal 0
			`ALUOp_SRA: begin                          	// SRA/SRAV
				for(i=1; i<=A[4:0]; i=i+1)
					C[32-i] = B[31];
				for(i=31-A[4:0]; i>=0; i=i-1)
					C[i] = B[i+A[4:0]];
			end                             
			default:   C = 32'd0;                	   // Undefined
		endcase
	end // end always

endmodule
    
