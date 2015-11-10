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
	1. Generate the Port MUX & Constrol Signal related;
	2. Add the Link to necessary Module;
	3. 
	"""
	
	def __init__(self, excelRtl, pipeLine, modMap, insnMap, needBypass):
		self.excelRtl = excelRtl
		self.pipeLine = pipeLine
		self.modMap = modMap
		self.insnMap = insnMap
		self.needBypass = needBypass
	
	# Add the link
	def LinkMod(self):
		likRtl = self.excepRtl.linkRtl
		stgn = self.pipeLine.stg
		for istg in xrange(stgn):
			rtlSet = set()
			for insnName, insnRtlList in linkRtls.iteritems():
				rtlSet.update(insnRtlList[istg])
			self.__LinkModPerStg(rtlSet, istg)
			
			
	def __LinkModPerStg(self, rtlSet, istg):
		stgName = self.pipeLine.StgNameAt(istg)
		d = defaultdict(set)
		for rtl in rtlSet:
			d[rtl.des].add(rtl)
			
		for des, rtlSet in d.iteritems():
			rtlList = list(rtlSet)
			rtl = rtlList[0]
			if rtl.isCtrlLink():
				# Control Signal named as itself
				varName = RP.DesToVar(rtl.des)
				mod = self.modMap.find(rtl.desMod)
				mod.addLink(rtl.desPort, varName)
				
			elif len(rtlList)>1:
				# mux.dout link (linked in mux generating)
				pass
				
			else:
				src = self.__FindInBypass(src=rtl.src, stg=istg)
				varName = RP.SrcToVerilog(src=src, srg="_"+stgName)
				mod = self.modMap.find(rtl.desMod)
				mod.addLink(rtl.desPort, varName)
			
	
	
	# Generate all the Port Mux
	def GenPortMux(self):
		linkRtl = self.excelRtl.linkRtl
		stgn = self.pipeLine.stgn
		retMuxList = []
		retCSList = []
		for istg in xrange(stgn):
			rtlSet = set()
			for insnName, insnRtlList in linkRtl.iteritems();
				rtlSet.update(insnRtlList[istg])
			muxList, csList = self.__GenPortMuxPerStg(self, rtlSet, istg)
			retMuxList += muxList
			retCSList += retCSList
		return retMuxList, retCSList
		
	
	# Generate the Port Mux & Control Signal @istg
	def __GenPortMuxPerStg(self, rtlSet, istg):
		portDict = defaultdict(set)
		for rtl in rtlSet:
			if not rtl.isCtrlLink():
				portDict[rtl.des].add(rtl)
		retMuxList = []
		retCSList = []
		for des,linkSet in portDict.iteritems():
			srcList = map(lambda x:x.src, linkSet)
			srcList = map(self.__FindInBypass(src=src,stg=istg), srcList)
			if len(srcList) > 1:
				rtl = list(linkSet)[0]
				# Need to Insert a Port MUX
				name = self.__GenPortMuxIname(rtl, istg)
				linkedIn = self.__GenPortMuxLinkedIn(srcList, istg)
				desMod = self.modMap.find(rtl.desMod)
				width = VP.RangeToInt(desMod.find(rtl.desPort))
				
				### Generate the MUX
				pmux = PortMutex(name=name, width=width, linkedIn=linedIn)
				retMuxList.append(pmux)
				
				### Link the MUX dout to orginal module
				doutName = pmux.GenDoutName():
				mod = self.modMap.find(rtl.desMod)
				mod.addLink(rtl.dePort, doutName)
				
				### Generate the CtrlSignal
				selName = pmux.GenSelName()
				selN = pmux.seln
				tList = []
				for insnName, insnRtlList in linkRtl.iteritems():
					for r in insnRtlList[istg]:
						if r in linkSet:
							insn = self.insnMap.find(insnName)
							cond = insn.condition(suf = self.pipeLine.StgNameAt(istg))
							src = self.__FindInBypass(src=r.src, stg=istg)
							op = linkeIn.index(src)
							tList.append( CtrlTriple(cond=cond, op=op) )
				cs = CtrlSignal(name=selName, width=selN, iterable=tList)
				retCSList.append(cs)
				
		return retMuxList, retCSList
		
		
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
		
	
	# find source in the bypass if source flow through bypass then return rename or return itself
	def __FindInBypass(self, src, istg):
		for rt in self.needBypass:
			if rt.equal(src=src, stg=istg)
				return rt.des
		return src
		