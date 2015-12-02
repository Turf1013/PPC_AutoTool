# -*- coding: utf-8 -*-
import re

class constForRtl:
	re_space = re.compile("\s+")
	linkSymbol = "->"
	pipeSymbol = ">>"
	ctrlSuffix = [
		"Op",
		"wr",
	]
	
	
class CFR(constForRtl):
	pass

class Rtl(object):
	"""Rtl means a language to describe the execution process of one Insn.
	
	
	"""
	
	def __init__(self, val):
		self.val = CFR.re_space.sub("", val)
		
	def __hash__(self):
		return hash(self.val)
		
	def __str__(self):
		return self.val
			
	@classmethod
	def getMod(cls, wire):
		return wire.split(".")[0]
		
	@classmethod
	def getPort(cls, wire):
		return wire.split(".")[-1]
		
	@classmethod
	def getModAndPort(cls, wire):
		if "." not in wire:
			return [None, wire]
		return wire.split(".")
	
	@classmethod
	def isLinkRtl(cls, line):
		return CFR.linkSymbol in line
		
	
	@classmethod
	def isPipeRtl(cls, line):
		return CFR.pipeSymbol in line
		
	@classmethod
	def isConstSrc(cls, src):
		return "." not in src and "'" in src
	


class LinkRtl(Rtl):
	"""LinkRtl means rtl which contains "->".
	
	"""
	
	def __init__(self, val):
		super(LinkRtl, self).__init__(val)
		self.src, self.des = self.val.split(CFR.linkSymbol)
		self.srcMod, self.srcPort = self.getModAndPort(self.src)
		self.desMod, self.desPort = self.getModAndPort(self.des)
	
	
	def __hash__(self):
		return hash(self.des)
		
	
	def __eq__(self, other):
		return self.src==other.src and self.des==other.des
	
		
	def isConstLink(self):
		return "." not in self.src
		
		
	def isCtrlLink(self):
		for suf in CFR.ctrlSuffix:
			if self.desPort.endswith(suf):
				return True
		return False
	
	
	
	
class PipeRtl(Rtl):
	"""PipeRtl means rtl which contains ">>".
	
	"""

	
	def __init__(self, val):
		super(PipeRtl, self).__init__(val)
		self.src = self.val.split(CFR.pipeSymbol)[0]
		self.srcMod, self.srcPort = self.getModAndPort(self.src)
		
	def __eq__(self, other):
		return self.src==other.src
	
	
		

	