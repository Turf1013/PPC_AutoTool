# -*- coding: utf-8 -*-
from itertools import izip
import logging

class constForPort:
	pass
	
class CFP(constForPort):
	pass

class Port(object):
	""" Port describes the port of the module
	"""
	
	def __init__(self, name, width="[0:0]", dir=0):
		self.name 	= name
		self.width 	= width
		self.dir	= dir
		
			
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
		# logging.debug("[%s] link %s to %s\n" % (self.name, srcPort, desPort))
		if isinstance(desPort, str):
			tmpStr = desPort
			desPort = self.find(desPort)
			if desPort is None:
				print self.name, tmpStr
		if desPort not in self.portList:
			raise KeyError, "%s not in [%s]" % (desPort, self.name)
		elif self.linkDict[desPort] is not None:
			raise ValueError, "both %s and %s link %s " % (srcPort, self.linkDict[desPort], desPort)
			# pass
		else:
			self.linkDict[desPort] = srcPort
			
	
	def	getLink(self, desPort):
		if isinstance(desPort, str):
			desPort = self.find(desPort)
		if desPort not in self.portList:
			raise KeyError, "%s not in [%s]" % (desPort, self.name)
		return self.linkDict[desPort]
			
			
	def __hash__(self, hash):
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
		ret += "%s%s I_%s (\n" % (pre, self.name, Iname)
		portList = []
		# filter the unlink output port
		for port, inst in self.linkDict.iteritems():
			if inst is None and port.dir==0:
				continue
			portList.append([port.name, inst])	
			
		for i,(portName, inst) in enumerate(portList):
			if inst is None:
				inst = 0
			if i == len(portList)-1:
				ret += pre + "\t.%s(%s)\n" % (portName, inst)
			else:
				ret += pre + "\t.%s(%s),\n" % (portName, inst)
		ret += "%s);\n\n" % (pre)
		return ret
	
	
	def toVerilog(self, tabn=1):
		return self.instance(tabn=tabn)
	
		
	def find(self, name):
		for port in self.portList:
			if port.name == name:
				return port
		# raise ValueError, "%s has no port named %s" % (self.name, name)
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
		
		
	def linkn(self):
		ret = 0
		for key, val in self.linkDict.iteritems():
			if val:
				ret += 1
		return ret
		
		