module mux2 (
	din0, din1,
	sel, dout
);
	parameter WIDTH = 8;

	input [WIDTH-1:0] din0, din1;
	input [0:0] sel;
	output [WIDTH-1:0] dout;

	reg [WIDTH-1:0] dout_r;

	always @( * ) begin
		case ( sel )
			1'd0: dout_r = din0;
			1'd1: dout_r = din1;
		endcase
	end // end always

	assign dout = dout_r;

endmodule

module mux4 (
	din0, din1, din2, din3,
	sel, dout
);
	parameter WIDTH = 8;

	input [WIDTH-1:0] din0, din1, din2, din3;
	input [1:0] sel;
	output [WIDTH-1:0] dout;

	reg [WIDTH-1:0] dout_r;

	always @( * ) begin
		case ( sel )
			2'd0: dout_r = din0;
			2'd1: dout_r = din1;
			2'd2: dout_r = din2;
			2'd3: dout_r = din3;
		endcase
	end // end always

	assign dout = dout_r;

endmodule

module mux8 (
	din0, din1, din2, din3, din4, din5, din6, din7,
	sel, dout
);
	parameter WIDTH = 8;

	input [WIDTH-1:0] din0, din1, din2, din3, din4, din5, din6, din7;
	input [2:0] sel;
	output [WIDTH-1:0] dout;

	reg [WIDTH-1:0] dout_r;

	always @( * ) begin
		case ( sel )
			3'd0: dout_r = din0;
			3'd1: dout_r = din1;
			3'd2: dout_r = din2;
			3'd3: dout_r = din3;
			3'd4: dout_r = din4;
			3'd5: dout_r = din5;
			3'd6: dout_r = din6;
			3'd7: dout_r = din7;
		endcase
	end // end always

	assign dout = dout_r;

endmodule

module mux16 (
	din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11, din12, din13, din14, din15,
	sel, dout
);
	parameter WIDTH = 8;

	input [WIDTH-1:0] din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11, din12, din13, din14, din15;
	input [3:0] sel;
	output [WIDTH-1:0] dout;

	reg [WIDTH-1:0] dout_r;

	always @( * ) begin
		case ( sel )
			4'd0: dout_r = din0;
			4'd1: dout_r = din1;
			4'd2: dout_r = din2;
			4'd3: dout_r = din3;
			4'd4: dout_r = din4;
			4'd5: dout_r = din5;
			4'd6: dout_r = din6;
			4'd7: dout_r = din7;
			4'd8: dout_r = din8;
			4'd9: dout_r = din9;
			4'd10: dout_r = din10;
			4'd11: dout_r = din11;
			4'd12: dout_r = din12;
			4'd13: dout_r = din13;
			4'd14: dout_r = din14;
			4'd15: dout_r = din15;
		endcase
	end // end always

	assign dout = dout_r;

endmodule

module mux32 (
	din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11, din12, din13, din14, din15, din16, din17, din18, din19, din20, din21, din22, din23, din24, din25, din26, din27, din28, din29, din30, din31,
	sel, dout
);
	parameter WIDTH = 8;

	input [WIDTH-1:0] din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11, din12, din13, din14, din15, din16, din17, din18, din19, din20, din21, din22, din23, din24, din25, din26, din27, din28, din29, din30, din31;
	input [4:0] sel;
	output [WIDTH-1:0] dout;

	reg [WIDTH-1:0] dout_r;

	always @( * ) begin
		case ( sel )
			5'd0: dout_r = din0;
			5'd1: dout_r = din1;
			5'd2: dout_r = din2;
			5'd3: dout_r = din3;
			5'd4: dout_r = din4;
			5'd5: dout_r = din5;
			5'd6: dout_r = din6;
			5'd7: dout_r = din7;
			5'd8: dout_r = din8;
			5'd9: dout_r = din9;
			5'd10: dout_r = din10;
			5'd11: dout_r = din11;
			5'd12: dout_r = din12;
			5'd13: dout_r = din13;
			5'd14: dout_r = din14;
			5'd15: dout_r = din15;
			5'd16: dout_r = din16;
			5'd17: dout_r = din17;
			5'd18: dout_r = din18;
			5'd19: dout_r = din19;
			5'd20: dout_r = din20;
			5'd21: dout_r = din21;
			5'd22: dout_r = din22;
			5'd23: dout_r = din23;
			5'd24: dout_r = din24;
			5'd25: dout_r = din25;
			5'd26: dout_r = din26;
			5'd27: dout_r = din27;
			5'd28: dout_r = din28;
			5'd29: dout_r = din29;
			5'd30: dout_r = din30;
			5'd31: dout_r = din31;
		endcase
	end // end always

	assign dout = dout_r;

endmodule

module mux64 (
	din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11, din12, din13, din14, din15, din16, din17, din18, din19, din20, din21, din22, din23, din24, din25, din26, din27, din28, din29, din30, din31, din32, din33, din34, din35, din36, din37, din38, din39, din40, din41, din42, din43, din44, din45, din46, din47, din48, din49, din50, din51, din52, din53, din54, din55, din56, din57, din58, din59, din60, din61, din62, din63,
	sel, dout
);
	parameter WIDTH = 8;

	input [WIDTH-1:0] din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11, din12, din13, din14, din15, din16, din17, din18, din19, din20, din21, din22, din23, din24, din25, din26, din27, din28, din29, din30, din31, din32, din33, din34, din35, din36, din37, din38, din39, din40, din41, din42, din43, din44, din45, din46, din47, din48, din49, din50, din51, din52, din53, din54, din55, din56, din57, din58, din59, din60, din61, din62, din63;
	input [5:0] sel;
	output [WIDTH-1:0] dout;

	reg [WIDTH-1:0] dout_r;

	always @( * ) begin
		case ( sel )
			6'd0: dout_r = din0;
			6'd1: dout_r = din1;
			6'd2: dout_r = din2;
			6'd3: dout_r = din3;
			6'd4: dout_r = din4;
			6'd5: dout_r = din5;
			6'd6: dout_r = din6;
			6'd7: dout_r = din7;
			6'd8: dout_r = din8;
			6'd9: dout_r = din9;
			6'd10: dout_r = din10;
			6'd11: dout_r = din11;
			6'd12: dout_r = din12;
			6'd13: dout_r = din13;
			6'd14: dout_r = din14;
			6'd15: dout_r = din15;
			6'd16: dout_r = din16;
			6'd17: dout_r = din17;
			6'd18: dout_r = din18;
			6'd19: dout_r = din19;
			6'd20: dout_r = din20;
			6'd21: dout_r = din21;
			6'd22: dout_r = din22;
			6'd23: dout_r = din23;
			6'd24: dout_r = din24;
			6'd25: dout_r = din25;
			6'd26: dout_r = din26;
			6'd27: dout_r = din27;
			6'd28: dout_r = din28;
			6'd29: dout_r = din29;
			6'd30: dout_r = din30;
			6'd31: dout_r = din31;
			6'd32: dout_r = din32;
			6'd33: dout_r = din33;
			6'd34: dout_r = din34;
			6'd35: dout_r = din35;
			6'd36: dout_r = din36;
			6'd37: dout_r = din37;
			6'd38: dout_r = din38;
			6'd39: dout_r = din39;
			6'd40: dout_r = din40;
			6'd41: dout_r = din41;
			6'd42: dout_r = din42;
			6'd43: dout_r = din43;
			6'd44: dout_r = din44;
			6'd45: dout_r = din45;
			6'd46: dout_r = din46;
			6'd47: dout_r = din47;
			6'd48: dout_r = din48;
			6'd49: dout_r = din49;
			6'd50: dout_r = din50;
			6'd51: dout_r = din51;
			6'd52: dout_r = din52;
			6'd53: dout_r = din53;
			6'd54: dout_r = din54;
			6'd55: dout_r = din55;
			6'd56: dout_r = din56;
			6'd57: dout_r = din57;
			6'd58: dout_r = din58;
			6'd59: dout_r = din59;
			6'd60: dout_r = din60;
			6'd61: dout_r = din61;
			6'd62: dout_r = din62;
			6'd63: dout_r = din63;
		endcase
	end // end always

	assign dout = dout_r;

endmodule

