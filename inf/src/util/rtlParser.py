# -*- coding: utf-8 -*-
import re

class constForRtlParser:
	re_rtlConst = re.compile(r"`\w+|\d+")
	re_rtlVariable = re.compile(r"[\`\'\.\w]+")
	re_rtlNumber = re.compile(r"^\d+$")
	re_hdlNumber = re.compile(r"^\d+'(b[01]+|d\d+|h[a-f\d]+)$")
	re_hdlConst  = re.compile(r"^`[\_\w]+$")

class CFRP(constForRtlParser):
	pass
	

class RtlParser:

	
	@classmethod
	def SrcToVar(cls, src, stg=""):
		# if not src:
			# print src, stg
		def repl(matchobj):
			val = matchobj.group(0)
			if CFRP.re_rtlConst.match(val):
				return val
			else:
				return val + "_" + stg
		return CFRP.re_rtlVariable.sub(repl, src.replace(".", "_"))
		
	
	@classmethod		
	def DesToVar(cls, des, suf=""):
		if suf:
			return des.replace(".", "_") + "_" + suf
		else:
			return des.replace(".", "_")
		
	
	@classmethod
	def SrcToList(cls, src):
		m = CFRP.re_rtlVariable.findall(src)
		m = filter(lambda s:not (CFRP.re_rtlNumber.match(s) or CFRP.re_hdlNumber.match(s) or CFRP.re_hdlConst.match(s)), m)
		return m
		