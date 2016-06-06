# -*- coding: utf-8 -*-
import logging
import ..util.verilog import verilog as vlg
import ..util.decorator import accepts, returns
import os


class constForPort:
	INPUT = 1
	OUPUT = 0
	
class CFP(constForPort):
	pass
	
	
class constForModule:
	
	
class CFM(constForModule):
	pass


class BasePort(object):

	@accepts(object, str, int, int)
	def __init__(self, name, dir, width):
		self.name = name
		self.dir = dir
		self.width = width
		
		
	def __hash__(self):
		return hash(self.name)
		
		
	def __eq__(self, other):
		return self.name == other.name
		
		
	def __repr__(self):
		if self.dir == CFP.INPUT:
			return "input [%d:0] %s" % (self.width-1, self.name)
		else:
			return "output [%d:0] %s" % (self.width-1, self.name)
			
	__str__ = __repr__
	

class Port(BasePort):

	def __init__(self, name, dir, width):
		super(Port, self).__init__(name, dir, width)
	
	
class BaseModule(object):
	
	@accpets(object, str, (list,set,tuple))
	def __init__(self, name, portList):
		self.name = name
		self.ports = tuple(portList)
		
		
	def findPort(self, name):
		for port in self.ports:
			if port.name == name:
				return port
		return None
		
	def findWidth(self, name):
		p = self.findPort(name)
		if p:
			return p.width
		else:
			return None
		
		
	def __eq__(self, other):
		return self.name == other.name
		
		
	def __hash__(self):
		return hash(self.name)
		
		
	def __repr__(self):
		ret = "<Module> %s\n" % (self.name)
		for port in self.ports:
			ret += str(port)
		return ret	
		
	__str__ = __repr__
	
	
class Module(BaseModule):

	
	def __init__(self, name, portList, iterable=None):
		super(Module, self).__init__(name, portList)
		if iterable:
			self.linkDict= dict(izip(iterable, [None] * len(iterable)))
		else:
			self.linkDict = dict()
		
	
	@staticmethod
	@accepts(str, dict)
	def GenModules(filename, widthDict):
		if not os.path.isfile(filename):
			raise ValueError, "[Module] %s is unvalid filename" % (filename)
		ret = []
		with open(filename, "r") as fin:
			tmpList = []
			for line in fin:
				if line.strip().startswith(CFP.MODULE):
					tmpList = []
				tmpList.append(line)
				if line.strip().startswith(CFP.ENDMODULE):
					name, portList = vlg.ParseModule(tmpList, widthDict)
					ret.append( Module(name, portList) )
			
		return ret	
		
		
	def addLink(self, desPort, srcPort):
		logging.debug("[%s] link %s to %s\n" % (self.name, srcPort, desPort))
		if isinstance(desPort, str):
			desPort = self.findPort(desPort)
		if desPort not in self.ports:
			raise KeyError, "%s not in [%s]" % (desPort, self.name)
		elif self.linkDict[desPort] is not None:
			raise ValueError, "both %s and %s link %s " % (srcPort, self.linkDict[desPort], desPort)
			# pass
		else:
			self.linkDict[desPort] = srcPort
		
		
	def __instance(Iname, tabn):
		pre = '\t' * tabn
		ret = ""
		ret += "%s%s %s (\n" % (pre, self.name, Iname)
		n = len(self.linkDict)
		for i,(key, value) in enumerate(self.linkDict.iteritems()):
			if value is None:
				value = "0000"
			if i == n - 1:
				ret += pre + "\t.%s(%s)\n" % (key, value)
			else:
				ret += pre + "\t.%s(%s),\n" % (key, value)
		ret += "%s);\n\n" % (pre)
		return ret
		
		
	def toVerilog(self, Iname=None, tabn=1):
		if not Iname:
			Iname = "I_" + self.name
		return self.__instance(Iname, tabn)
		
		
	def unlinkPort(self):
		return filter(lambda k:self.linkDict[k], self.linkDict.iterkeys())
		
		
	def linkNum(self):	
		return len(filter(lambda val: val, self.linkDict.itervalues()))
		
		
	def formula(self):
		pass