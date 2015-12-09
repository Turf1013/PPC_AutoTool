`include "arch_def.v"
`include "ctrl_encode_def.v"

module MDU (
	A, B, Op, C, D
);
       
    input  [0:`ARCH_WIDTH-1] 	A;
    input  [0:`ARCH_WIDTH-1] 	B;
    input  [0:`MDUOp_WIDTH-1]  	Op;
    output [0:`ARCH_WIDTH-1] 	C;         
	output [0:`MDU_D_WIDTH-1]	D;
	
	reg [0:`ARCH_WIDTH-1] C;
	wire [0:`ARCH_WIDTH*2-1] Div_result, Mul_result;
	reg flag;
   
    // Divide Array Unit
    DivUnit #(`ARCH_WIDTH) DivUnit (
		.srcA(A),
		.srcB(B),
		.ctrl(flag),
		.Div_result(Div_result)
	);  
	 
	 // Multiply Array	Unit	            
    MultUnit #(`ARCH_WIDTH) MulUnit (
		.srcA(A),
		.srcB(B),
		.ctrl(flag),
		.Mul_result(Mul_result)
	);
	
	reg OV;
				          
    always @ ( * ) begin
		case ( Op )
		
			`MDUOp_MULH: begin
				flag = 1'b1;
				C = Mul_result[0:`ARCH_WIDTH-1];
				OV = 1'b0;
			end
			
			`MDUOp_MULHU: begin
				flag = 1'b0;
				C = Mul_result[0:`ARCH_WIDTH-1];
				OV = 1'b0;
			end
			
			`MDUOp_MULW: begin
				flag = 1'b1;
				C = Mul_result[`ARCH_WIDTH:`ARCH_WIDTH*2-1];
				OV = (Mul_result[0:`ARCH_WIDTH-1] != `CONST_ZERO) & (Mul_result[0:`ARCH_WIDTH-1] != `CONST_NEG1);
			end
			
			`MDUOp_DIVW: begin
				flag = 1'b1;
				C = Div_result[`ARCH_WIDTH:`ARCH_WIDTH*2-1];	// quotient
				OV = 1'b0;
			end
			
			`MDUOp_DIVWU: begin
				flag = 1'b0;
				C = Div_result[`ARCH_WIDTH:`ARCH_WIDTH*2-1];	// quotient
				OV = 1'b0;
			end
			
			default: begin
				flag = 1'b0;
				C = 0;
				OV = 1'b0;
			end
			
		endcase	
	end // end always
	
	// logic of CR0
	wire LT0, GT0, EQ0;
	wire [0:2] CR0_3;
	
	assign LT0 = (C <  0) ? 1'b1 : 1'b0;
	assign GT0 = (C >  0) ? 1'b1 : 1'b0;
	assign EQ0 = (C == 0) ? 1'b1 : 1'b0;
	assign CR0_3 = {LT0, GT0, EQ0};
    
	assign D = {OV, CR0_3};
	
endmodule
