# -*- coding: utf-8 -*-
import os
import re
import math
from collections import defaultdict, OrderedDict
import itertools
from ..util.Access_Excel import Access_Excel
from ..role.stage import Stage
from ..role.pipeline import PipeLine
from ..role.rtl import Rtl, LinkRtl, PipeRtl
from ..role.reg import Reg
from ..glob.glob import CFG

class constForExcel:
	ReadStageName = "D"
	WriteStageName = "W"
	rtlBegRow = 0
	rtlBegCol = 0
	
class CFE(constForExcel):
	pass

	
	
class ExcelRtl:

	def __init__(self, linkDict, pipeDict):
		self.linkRtl = linkDict
		self.pipeRtl = pipeDict
		self.stgn = 0
		for insnName,rtlList in linkDict.iteritems():
			self.stgn = len(rtlList)
			break
			
			
	def showInfo(self):
		nLinkRtl = 0
		nPipeRtl = 0
		for rtlList in self.linkRtl.itervalues():
			for rtls in rtlList:
				nLinkRtl += len(rtls)
		for rtlList in self.pipeRtl.itervalues():
			for rtls in rtlList:
				nPipeRtl += len(rtls)
		line = ""
		line += "********************\n"
		line += "RTL:\n"
		line += "(1) %4d link Rtl\n" % (nLinkRtl)
		line += "(2) %4d pipe Rtl\n" % (nPipeRtl)
		line += "********************\n"
		line += "\n\n"
		print line
		
		

class Excel(object):
	""" Excel means Access all kinds of *.xls file.
	
	Excel Function includes:
	1. Generate the PipeLine;	(Must be the first)
	2. Generate all the Rtls(Link & Pipe);
	
	"""
	
	def __init__(self, path):
		if not os.path.exists(path):
			raise SystemError, "%s not exists" % (path)
		self.AE = Access_Excel(path)
	
	
	def GenPipeLine(self, sheetName, regArgsList, brList=[]):
		self.AE.Open_rsheet(sheetName)
		begRow, endRow = CFE.rtlBegRow, self.AE.Get_NRow()
		begCol, endCol = CFE.rtlBegCol, self.AE.Get_NCol()
		# StageName is in firstRow begin with secondCol
		stgNameList = self.AE.Get_OneRow(begRow, begCol+1, endCol)
		stgn = len(stgNameList)
		stgList = [Stage(i, name) for i, name in enumerate(stgNameList)]
		Rstg = stgList[stgNameList.index(CFE.ReadStageName)]
		Wstg = stgList[stgNameList.index(CFE.WriteStageName)]
		regList = []
		for args in regArgsList:
			reg = Reg(*args)
			regList.append(reg)
		ret = PipeLine(stgList=stgList, Rstg=Rstg, Wstg=Wstg, regList=regList, brList=brList)
		if CFG.SHOWINFO:
			ret.showInfo()
		return ret
		
	
	def GenAllRtl(self, sheetName):
		self.AE.Open_rsheet(sheetName)
		begRow, endRow = CFE.rtlBegRow, self.AE.Get_NRow()
		begCol, endCol = CFE.rtlBegCol, self.AE.Get_NCol()
		insnBound = self.__GetInsnBound(begCol)
		retLinkDict = dict()
		retPipeDict = dict()
		for insnName, bound in insnBound.iteritems():
			linkList, pipeList = self.__GenOneInsnRtl(*bound)
			retLinkDict[insnName] = linkList
			retPipeDict[insnName] = pipeList
		ret = ExcelRtl(linkDict=retLinkDict, pipeDict=retPipeDict)
		if CFG.SHOWINFO:
			ret.showInfo()
		return ret
			
			
	# return [2-dimension array] * 2
	def __GenOneInsnRtl(self, begRow, endRow):
		cellList = self.__GenOneInsnCell(begRow, endRow)
		retLinkList = []
		retPipeList = []
		for cells in cellList:
			tmpLinkList = []
			tmpPipeList = []
			for val in cells:
				if Rtl.isLinkRtl(val):
					tmpLinkList.append( LinkRtl(val) )
					
				elif Rtl.isPipeRtl(val):
					tmpPipeList.append( PipeRtl(val) )
				
			retLinkList.append(tmpLinkList)
			retPipeList.append(tmpPipeList)
		return retLinkList, retPipeList
		
		
	# return [2-dimension array] * 1
	def __GenOneInsnCell(self, begRow, endRow):
		begCol, endCol = CFE.rtlBegCol+1, self.AE.Get_NCol()
		retList = [] 
		for c in range(begCol, endCol):
			cellList = self.AE.Get_OneCol(c, begRow, endRow)
			retList.append( filter(lambda s:len(s)>0, cellList) )
		return retList
	
	
	def __HandleInsnName(self, s):
		return s[:-1]+'_' if s[-1]=='.' else s

		
	
	def __GetInsnBound(self, col):
		begRow, endRow = CFE.rtlBegRow, self.AE.Get_NRow()
		retDict = OrderedDict()
		cnt = 0
		for r in xrange(begRow, endRow):
			val = self.AE.Get_OneCell(r, col)
			if val:
				if cnt:
					retDict.update({name: (rr, r)})
				rr = r
				cnt += 1
				name = self.__HandleInsnName(val)
		if name:
			retDict.update({name: (rr, endRow)})
		return retDict
		