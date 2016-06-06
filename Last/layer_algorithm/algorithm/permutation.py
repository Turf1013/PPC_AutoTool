# -*- coding: utf-8 -*-
import re
import math
import logging
from copy import deepcopy


class constForPermutation:
	NOP = 0
	READ = 1
	WRITE = 2

class CFP(constForPermutation):
	pass
	

class Permutation:

	def __init__(self, n):
		self.n = n
		self.P = []
		self.__c = [n] * 3
		self.__tmp = [0] * n
		self.__dfs(0)
		assert len(self.P) == 3 ** n
		
	def __dfs(self, dep):
		if dep == self.n:
			self.P.append( deepcopy(self.tmp) )
			return 
		
		for i in xrange(3):
			if self.__c[i] > 0:
				self.__c[i] -= 1
				self.__tmp[dep] = i
				self.__dfs(dep + 1)
				self.__c[i] += 1
				
				
	def __len__(self):
		return 3 ** self.n
				
				
	def __iter__(self):
		return iter(self.P)
				
		