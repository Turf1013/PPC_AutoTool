# -*- coding: utf-8 -*-
import re
from ..role.mutex import CFM

class constForRtlGenerator:
	RADDR 	= "raddr"
	WADDR 	= "waddr"
	RD 		= "rd"
	WD		= "wd"
	WR		= "wr"

class CFRG(constForRtlGenerator):
	pass
	
	
class RtlGenerator:

	@classmethod
	def GenMuxSel(cls, name, seln, isel):
		return "%d'd%d -> %s.%s" % (seln, isel, name, CFM.mux_sel)
		
	
	@classmethod
	def GenRegRaddr(cls, name, index=""):
		return "%s.%s%s" % (name, CFRG.RADDR, str(index))

		
	@classmethod
	def GenRegWaddr(cls, name, index=""):
		return "%s.%s%s" % (name, CFRG.WADDR, str(index))
		
		
	@classmethod
	def GenRegWr(cls, name, index=""):
		return "%s.%s%s" % (name, CFRG.WR, str(index))
	
	
	@classmethod
	def GenRegWd(cls, name, index=""):
		return "%s.%s%s" % (name, CFRG.WD, str(index))
		
		
	@classmethod
	def GenRegRd(cls, name, index=""):
		return "%s.%s%s" % (name, CFRG.RD, str(index))
		