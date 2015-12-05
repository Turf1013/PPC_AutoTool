# -*- coding: utf-8 -*-
import logging
from instruction import Insn
from stage import Stage
from reg import Reg
from mutex import BypassMutex, CFM
from ..util.verilogGenerator import VerilogGenerator as VG
from ..util.rtlParser import RtlParser as RP


class constForHazard:
	INSTR = "Instr"	
	DATA_WIDTH = 32
	
class CFH(constForHazard):
	pass
	
	
class StgReg(object):
	
	def __init__(self, name, index, stg, stgName, iterable=None):
		self.name = name
		self.index = index
		self.stg = stg
		self.stgName = stgName
		if iterable is None:
			self.m = 0
			self.dinDict = dict()
			
		elif isinstance(iterable, dict):
			self.m = len(iterable)
			self.dinDict = dict(iterable.items())
			
		elif isinstance(iterable, (list, set)):
			self.m = len(iterable)
			self.dinDict = dict(zip(iterable, range(self.m)))
		
		else:
			self.m = 0
			self.dinDict = dict()
			
		
	def __contains__(self, d):
		return d in self.dinDict
	
	
	def __len__(self):
		return len(self.dinDict)
	
		
	def add(self, d):
		if d not in self.dinDict:
			self.dinDict[d] = self.m
			self.m += 1
			
	def index(self, d):
		return self.dinDict[d]
			
			
	def GenBypassMuxName(self):
		return VG.GenBypassMuxName(name=self.name, suf="%s_%s" % (str(self.index), self.stgName))
		
	def toBypassMux(self, stg=-1):
		name = self.GenBypassMuxName()
		width = CFH.DATA_WIDTH
		linkedIn = self.dinDict.keys()
		# logging.debug("[linkedIn] %s: %s\n" % (self.name, linkedIn))
		return BypassMutex(name=name, width=width, stg=stg, linkedIn=linkedIn)
			
	def GenMuxSelName(self):
		return "%s_%s" % (VG.GenBypassMuxName(name=self.name, suf="%s_%s" % (str(self.index), self.stgName)), CFM.mux_sel)


		
class BaseStgInsn(object):
	"""	BaseStgInsn means Basic Insn with Stage
	
	"""
	
	def __init__(self, insn, stg):
		if not isinstance(insn, Insn) or not isinstance(stg, Stage):
			raise TypeError, "Init BaseStgInsn with (Insn, Stage)"
		self.insn = insn
		self.stg = stg
		
		
	def __str__(self):
		return "%s@%s" % (self.insn.name, self.stg.name)
		
		
	def __cmp__(self, other):
		return self.stg.id - other.stg.id
	
	
	def __eq__(self, other):
		return self.insn==other.insn and self.stg==other.stg
		
		
	def __hash__(self):
		return hash(self.__str__())
	
	
	def condition(self):
		instr = "%s_%s" % (CFH.INSTR, self.stg)
		return self.insn.condition(INSTR = instr)
	
		
		
class StgInsn(BaseStgInsn):
	""" StgInsn presents a member of RW_Hazard (R or W depends on action)
		
	"""
	
	def __init__(self, insn, stg, addr, wd=None, ctrl="1'b1"):
		super(StgInsn, self).__init__(insn, stg)
		self.addr = addr
		self.wd = wd
		self.ctrl = ctrl
		
	def __str__(self):
		return "%s@%s [%s]" % (self.insn.name, self.stg.name, self.addr)
	
	
	def __eq__(self, other):
		return self.insn==other.insn and self.stg==other.stg and self.addr==other.addr
		
		
	def __hash__(self):
		return hash(self.__str__())	
		
		
	def ctrlCondition(self):
		return RP.SrcToVar(self.ctrl)
		
		
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
	
	
	
class InsnGrp(object):
	
	def __init__(self, Binsn):
		if not isinstance(Binsn, BaseStgInsn):
			raise TypeError, "insn must be instanced with StgInsn During RW_Hazard"
		self.Binsn = Binsn
		self.FinsnSet = set()
		
	
	def add(self, Finsn):
		if not isinstance(Finsn, BaseStgInsn):
			raise TypeError, "insn must be instanced with StgInsn During RW_Hazard"
		self.FinsnSet.add(Finsn)
	
	
	def addInsn(self, Finsn):
		self.FinsnSet.add(Finsn)
		
		
	def __iter__(self):
		return iter(self.FinsnSet)
		
	
	def __eq__(self, other):
		return self.Binsn == other.Binsn
		
		
	def __hash__(self):
		return hash(self.Binsn)
		
	
	
	def __len__(self):
		return len(self.FinsnSet)
	
	
	
	def __contains__(self, Binsn):
		return Binsn in self.FinsnSet
	
	
	
	def __str__(self):
		ret = ""
		ret += "[%s] InsnGrp:\n" % (str(self.Binsn))
		for finsn in self.FinsnSet:
			ret += "\t%s\n" % (str(finsn))
		return ret
		
		
		
	def condition(self):
		condList = [self.Binsn.condition]
		condList += [insn.condition() for insn in self.FinsnSet]
		return " && ".join(condList)
	
	
class RW_InsnGrp(InsnGrp):
	""" RW_InsnGrp means several backInsn VS one frontInsn
	
	One RW_InsnGrp includes:
	1. One Succeeded Instruction (BInsn);
	2. Several Predessor Instruction (Finsn);
	"""
	
	def __init__(self, Binsn):
		super(RW_InsnGrp, self).__init__(Binsn=Binsn)
		self.linkedIn = set()
		
		
	def addLink(self, data):
		self.linkedIn.add(data)
		
		
	def __str__(self):
		ret = ""
		ret += "[%s] InsnGrp:\n" % (str(self.Binsn))
		for finsn in self.FinsnSet:
			ret += "\t%s\n" % (str(finsn))
		ret += "\n SendData:\n"
		for data in self.linkedIn:
			ret += "\t%s\n" % (data)
		return ret
		
		

class BaseHazard(object):

	def __init__(self, insnGrpIterator=None):
		if isinstance(insnGrpIterator, list):
			self.insnGrpSet = set(insnGrpIterator)
		elif isinstance(insnGrpIterator, RW_InsnGrp):
			self.insnGrpSet = set([insnGrpIterator])
		else:
			self.insnGrpSet = set()
		
	def add(self, insnGrp):
		if not isinstance(insnGrp, InsnGrp):
			raise TypeError, "InsnGrp used to add into Hazard"
		self.insnGrpSet.add(insnGrp)
		
		
	def __contains__(self, insnGrp):
		if not isinstance(insnGrp, InsnGrp):
			raise TypeError, "InsnGrp used to add into Hazard"
		return insnGrp in self.insnGrpSet
		
		
	def __len__(self):
		return len(self.insnGrpSet)
		
		
	def __iter__(self):
		return iter(self.insnGrpSet)
	
	
class RW_Hazard(BaseHazard):
	""" RW_Hazard presents Read and Writer Hazard.
	
	One RW_Hazard includes:
	1. some RW_InsnGrp 
	"""
	
	def __init__(self, name, index, insnGrpIterator=None):
		super(RW_Hazard, self).__init__(insnGrpIterator=insnGrpIterator)
		self.name = name
		self.index = index
		
		
	def add(self, insnGrp):
		if not isinstance(insnGrp, RW_InsnGrp):
			raise TypeError, "RW_InsnGrp used to add into RW_Hazard"
		self.insnGrpSet.add(insnGrp)
		
		
	def __contains__(self, insnGrp):
		if not isinstance(insnGrp, RW_InsnGrp):
			raise TypeError, "RW_InsnGrp used to add into RW_Hazard"
		return insnGrp in self.insnGrpSet
		

class Stall_Hazard(BaseHazard):
	
	def __str__(self):
		ret = ""
		for insnGrp in self.insnGrpSet:
			ret += "%s\n" %(str(insnGrp))
		return ret
	