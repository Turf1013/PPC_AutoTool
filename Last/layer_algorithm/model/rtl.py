# -*- coding: utf-8 -*-
import logging
from ..util.verilog import verilog as vlg
from ..util.decorator import accepts, returns
from abc import abstractmethod
import os

class constForRtl:
	re_space = re.compile("\s+")
	linkSymbol = "->"
	pipeSymbol = ">>"
	ctrlSufList = [
		"Op",
		"wr",
	]
	
	
class CFR(constForRtl):
	pass
	

	
class BaseRtl(object):
	
	
	def __init__(self, rawVal):
		self.rawVal = CFR.re_space("", rawVal)
		
		
	def __hash__(self):
		return hash(self.rawVal)
		
	def __eq__(self, other):
		return self.rawVal == other.rawVal
		
		
	def __repr__(self):
		return self.rawVal
		
	__str__ = __repr__
	
	
class Rtl(BaseRtl):

	@staticmethod
	def isLinkRtl(line):
		return linkSymbol in line
		
		
	@staticmethod	
	def isPipeRtl(line):
		return pipeSymbol in line
		
		
	@staticmethod
	def isConst(line):
		return "." not in line and "'" in line
		
		
	@staticmethod
	def extractMod(line):
		return line.split('.')[0]
		
		
	@staticmethod
	def extractPort(line):
		return line.split('.')[-1]
		
		
	@staticmethod
	def extractAll(line):
		if '.' not in line:
			return [None, line]
		return line.split('.')
	
		
		
class LinkRtl(Rtl):
	
	def __init__(self, rawVal):
		super(LinkRtl, self).__init__(rawVal)
		self.src, self.des = self.rawVal.split(CFR.linkSymbol)
		self.srcMod, self.srcPort = Rtl.extractAll(self.src)
		self.desMod, self.desPort = Rtl.extractAll(self.des)
		
		
	def __hash__(self):
		return hash(self.des)
		
		
	def isConstLink(self):
		return "." not in self.src
		
		
	def isCtrlLink(self):
		for suf in CFR.ctrlSufList:
			if suf in self.desPort
				return True
		return False
		
		
class PipeRtl(Rtl):

	def __init__(self, rawVal):
		super(LinkRtl, self).__init__(rawVal)
		self.src = self.rawVal.split(CFR.pipeSymbol)[0]
		self.srcMod, self.srcPort = Rtl.extractAll(self.src)
		
		
	def __hash__(self):
		return hash(self.src)
		