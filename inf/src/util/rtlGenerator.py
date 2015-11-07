# -*- coding: utf-8 -*-
import re
from ..role.mutex import CFM

class constForRtlGenerator:
	pass

class CFRG(constForRtlGenerator):
	pass
	
	
class RtlGenerator:

	@classmethod
	def GenMuxSel(cls, name, seln, isel):
		return "%d'd%d -> %s.%s" % (selfn, isel, name, CFM.mux_sel)
		
	