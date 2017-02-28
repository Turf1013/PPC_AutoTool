# -*- coding: utf-8 -*-
import logging
from ..util.verilogGenerator import VerilogGenerator as VG


class constForInsn:
	INSTR = "Instr"

class CFI(constForInsn):
	pass


class Insn(object):
	"""Insn means Instruction for short just like GNU.
	
	Implemented to get condtion of a Insn for convenient.
	
	"""
	
	def __init__(self, name, fieldDict):
		self.name = name
		self.fieldDict = fieldDict
		
		
	def condition(self, suf=""):
		instr = CFI.INSTR + "_" + suf if suf else CFI.INSTR
		condList = []
		for fieldName, fieldVal in self.fieldDict.iteritems():
			fieldDef = VG.GenInsnFieldDef(fieldName)
			condList.append( "%s%s == %s" % (instr, fieldDef, fieldVal) )
		return "( %s )" % (" && ".join(condList))
		
	
	def __hash__(self):
		return hash(self.name)
	
		
	def __eq__(self, other):
		return self.name == other.name
		
	def __str__(self):
		return self.name
		
	def __repr__(self):
		return self.name
		
		
		
class InsnSet(set):
	"""InsnSet means a Set of instruction
	
	Implemented as a set subclass so that we can generate a heap of  
	insn-condition for more simply circuit.
	
	"""
	
	def __init__(self):
		super(InsnSet, self).__init__()
		
	
	def condition(self, opField, opWidth, xoField, xoWidth):
		conds = []
		for insn in self:
			conds.append(insn.condtion(opField, opWidth, xoField, xoWidth))
		return " && ".join(conds)
	

	