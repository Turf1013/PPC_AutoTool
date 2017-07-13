module MultUnit (
	srcA, srcB, ctrl, Mul_result
);
   
   parameter WIDTH = 32;
   
	input  [WIDTH-1:0]   srcA, srcB;
	input		              ctrl;
	output [WIDTH*2-1:0] Mul_result;
	
	// if ctrl is multu then srcA_ext_org, if ctrl is mut and srcA is negative, the srcA_ext_not.
	wire [WIDTH-1:0] srcA_ext;
	wire [WIDTH-1:0] srcA_ext_org, srcA_ext_not;
	wire srcA_ext_mux2_sel;
	
	mux2 #(WIDTH) srcA_ext_mux2(.din0(srcA_ext_org),     .din1(srcA_ext_not),
							          .sel(srcA_ext_mux2_sel), .dout(srcA_ext));
							
	assign srcA_ext_org      = srcA;
	assign srcA_ext_not      = ~srcA + 1'b1;	
	assign srcA_ext_mux2_sel = ctrl & srcA[WIDTH-1];
	
	// if ctrl is multu then srcB_ext_org, if ctrl is mut and srcB is negative, the srcB_ext_not.
	wire [WIDTH-1:0] srcB_ext;
	wire [WIDTH-1:0] srcB_ext_org, srcB_ext_not;
	wire srcB_ext_mux2_sel;
	
	mux2 #(WIDTH) srcB_ext_mux2(.din0(srcB_ext_org),     .din1(srcB_ext_not),
							          .sel(srcB_ext_mux2_sel), .dout(srcB_ext));
							
	assign srcB_ext_org      = srcB;
	assign srcB_ext_not      = ~srcB + 1'b1;	
	assign srcB_ext_mux2_sel = ctrl & srcB[WIDTH-1];
	
	// the bit
	wire [WIDTH:0] srcA_cur0,  srcA_cur1,  srcA_cur2,  srcA_cur3,  srcA_cur4 ;
	wire [WIDTH:0] srcA_cur5,  srcA_cur6,  srcA_cur7,  srcA_cur8,  srcA_cur9 ;
	wire [WIDTH:0] srcA_cur10, srcA_cur11, srcA_cur12, srcA_cur13, srcA_cur14;
	wire [WIDTH:0] srcA_cur15, srcA_cur16, srcA_cur17, srcA_cur18, srcA_cur19;
	wire [WIDTH:0] srcA_cur20, srcA_cur21, srcA_cur22, srcA_cur23, srcA_cur24;
	wire [WIDTH:0] srcA_cur25, srcA_cur26, srcA_cur27, srcA_cur28, srcA_cur29;
	wire [WIDTH:0] srcA_cur30, srcA_cur31, srcA_cur32;
	
	assign srcA_cur0 = 0;
	
	// store the mult result, not the final_result
	wire [WIDTH*2-1:0] result; 
	
	// 0_bit
	multElem #(WIDTH+1) multElem_0( .srcA_cur(srcA_cur0),   .srcA_ext(srcA_ext), 
	                                .srcA_nxt(srcA_cur1),   .srcB_ext_bit(srcB_ext[0]), 
	                                .result_bit(result[0]) );
	
	// 1_bit
	multElem #(WIDTH+1) multElem_1( .srcA_cur(srcA_cur1),   .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur2),   .srcB_ext_bit(srcB_ext[1]),
	                                .result_bit(result[1]) );
	
	// 2_bit
	multElem #(WIDTH+1) multElem_2( .srcA_cur(srcA_cur2),   .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur3),   .srcB_ext_bit(srcB_ext[2]),
	                                .result_bit(result[2]) );
	
	// 3_bit
	multElem #(WIDTH+1) multElem_3( .srcA_cur(srcA_cur3),   .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur4),   .srcB_ext_bit(srcB_ext[3]),
	                                .result_bit(result[3]) );
							       
	// 4_bit
	multElem #(WIDTH+1) multElem_4( .srcA_cur(srcA_cur4),   .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur5),   .srcB_ext_bit(srcB_ext[4]),
	                                .result_bit(result[4]) );
	                               
	// 5_bit
	multElem #(WIDTH+1) multElem_5( .srcA_cur(srcA_cur5),   .srcA_ext(srcA_ext), 
	                                .srcA_nxt(srcA_cur6),   .srcB_ext_bit(srcB_ext[5]), 
	                                .result_bit(result[5]) );
	
	// 6_bit
	multElem #(WIDTH+1) multElem_6( .srcA_cur(srcA_cur6),   .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur7),   .srcB_ext_bit(srcB_ext[6]),
	                                .result_bit(result[6]) );
	
	// 7_bit
	multElem #(WIDTH+1) multElem_7( .srcA_cur(srcA_cur7),   .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur8),   .srcB_ext_bit(srcB_ext[7]),
	                                .result_bit(result[7]) );
	
	// 8_bit
	multElem #(WIDTH+1) multElem_8( .srcA_cur(srcA_cur8),   .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur9),   .srcB_ext_bit(srcB_ext[8]),
	                                .result_bit(result[8]) );
							       
	// 9_bit
	multElem #(WIDTH+1) multElem_9( .srcA_cur(srcA_cur9),   .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur10),  .srcB_ext_bit(srcB_ext[9]),
	                                .result_bit(result[9]) );	                               						       

	// 10_bit
	multElem #(WIDTH+1) multElem_10(.srcA_cur(srcA_cur10),  .srcA_ext(srcA_ext), 
	                                .srcA_nxt(srcA_cur11),  .srcB_ext_bit(srcB_ext[10]), 
	                                .result_bit(result[10]));
	
	// 11_bit
	multElem #(WIDTH+1) multElem_11(.srcA_cur(srcA_cur11),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur12),  .srcB_ext_bit(srcB_ext[11]),
	                                .result_bit(result[11]));
	
	// 12_bit
	multElem #(WIDTH+1) multElem_12(.srcA_cur(srcA_cur12),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur13),  .srcB_ext_bit(srcB_ext[12]),
	                                .result_bit(result[12]));
	
	// 13_bit
	multElem #(WIDTH+1) multElem_13(.srcA_cur(srcA_cur13),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur14),  .srcB_ext_bit(srcB_ext[13]),
	                                .result_bit(result[13]));
							       
	// 14_bit
	multElem #(WIDTH+1) multElem_14(.srcA_cur(srcA_cur14),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur15),  .srcB_ext_bit(srcB_ext[14]),
	                                .result_bit(result[14]));
	                               
	// 15_bit
	multElem #(WIDTH+1) multElem_15(.srcA_cur(srcA_cur15),  .srcA_ext(srcA_ext), 
	                                .srcA_nxt(srcA_cur16),  .srcB_ext_bit(srcB_ext[15]), 
	                                .result_bit(result[15]));
	
	// 16_bit
	multElem #(WIDTH+1) multElem_16(.srcA_cur(srcA_cur16),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur17),  .srcB_ext_bit(srcB_ext[16]),
	                                .result_bit(result[16]));
	
	// 17_bit
	multElem #(WIDTH+1) multElem_17(.srcA_cur(srcA_cur17),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur18),  .srcB_ext_bit(srcB_ext[17]),
	                                .result_bit(result[17]));
	
	// 18_bit
	multElem #(WIDTH+1) multElem_18(.srcA_cur(srcA_cur18),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur19),  .srcB_ext_bit(srcB_ext[18]),
	                                .result_bit(result[18]));
							       
	// 19_bit
	multElem #(WIDTH+1) multElem_19(.srcA_cur(srcA_cur19),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur20),  .srcB_ext_bit(srcB_ext[19]),
	                                .result_bit(result[19]));	
	                                
	// 20_bit
	multElem #(WIDTH+1) multElem_20(.srcA_cur(srcA_cur20),  .srcA_ext(srcA_ext), 
	                                .srcA_nxt(srcA_cur21),  .srcB_ext_bit(srcB_ext[20]), 
	                                .result_bit(result[20]));
	
	// 21_bit
	multElem #(WIDTH+1) multElem_21(.srcA_cur(srcA_cur21),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur22),  .srcB_ext_bit(srcB_ext[21]),
	                                .result_bit(result[21]));
	
	// 22_bit
	multElem #(WIDTH+1) multElem_22(.srcA_cur(srcA_cur22),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur23),  .srcB_ext_bit(srcB_ext[22]),
	                                .result_bit(result[22]));
	
	// 23_bit
	multElem #(WIDTH+1) multElem_23(.srcA_cur(srcA_cur23),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur24),  .srcB_ext_bit(srcB_ext[23]),
	                                .result_bit(result[23]));
							       
	// 24_bit
	multElem #(WIDTH+1) multElem_24(.srcA_cur(srcA_cur24),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur25),  .srcB_ext_bit(srcB_ext[24]),
	                                .result_bit(result[24]));
	                               
	// 25_bit
	multElem #(WIDTH+1) multElem_25(.srcA_cur(srcA_cur25),  .srcA_ext(srcA_ext), 
	                                .srcA_nxt(srcA_cur26),  .srcB_ext_bit(srcB_ext[25]), 
	                                .result_bit(result[25]));
	
	// 26_bit
	multElem #(WIDTH+1) multElem_26(.srcA_cur(srcA_cur26),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur27),  .srcB_ext_bit(srcB_ext[26]),
	                                .result_bit(result[26]));
	
	// 27_bit
	multElem #(WIDTH+1) multElem_27(.srcA_cur(srcA_cur27),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur28),  .srcB_ext_bit(srcB_ext[27]),
	                                .result_bit(result[27]));
	
	// 28_bit
	multElem #(WIDTH+1) multElem_28(.srcA_cur(srcA_cur28),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur29),  .srcB_ext_bit(srcB_ext[28]),
	                                .result_bit(result[28]));
							       
	// 29_bit
	multElem #(WIDTH+1) multElem_29(.srcA_cur(srcA_cur29),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur30),  .srcB_ext_bit(srcB_ext[29]),
	                                .result_bit(result[29]));	                                
   
 	// 30_bit
	multElem #(WIDTH+1) multElem_30(.srcA_cur(srcA_cur30),  .srcA_ext(srcA_ext), 
	                                .srcA_nxt(srcA_cur31),  .srcB_ext_bit(srcB_ext[30]), 
	                                .result_bit(result[30]));
	
	// 31_bit
	multElem #(WIDTH+1) multElem_31(.srcA_cur(srcA_cur31),  .srcA_ext(srcA_ext),
	                                .srcA_nxt(srcA_cur32),  .srcB_ext_bit(srcB_ext[31]),
	                                .result_bit(result[31]));  
	// final result;
	wire [WIDTH*2-1:0] result_neg;
	wire               final_result_sel;
	
	assign result[WIDTH*2-1:WIDTH] = srcA_cur32[WIDTH-1:0];
	assign result_neg = ~result + 1'b1;
	// if is MULT and srcA[WIDTH-1] ^ srcB[WIDTH-1] == 1'b1, then set final_result_sel;
	assign final_result_sel = ctrl & (srcA[WIDTH-1] ^ srcB[WIDTH-1]); 
	
	mux2 #(WIDTH*2) final_result_mux2(.din0(result),          .din1(result_neg),
	                                  .sel(final_result_sel), .dout(Mul_result));
	
endmodule

