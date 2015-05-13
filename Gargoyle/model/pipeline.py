import os
import sys
import logging
from ..utility.

class pipeLine(object):
	"""
	pipeLine is used to describe a model, Included
	1. stageName & stageCycle
	2. module & how to connect the module
	"""
	
	# @param:
	#	stgNameList: stage Name List
	#	stgCycList: each stage need how many cycles to finish
	#	rindex:	which stage read the register	(All register read in only one stage)
	#	windex: which stage write the register	(All register write in only one stage)
	def __init__(self, stgNameList, stgCyclist, rIndex, wIndex,
					module, rmodule, wModule):
		self.stgNameList = stgNameList
		self.stgCycList = stgCycList
		self.rIndex = rIndex
		self.wIndex = wIndex
		'need to rename the rModule & wModule, because they may have the same name'
		self.rModule = rModule	#map(portName.gen_rModName, rModule)
		self.wModule = wModule	#map(portName.gen_wModName, wModule)
		self.module = module
		
		self.init_mod_parameter()
		
		
	# @function:
	#	generator the parameter of the module, such as num of waddr/raddr,
	#	num of wd/rd
	def init_mod_parameter(self):
		
		
		
	def __str__(self):
		return self.__repr__()
		
		
	def __repr__(self):
		ret = 'PipeLine definition:\n'
		ret += '%-5s    %s\n' % ('name', 'cycle')
		for i,item in enumerate(zip(self.stgNameList, self.stgCycList)):
			ret += "%-5s    %-2d\n" % (item[0], item[1])
		return ret
		
		
if __name__ == '__main__':
	stgNameList = ['F', 'D', 'E', 'M', 'W']
	stgCycList = [1, 1, 2, 2, 1]
	ppl = pipeLine(stgNameList, stgCycList)
	print ppl
	