# -*- coding: utf-8 -*-
from ..util.verilogGenerator import VerilogGenerator as VG

class constForWire:
	WIRE = "wire"
	REG = "reg"
	DEFAULT_WIDTH = "[0:0]"
	
class CFW(constForWite):
	pass
	
	
class Wire(object):

	def __init__(self, name, width=CFM.DEFAULT_WIDTH, kind):
		self.name = name
		self.width = width
		self.kind = kind
		self.stg = stg
		
	def __cmp__(self, other):
		return self.stg - other.stg
	
	
	def __hash__(self):
		return hash(self.name)
	
		
	def __eq__(self, other):
		return self.name == other.name
	
	
	def toVerilog(self, tabn):
		if self.kind == CFW.Reg:
			return VG.GenReg(name=self.name, width=self.width, tabn=tabn)
		else:
			return VG.GenWire(name=self.name, width=self.width, tabn=tabn)
			
			
class WireSet(set):

	def toVerilog(self):
		ret = ""
		for wire in self:
			ret += wire.toVerilog()
		return ret
		