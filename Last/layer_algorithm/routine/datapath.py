# -*- coding: utf-8 -*-
import logging
from ..util.verilog import verilog as vlg
from ..util.decorator import accepts, returns
from ..model.wire import Wire
from ..model.mutex import PortMutex, BypassMutex
from abc import abstractmethod
import os


class constForDatapath:
	INSTR = "Instr"
	CLK = "clk"
	RST = "rst_n"
	CLR = "clr"
	STALL = "stall"
	WIRE = "wire"
	REG = "reg"
	
class CFD(constForDatapath):
	pass
	

class BaseDatapath(object):
	
	def __init__(self, proc):
		self.proc = proc
	
	
	@abstractmethod 
	def LinkMod(self):
		pass
		
		
	@abstractmethod
	def GenPortMux(self):
		pass
	
	
	@abstractmethod
	def	GenPipe(self):
		pass
		
		
	@abstractmethod	
	def toVerilog(self, tabn):
		pass
	
	
class Datapath(BaseDatapath):


	def __init__(self, proc, linkRtl, pipeRtl):
		super(Datapath, self).__init__(proc)
		self.linkRtl = linkRtl
		self.pipeRtl = pipeRtl
		self.wireSet = set()
		
		
	def LinkMod(self):
		nstg = self.proc.ppl.nstg
		pipeSet = set()
		for istg in xrange(nstg):
			linkRtlSet = set()
			for insnName, linkRtlList in self.linkRtl.iteritems():
				linkRtlSet.update(linkRtlList)
			
			pipeRtlSet = set()
			for insnName, pipeRtlList in self.pipeRtl.iteritems():
				pipeRtlSet.update(pipeRtlList)
			
			pipeRtlSet -= pipeSet
			self.__LinkMod(linkRtlSet, pipeRtlSet, istg)
			pipeSet |= pipeRtlSet
			
			
	def UpdateWireSet(self, ctrl=None, pmuxList=None, bmuxList=None):		
		if ctrl:
			for w in ctrl.wireSet
				ww = Wire(name=w.name, width=w.width, kind=CFD.WIRE, stg=w.stg)
				self.wireSet.add(ww)
				
		if pmuxList:
			for pmux in pmuxList:
				w = Wire(name=pmux.GenDoutName(), width=pmux.width, kind=CFD.WIRE, stg=pmux.stg)
				self.wireSet.add(w)
				
		if bmuxList:
			for bmux in bmuxList:
				w = Wire(name=bmux.GenDoutName(), width=bmux.width, kind=CFD.WIRE, stg=bmux.stg)
				self.wreSet.add(w)
			
			
	def __LinkMod(self, linkRtlSet, pipeRtlSet, istg):
		self.__LinkModByLink(self, linkRtlSet, istg)
		self.__LinkModByPipe(self, pipeRtlSet, istg)
		
		
	def __LinkModByPipe(self, pipeRtlSet, istg):
		stgName = self.proc.ppl.stgNameAt(istg)	
		for rtl in pipeRtlSet:
			if rtl.srcMod is None or rtl.srcPort is None:
				continue
			varName = vlg.SrcToVar(rtl.src, suf=stgName)
			mod = self.proc.findMod(rtl.srcMod)
			mod.addLink(rtl.srcPort, varName)
		
			
	def __LinkModByLink(self, linkRtlSet, istg):
		stgName = self.proc.ppl.stgNameAt(istg)	
		tmpDict = defaultdict(set)	
		for rtl in linkRtlSet:
			tmpDict[rtl.des].add(rtl)
			
		for desPort, linkSet in tmpDict.iteritems():
			linkList = list(linkSet)
			
			if len(linkList) > 1:
				# obviously mux.dout as input
				for rtl in linkList:
					if rtl.srcMod is None:
						continue
					varName = vlg.SrcToVar(rtl.src, suf=stgName)
					mod = self.proc.findMod(rtl.srcMod)
					mod.addLink(rtl.srcPort, varName)
					width = mod.findWidth(rtl.srcPort)
					srcList = vlg.SrcToList(rtl.src)
					for src in srcList
						varName = vlg.SrcToVar(src, suf=stgName)
						self.wireSet.add( Wire(name=varName, width=width, kind=CFR.WIRE, stg=istg) )
						
			elif linkList[0].isCtrlLink():
				# Control Signal named as itself
				varName = vlg.DesToVar(rtl.des, suf=stgName)
				mod = self.proc.findMod(rtl.desMod)
				mod.addLink(rtl.desPort, varName)
				width = mod.findWidth(rtl.desPort)
				self.wireSet.add( Wire(name=varname, width=width, kind=CFR.WIRE, stg=istg) )
				
			else:
				src = self.__FindInBypass(rtl.src, stg=istg)[0]
				varName = vlg.SrcToVar(src, suf=stgName)
				mod = self.proc.findMod(rtl.desMod)
				mod.addLink(rtl.desMod, varName)
				width = mod.findWidth(rtl.desPort)
				
				# add the desPort to wireSet
				self.wireSet.add( Wire(name=vlg.SrcToVar(varName, suf=stgName), width=width, kind=CFR.WIRE, stg=istg))
				
				# add the element in srcList to wireSet
				srcList = vlg.SrcToList(rtl.src)
				for src in srcList:
					varName = vlg.SrcToVar(src, suf=stgName)
					self.wireSet.add( Wire(name=varName, width=width, kind=CFR.WIRE, stg=istg) )
				
				# some srcPort is the output of the module, make them link
				if rtl.srcMod is not None:
					varName = vlg.SrcToVar(rtl.src, suf=stgName)
					mod = self.proc.findMod(rtl.srcMod)
					mod.addLink(rtl.srcPort, varName)
					self.wireSet.add( Wire(name=varName, width=width, kind=CFR.WIRE, stg=istg) )
				
			
	def __inputToVerilog(self, tabn):
		pre = "\t" * tabn
		ret = ""
		ret += pre + "input %s;\n" % (CFD.CLK)
		ret += pre + "input %s;\n" % (CFD.RST)
		return ret
		
		
	def __outputToVerilog(self, tabn):
		pre = "\t" * tabn
		ret = ""
		return ret
		
		
	def __ModToVerilog(self, tabn):
		ret = ""
		for mod in self.proc.itermodules():
			linkNum = self.linkNum()
			if linkNum == 0:
				logging.debug("[linkn] %s create, but not Instance.\n" % (mod.name))
				continue
			try:
				mod.addLink(CFD.CLK, CFD.CLK)
				mod.addLink(CFD.RST, CFD.RST)
			except:
				pass
			ret += mod.toVerilog(tabn=tabn)
		return ret
		
		
	def __wireToVerilog(self, tabn):
		ret = ""
		tmpList = sorted(self.wireSet)
		for wire in tmpList:
			ret += wire.toVerilog(tabn = tabn)
		return ret
		
		
	def __muxToVerilog(self, muxList, tabn):
		ret = ""
		for mux in muxList:
			ret += mux.toVerilog(tabn = tabn) + "\n"
		return ret
		