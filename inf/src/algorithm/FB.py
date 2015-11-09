# -*- coding: utf-8 -*-
from tree import WTree
from ..role.hazard import StgInsn
from ..role.ctrlSignal import CtrlSignal, CtrlTriple
from ..util.RTLParser import RTlParser as RP

class constForFB:
	STALL = "stall"
	
class CFFB(constForFB):
	pass

class FB(object):
	""" FB is the most optimized algorithm handled the hazard in PipeLine Compeletely.
	
	
	"""
	
	def __init__(self, excelRtl, pipeLine, modMap, insnMap):
		self.excelRtl = excelRtl
		self.pipeLine = pipeLine
		self.modMap = modMap
		self.insnMap = insnMap
		self.bmuxList = []
		self.stall = CtrlSignal(name=CFFB.STALL, width=1)
		
	
	def __str__(self):
		return "Forward and Backward Algorithm"
		
		
	def HandleHazard(self):
		for reg in self.pipeLine.regList:
			self.__HandleHazardPerReg(reg)

			
	def __HandleHazardPerReg(self, reg):
		regName = reg.name
		if reg.wn == 1:
		wInsnList = []
		rInsnList = []
		# Generate Write StgInsn
		for i in range(reg.wn):
			wStgInsnList = self.__GenWStgInsn(regName, index=i)
			wInsnList += wStgInsnList
			
		# Generate Read StgInsn
		for j in range(reg.rn):
			rStgInsnList = self.__GenRStgInsn(regName, index=j)
			rInsnList.append(rStgInsnList)
		
		Rstg = self.pipeLine.Rstg
		stgn = self.pipeLine.stgn
		for rIndex in range(reg.rn):
			regs = map(
				lambda i: StgReg(name=regName, index=rIndex, stgName=self.pipeLine.StgNameAt(i)), range(Rstg, stgn)
			)
			for binsn in rInsnList:
				for finsn in wInsnList:
					self.__HandleInsnPair(finsn, binsn, regs)
					
				
	def __HandleInsnPair(self, finsn, binsn, regs):
		Wstg = self.pipeLine.Wstg
		Rstg = self.pipeLine.Rstg
		# the condition of send
		for pw in range(finsn.stg+1, Wstg):
			# link the send-wd into bmux
			sendData = RP.SrcToVerilog(src=finsn.wd, stg=self.pipeLine.StgNameAt(pw))
			regs[Rstg].add(sendData)
			# add the condition to csMap
			
		
	def __GenWStgInsn(self, regName, index=""):
		ret = []
		waddr = RG.GenRegWaddr(regName, index="")
		wd = RG.GenRegWd(regName, index="")
		wstg = self.pipeLine.Wstg
		linkRtl = self.excelRtl.linkRtl
		for insnName, rtlList in linkRtl.iteritems():
			addrRtl, wdRtl = None, None
			for rtl in rtlList[wstg]:
				if rtl.des == waddr:
					addrRtl = rtl
				elif rtl.des == wd:
					wdRtl = rtl
			if wdRtl is None:
				continue
			insn = self.insnMap.find(insnName)
			addr = None if addrRtl is None else addrRtl.src
			stg = self.__findFirstAppear(insnName, wd.src)
			if stg<0:
				raise ValueError, "%s not appear in %s Pipe" % (wd.src, insnName)
			si = StgInsn(insn=insn, stg=stg, addr=addr, wd=wdRtl.src)
			ret.append(si)
		return ret
			
			
	def __findFirstAppear(self, insnName, src):
		pipeRtl = self.excel.linkRtl
		rtlList = pipeRtl[insnName]
		for i in xrange(self.pipeLine.stgn):
			for rtl in rtlList[i]:
				if rtl.src == src:
					return i
		return -1		
		
		
	def __GenRStgInsn(self, insnName, index=""):
		ret = []
		raddr = RG.GenRegRaddr(regName, index="")
		rd = RG.GenRegWd(regName, index="")
		rstg = self.pipeLine.Rstg
		stgn = self.pipeLine.stgn
		linkRtl = self.excelRtl.linkRtl
		for insnName, rtlList in linkRtl.iteritems():
			addrRtl,ustg = None,None
			# find first use stage
			for istg in range(rstg, stgn):
				for rtl in rtlList[istg]:
					if rtl.src == rd:
						ustg = istg
						break
				if ustg is not None:
					break
			if ustg is None:
				continue
			# find raddr
			for rtl in rtlList[rstg]:
				if rtl.des == rd:
					addrRtl = rtl
					break
			insn = self.insnMap.find(insnName)
			addr = None if addrRtl is None else addrRtl.src
			si = StgInsn(insn=insn, stg=ustg, addr=addr)
			ret.append(si)
		return si
		
		