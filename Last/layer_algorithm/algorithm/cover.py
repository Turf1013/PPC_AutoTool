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
	def HazardAll(self):
		pass
	

class Cover(BaseCover):

	def __init__(self, proc):
		super(Cover, self).__init__(proc.ppl.nStg)
		self.proc = proc
		self.rStg = proc.ppl.rStg
		self.wStg = proc.ppl.wStg
		
		
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
		for i in xrange(self.n-self.rStg.id, n):
			if p[i] != CFC.NOP:
				return False
		for i in xrange(0, self.n):
			if p[i] == CFC.WRITE:
				flag = False
				for j in xrange(i+1, self.n):
					if p[j] = CFC.READ:
						flag = True
						break
				if not flag:
					return False
		return True
			
			
	def HazardAll(self):
		for p in self.permu:
			if self.hasHazard(p):
				self.HazardPermu(p)
		
			
	def HazardPermu(self, P):
		fw = [3000] * (self.n + 1)
		for i in xrange(self.n-1, -1, -1):
			if p[i] == CFC.WRITE:
				p[i] = i
			else:
				p[i] = p[i+1]
		for rIdx in xrange(0, self.n):
			if p[rIdx] != CFC.READ:
				continue
			wIdx = fw[rIdx]
			self.HazardPair(rIdx, wIdx)
			
			
	def HazardPair(self, rIdx, wIdx):
		for reg in self.proc.regs:
			for rc in reg.rchannels:
				for rInsn in self.proc.ISA:
					for wInsn in self.proc.ISA:
						self.HazardInsnPair(rIdx, wIdx, rInsn, wInsn, reg)
	
	
	def HazardInsnPair(self, rIdx, wIdx, rInsn, wInsn, reg):
		ur = rInsn.findU(reg, rc)
		if ur is None or ur < rIdx:
			return 
		E = wInsn.findE(reg)
		rIdx = self.n - 1 - rIdx
		wIdx = self.n - 1 - wIdx
		for er in E:
			if wIdx>=er and wIdx<=self.wStg.id:
				self.AddBypass(rIdx, wIdx, rInsn, wInsn, reg)
			elif wIdx - rIdx > 	er - ur:
				self.FutureBypass(rIdx, wIdx, rInsn, wInsn, reg)
			else:
				self.AddStall(rIdx, wIdx, rInsn, wInsn, reg)
				
				
	def AddBypass(self, rIdx, wIdx, rInsn, wInsn, reg):
		
		
	def FutureBypass(self, rIdx, wIdx, rInsn, wInsn, reg):
		pass
		
	def AddStall(self, rIdx,wIdx, rInsn, wInsn, reg):
		