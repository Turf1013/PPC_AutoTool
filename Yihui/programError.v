/**
	\author: 	Trasier
	\date: 		2017/5/9
	\brief: 	Circuit of Program Error
*/
`include "sprn_def.v"
`include "MSR_def.v"

module programError (
	isUndefined, isPriveleged, isTraped,
	isMoveSpr, sprn, MSR, 
	progErrCode, progErr, ack, 
	clk, rst
);
	input isUndefined;
	input isPriveleged;
	input isTraped;
	input isMoveSpr;
	input [9:0] sprn;
	input [0:31] MSR;
	output progErr;
	output [2:0] progErrCode;
	input ack;
	input clk, rst;
	
	wire MSR_PR;
	
	assign MSR_PR = MSR[`MSR_PR];
	
	wire sprn_illegalError, sprn_privelegeError;
	
	oneSprError U_oneSprError (
		.sprn(sprn), 
		.MSR_PR(MSR_PR),
		.isMoveSpr(isMoveSpr),
		.sprn_illegalError(sprn_illegalError), 
		.sprn_privelegeError(sprn_privelegeError)
	);
	
	wire illegalError;
	
	assign illegalError = isUndefined || sprn_illegalError;
	
	wire privelegeError;
	
	assign privelegeError = (MSR_PR && isPriveleged) || sprn_privelegeError;
	
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

module oneSprError (
	sprn, MSR_PR, isMoveSpr,
	sprn_illegalError, sprn_privelegeError
);

	input [9:0] sprn;
	input MSR_PR;
	input isMoveSpr;
	output sprn_illegalError;
	output sprn_privelegeError;
	
	wire sprn_isExisted, sprn_isPriveleged;
	judgeSprn U_judgeSprn(
		.sprn(sprn),
		.isPriveleged(sprn_isPriveleged),
		.isExisted(sprn_isExisted)
	);
	
	assign sprn_illegalError = (MSR_PR && isMoveSpr && ~sprn_isExisted);
	assign sprn_privelegeError = (MSR_PR && isMoveSpr && sprn_isPriveleged);

endmodule

module judgeSprn ( 
	sprn, isExisted, isPriveleged
);

	input [9:0] sprn;
	output isExisted;
	output isPriveleged;
	
	reg isExisted;
	reg isPriveleged;
	
	always @(sprn) begin
		case (sprn)
			`SPRN_XER: begin
				isExisted = 1;
				isPriveleged = 0;
			end
			
			`SPRN_CTR: begin
				isExisted = 1;
				isPriveleged = 0;
			end
			
			`SPRN_LR: begin
				isExisted = 1;
				isPriveleged = 0;
			end
			
			`SPRN_IVPR: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_SRR0: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_SRR1: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_ESR: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_DEAR: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_IVOR2: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_IVOR3: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_IVOR13: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_IVOR14: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_IVOR6: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_IVOR8: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			`SPRN_IVOR4: begin
				isExisted = 1;
				isPriveleged = 1;
			end
			
			default: begin
				isExisted = 0;
				isPriveleged = 0;
			end

		endcase
	end // end always

endmodule

