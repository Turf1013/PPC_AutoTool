module decoder2to4 (
	din, dout
);

	input [0:1] din;
	output [0:3] dout;
	/*
	reg [0:3] dout;
	always @(din) begin
		case (din)
			2'd0: dout = 4'h1;
			2'd1: dout = 4'h2;
			2'd2: dout = 4'h4;
			2'd3: dout = 4'h8;
			default: ;
		endcase
	end // end always
	*/
	
	assign dout = (4'h1 << din);
	
endmodule

module decoder3to8 (
	din, dout
);

	input [0:2] din;
	output [0:7] dout;
	/*
	reg [0:3] dout;
	always @(din) begin
		case (din)
			3'd0: dout = 8'h1;
			3'd1: dout = 8'h2;
			3'd2: dout = 8'h4;
			3'd3: dout = 8'h8;
			3'd4: dout = 8'h10;
			3'd5: dout = 8'h20;
			3'd6: dout = 8'h40;
			3'd7: dout = 8'h80;
			default: ;
		endcase
	end // end always
	*/
	assign dout = (8'h1 << din);
	
endmodule
