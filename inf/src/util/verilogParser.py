# -*- coding: utf-8 -*-
import re


class constForVerilogParser:
	re_range = re.compile(r"\[\w+:\w+\]")
	re_space = re.compile(r"\s+")
	
class CFVP:
	pass
	
	
class VerilogParser:
	
	@classmethod
	def RangeToInt(cl, r):
		m = CFVP.re_range.match(r)
		if m is None:
			raise ValueError, "%s is not a range" % r
		r = m.group(0)
		f, t = r[1:-1].split(':')
		r = t if f=="0" else f
		r = CFVP.re_space.sub("", r)
		if r.endswith("-1"):
			return r[:-2]
		else:
			return str(int(r) + 1)
			
		