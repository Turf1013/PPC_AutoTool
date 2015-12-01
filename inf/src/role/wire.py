# -*- coding: utf-8 -*-
from ..util.verilogGenerator import VerilogGenerator as VG

class constForWire:
	WIRE = "wire"
	REG = "reg"
	DEFAULT_WIDTH = "[0:0]"
	
class CFW(constForWire):
	pass
	
	
class Wire(object):

	def __init__(self, name, width, kind, stg=0):
		self.name = name
		self.width = width
		self.kind = 1 if kind==CFW.REG else 0
		self.stg = stg
		
	def __cmp__(self, other):
		if self.stg == other.stg:
			return other.kind - self.kind
		return self.stg - other.stg
	
	
	def __hash__(self):
		return hash(self.name)
	
		
	def __eq__(self, other):
		return self.name == other.name
	
	
	def toVerilog(self, tabn):
		if self.kind:
			return VG.GenReg(name=self.name, width=self.width, tabn=tabn)
		else:
			return VG.GenWire(name=self.name, width=self.width, tabn=tabn)
			
			
class WireSet(set):

	def toVerilog(self, tabn = 1):
		ret = ""
		L = sorted(self)
		for wire in L:
			ret += wire.toVerilog(tabn = tabn)
		return ret
		