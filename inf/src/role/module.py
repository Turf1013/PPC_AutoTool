# -*- coding: utf-8 -*-
from itertools import izip

class constForPort:
	pass
	
class CFP(constForPort):
	pass

class Port(object):
	""" Port describes the port of the module
	
	"""
	
	def __init__(self, name, width="[0:0]"):
		self.name 	= name
		self.width 	= width
			
			
	def __hash__(self):
		return hash(self.name)
	
	
	def __eq__(self, oth):
		return self.name==oth.name
	
			
	def __str__(self):
		return self.name
			

class constForModule:
	pass

class CFM(constForModule):	
	pass
	
class Module(object):
	""" Module presents the core module writen in verilog
	
	"""
	
	def __init__(self, name, iterable=None):
		self.name = name
		if iterable is not None:
			self.portList = list(iterable)
			self.linkDict = dict(izip(iterable, [None] * len(iterable)))
		else:
			self.linkDict = {}
			self.portList = list()
		
	
	def addPort(self, port):
		if isinstance(port, (list, set)):
			for p in port:
				if p not in self.linkDict:
					self.linkDict[p] = None
					self.portList.append(p)
		else:
			if port not in self.linkDict:
				self.linkDict[port] = None
				self.portList.append(port)
	
	
	def add(self, port):
		self.addPort(port)
	
		
	def addLink(self, desPort, srcPort):
		if desPort not in self.portList:
			raise KeyError, "%s not in [%s]" % (desPort, self.name)
		elif self.linkDict[desPort] is not None:
			raise ValueError, "both %s and %s link %s " % (srcPort, self.linkDict[desPort])
			# pass
		else:
			self.linkDict[desPort] = srcPort
			
			
	def __hash__(hash):
		return hash(self.name)
		
			
	def __eq__(self, other):
		return self.name == other.name
	

	def	__len__(self):
		return len(self.portList)
		
		
	def __iter__(self):
		return iter(self.portList)
		
		
	def __str__(self):
		ret = "*Module* %s\n" % (self.name)
		for port in self.portList:
			ret += "%s %s\n" % (port.width, port.name)
		return ret	
		
		
	def instance(self, tabn=1):
		Iname = self.name
		pre = '\t' * tabn
		ret = ""
		ret += "%s%s I_%s(\n" % (pre, self.name, Iname)
		last = len(self.linkDict) - 1
		for i,(key, value) in enumerate(self.linkDict.iteritems()):
			if value is None:
				value = "0000"
			if i == last:
				ret += pre + "\t.%s(%s)\n" % (key, value)
			else:
				ret += pre + "\t.%s(%s),\n" % (key, value)
		ret += "%s);\n" % (pre)
		return ret
	
	
	def toVerilog(self, tabn=1):
		return self.instance(tabn=tabn)
	
		
	def find(self, name):
		for port in self.portList:
			if port.name == name:
				return port
		return None
		
		
	def findPortWidth(self, name):
		p = self.find(name)
		return p.width if p else None
		
		
	def chkLink(self):
		retList = []
		for key, val in self.linkDict.iteritems():
			if val is None:
				retList.append(key)
		return key
		