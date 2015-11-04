# -*- coding: utf-8 -*-
from instruction import Insn
from stage import Stage

class BaseHazard(object):

	def __init__(self):
		pass


		
INSTR = "Instr"		
class BaseStgInsn(object):
	"""	BaseStgInsn means Basic Insn with Stage
	
	"""
	
	def __init__(self, insn, stg):
		if not isinstance(insn, Insn) or not isinstance(stg, Stage):
			raise TypeError, "Init BaseStgInsn with (Insn, Stage)"
		self.insn = insn
		self.stg = stg
		
		
	def __str__(self):
		return "%s@%s" % (self.stg, self.insn)
		
		
	def __cmp__(self, other):
		return self.stg - other.stg
	
	
	def __eq__(self, other):
		return self.insn==other.insn and self.stg==other.stg
		
		
	def __hash__(self):
		return hash(self.__str__())
	
	
	def condition(self):
		instr = "%s_%s" % (INSTR, self.stg)
		return self.insn.condition(INSTR = instr)
	
		
		
class StgInsn(BaseStgInsn):
	""" StgInsn presents a member of RW_Hazard (R or W depends on action)
		
	"""
	
	def __init__(self, insn, stg, action, addr):
		super(StgInsn, self).__init__(insn, stg)
		self.action = action
		self.addr = addr
	
		
		
class InsnPair(object):
	""" InsnPair means a pair of instruction
	
	"""
	def __init__(self, Finsn, Binsn):
		if not isinstance(Finsn, BaseStgInsn) or not isinstance(Binsn, BaseStgInsn):
			raise TypeError, "insn must be instanced with BaseStgInsn During RW_Hazard"
		self.Finsn = Finsn
		self.Binsn = Binsn
		
		
		
	def condition(self):
		return "%s && %s" % (self.Finsn.condition(), self.Binsn.condition())
	
	
	
class RW_InsnGrp(object):
	""" RW_InsnGrp means several backInsn VS one frontInsn
	
	One RW_InsnGrp includes:
	1. One Predessor Instruction (Finsn);
	2. One Succeeded Instruction (BInsn);
	"""
	
	def __init__(self, Finsn):
		if not isinstance(Finsn, BaseStgInsn):
			raise TypeError, "insn must be instanced with StgInsn During RW_Hazard"
		self.Finsn = Finsn
		self.BinsnSet = set()

		
	
	def add(self, Binsn):
		if not isinstance(Binsn, BaseStgInsn):
			raise TypeError, "insn must be instanced with StgInsn During RW_Hazard"
		self.BinsnSet.add(Binsn)
	
	
	def __eq__(self, other):
		return self.Finsn == other.Finsn
		
		
	def __hash__(self):
		return hash(self.Finsn)
		
	
	
	def __len__(self):
		return len(self.BinsnSet)
	
	
	
	def __contains__(self, Binsn):
		return Binsn in self.BinsnSet
	
	
	
	def __str__(self):
		return "%s__RW_InsnGrp" % (self.Finsn)
		
		
		
	def condition(self):
		condList = [self.Finsn.condition]
		condList += [insn.condition() for insn in self.BinsnSet]
		return " && ".join(condList)
		
	
	
	
class RW_Hazard(object):
	""" RW_Hazard presents Read and Writer Hazard.
	
	One RW_Hazard includes:
	1. some RW_InsnGrp 
	"""
	
	def __init__(self, insnGrpIterator=None):
		if isinstance(insnGrpIterator, list):
			self.insnGrpSet = set(insnGrpIterator)
		elif isinstance(insnGrpIterator, RW_InsnGrp):
			self.insnGrpSet = set([insnGrpIterator])
		else:
			self.insnGrpSet = set()
		
		
	def add(self, insnGrp):
		if not isinstance(insnGrp, RW_InsnGrp):
			raise TypeError, "RW_InsnGrp used to add into RW_Hazard"
		self.insnGrpSet.add(insnGrp)
		
		
	def __contains__(self, insnGrp):
		if not isinstance(insnGrp, RW_InsnGrp):
			raise TypeError, "RW_InsnGrp used to add into RW_Hazard"
		return insnGrp in self.insnGrpSet
		
		
	def __len__(self):
		return len(self.insnGrpSet)
		
		
	def __iter__(self):
		return iter(self.insnGrpSet)