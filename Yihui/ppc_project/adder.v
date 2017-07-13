module adder (
	srca, srcb, result
);
    
	parameter WIDTH = 32;
	
    input  [WIDTH-1:0] srca, srcb;
    output [WIDTH-1:0] result;         
             
    assign result = srca + srcb;
    
endmodule
