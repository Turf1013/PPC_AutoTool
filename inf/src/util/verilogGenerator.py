# -*- coding: utf-8 -*-
import re, math
from ..verilog.const_hdl import CFV
from ..glob.glob import CFG

class constForVerilogGenerator:
	RD 		= "rd"
	WD		= "wd"
	BMUX	= "bmux"
	CLR		= "clr"
	WIRE	= "wire"
	REG		= "reg"
	WIDTH	= "WIDTH"
	OUTPUT  = "output"
	INPUT	= "input"
	
class CFVG(constForVerilogGenerator):
	pass
	
class VerilogGenerator:
	
	# L is a tripleList
	@classmethod
	def GenCtrlSignalAlways(cls, name, width, L, default, tabn=1):
		pre = '\t' * tabn
		if isinstance(width, int):
			# width is int
			radix = "%s'd" % (str(width))
			
		else:
			# width is `define
			radix = ""
			
		ret = pre + "/*********   Logic of %s   *********/\n" % (name)
		ret += pre + "%s @( * ) %s\n" % (CFV.ALWAYS, CFV.BEGIN)
		if L:
			# add if - else if
			for i, t in enumerate(L):
				# add condition
				if i:
					ret += pre + "\t" + "%s ( %s ) %s\n" % (CFV.ELSIF, t.cond, CFV.BEGIN)
				else:
					ret += pre + "\t" + "%s ( %s ) %s\n" % (CFV.IF, t.cond, CFV.BEGIN)
				#	add op
				ret += pre + "\t\t" + "%s = %s%s;\n" % (name, radix, str(t.op))
				# add end
				ret += pre + "\t" + "%s\n" % (CFV.END)
			# add else
			ret += pre + "\t" + "%s %s\n" % (CFV.ELSE, CFV.BEGIN)
			ret += pre + "\t\t" + "%s = %s%s;\n" % (name, radix, str(default))
			ret += pre + "\t" + "%s\n" % (CFV.END)
		else:
			# add default directly
			ret += pre + "\t\t" + "%s = %s%s;\n" % (name, radix, str(default))
		# add end always
		ret += pre + "%s %s\n" % (CFV.END, CFV.ENDALWAYS)
		return ret
		
	
	@classmethod
	def GenBypassMuxName(cls, name, suf=""):
		return "%s_%s%s" % (name, CFVG.RD, suf)
		
		
	@classmethod
	def GenClr(cls, suf=""):
		return "%s_%s" % (CFVG.CLR, suf)
	
	
	@classmethod
	def GenMuxVerilog(cls, muxn):
		ret = ""
		ret += "module mux%d (\n" % (muxn)
		seln = int(math.ceil(math.log(muxn, 2)))
		dinList = ["din"+str(i) for i in xrange(muxn)]
		ret += "\t" + ", ".join(dinList) + ",\n"
		ret += "\t" + "sel, dout\n"
		ret += ");\n"
		
		ret += "\t" + "parameter WIDTH = 8;\n\n"
		ret += "\t" + "input [WIDTH-1:0] " + ", ".join(dinList) + ";\n"
		ret += "\t" + "input [%d:0] sel;\n" % (seln-1)
		ret += "\t" + "output [WIDTH-1:0] dout;\n\n"
		
		ret += "\t" + "reg [WIDTH-1:0] dout_r;\n\n"
		
		ret += "\t" + "always @( * ) begin\n"
		ret += "\t\t" + "case ( sel )\n"
		for i in xrange(muxn):
			ret += "\t\t\t" + "%d'd%d: dout_r = din%d;\n" % (seln, i, i)
		ret += "\t\t" + "endcase\n"
		ret += "\t" + "end // end always\n\n"
		
		ret += "\t" + "assign dout = dout_r;\n\n"
		
		ret += "endmodule\n"
		return ret
		
		
	@classmethod
	def GenWire(cls, name, width, tabn=1):
		if isinstance(width, int):
			return "\t" * tabn + "%s [%d:0] %s;\n" % (CFVG.WIRE, width-1, name)
		else:
			return "\t" * tabn + "%s %s %s;\n" % (CFVG.WIRE, width, name)
		
		
		
	@classmethod
	def GenReg(cls, name, width, tabn=1):
		if isinstance(width, int):
			return "\t" * tabn + "%s [%d:0] %s;\n" % (CFVG.REG, width-1, name)
		else:
			return "\t" * tabn + "%s %s %s;\n" % (CFVG.REG, width, name)
		
		
	@classmethod
	def GenCtrlWidthMacro(cls, name):
		return "`%s_%s" % (name, CFVG.WIDTH)
		
		
	@classmethod
	def GenOutput(cls, name, width, tabn=1):
		if isinstance(width, int):
			return "\t" * tabn + "%s [%d:0] %s;\n" % (CFVG.OUTPUT, width-1, name)
		else:
			return "\t" * tabn + "%s %s %s;\n" % (CFVG.OUTPUT, width, name)
			
			
	@classmethod
	def GenInput(cls, name, width, tabn=1):
		if isinstance(width, int):
			return "\t" * tabn + "%s [%d:0] %s;\n" % (CFVG.INPUT, width-1, name)
		else:
			return "\t" * tabn + "%s %s %s;\n" % (CFVG.INPUT, width, name)
			
			
	@classmethod
	def IntToRange(cls, x):
		if isinstance(x, int):
			return "[%d:0]" % (x-1)
		else:
			raise TypeError, "%s call IntToRange" % (type(x))
			
			
	@classmethod
	def GenInsnFieldDef(cls, fieldName):
		return "`" + fieldName.upper()
		
		
	@classmethod
	def DefToRange(cls, d):
		if CFG.PPC:
			return "[0:%s-1]" % (d)
		else:
			return "[%s-1:0]" % (d)
			
		