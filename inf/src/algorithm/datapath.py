# -*- coding: utf-8 -*-
from collections import defaultdict
from ..role.ctrlSignal import CtrlSignal, CtrlTriple
from ..util.verilogParser import VerilogParser as VP
from ..util.rtlParser import RtlParser as RP
from ..util.rtlGenerator import RtlGenerator as RG


class constForDatapath:
	pass
	
class CFD(constForDatapath):
	pass


class Datapath(object):
	""" datapath includes all kinds of function about the whole datapath
	
	Function:
	1. Generate the Port MUX;
	2. Generate the Norm-Control;
	"""
	
	def __init__(self, excelRtl, pipeLine, modules):
		self.excelRtl = excelRtl
		self.pipeLine = pipeLine
		self.modules = modules
	
	
	# Generate all the Port Mux
	def GenPortMux(self):
		linkRtl = self.excelRtl.linkRtl
		stgn = self.pipeLine.stgn
		retMuxList = []
		for istg in xrange(stgn):
			rtlSet = set()
			for insnName, insnRtlList in linkRtl.iteritems();
				rtlSet.update(insnRtlList[istg])
			retMuxList += self.__GenPortMuxPerStg(self, rtlSet, istg)
		return retMuxList
		
	
	# Generate the Port Mux @istg
	def __GenPortMuxPerStg(self, rtlSet, istg):
		portDict = defaultdict(set)
		for rtl in rtlSet:
			portDict[rtl].add(rtl)
		retList = []
		retDict = dict()
		for rtl,rtlSet in portDict.iteritems():
			srcList = map(lambda x:x.src, rtlSet)
			if len(srcList) > 1:
				# Need to Insert a Port MUX
				name = self.__GenPortMuxIname(rtl, istg)
				linkedIn = self.__GenPortMuxLinkedIn(srcList, istg)
				desMod = self.modules.find(rtl.desMod)
				width = VP.RangeToInt(desMod.find(rtl.desPort))
				pmux = PortMutex(name=name, width=width, linkedIn=linedIn)
				retList.append(pmux)
				# the rtl need a mux parse to Instance a mux and Encode the select
				retDict[rtl] = (RG.GenMuxSel(pmux.Iname), srcList)
				
		return retList, retDict	
		
		
	# Generate the link of the Mux
	def __GenPortMuxLinkedIn(self, srcList, istg):
		retList = []
		stgName = self.pipeLine.StgNameAt(istg)
		for src in srcList:
			retList.append(RP.SrcToVerilog(src, stgName))
		return retList	
		
				
	# Generate the instance name of Port Mux
	def __GenPortMuxIname(self, rtl, istg):
		return "%s_%s_%s" % (rtl.desMod, rtl.desPort, self.pipeLine.stgNameAt(istg))
		
		
	