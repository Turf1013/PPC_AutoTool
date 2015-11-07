# -*- coding: utf-8 -*-
from ..role.instruction import Insn


class constForModuleMap:
	pass
	
class CFMM(constForModuleMap):
	pass
	
	
class InsnMap(dict):

	def __init__(self, iterable=None):
		dict.__init__(self)
		if iterable is not None:
			self.update(zip(map(lambda insn:insn.name, iterable), iterable))
		
		
	def find(self, insnName):
		return self.get(insnName)
		
	
	
		