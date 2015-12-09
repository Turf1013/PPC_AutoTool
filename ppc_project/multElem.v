module multElem (
	srcA_cur,     srcA_ext,
	srcB_ext_bit, result_bit, 
	srcA_nxt
);
					
	parameter WIDTH = 5;				
					
	input  [WIDTH-1:0] srcA_cur;
	input  [WIDTH-2:0] srcA_ext;
	input  			         srcB_ext_bit;
	output             result_bit;
	output [WIDTH-1:0] srcA_nxt;
	
	wire   [WIDTH-1:0] srcB_cur;
	wire   [WIDTH-1:0] result_cur;
	
	adder #(WIDTH) mul_addr_Elem( .srca(srcA_cur), .srcb(srcB_cur), .result(result_cur) );
	
	wire   [WIDTH-1:0] srcB_cur_d0;
	
	mux2  #(WIDTH) srcB_cur_mux2( .din0(srcB_cur_d0), .din1({1'd0, srcA_ext}),
								         .sel(srcB_ext_bit), .dout(srcB_cur) );
	
	assign srcB_cur_d0 = 0;							 
	assign srcA_nxt    = { 1'd0, result_cur[WIDTH-1:1] };
	assign result_bit  = result_cur[0];
	
endmodule
