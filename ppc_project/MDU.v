`include "arch_def.v"
`include "ctrl_encode_def.v"
`include "SPR_def.v"
`include "global_def.v"

module MDU (
	clk, rst_n,
	A, B, Op, C, D,
	cnt, ack, req
);
	
	input clk, rst_n;
	input  [0:`ARCH_WIDTH-1] 	A;
    input  [0:`ARCH_WIDTH-1] 	B;
    input  [0:`MDUOp_WIDTH-1]  	Op;
    output [0:`ARCH_WIDTH-1] 	C;         
	output [0:`MDU_D_WIDTH-1]	D;
	output [`MDU_CNT_WIDTH-1:0] cnt;
	input req;
	output ack;

`ifdef USE_FASTMDU
	
	fastMDU I_fastMDU (
		.A(A),
		.B(B),
		.C(C),
		.D(D),
		.Op(Op)
	);
	
	assign cnt = 0;
	
`else

	slowMDU I_fastMDU (
		.clk(clk),
		.rst_n(rst_n),
		.A(A),
		.B(B),
		.C(C),
		.D(D),
		.Op(Op),
		.cnt(cnt),
		.req(req),
		.ack(ack)
	);
	
`endif
	
endmodule

module slowMDU (
	clk, rst_n, req, ack,
	A, B, Op, C, D, cnt
);
	
	input						clk, rst_n;
	input						req;
	input  [0:`ARCH_WIDTH-1] 	A;
    input  [0:`ARCH_WIDTH-1] 	B;
    input  [0:`MDUOp_WIDTH-1]  	Op;
    output [0:`ARCH_WIDTH-1] 	C;         
	output [0:`MDU_D_WIDTH-1]	D;
	output						ack;
	output [`MDU_CNT_WIDTH-1:0] cnt;
	
	reg [0:`ARCH_WIDTH-1] C;
	reg [`MDU_CNT_WIDTH-1:0] cnt;
	wire [`MDU_CNT_WIDTH-1:0] ini_cnt;
	
	reg signed [0:`ARCH_WIDTH] srcA, srcB;
	reg signed [0:`ARCH_WIDTH*2+1] mulC;
	reg signed [0:`ARCH_WIDTH] divC;
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			srcA <= 0;
			srcB <= 0;
		end
		else if (req && ack) begin
			case ( Op )
				`MDUOp_MULH: begin
					srcA <= {A[0], A};
					srcB <= {B[0], B};				
				end
				
				`MDUOp_MULHU: begin
					srcA <= {1'b0, A};
					srcB <= {1'b0, B};					
				end
				
				`MDUOp_MULW: begin
					srcA <= {A[0], A};
					srcB <= {B[0], B};
				end
				
				`MDUOp_DIVW: begin
					srcA <= {A[0], A};
					srcB <= {B[0], B};
				end
				
				`MDUOp_DIVWU: begin
					srcA <= {1'b0, A};
					srcB <= {1'b0, B};
				end
				
				default: begin
					srcA <= 0;
					srcB <= 0;
				end
			endcase
		end
		else begin
			srcA <= srcA;
			srcB <= srcB;
		end
	end // end always
	
	reg [0:`MDUOp_WIDTH-1] Op_r;
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			Op_r <= `MDUOp_NOP;
		end 
		else if (req) begin
			Op_r <= Op;
		end
		else if (cnt == 0) begin
			Op_r <= `MDUOp_NOP;
		end
	end // end always
	
	always @( * ) begin
		case ( Op_r )
			`MDUOp_MULH: begin
				if (cnt == 0) 
					mulC = srcA * srcB;
				else
					mulC = 0;
				divC = 0;
			end	
			
			`MDUOp_MULHU: begin
				if (cnt == 0) 
					mulC = srcA * srcB;
				else
					mulC = 0;
				divC = 0;
			end
			
			`MDUOp_MULW: begin
				if (cnt == 0) 
					mulC = srcA * srcB;
				else
					mulC = 0;
				divC = 0;
			end
			
			`MDUOp_DIVW: begin
				if (cnt == 0)
					divC = srcA / srcB;
				else
					divC = 0;
				mulC = 0;
			end
			
			`MDUOp_DIVWU: begin
				if (cnt == 0)
					divC = srcA / srcB;
				else
					divC = 0;
				mulC = 0;
			end
			
			default: begin
				divC = 0;
				mulC = 0;
			end
		endcase
	end // end always
	
	always @( * ) begin
		case ( Op_r )
			`MDUOp_MULH: begin
				C = mulC[2:`ARCH_WIDTH+1];
			end	
			
			`MDUOp_MULHU: begin
				C = mulC[2:`ARCH_WIDTH+1];
			end
			
			`MDUOp_MULW: begin
				C = mulC[`ARCH_WIDTH+2:`ARCH_WIDTH*2+1];
			end
			
			`MDUOp_DIVW: begin
				C = divC[1:`ARCH_WIDTH];
			end
			
			`MDUOp_DIVWU: begin
				C = divC[1:`ARCH_WIDTH];
			end
			
			default: begin
				C = 0;
			end
		endcase		
	end // end always;
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			cnt <= 0;
		end
		else if (req && ack) begin
			cnt <= ini_cnt;
		end
		else if (cnt != 0) begin
			cnt <= cnt - 1;
		end
	end // end always
	
	assign ini_cnt = `MDU_CYCLE - 2;
	assign ack = (cnt == 0);
	
	// logic of CR0
	wire LT0, GT0, EQ0;
	wire [0:2] CR0_3;
	wire OV;
	
	assign OV = 1'b0;
	assign LT0 = (C <  0) ? 1'b1 : 1'b0;
	assign GT0 = (C >  0) ? 1'b1 : 1'b0;
	assign EQ0 = (C == 0) ? 1'b1 : 1'b0;
	assign CR0_3 = {LT0, GT0, EQ0};
    
	assign D = {OV, CR0_3};
	
endmodule

module fastMDU (
	clk, rst_n, 
	A, B, Op, C, D
);

    input						clk, rst_n;
    input  [0:`ARCH_WIDTH-1] 	A;
    input  [0:`ARCH_WIDTH-1] 	B;
    input  [0:`MDUOp_WIDTH-1]  	Op;
    output [0:`ARCH_WIDTH-1] 	C;         
	output [0:`MDU_D_WIDTH-1]	D;
	
	reg [0:`ARCH_WIDTH-1] C;
	wire [0:`ARCH_WIDTH*2-1] Div_result, Mul_result;
	reg flag;
	reg OV;
   
    // Divide Array Unit
    // DivUnit #(`ARCH_WIDTH) DivUnit (
		// .srcA(A),
		// .srcB(B),
		// .ctrl(flag),
		// .Div_result(Div_result)
	// );  
	wire [0:`ARCH_WIDTH-1] div_q, div_d;
	assign Div_result = {div_q, div_d};
	assign div_q = A / B;
	assign div_d = A % B;
	 
	 // Multiply Array	Unit	            
    // MultUnit #(`ARCH_WIDTH) MulUnit (
		// .srcA(A),
		// .srcB(B),
		// .ctrl(flag),
		// .Mul_result(Mul_result)
	// );
	assign Mul_result = {{32{A[0]}}, A} * {{32{B[0]}}, B};
				          
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
