module divElem (
	srcA_cur, srcB_cur,
	srcA_org_Nbit,
	srcB_ext_pos, srcB_ext_neg,
	srcA_nxt, srcB_nxt,
	result_cur
);
					 
	parameter WIDTH = 4;
	
	input  [WIDTH:0]   srcA_cur;
	input  [WIDTH:0]   srcB_cur;
	input              srcA_org_Nbit;
	input  [WIDTH-1:0] srcB_ext_pos, srcB_ext_neg;	
	output [WIDTH:0]   srcA_nxt;
	output [WIDTH:0]   srcB_nxt;
	output [WIDTH:0]   result_cur;
	
	adder #(WIDTH+1) divElem_adder(.srca(srcA_cur), .srcb(srcB_cur), 
	                               .result(result_cur));
	mux2  #(WIDTH+1) srcB_nxt_mux2(.din0({1'd0,srcB_ext_pos}), .din1({1'd0,srcB_ext_neg}),
								          .sel(result_cur[WIDTH]),    .dout(srcB_nxt));
	
	assign srcA_nxt = { 1'd0, result_cur[WIDTH-2:0], srcA_org_Nbit };
	
	
endmodule
