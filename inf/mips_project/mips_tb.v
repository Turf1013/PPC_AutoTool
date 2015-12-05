 module mips_tb();
    
   reg clk, rst_n;
	 reg wr;
	 reg [31:0] instr;
	 reg [31:0] GPR[31:0];
	 integer i, j;
	 
   mips I_MIPS(
      .clk(clk), .rst_n(rst_n)
   );
    
   initial begin
      $readmemh( "code.txt" , I_MIPS.I_IM.imem );
//      $monitor("PC = 0x%8X, IR = 0x%8X", I_MIPS.U_PC.PC, I_MIPS.instr ); 
      wr = 0;
      for (i=0; i<32; i=i+1) begin
        GPR[i] = 0;
      end
      instr = 0;
      clk = 1;
      rst_n = 1;
      #5;
      rst_n = 0;
      #20;
      rst_n = 1;
		// #7100;
		// $finish;
   end
   
   always
	   #(50) clk = ~clk;
	   
	 always @(posedge clk) begin
	   if (I_MIPS.I_GPR.wr) begin
	     wr <= 1'b1;
	     instr <= I_MIPS.Instr_W;
		 // $display("instr = %h, GPR[%2d] = %h\n", I_MIPS.Instr_W, I_MIPS.I_GPR.waddr, I_MIPS.I_GPR.wd);
	   end
	   else begin
	     wr <= 1'b0;
	     instr <= 32'd0;
	   end
	 end
	 
	 always @(posedge clk) begin
     if (wr) begin
	       $display("instr = %h\n", instr);
	       for (i=0; i<32; i=i+4) begin
	         for (j=0; j<4; j=j+1)
	           $display("GPR[%2d] = %h", i+j, I_MIPS.I_GPR.GPR[i+j]);
	       end
     end
     else begin
       $display("\n");
     end
   end
endmodule
