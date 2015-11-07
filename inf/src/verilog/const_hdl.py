import string

class constForVerilog:
	INCLUDE		= 	'`include'
	DEFINE		= 	'`define'
	MODULE 		= 	'module'
	ENDMODULE 	= 	'endmodule'
	INPUT		= 	'input'
	OUTPUT		= 	'output'
	REG			= 	'reg'
	WIRE		= 	'wire'
	ASSIGN		= 	'assign'
	ALWAYS		= 	'always'
	CASE		= 	'case'
	ENDCASE		= 	'endcase'
	BEGIN		= 	'begin'
	END			= 	'end'
	IF			=	'if'
	ELSE		= 	'else'
	ELSIF		= 	'else if'
	WIDTHONE	= 	'[0:0]'
	ENDALWAYS	= 	'// end always'

	OP 			= 	'OPCD'
	XO			= 	'XO'
	
class CFV(constForVerilog):
	pass