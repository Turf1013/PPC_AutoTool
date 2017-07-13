/******************************************************************************************
 * In this Array, we excitingly implemention DivUnit With Array. But we must pay attention:
 * 1. Case Div:
 *    (+7) / (+2) = (+3) ... (+1)
 *    (+7) / (-2) = (-3) ... (+1)
 *    (-7) / (-2) = (+3) ... (-1)
 *    (-7) / (+2) = (-3) ... (-1)
 *    We find that quotinet's  flag determined by dividend & dividor,
 *                 remainder's flag determined by dividend and same as dividend.
 * 2. In last Array Element, we don't create a module, because in that way, we will
 *     use unecessary resouce such mux2... We write it by hand, faster and more efficient.
 *
 */


module DivUnit (
	srcA, srcB, ctrl, Div_result
);
				 
	parameter WIDTH	= 32;
	
	input  [WIDTH-1:0]   srcA;
	input  [WIDTH-1:0]   srcB;
	input  		 		         ctrl;
	output [WIDTH*2-1:0] Div_result;
	
	// if ctrl is divu then srcA_ext_org, if ctrl is div and srcA is negative, the srcA_ext_not.
	wire [WIDTH:0] srcA_ext;
	wire [WIDTH:0] srcA_ext_org, srcA_ext_not;
	wire srcA_ext_mux2_sel;
	
	mux2 #(WIDTH+1) srcA_ext_mux2(.din0(srcA_ext_org),     .din1(srcA_ext_not),
							            .sel(srcA_ext_mux2_sel), .dout(srcA_ext));
							
	assign srcA_ext_org      = (ctrl) ? { srcA[WIDTH-1], srcA } : { 1'b0, srcA };
	assign srcA_ext_not      = ~srcA_ext_org + 1'b1;	
	assign srcA_ext_mux2_sel = ctrl & srcA[WIDTH-1];
	
	// if ctrl is divu then srcB_ext_org, if ctrl is div and srcB is negative, the srcB_ext_not.
	//wire [WIDTH:0] srcB_ext;
	wire [WIDTH:0] srcB_ext_org, srcB_ext_not;
	wire [WIDTH:0] srcB_ext_pos, srcB_ext_neg;
	wire srcB_ext_mux2_sel;
							
	assign srcB_ext_org      = (ctrl) ? { srcB[WIDTH-1], srcB } : { 1'b0, srcB };
	assign srcB_ext_not      = ~srcB_ext_org + 1'b1;	
	assign srcB_ext_mux2_sel = ctrl & srcB[WIDTH-1];
	
	// choose the right srcB(Make sure srcB_ext_pos > 0 and srcB_ext_neg < 0)
	mux2 #(WIDTH+1) srcB_pos_mux2(.din0(srcB_ext_org),     .din1(srcB_ext_not),
	                              .sel(srcB_ext_mux2_sel), .dout(srcB_ext_pos));
	
	mux2 #(WIDTH+1) srcB_neg_mux2(.din0(srcB_ext_not),     .din1(srcB_ext_org),
	                              .sel(srcB_ext_mux2_sel), .dout(srcB_ext_neg));
	                            
	// the bit
	wire [WIDTH+1:0] srcA_cur0,  srcA_cur1,  srcA_cur2,  srcA_cur3,  srcA_cur4,
	                 srcA_cur5,  srcA_cur6,  srcA_cur7,  srcA_cur8,  srcA_cur9,
	                 srcA_cur10, srcA_cur11, srcA_cur12, srcA_cur13, srcA_cur14,
	                 srcA_cur15, srcA_cur16, srcA_cur17, srcA_cur18, srcA_cur19,
	                 srcA_cur20, srcA_cur21, srcA_cur22, srcA_cur23, srcA_cur24,
	                 srcA_cur25, srcA_cur26, srcA_cur27, srcA_cur28, srcA_cur29,
	                 srcA_cur30, srcA_cur31;
	                  
	wire [WIDTH+1:0] srcB_cur0,  srcB_cur1,  srcB_cur2,  srcB_cur3,  srcB_cur4,
	                 srcB_cur5,  srcB_cur6,  srcB_cur7,  srcB_cur8,  srcB_cur9,
	                 srcB_cur10, srcB_cur11, srcB_cur12, srcB_cur13, srcB_cur14,
	                 srcB_cur15, srcB_cur16, srcB_cur17, srcB_cur18, srcB_cur19,
	                 srcB_cur20, srcB_cur21, srcB_cur22, srcB_cur23, srcB_cur24,
	                 srcB_cur25, srcB_cur26, srcB_cur27, srcB_cur28, srcB_cur29,
	                 srcB_cur30, srcB_cur31;
	
	wire [WIDTH+1:0] result_cur0,  result_cur1,  result_cur2,  result_cur3,  result_cur4,
	                 result_cur5,  result_cur6,  result_cur7,  result_cur8,  result_cur9,
	                 result_cur10, result_cur11, result_cur12, result_cur13, result_cur14,
	                 result_cur15, result_cur16, result_cur17, result_cur18, result_cur19,
	                 result_cur20, result_cur21, result_cur22, result_cur23, result_cur24,
	                 result_cur25, result_cur26, result_cur27, result_cur28, result_cur29,
	                 result_cur30, result_cur31;
	
	wire [WIDTH-1:0] quotient, remainder;
	wire [WIDTH-1:0] zero_src;
	
	// need to prepare the initial srcA & srcB
	assign zero_src  = 0;
	assign srcA_cur0 = { zero_src, srcA_ext[WIDTH:WIDTH-1] };
	// if divu then srcB = { 1.din0, srcB_ext_neg };
	// if div & srcA[WIDTH]
	assign srcB_cur0 = { 1'b0, srcB_ext_neg };
	
	
	/** If want to reuse the Div_Array, you need to check here according to your Design. */
	// 0th
	divElem #(WIDTH+1) divElem_00(.srcA_cur(srcA_cur0),  .srcB_cur(srcB_cur0),
							            .srcA_org_Nbit(srcA_ext[WIDTH-2]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur1),  .srcB_nxt(srcB_cur1),
							            .result_cur(result_cur0));
	 
	// 1th
	divElem #(WIDTH+1) divElem_01(.srcA_cur(srcA_cur1),  .srcB_cur(srcB_cur1),
							            .srcA_org_Nbit(srcA_ext[WIDTH-3]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur2), .srcB_nxt(srcB_cur2),
							            .result_cur(result_cur1));							   
	
	// 2th
	divElem #(WIDTH+1) divElem_02(.srcA_cur(srcA_cur2),  .srcB_cur(srcB_cur2),
							            .srcA_org_Nbit(srcA_ext[WIDTH-4]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur3),  .srcB_nxt(srcB_cur3),
							            .result_cur(result_cur2));
	
	
	// 3th
	divElem #(WIDTH+1) divElem_03(.srcA_cur(srcA_cur3),  .srcB_cur(srcB_cur3),
							            .srcA_org_Nbit(srcA_ext[WIDTH-5]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur4),  .srcB_nxt(srcB_cur4),
							            .result_cur(result_cur3));
	 
	// 4th
	divElem #(WIDTH+1) divElem_04(.srcA_cur(srcA_cur4),  .srcB_cur(srcB_cur4),
							            .srcA_org_Nbit(srcA_ext[WIDTH-6]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur5),  .srcB_nxt(srcB_cur5),
							            .result_cur(result_cur4));							   
	
	// 5th
	divElem #(WIDTH+1) divElem_05(.srcA_cur(srcA_cur5),  .srcB_cur(srcB_cur5),
							            .srcA_org_Nbit(srcA_ext[WIDTH-7]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur6),  .srcB_nxt(srcB_cur6),
							            .result_cur(result_cur5));

	// 6th
	divElem #(WIDTH+1) divElem_06(.srcA_cur(srcA_cur6),  .srcB_cur(srcB_cur6),
							            .srcA_org_Nbit(srcA_ext[WIDTH-8]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur7),  .srcB_nxt(srcB_cur7),
							            .result_cur(result_cur6));
	 
	// 7th
	divElem #(WIDTH+1) divElem_07(.srcA_cur(srcA_cur7),  .srcB_cur(srcB_cur7),
							            .srcA_org_Nbit(srcA_ext[WIDTH-9]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur8), .srcB_nxt(srcB_cur8),
							            .result_cur(result_cur7));							   
	
	// 8th
	divElem #(WIDTH+1) divElem_08(.srcA_cur(srcA_cur8),  .srcB_cur(srcB_cur8),
							            .srcA_org_Nbit(srcA_ext[WIDTH-10]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur9),  .srcB_nxt(srcB_cur9),
							            .result_cur(result_cur8));
	
	
	// 9th
	divElem #(WIDTH+1) divElem_09(.srcA_cur(srcA_cur9),  .srcB_cur(srcB_cur9),
							            .srcA_org_Nbit(srcA_ext[WIDTH-11]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur10), .srcB_nxt(srcB_cur10),
							            .result_cur(result_cur9));
	 
	// 10th
	divElem #(WIDTH+1) divElem_10(.srcA_cur(srcA_cur10), .srcB_cur(srcB_cur10),
							            .srcA_org_Nbit(srcA_ext[WIDTH-12]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur11), .srcB_nxt(srcB_cur11),
							            .result_cur(result_cur10));							   
	
	// 11th
	divElem #(WIDTH+1) divElem_11(.srcA_cur(srcA_cur11), .srcB_cur(srcB_cur11),
							            .srcA_org_Nbit(srcA_ext[WIDTH-13]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur12), .srcB_nxt(srcB_cur12),
							            .result_cur(result_cur11));	
				
	// 12th
	divElem #(WIDTH+1) divElem_12(.srcA_cur(srcA_cur12), .srcB_cur(srcB_cur12),
							            .srcA_org_Nbit(srcA_ext[WIDTH-14]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur13), .srcB_nxt(srcB_cur13),
							            .result_cur(result_cur12));							   
	
	// 13th
	divElem #(WIDTH+1) divElem_13(.srcA_cur(srcA_cur13), .srcB_cur(srcB_cur13),
							            .srcA_org_Nbit(srcA_ext[WIDTH-15]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur14), .srcB_nxt(srcB_cur14),
							            .result_cur(result_cur13));				
		
	// 14th
	divElem #(WIDTH+1) divElem_14(.srcA_cur(srcA_cur14), .srcB_cur(srcB_cur14),
							            .srcA_org_Nbit(srcA_ext[WIDTH-16]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur15), .srcB_nxt(srcB_cur15),
							            .result_cur(result_cur14));							   
	
	// 15th
	divElem #(WIDTH+1) divElem_15(.srcA_cur(srcA_cur15), .srcB_cur(srcB_cur15),
							            .srcA_org_Nbit(srcA_ext[WIDTH-17]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur16), .srcB_nxt(srcB_cur16),
							            .result_cur(result_cur15));	
				
	// 16th
	divElem #(WIDTH+1) divElem_16(.srcA_cur(srcA_cur16), .srcB_cur(srcB_cur16),
							            .srcA_org_Nbit(srcA_ext[WIDTH-18]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur17), .srcB_nxt(srcB_cur17),
							            .result_cur(result_cur16));							   
	
	// 17th
	divElem #(WIDTH+1) divElem_17(.srcA_cur(srcA_cur17), .srcB_cur(srcB_cur17),
							            .srcA_org_Nbit(srcA_ext[WIDTH-19]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur18), .srcB_nxt(srcB_cur18),
							            .result_cur(result_cur17));	
	
	// 18th
	divElem #(WIDTH+1) divElem_18(.srcA_cur(srcA_cur18), .srcB_cur(srcB_cur18),
							            .srcA_org_Nbit(srcA_ext[WIDTH-20]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur19), .srcB_nxt(srcB_cur19),
							            .result_cur(result_cur18));	
				
	// 19th
	divElem #(WIDTH+1) divElem_19(.srcA_cur(srcA_cur19), .srcB_cur(srcB_cur19),
							            .srcA_org_Nbit(srcA_ext[WIDTH-21]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur20), .srcB_nxt(srcB_cur20),
							            .result_cur(result_cur19));							   
	
	// 20th
	divElem #(WIDTH+1) divElem_20(.srcA_cur(srcA_cur20), .srcB_cur(srcB_cur20),
							            .srcA_org_Nbit(srcA_ext[WIDTH-22]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur21), .srcB_nxt(srcB_cur21),
							            .result_cur(result_cur20));								            
	
	// 21th
	divElem #(WIDTH+1) divElem_21(.srcA_cur(srcA_cur21), .srcB_cur(srcB_cur21),
							            .srcA_org_Nbit(srcA_ext[WIDTH-23]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur22), .srcB_nxt(srcB_cur22),
							            .result_cur(result_cur21));	
				
	// 22th
	divElem #(WIDTH+1) divElem_22(.srcA_cur(srcA_cur22), .srcB_cur(srcB_cur22),
							            .srcA_org_Nbit(srcA_ext[WIDTH-24]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur23), .srcB_nxt(srcB_cur23),
							            .result_cur(result_cur22));							   
	
	// 23th
	divElem #(WIDTH+1) divElem_23(.srcA_cur(srcA_cur23), .srcB_cur(srcB_cur23),
							            .srcA_org_Nbit(srcA_ext[WIDTH-25]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur24), .srcB_nxt(srcB_cur24),
							            .result_cur(result_cur23));				
		
	// 24th
	divElem #(WIDTH+1) divElem_24(.srcA_cur(srcA_cur24), .srcB_cur(srcB_cur24),
							            .srcA_org_Nbit(srcA_ext[WIDTH-26]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur25), .srcB_nxt(srcB_cur25),
							            .result_cur(result_cur24));							   
	
	// 25th
	divElem #(WIDTH+1) divElem_25(.srcA_cur(srcA_cur25), .srcB_cur(srcB_cur25),
							            .srcA_org_Nbit(srcA_ext[WIDTH-27]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur26), .srcB_nxt(srcB_cur26),
							            .result_cur(result_cur25));	
				
	// 26th
	divElem #(WIDTH+1) divElem_26(.srcA_cur(srcA_cur26), .srcB_cur(srcB_cur26),
							            .srcA_org_Nbit(srcA_ext[WIDTH-28]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur27), .srcB_nxt(srcB_cur27),
							            .result_cur(result_cur26));							   
	
	// 27th
	divElem #(WIDTH+1) divElem_27(.srcA_cur(srcA_cur27), .srcB_cur(srcB_cur27),
							            .srcA_org_Nbit(srcA_ext[WIDTH-29]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur28), .srcB_nxt(srcB_cur28),
							            .result_cur(result_cur27));	
	
	// 28th
	divElem #(WIDTH+1) divElem_28(.srcA_cur(srcA_cur28), .srcB_cur(srcB_cur28),
							            .srcA_org_Nbit(srcA_ext[WIDTH-30]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur29), .srcB_nxt(srcB_cur29),
							            .result_cur(result_cur28));	
				
	// 29th
	divElem #(WIDTH+1) divElem_29(.srcA_cur(srcA_cur29), .srcB_cur(srcB_cur29),
							            .srcA_org_Nbit(srcA_ext[WIDTH-31]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur30), .srcB_nxt(srcB_cur30),
							            .result_cur(result_cur29));							   
	
	// 30th
	divElem #(WIDTH+1) divElem_30(.srcA_cur(srcA_cur30), .srcB_cur(srcB_cur30),
							            .srcA_org_Nbit(srcA_ext[WIDTH-32]),
							            .srcB_ext_pos(srcB_ext_pos),
							            .srcB_ext_neg(srcB_ext_neg),
							            .srcA_nxt(srcA_cur31), .srcB_nxt(srcB_cur31),
							            .result_cur(result_cur30));								            	
				
							   
	// 31th, the last we write it by ourself, in this way we can decrease some uncessary circuit.
	adder #(WIDTH+2) divElem_adder_31(.srca(srcA_cur31), .srcb(srcB_cur31), 
	                                  .result(result_cur31));
		
	wire [WIDTH-1:0] quotient_org, remainder_org, remainder_restore;
	wire [WIDTH-1:0] quotient_not, remainder_not;
	
	mux2 #(WIDTH) remainder_rst_mux2(.din0(result_cur31[WIDTH-1:0] + srcB_ext_org[WIDTH-1:0]),
	                                 .din1(result_cur31[WIDTH-1:0] + srcB_ext_not[WIDTH-1:0]),
	                                 .sel(srcB_ext_org[WIDTH]), .dout(remainder_restore));
	
	assign quotient_org  = {  result_cur0[WIDTH+1],  result_cur1[WIDTH+1],  result_cur2[WIDTH+1],  result_cur3[WIDTH+1],
	                          result_cur4[WIDTH+1],  result_cur5[WIDTH+1],  result_cur6[WIDTH+1],  result_cur7[WIDTH+1],
	                          result_cur8[WIDTH+1],  result_cur9[WIDTH+1], result_cur10[WIDTH+1], result_cur11[WIDTH+1],
	                         result_cur12[WIDTH+1], result_cur13[WIDTH+1], result_cur14[WIDTH+1], result_cur15[WIDTH+1],
	                         result_cur16[WIDTH+1], result_cur17[WIDTH+1], result_cur18[WIDTH+1], result_cur19[WIDTH+1],
	                         result_cur20[WIDTH+1], result_cur21[WIDTH+1], result_cur22[WIDTH+1], result_cur23[WIDTH+1],
	                         result_cur24[WIDTH+1], result_cur25[WIDTH+1], result_cur26[WIDTH+1], result_cur27[WIDTH+1],
	                         result_cur28[WIDTH+1], result_cur29[WIDTH+1], result_cur30[WIDTH+1], result_cur31[WIDTH+1] };
	                         
	                         
	assign remainder_org = (result_cur31[WIDTH+1]) ? result_cur31[WIDTH-1:0] : remainder_restore;
	assign quotient_not  = ~quotient_org  + 1'b1;
	assign remainder_not = ~remainder_org + 1'b1;
	
	wire quotient_mux2_sel, remainder_mux2_sel;
	
	// some case we need to correct the final quotient & remainder.
	mux2 #(WIDTH)  quotient_mux2(.din0(quotient_org),      .din1(quotient_not),
	                             .sel(quotient_mux2_sel),  .dout(quotient));
	                                
	mux2 #(WIDTH) remainder_mux2(.din0(remainder_org),     .din1(remainder_not),
	                             .sel(remainder_mux2_sel), .dout(remainder));	                                
	
	// if it is Div and ( srcA[WIDTH-1] ^ srcB[WIDTH-1] ).
	assign  quotient_mux2_sel = ctrl & (srcA[WIDTH-1] ^ srcB[WIDTH-1]);
	// if it is Div and ( srcA[WIDTH-1] ^ remainder_org[WIDTH-1] ).
	assign remainder_mux2_sel = ctrl & (srcA[WIDTH-1] ^ remainder_org[WIDTH-1]);

	assign Div_result = { remainder, quotient };
							   
endmodule
