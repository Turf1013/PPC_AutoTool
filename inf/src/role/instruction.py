# -*- coding: utf-8 -*-


class constForInsn:
	pass

class CFI(constForInsn):
	pass


class Insn(object):
	"""Insn means Instruction for short just like GNU.
	
	Implemented to get condtion of a Insn for convenient.
	
	"""
	
	def __init__(self, name, op, xo):
		self.name	= name
		self.op		= op
		self.xo		= xo
		
		
	def condition(self, opField="[0:5]", opWidth=6, xoField="[21:30]", xoWidth=10, INSTR="Instr", suf=""):
		instr = INSTR + "_" + suf if suf else INSTR
		if self.xo is None:
			return "(%s%s==%d'd%d)" % (instr, opField, opWidth, self.op)
		return "(%s%s==%d'd%d && %s==%d'd%d)" % (
					instr, opField, opWidth, self.op, xoField, xoWidth, self.xo
				)
	
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
	

	