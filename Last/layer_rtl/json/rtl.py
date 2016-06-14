# -*- coding: utf-8 -*-
import os
import re
import math
import logging
from copy import deepcopy
from abc import abstractmethod
from ..Util.decorator import accetps, returns 
import json

class BaseRTL(object):

	@accepts(object, str)
	def __init__(self, filename):
		if not os.path.isfile(filename):
			raise ValueError, "%s is unvalid filename" % (filename)
		self.filename = filename
		
	@abstractmethod
	def Parse(self):
		pass
		
	@abstractmethod
	def Collection(self):
		pass
		
		
class RTL(BaseRTL):
	
	
	def __init__(self, filename):
		super(RTL, self).__init__(filename)
		
		
	def __getLine(self, filename):
		ret = ""
		with open(filename, "r") as fin:
			for line in fin:
				ret += line.strip()
		return ret
		
		
	def __parse(self, filename):
		rawLine = self.__getLine(filename)
		d = json.loads(rawLine)
		stageList = d["stage"]
		stageDict = dict(zip(stageList, range(0, len(stage))))
		ret = dict()
		for kw, dd in d.iteritems():
			if not kw.startswith("grp_"):
				continue
			insnList = dd["Insns"]
			sameDict = dd.get("same")
			if sameDict is None:
				sameDict = dict()
			diffDict = dd.get("diff")
			if diffDict is None:
				diffDict = dict()
			for insnName in insnList:
				rtlDict = deepcopy(sameDict)
				theDict = diffDict.get(insnName)
				if theDict:
					for stageName, rtls in theDict.iteritems():
						if not rtlDict.has_key(stageName):
							rtlDict[stageName] = []
						rtlDict[stageName] += rtls
				tmpList = []
				for stageName in stageList:
					if rtlDict.has_key(stageName):
						tmpList.append(rtlDict[stageName])
					else:
						tmpList.append([])
				ret[insnName] = tmpList
		return ret
		
		
	def Parse(self):
		return __parse(self.filename)
		
		
	def	__collectByDict(self, rtlDict):
		tmpDict = defaultdict(set)
		for insnName,rtlList in rtlDict.iteritems():
			for i, rtls in enumerate(rtlList):
				tmpDict[i].update(rtls)
				
		ret = dict()
		for stageId, rtlSet in tmpDict.iteritems():
			ret[stageId] = list(rtlSet)
		return ret
		
	
	def __collectByFile(self):
		tmpDict = defaultdict(set)
		rawLine = self.__getLine(filename)
		d = json.loads(rawLine)
		stageList = d["stage"]
		stageDict = dict(zip(stageList, range(0, len(stage))))
		for kw, dd in d.iteritems():
			if not kw.startswith("grp_"):
				continue
			insnList = dd["Insns"]
			sameDict = dd.get("same")
			if sameDict is None:
				sameDict = dict()
			diffDict = dd.get("diff")
			if diffDict is None:
				diffDict = dict()
			for stageName, rtls in sameDict.iteritems():
				stageId = stageDict[stageName]
				tmpDict[stageId].update(rtls)
			for rtlDict in diffDict.itervalues():
				for stageName, rtls in rtlDict.iteritems():
					stageId = stageDict[stageName]
					tmpDict[stageId].update(rtls)
				
		ret = dict()
		for stageId, rtlSet in tmpDict.iteritems():
			ret[stageId] = list(rtlSet)
		return ret
		
		
	def Collection(self, rtlDict=None):
		if rtlDict:
			return self.__collectByDict(rtlDict)
		else:
			return self.__collectByFile()
			
	