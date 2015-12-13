module GC_CharDec (
	ascii, char_y_pos, lattice
);
	
	input [7:0] ascii;
	input [3:0] char_y_pos;
	output [7:0] lattice;
	
	/*	
	 * The CharDecROM stores all the ASCII char's lattice.
	 * Total size is 4KB(256 chars).
	 * Every char is 16B which means 16 * ASCII is the correct base-address.
	 * And the Offset-address equals to char_y_pos, but we need to make it to 12bit.
	 */
	
	wire [11:0] addr;
	
	
	reg [7:0] CharDecROM[4095:0];
	
	initial begin
		$readmemh("CharMem.txt", CharDecROM);
	end
	
	assign lattice = CharDecROM[addr];
	
	
	/*
	//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
	CharDecROM CharDecROM (
	  .a(addr), // input [11 : 0] a
	  .spo(lattice) // output [7 : 0] spo
	);
	// INST_TAG_END ------ End INSTANTIATION Template ---------
	*/
	// The logic of address calculate, which is boring and complicated.
	wire [11:0] base_addr;
	wire [11:0] offset_addr;

	assign addr        = base_addr + offset_addr;
	assign base_addr   = { ascii, 4'd0 };
	assign offset_addr = { 7'd0, char_y_pos }; 	

endmodule
