# -*- coding: utf-8 -*-
import re

class constForRtlParser:
	re_rtlConst = re.compile(r"`\w+|\d+")
	re_rtlVariable = re.compile(r"[\w`']+")

class CFRP:
	pass
	

class RtlParser:

	
	@classmethod
	def SrcToVar(cls, src, stg=""):
		def repl(matchobj):
			val = matchobj.group(0)
			if CFRP.re_rtlConst.match(val):
				return val
			else:
				return val + "_" + stg
		return re_rtlVariable.sub(repl, src.replace(".", "_"))
		
	
	@classmethod		
	def DesToVar(cl, des):
		return des.sub(".", "_") 