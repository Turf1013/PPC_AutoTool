# -*- coding: utf-8 -*-
from ..role.stage import Stage

class constForPipeLine:
	pass
	
class CFP(constForPipeLine):
	pass


class BasePipeLine(object):
	""" Pipeline is used to define the model of Basic information of pipeline processor
	
	"""
	
	def __init__(self, stgList, Rstg, Wstg):
		self.stgList = stgList
		self.stgn = len(stgList)
		self.Rstg = Rstg
		self.Wstg = Wstg
		
		
	def StgNameAt(self, istg):
		if isinstance(istg, Stage):
			return self.stgList[istg.id].name
		return self.stgList[istg].name
		
		
class PipeLine(BasePipeLine):
	
	
	def __init__(self, stgList, Rstg, Wstg, regList, brList=[]):
		super(PipeLine, self).__init__(stgList, Rstg, Wstg)
		self.regList = regList
		self.brList = map(lambda s:s.upper(), brList)
		
		
	def findReg(self, regName):
		for reg in self.regList:
			if reg.name == regName:
				return reg
		raise ValueError, "%s not in pipeLine.regList" % (regName)
		
		
	def addBrList(self, iteratable):
		for item in iteratable:
			item = item.upper()
			if item not in self.brList:
				self.brList.append(item)
				