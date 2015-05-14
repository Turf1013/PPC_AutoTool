import os
import sys
import logging
import collections
import string
from ..utility.portRename import portRename


class mutex(object):

	'''
	type:
		0: general
		1: bypass
	'''
	def __init__(self, stg, input, output, type=0):
		self.stg = stg
		self.output = output
		self.input = input
		self.type = "bypass" if type else "general"

		
	def __eq__(self, oth):
		return self.stg==oth.stg and self.output==oth.output and\
				self.input==oth.input and self.type==oth.type
	
	
	def __str__(self):
		return """
		Mutex   @%d
		output:	%s
		input :	%s
		type  :	%s
		""" % (self.stg, self.output, self.input, self.type)
		
	
class mutexSet(collections.Set):
	''' Alternate set implementation favoring space over speed
	and not requiring the set elements to be hashable. '''
	def __init__(self, iterable=[]):
		self.mutexList = lst = []
		for value in iterable:
			if value not in lst:
				lst.append(value)
				
				
	def update(self, oth):
		if isinstance(oth, muxtex):
			for ele in oth:
				if ele not in self.mutexList:
					self.mutexList.append(ele)
		else:
			raise KeyError, 'mutexSet.add() only support type mutex.'
		
		
	def add(self, mux):
		if isinstance(mux, mutex):
			if mux not in self.mutexList:
				mutexList.append(mux)
		else:
			raise KeyError, 'mutexSet.add() only support type mutex.'
	
	
	def discard(self, mux):
		if mux in self.mutexList:
			self.mutexList.remove(mux)
	
	
	def remove(self, mux):
		self.mutexList.remove(mux)
		
	
	def clear(self, mux):
		self.mutexList = []
	
				
	def __iter__(self):
		return iter(self.mutexList)

		
	def __contains__(self, value):
		return value in self.mutexList

		
	def __len__(self):
		return len(self.mutexList)
		
		
	def __str__(self):
		return str(self.mutexList)
		

if __name__ == '__main__':
	