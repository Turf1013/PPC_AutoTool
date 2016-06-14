# -*- coding: utf-8 -*-
import logging
from ..util.verilog import verilog as vlg
from ..util.decorator import accepts, returns
from abc import abstractmethod
import os, re


"""
We only support simple grammer with two operators: `->`, `>>`.
Reference http://poj.org/problem?id=3136 is a nice algorithm for solving parsing the grammer.
I use thompson-construct method to solve the problem.
If you know nothing about `Ken Thompson`, then I will be wordless.
"""

class constForGrammer:
	LINK_TOKEN = "->"
	PIPE_TOKEN = ">>"
	space_re = re.compile("\s+")

class CFG(constForGrammer):
	pass
	
	
class BaseGrammer(object):
	
	@abtractmethod
	def Parse(insnDict):
		pass
		
		
class Grammer(BaseGrammer):
	
	@staticmethod
	def isLink(rtl):
		return CFG.LINK_TOKEN in rtl
		
		
	@staticmethod	
	def isPipe(rtl):
		return CFG.PIPE_TOKEN in rtl
	
	@staticmethod
	def __trim(line):
		return space_re.sub("", line)
		
		
	@staticmethod	
	def __ParseLink(line):
		line = Grammer.__trim(line)
		return rtl.split(CFG.LINK_TOKEN)[:-2]
		
		
	@staticmethod	
	def __ParsePipe(line):
		line = Grammer.__trim(line)
		return rtl.split(CFG.PIPE_TOKEN)[0]
		
		
	@staticmethod	
	def	__Parse(rtl):
		assert Grammer.isLink(rtl) or Grammer.isPipe(rtl)
		if Grammer.isLink(rtl):
			return Grammer.__ParseLink(rtl)
		elif Grammer.isPipe(rtl):
			return Grammer.__ParsePipe(rtl)
		
	
	@staticmethod
	def __ParseAll(rtlList):
		retLinkList, retPipeList = [], []
		for rtls in rtlList:
			tmpLinkList, tmpPipeList = [], []
			for rtl in rtls:
				if Grammer.isLink(rtl):
					tmpLinkList.append( Grammer.__ParseLink(rtl) )
				elif Grammer.isPipe(rtl):
					tmpPipeList.append( Grammer.__ParsePipe(rtl) )
				else:
					logging.debug("unknown type rtl: %s" % (rtl))
			retLinkList.append( tmpLinkList )
			retPipeList.append( tmpPipeList )
		return retLinkList, retPipeList
			
		
	@staticmethod
	@accpets(dict)
	@returns(dict)
	def Parse(insnDict):
		retLinkDict, retPipeDict = {},{}
		for insnName, rtlList in insnDict.iteritems():
			tmpLinkList, tmpPipeList = Grammer.__ParseAll(rtlList)
			retLinkDict[insnName] = tmpRtlList
			retPipeDict[insnName] = tmpPipeList
		return retLinkDict, retPipeDict
		