/*
 * Description: This module is XERIn(Combine XER & ALU.CA/ALU.OV/ALU.SO).
 *		1. XERIn
 * Author: ZengYX
 * Date:   2014.9.4
 */
`include "arch_def.v"

module XERIn (
	OVWr, CAWr, ALU_CA, ALU_SO, ALU_OV, XER, ALU_XERWd
);
	input					OVWr, CAWr;
	input	 			    ALU_CA, ALU_SO, ALU_OV;
	input  [0:`XER_WIDTH-1] XER;
	output [0:`XER_WIDTH-1] ALU_XERWd;
	
	wire XERWd_CA, XERWd_SO, XERWd_OV;
	
	assign XERWd_CA = (CAWr) ? ALU_CA:XER[`XER_CA];
	assign XERWd_OV = (OVWr) ? ALU_OV:XER[`XER_OV];
	assign XERWd_SO = (OVWr) ? ALU_SO:XER[`XER_SO];
	
	assign ALU_XERWd = {XERWd_CA, XERWd_OV, XERWd_SO, XER[`XER_SO+1:`XER_WIDTH-1]};
	
endmodule
