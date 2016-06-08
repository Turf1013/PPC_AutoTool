# -*- coding: utf-8 -*-
import re
import math
import logging
from copy import deepcopy
from ..Util.decorator import accetps, returns 


class constForHazard:
	DATA_HAZARD = 0
	MOD_HAZARD = 1
	CTRL_HAZARD = 2
	
	
class CFH(constForHazard):
	pass
	

class RdInsn(Insn):	

	def __init__(self, insn, stg):
		super(RdInsn, self).__init__(insn.name, insn.fieldDict)
		self.stg = stg
	
	
class WtInsn(Insn):	


	def __init__(self, insn, stg):
		super(WtInsn, self).__init__(insn.name, insn.fieldDict)
		self.stg = stg
		
class RegChannel(object):

	@accepts(object, str, int)
	def __init__(self, name, idx):
		self.name = name
		self.idx = idx
		
		
	def __repr__(self):
		return "%s.rchannel[%d]" % (self.name, self.idx)
		
	__repr__ = __str__
	


class BaseHazard(object):

	def __init__(self, typeId):
		self.typeId = typeId
		
	@abstract
	def __eq__(self, other):
		pass
		
	@abstract
	def __hash__(self):
		pass
		
	@abstract
	def __cmp__(self):
		pass
		
		
	@abstract
	def condition(self):
		pass
		
	
class DataHazard(BaseHazard):

	def __init__(self, rInsn, wInsn, rStg, wStg, reg, rc, dataId):
		super(DataHazard, self).__init__(CFH.DATA_HAZARD)
		self.RdInsn = RdInsn(rInsn, rStg)
		self.WtInsn = WtInsn(wInsn, wStg)
		self.RegCha = RegChannel(reg, rc)
		self.dataId = dataId
		self.pri = wStg.id
		
		
	def __cmp__(self, other):
		return self.pri < other.pri
		
		
	def __eq__(self, other):
		return self.RdInsn==other.RdInsn and self.WtInsn==other.WtInsn
		
		
	def __hash__(self):
		s = '%s_%s - %s_%s' %\
			(self.RdInsn.name, self.RdInsn.stg.id, self.WtInsn.name, self.WtInsn.stg.id)
		return hash(s)
		
		
	def __repr__(self):
		ret = '%s@%s <-> %s_%s' %\
			(self.RdInsn.name, self.RdInsn.stg.name, self.WtInsn.name, self.WtInsn.stg.name)
		return ret
		
	__str__ = __repr__
		
		
	def condiction(self):
		pass
		
		
class ModHazard(BaseHazard):
	"""
		Module Hazard because mult or div Insn finish executing and going to next stage,
			as the same time another insn goes into along with.
	"""
	
	def __init__(self):
		super(ModHazard, self).__init__(CFH.MOD_HAZARD)
		
		
	def __cmp__(self):
	
	def __hash__(self):
		
	def __eq__(self):
		
		
class CtrlHazard(BaseHazard):
	
	
	def __init__(self):
		super(CtrlHazard, self).__init__(CFH.CTRL_HAZARD)
		
	def __cmp__(self):
	
	def __hash__(self):
		
	def __eq__(self):	
	