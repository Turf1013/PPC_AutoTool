# -*- coding: utf-8 -*-
import re
from ..verilog.const_hdl import CFV

class constForVerilogGenerator:
	pass
	
class CFVG:
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
		# add if - else if
		for i, t in enumerate(L):
			# add condition
			if i:
				ret += pre + "\t" + "%s ( %s ) %s\n" % (CFV.ELSIF, t.cond, CFV.BEGIN)
			else:
				ret += pre + "\t" + "%s ( %s ) %s\n" % (CFV.IF, t.cond, CFV.BEGIN)
			#	add op
			ret += pre + "\t\t" + "%s = %s%s\n" % (name, radix, str(t.op))
			# add end
			ret += pre + "\t" + "%s\n" % (CFV.END)
		# add else
		ret += pre + "\t" + "%s %s\n" % (CFV.ELSE, CFV.BEGIN)
		ret += pre + "\t\t" + "%s = %s%s\n" % (name, radix, str(default))
		ret += pre + "\t" + "%s\n" % (CFV.END)
		# add end always
		ret += pre + "%s %s\n" % (CFV.END, CFV.ENDALWAYS)
		return ret
		
