# -*- coding: utf-8 -*-
import re
from const_hdl import *


class GenVerilog:

	@classmethod
	def genIncludeCode(cls, includeList, tabn=0):
		ret = ''
		pre = '\t' * tabn
		for fname in includeList:
			ret += pre + '%s "%s"\n' % (hdl_INCLUDE, fname)
		return ret