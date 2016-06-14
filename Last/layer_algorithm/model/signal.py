# -*- coding: utf-8 -*-
import logging
from ..util.verilog import verilog as vlg
from ..util.decorator import accepts, returns
from abc import abstractmethod
import os

class constForSignal:


class CFS(constForSignal):
	pass
	
	
class BaseSignal(object):

	@accepts(object, str, int)
	def __init__(self, name, width):
		self.name = name
		self.width = width
		self.rule = defaultdict(list)
		
		
	def __eq__(self, other):
		return self.name == other.name
		
		
	def __hash__(self):
		return hash(self.name)
	
	
	def isEmpty(self):
		for L in self.rule.iteritems():
			if len(L) > 0:
				return False
		return True
		
		
	@acccepts(object, str, int)	
	def addRule(self, cond, val):
		assert val>=0 && val<2**self.width
		self.rule[val].append( cond )
		
		
	@abstractmethod	
	def toVerilog(self, tabn, defaultVal):
		pass
		
		
class Signal(BaseSignal):

	@accepts(object, str, int)
	def __init__(self, name, width):
		super(Signal, self).__init__(name, width)
	
		
	def toVerilog(self, tabn = 1, defaultVal = 0):
		pre = '\t' * tabn
		radix = "%s'd" % (self.width)
		
		ret = pre + "/*********   Logic of %s   *********/\n" % (self.name)
		ret += pre + "always @( * ) begin\n"
		
		if self.isEmpty():
			# only using default val
			ret += pre + "\t\t%s = %s%s;\n" % (self.name, radix, defaultVal)
		else:
			# use if-else if 
			c = 0
			for val,condList in self.rule.iteritems():
				for cond in condList:
					if c:
						ret += pre + "\t" + "else if ( %s ) begin\n" % (cond)
					else:
						ret += pre + "\t" + "if ( %s ) begin\n" % (cond)
					ret += pre + "\t\t" + "%s = %s%s;\n" % (self.name, radix, val)
					ret += pre + "\t" + "end\n"
					c += 1
			# add else
			assert c > 0
			ret += pre + "\t" + "else begin\n"
			ret += pre + "\t\t" + "%s = %s%s;\n" % (self.name, radix, defaultVal)
			ret += pre + "\t" + "end\n"
		# add end always
		ret += pre + "end // end always\n"
		return ret
		
		
class Priority_Signal(BaseSignal):

	@accepts(object, str, int)
	def __init__(self, name, width):
		super(Signal, self).__init__(name, width)
		self.priDict = dict()
		
		
	@acccepts(object, str, int)	
	def addRule(self, cond, pri, val):
		assert val>=0 && val<2**self.width
		self.rule[val].append( cond )
		if cond in self.priDict:
			assert self.priDict[cond] == pri
		self.priDict[cond] = pri
		
		
	def toVerilog(self, tabn = 1, defaultVal = 0):
		pre = '\t' * tabn
		radix = "%s'd" % (self.width)
		tmpList = reduce(lambda x,y: x+y, map(lambda t: zip([t[0]]*len(t[1]), t[1]), ruleList.iteritems()))
		ruleList = sorted(tmpList, cmp=lambda x,y: cmp(self.priDict[x[1]], self.priDict[y[1]]))
		
		ret = pre + "/*********   Logic of %s   *********/\n" % (self.name)
		ret += pre + "always @( * ) begin\n"
		
		if self.isEmpty():
			# only using default val
			ret += pre + "\t\t%s = %s%s;\n" % (self.name, radix, defaultVal)
		else:
			# use if-else if 
			c = 0
			for val,cond in ruleList:
				if c:
					ret += pre + "\t" + "else if ( %s ) begin\n" % (cond)
				else:
					ret += pre + "\t" + "if ( %s ) begin\n" % (cond)
				ret += pre + "\t\t" + "%s = %s%s;\n" % (self.name, radix, val)
				ret += pre + "\t" + "end\n"
				c += 1
			# add else
			assert c > 0
			ret += pre + "\t" + "else begin\n"
			ret += pre + "\t\t" + "%s = %s%s;\n" % (self.name, radix, defaultVal)
			ret += pre + "\t" + "end\n"
		# add end always
		ret += pre + "end // end always\n"
		return ret