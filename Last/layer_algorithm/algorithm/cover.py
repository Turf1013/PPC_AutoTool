# -*- coding: utf-8 -*-
import re
import math
import logging
from copy import deepcopy
from permutation import Permutation, CFP
import ..model.instruction import Insn
from abc import abstractmethod



class constForCover(CFP):
	
	
class CFC(constForCover):
	pass
	


class RdInsn(Insn):	


	def __init__(self, name, fieldDict, regs):
		super(RdInsn, self).__init__(name, fieldDict)
		self.regs = regs
	
	
class WtInsn(Insn):	


	def __init__(self, name, fieldDict, regs):
		super(RdInsn, self).__init__(name, fieldDict)
		self.regs = regs

	
	
class BaseCover(object):
	
	def __init__(self, n):
		self.n = n
		self.permu = Permutation(n)
	
	
	@abstractmethod
	def hasHazard(self, p):
		"""
			Not all the permutation has valid hazard,
				we can using `judge` function to filter a lot of permu.
				using your own strategy.
		"""
		pass
	
	@abstractmethod
	def 
	

class Cover(BaseCover):

	def __init__(self, n):
		super(Cover, self).__init__(n)
		
		
		
	def hasHazard(self, p):
		"""
			P[0]: the longest living insn.
			P[-1]: new born insn.
		"""
		rIdx = -1 if CFC.READ not in p else p.index(CFC.READ)
		wIdx = -1 if CFC.WRITE not in p else p.index(CFC.WRITE)
		if rIdx==-1 or wIdx==-1 or rIdx<wIdx:
			"There must be another liter permu equiv to this one"
			return False
		return True
			
			
	def 