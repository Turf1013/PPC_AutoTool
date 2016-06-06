# -*- coding: utf-8 -*-
import logging
import ..util.verilog import verilog as vlg
import ..util.decorator import accepts, returns


class constForInsn:
	INSN = "Insn"
	
class CFI(constForInsn):
	pass
	
	
class BaseInsn(object):
	
	@accepts(object, str, dict)
	def __init__(self, name, fieldDict):
		self.name = name
		self.fieldDict = fieldDict
	
	
	def	condition(self, insnSuffix=""):
		insnVarName = CFI.INSN + "_" + insnSuffix if insnSuffix else CF.INSN
		tmpList = []
		for fieldName, fieldVal in fieldDict.iteritems():
			fieldDefn = vlg.GenInsnFieldDefn(fieldName)
			tmpList.append( "%s%s == %s" % (insnVarName, fieldDefn, fieldVal) )
		return "( %s )" % (" && ".join(tmpList))
		
		
	def __eq__(self, other):
		return self.name == other.name
		
		
	def __hash__(self):
		return hash(self.name)
		
		
	def __str__(self):
		return self.name
		
		
class Insn(BaseInsn):


	def __init__(self, name, fieldDict):
		BaseInsn.__init__(name, fieldDict)
		
	
	def formula(self):
		"""
		Math formula of insn
		"""
		pass

		
class InsnSet(set):
	
	
	def __init__(self):
		super(InsnSet, self).__init__()
		
		
	def condition(self):
		tmpList = []
		for insn in self:
			tmpList.append(insn.condition())
		return " && ".join(tmpList)
		
		
	def __repr__(self):
		return super(InsnSet, self).__repr__()
		
	__str__ = __repr__
	
	