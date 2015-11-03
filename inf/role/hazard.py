# -*- coding: utf-8 -*-


class BaseHazard(object):

	def __init__(self):
		pass

		
class BaseStgInsn(object):
	"""	BaseStgInsn means Basic Insn with Stage
	
	"""
	
	def __init__(self, insn, stg):
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
		self.Finsn = Finsn
		self.Binsn = Binsn
		
		
	
class RW_InsnGrp(object):
	""" RW_InsnGrp means several backInsn VS one frontInsn
	
	"""
	
	def __init__(self, Finsn):
		self.Finsn = Finsn
		self.BinsnSet = set()

		
	
	def add(self, Binsn):
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
	
	
	
class RW_Hazard(object):
	""" RW_Hazard presents Read and Writer Hazard
	
	"""
	
	
		