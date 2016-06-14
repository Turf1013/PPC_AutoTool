# -*- coding: utf-8 -*-
import logging
from ..util.verilog import verilog as vlg
from ..util.decorator import accepts, returns
from abc import abstractmethod
import os

class constForWire:
	WIRE = 0
	REG = 1
	
class CFW(constForWire):
	pass
	
class BaseWire(object):

	def __init__(self, name, width, kind):
		self.name = name
		self.width = width
		if isinstance(kind, (int,long)):
			assert kind>=0 && kind<=1
			self.kind = int(kind)
		else:
			if kind.lower() == "wire":
				self.kind = CFW.WIRE
			elif kind.lower() == "reg":
				self.kind = CFW.REG
			else:
				raise ValueError, "%s is unvalid kind" % (kind)
		
		
	def __repr__(self):
		if self.kind:
			return "reg %s" % (self.name)
		else:
			return "wire %s" % (self.name)
			
	__str__ == __repr__
	
	
	@abstractmethod
	def toVerilog(self, tabn):
		pass
		
		
class Wire(BaseWire):

	def __init__(self, name, width, kind, stg):
		super(Wire, self).__init__(name, width, kind)
		self.stg = stg
		
		def __repr__(self):
			if self.kind:
				return "reg %s@%s" % (self.name, self.stg.name)
			else:
				return "wire %s@%s" % (self.name, self.stg.name)
				
			
		def __eq__(self, other):
			return self.name == other.name and self.width == other.name and self.stg.id == other.stg.id
			
			
		def __cmp__(self, other):
			if self.stg.id != other.stg.id:
				return self.stg.id - other.stg.id
			elif self.kind != other.kind:
				return other.kind - self.kind
			else:
				return -1 if self.name < other.name else 1
				
			
		def toVerilog(self, tabn = 1):
			pre = "\t" * tabn
			if self.kind:
				return pre + "reg [%d:0] %s;\n" % (self.width-1, self.name)
			else:
				return pre + "wire [%d:0] %s;\n" % (self.width-1, self.name)
				