/**
	\author: 	Trasier
	\date: 		2017/5/9
	\brief: 	Circuit of Program Error
*/
`include "sprn_def.v"

module programError (
	isUndefined, isPriveleged, isTraped
	isMoveSpr, sprn, MSR_PR, 
	progErr, ack, clk, rst,
	progErrCode;
);
	input isUndefined;
	input isPriveleged;
	input isTraped;
	input isMoveSpr;
	input [9:0] sprn;
	input MSR_PR;
	output progErr;
	output [2:0] progErrCode;
	input ack;
	input clk, rst;
	
	wire sprn_isExisted, sprn_isPriveleged;
	judgeSprn U_judgeSprn(
		.sprn(sprn),
		.isPriveleged(sprn_isPriveleged),
		.isExisted(sprn_isExisted)
	);
	
	wire illegalError;
	
	assign illegalError = (isUndefined) || 
						  (MSR_PR && isMoveSpr && ~sprn_isExisted);
	
	wire privelegeError;
	
	assign privelegeError = (MSR_PR && isPriveleged) ||
							(MSR_PR && isMoveSpr && sprn_isPriveleged);
	
	wire req;
	assign req = illegalError | privelegeError | isTraped;
	
	reg progErr_r;
	
	always @(posedge clk) begin
		if (rst) begin
			progErr_r <= 1'b0;
		end
		else if (ack) begin
			progErr_r <= 1'b0;
		end
		else begin
			progErr_r <= progErr_r | req;
		end
	end // end always
	
	assign progErr = progErr_r;
	
	assign progErrCode = {illegalError, privelegeError, isTraped};

endmodule

module judgeSprn ( 
	sprn, isExisted, isPriveleged
);

	input [9:0] sprn;
	output isExisted;
	output isPriveleged;
	
	reg isExisted;
	reg isPriveledged;
	
	always @(sprn) begin
		case (sprn)
			`SPRN_XER: begin
				isExisted = 1;
				isPriveledged = 0;
			end
			
			`SPRN_CTR: begin
				isExisted = 1;
				isPriveledged = 0;
			end
			
			`SPRN_LR: begin
				isExisted = 1;
				isPriveledged = 0;
			end
			
			`SPRN_IVPR: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_SRR0: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_SRR1: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_ESR: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_DEAR: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_IVOR2: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_IVOR3: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_IVOR13: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_IVOR14: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_IVOR6: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_IVOR8: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			`SPRN_IVOR4: begin
				isExisted = 1;
				isPriveledged = 1;
			end
			
			default: begin
				isExisted = 0;
				isPriveledged = 0;
			end

		endcase
	end // end always

endmodule

