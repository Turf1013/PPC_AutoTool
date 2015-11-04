# -*- coding: utf-8 -*-


class BasePipeLine(object):
	""" Pipeline is used to define the model of Basic information of pipeline processor
	
	"""
	
	def __init__(self, stgList, Rstg, Wstg):
		self.stgList = stgList
		self.Rstg = Rstg
		self.Wstg = Wstg
		
		
		
class PipeLine(BasePipeLine):
	
	
	def __init__(self, stgList, Rstg, Wstg):
		super(PipeLine, self).__init__(stgList, Rstg, Wstg)
		
	