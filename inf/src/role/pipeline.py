# -*- coding: utf-8 -*-


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
		return self.stgList[istg]
		
		
class PipeLine(BasePipeLine):
	
	
	def __init__(self, stgList, Rstg, Wstg, regList):
		super(PipeLine, self).__init__(stgList, Rstg, Wstg)
		self.regList = regList
	