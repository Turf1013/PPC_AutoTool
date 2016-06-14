# -*- coding: utf-8 -*-
import logging
from ..util.verilog import verilog as vlg
from ..util.decorator import accepts, returns
from abc import abstractmethod
import os


class constForDefine:
	INCLUDE = r'`include'
	
class CFD(constForDefine):
	pass
	
	
class BaseDefine(object):

	def __init__(self, filepath):
		if not os.path.isdir(filepath):
			raise ValueError, "%s is unvalid filepath" % (filepath)
		self.filepath = filepath
			
		
	@abstractmethod
	def	Parse(self):
		pass
		
		
	@abstractmethod	
	def toVerilog(self):
		pass
	
	
class Define(BaseDefine):
	
	
	def __init__(self, filepath):
		super(Define, self).__init__(filepath)
		
	
	@staticmethod
	def isDefineFile(filename):
		if not filename.endswith('.v'):
			
		
		
	def Parse(self):
		nameList = os.listdir()
		ret = dict()
		for name in nameList:
			if vlg.isDefineFile(name):
				filename = os.path.join(self.filepath, name)
				tmpDict = vlg.ParseDefnDict(filename)
				ret.update( tmpDict )
		return ret
	
	
	def toVerilog(self):
		nameList = os.listdir()
		tmpList = []
		for name in nameList:
			if vlg.isDefineFile(name):
				tmpList.append(name)
		tmpList = map(lambda s:CFD.INCLUDE + "%s" % (s), tmpList)
		return "\n".join(tmpList) + "\n"
		