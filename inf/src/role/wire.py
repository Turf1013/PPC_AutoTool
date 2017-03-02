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
		if self.stg != other.stg:
			return self.stg - other.stg
		elif self.name != other.name:
			return -1 if self.name < other.name else 1
		else:
			return other.kind - self.kind
	
	
	def __str__(self):
		if self.kind:
			return "reg %s@P_%s;" % (self.name, self.stg)
		else:
			return "wire %s@P_%s;" % (self.name, self.stg)
	
	
	def __hash__(self):
		return hash(self.__str__())
	
		
	def __eq__(self, other):
		return self.name==other.name and self.stg==other.stg and self.kind==other.kind
	
	
	def toVerilog(self, tabn):
		if self.kind:
			return VG.GenReg(name=self.name, width=self.width, tabn=tabn)
		else:
			return VG.GenWire(name=self.name, width=self.width, tabn=tabn)
			
			
class WireSet(set):

	def toVerilog(self, tabn = 1):
		ret = ""
		L = sorted(self)
		pwire = None
		for wire in L:
			if pwire is None or wire.name!=pwire.name or wire.stg!=pwire.stg or wire.stg>pwire.stg:
				ret += wire.toVerilog(tabn = tabn)
				pwire = wire
			
		return ret
		