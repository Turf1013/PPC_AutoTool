/**
	\author: 	Trasier
	\date: 		2017/5/9
	\brief: 	Circuit of DSI and ISI
*/
`include "MSR_def.v"

module DSI (
	MSR, entry_RW,
	isLoad, isStore,
	dsi, ack, clk, rst
);

	input [0:31] MSR;
	input isLoad, isStore;
	input [3:0] entry_RW;
	output dsi;
	input ack;
	input clk, rst;
	
	wire MSR_PR;
	
	assign MSR_PR = MSR[`MSR_PR];
	
	wire UR, SR, UW, SW
	assign {UR, SR, UW, SW} = entry_RW;
	
	wire readException, writeException;
	
	assign readException = (MSR_PR && isLoad && ~UR) || 
						   (~MSR_PR & isLoad && ~SR) ;
						   
	assign writeException = (MSR_PR && isWrite && ~UW) || 
							(~MSR_PR && isWrite && ~SW) ;
				
	wire req;
	assign req = readException | writeException;
	
	reg dsi_r;
	
	always @(posedge clk) begin
		if (rst) begin
			dsi_r <= 1'b0;
		end
		else if (ack) begin
			dsi_r <= 1'b0;
		end
		else begin
			dsi_r <= dsi_r | req;
		end
	end // end always
	
	assign dsi = dsi_r;

endmodule

module ISI (
	MSR, entry_X,
	isFetch,
	isi, ack, clk, rst
);

	input [0:31] MSR;
	input isFetch;
	input [1:0] entry_X;
	output isi;
	input ack;
	input clk, rst;
	
	wire MSR_PR;
	
	assign MSR_PR = MSR[`MSR_PR];
	
	wire UX, SX;
	
	assign {UX, SX} = entry_X;
	
	wire executeException;
	
	assign executeException = (MSR_PR && isFetch && ~UX) || 
							  (~MSR_PR && isFetch && ~SX) ;
							  
	wire req;						  
	assign req = executeException;
	
	reg isi_r;
	
	always @(posedge clk) begin
		if (rst) begin
			isi_r <= 1'b0;
		end
		else if (ack) begin
			isi_r <= 1'b0;
		end
		else begin
			isi_r <= isi_r | req;
		end
	end // end always
	
	assign isi = isi_r;

endmodule

