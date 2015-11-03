# -*- coding: utf-8 -*-
import re


re_space = re.compile("\s+")

class Rtl(object):
	"""Rtl means a language to describe the execution process of one Insn.
	
	
	"""
	
	def __init__(self, line):
		self.line = re_space.sub("", line)
		
	def __hash__(self):
		return hash(self.line)
		
	def __str__(self):
		return self.line
			
	@classmethod
	def getMod(cls, wire):
		return wire.split(".")[0]
		
	@classmethod
	def getPort(cls, wire):
		return wire.split(".")[-1]
		
	@classmethod
	def getModAndPort(cls, wire):
		return wire.split(".")

	
linkSymbol = "->"
ctrlSuffix = [
	"Op",
	"Wr"
]
class LinkRtl(Rtl):
	"""LinkRtl means rtl which contains "->".
	
	"""
	
	def __init__(self, line):
		super(LinkRtl, self).__init__(line)
		self.src, self.des = self.line.split(linkSymbol)
		if self.isConstLink():
			self.srcMod = None
			self.srcPort = self.src
		else:
			self.srcMod, self.srcPort = self.getModAndPort(self.src)
			
		self.desMod, self.desPort = self.getModAndPort(self.des)
		
	
	def __eq__(self, other):
		return self.src==other.src and self.des==other.des
		
		
	def isConstLink(self):
		return "." not in self.src
		
		
	def isCtrlLink(self):
		for suf in ctrlSuffix:
			if self.desPort.endswith(suf):
				return true
		return false
	
	
	
	
	
pipeSymbol = ">>"
class PipeRtl(Rtl):
	"""PipeRtl means rtl which contains ">>".
	
	"""

	
	def __init__(self, line):
		super(PipeRtl, self).__init__(line)
		self.src = self.line.split(pipeSymbol)
		self.srcMod, self.srcPort = self.getModAndPort(self.src)
		
		
	def __eq__(self, other):
		return self.src==other.src
	
	
		
if __name__ == "__main__":
	aLinkb = LinkRtl("1'b1   ->  b.y")
	aPipe  = PipeRtl("a.x >> ")
	# print aLinkb
	# print aPipe
	print aLinkb.isConstLink()
	
	