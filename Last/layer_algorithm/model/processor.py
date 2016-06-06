# -*- coding: utf-8 -*-
import logging
import ..util.decorator import accepts, returns


class BaseProcessor(object):
	
	@accpets(object, str, (set, list))
	def __init__(self, name, ISA):
		self.name = name
		self.ISA = tuple(ISA)
		
		
	def insnAt(self, idx):
		assert idx>=0 && idx<len(self.ISA)
		return self.ISA[idx]
		
		
	def __repr__(self):
		ret = "Processor [%s]" % (self.name)
		ret += "ISA:"
		for insn in self.ISA:
			ret += "\t" + str(insn)
		return ret
		
	__str__ = __repr__
	
		
	
class PipelineProcessor(BaseProcessor):
	"""
		`ABSTRACT` processor's specifications and 
			`INSTANCE` a processor
	"""
	
	def __init__(self, name, ISA, pipeline, regList, brInsnList):
		super(PipelineProcessor, BaseProcessor).__init__(name, ISA)
		self.ppl = pipeline
		self.regs = tuple(regList)
		self.brInsns = tuple(brInsnList)
	
	
	def stgAt(self, idx):
		return self.ppl.stgAt(idx)
		
		
	def stgNameAt(self, idx):
		return self.ppl.stgNameAt(idx)
	
	
	@accepts(object, str)
	def findReg(self, name):
		for reg in self.regs:
			if reg.name == name:
				return reg
		return None
		
		
	def formula(self):
		pass
		
		
Processor = PipelineProcessor