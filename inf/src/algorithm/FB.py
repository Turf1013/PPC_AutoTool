# -*- coding: utf-8 -*-
from ..role.hazard import StgInsn, RW_Hazard, Stall_Hazard
from ..role.ctrlSignal import CtrlSignal, CtrlTriple
from ..role.stage import Stage
from ..util.rtlParser import RtlParser as RP
from ..util.rtlGenerator import RtlGenerator as RG
from ..util.verilogParser import VerilogParser as VP
from ..util.verilogGenerator import VerilogGenerator as VG

class constForFB:
	STALL = "stall"
	
class CFFB(constForFB):
	pass
	
	
class RdTriple(object):

	def __init__(self, src, des, stg):
		self.src = src
		self.stg = stg
		self.des = des
	
	def __hash__(self):
		return hash(self.__str__())
	
	def __eq__(self, other):
		return self.src==other.src and self.des==other.des and self.stg==other.stg
		
	def __str__(self):
		return "%s->%s @%s" % (self.src, self.des, str(self.stg))
		
	
	def equal(self, src, stg):
		return self.src==src and self.stg==stg
	
class FB(object):
	""" FB is the most optimized algorithm handled the hazard in PipeLine Compeletely.
	
	
	"""
	
	def __init__(self, excelRtl, pipeLine, modMap, insnMap):
		self.excelRtl = excelRtl
		self.pipeLine = pipeLine
		self.modMap = modMap
		self.insnMap = insnMap
		self.stallHazard = Stall_Hazard()
		self.needBypass = set()
	
	def __str__(self):
		return "Forward and Backward Algorithm"
		
		
	# Handle all the possible hazard pair (stall and bypass)
	def HandleHazard(self):
		csRetList = []
		muxRetList = []
		for reg in self.pipeLine.regList:
			csList, muxList = self.__HandleHazardPerReg(reg)
			csRetList += csList
			muxList += muxList
		csRetList.append( self.__HandleStall() )
		return csRetList, muxRetList
		
		
	def __HandleStall(self, reg):
		Rstg = self.pipeLine.Rstg
		cs = CtrlSignal(name=CFFB.STALL, width=1)
		# add clear 
		clr = VG.GenClr(suf = self.pipeLine.StgNameAt(Rstg))
		cs.add( CtrlTriple(cond=clr, pri=10**5))
		for insnGrp in self.stallHazard:
			Binsn = insnGrp.Binsn
			for Finsn in insnGrp.FinsnSet:
				if binsn.addr is None and finsn.addr is None:
					# no addr
					cond = "%s && %s " % (binsn.condition(), finsn.condition())
				else:
					baddr = RP.SrcToVar(binsn.addr, stg=self.pipeLine.StgNameAt(binsn.stg))
					faddr = RP.SrcToVar(finsn.addr, stg=self.pipeLine.StgNameAt(finsn.stg))
					addrCond = "(%s == %s)" % (baddr, faddr)
					cond = "%s && %s && %s" % (binsn.condition(), finsn.condition(), addrCond)
				op = 1
				pri = stgn - finsn.stg
				ct = CtrlTriple(cond=cond, op=op, pri=pri)
				cs.add(ct)
		return cs
		
			
	def __HandleHazardPerReg(self, reg):
		regName = reg.name
		wInsnList = []
		rInsnList = []
		
		if reg.wn > 1:
			# Generate Write StgInsn
			for i in range(reg.wn):
				wStgInsnList = self.__GenWStgInsn(regName, index=i)
				wInsnList += wStgInsnList
		else:
			wInsnList.append( self.__GenWStgInsn(regName))
			
		if reg.rn > 1:
			# Generate Read StgInsn
			for j in range(reg.rn):
				rStgInsnList = self.__GenRStgInsn(regName, index=j)
				rInsnList.append(rStgInsnList)
		else:
			rInsnList.append( self.__GenRStgInsn(regName) )
			
		rstg = self.pipeLine.Rstg.id
		stgn = self.pipeLine.stgn
		csRetList = []
		muxRetList = []
		# iterate every read channels
		for rIndex in range(reg.rn):
			rwHazard = RW_Hazard(name=regName, index=rIndex)
			for binsn in rInsnList:
				insnGrps = []
				for istg in xrange(rstg, binsn.stg+1):
					stg = Stage(istg, self.pipeLine.StgNameAt(istg))
					insnGrps.append(
						RW_InsnGrp(Binsn=StgInsn(insn=binsn.insn, stg=stg, addr=binsn.addr))
					)
				stallGrp = InsnGrp(Binsn=StgInsn(insn=binsn.insn, stg=Rtg, addr=binsn.addr))
				for finsn in wInsnList:
					self.__HandleInsnPair(finsn, binsn, regs, grps, hazard)
				# if has valid stall condition
				if len(stallGrp) > 0:
					stallHazard.add(stallGrp)
				# if has valid send condtion
				for grp in insnGrps:
					if len(grp) > 0:
						rwHazard.add(grp)
			# handle current channel of reg
			csList, muxList = self.__HandleRW(rwHazard)
			csRetList += csList
			muxRetList += muxList
		return csRetList, muxRetList
		
	
		
	def __HandleRW(self, hazard):
		Rstg = self.pipeLine.Rstg
		stgn = self.pipeLine.stgn
		regName = hazard.name
		index = hazard.index
		csRetList = []
		muxRegList = []
		for istg in range(Rstg, stgn):
			curGrp = filter(lambda grp: grp.BInsn.stg==istg, hazard.insnGrpSet)
			if len(curGrp) == 0:
				continue
			linkedSet = reduce(lambda ast,bst: ast|bst, map(lambda g:g.linkedIn, curGrp))
			# add raw rd to the first index
			### Generate the MUX
			stgName = self.pipeLine.StgNameAt(istg)
			rd = RG.GenRegRd(name=hazard.name, index=hazard.index)
			rdName = RP.SrcToVar(src=rd, stg=stgName)
			linkedIn = [rdName] + list(linkedSet)
			stgReg = StgReg(name=hazard.name, index=hazard.index, stg=istg, stgName=stgName, iterable=linkedIn)
			mux = stgReg.toBypassMux()
			### Insert Into needBypass
			selName = mux.GenSelName()
			src = RG.GenRegRd(name=regName, index=index)
			doutName = mux.GenDoutName()
			rt = RDTriple(src=src, des=doutName, stg=istg)
			self.needBypass.add(rt)
			### Generate control singla referenced
			cs = CtrlSignal(name=selName, width=mux.seln)
			# add clr
			clr = VG.GenClr(suf=self.pipeLine.StgNameAt(istg))
			cs.add( CtrlTriple(cond=clr, pri=10**5) )
			for g in curGrp:
				binsn = g.Binsn
				for finsn in g:
					if binsn.addr is None and finsn.addr is None:
						# no addr
						# check if finsn wr is 1'b1
						if finsn.ctrl == "1'b1":
							cond = "%s && %s" % (binsn.condition(), finsn.condition())
						else:
							cond = "%s && %s && %s" % (binsn.condition(), finsn.condition(), finsn.ctrlCondition())
					else:
						baddr = RP.SrcToVar(binsn.addr, stg=self.pipeLine.StgNameAt(binsn.stg))
						faddr = RP.SrcToVar(finsn.addr, stg=self.pipeLine.StgNameAt(finsn.stg))
						addrCond = "(%s == %s)" % (baddr, faddr)
						if finsn.ctrl == "1'b1":
							cond = "%s && %s && %s" % (binsn.condition(), finsn.condition(), addrCond)
						else:
							cond = "%s && %s && %s && %s" % (binsn.condition(), finsn.condition(), finsn.ctrlCondition(), addrCond)
					data = RP.SrcToVar(src=finsn.wd, srg=self.pipeLine.StgNameAt(finsn.stg))
					op = linkedIn.index(data)
					pri = stgn - finsn.stg
					ct = CtrlTriple(cond=cond, op=op, pri=pri)
					cs.add(ct)
			csRetList.append(cs)
			muxRetList.append(mux)
		return csRetList, muxRetList
		
				
	def __HandleInsnPair(self, finsn, binsn, regs, rwGrps, stallGrp):
		Wstg = self.pipeLine.Wstg
		Rstg = self.pipeLine.Rstg
		# the condition of send
		for w in range(finsn.stg+1, Wstg+1):
			# add the predessor insn to insn groups
			wInsn = StgInsn(insn=finsn.insn, stg=w, addr=finsn.addr, wd=finsn.wd)
			rwGrps[Rstg].addInsn(wInsn)
			# add the sendData to hazard's linkedIn
			sendData = RP.SrcToVar(src=finsn.wd, stg=self.pipeLine.StgNameAt(w))
			rwGrps[Rstg].addLink(sendData)
		
		w = finsn.stg + 1
		wInsn = StgInsn(insn=finsn.insn, stg=w, addr=finsn.addr, wd=finsn.wd)
		for r in range(Rstg+1, binsn.stg+1):
			rwGrps[r].addInsn(wInsn)
			sendData = RP.SrcToVar(src=finsn.wd, stg=self.pipeLine.StgNameAt(w))
			rwGrps[r].addLink(sendData)
			
		# the condition of stall
		delta = fisn.stg - binsn.stg
		if delta > 0:
			for d in range(1, delta+1):
				wInsn = StgInsn(insn=finsn.insn, stg=binsn.stg+d, addr=finsn.addr)
				stallGrp.addInsn(wInsn)
			
			
		
	def __GenWStgInsn(self, regName, index=""):
		ret = []
		waddr = RG.GenRegWaddr(regName, index=index)
		wd = RG.GenRegWd(regName, index=index)
		wr = RG.GenRegWr(regName, index=index)
		wstg = self.pipeLine.Wstg
		linkRtl = self.excelRtl.linkRtl
		for insnName, rtlList in linkRtl.iteritems():
			addrRtl, wdRtl, wrRtl = None, None, None
			for rtl in rtlList[wstg.id]:
				if rtl.des == waddr:
					addrRtl = rtl
				elif rtl.des == wd:
					wdRtl = rtl
				elif rtl.des == wr:
					wrRtl = rtl
			if wdRtl is None or wrRtl is None:
				continue
			insn = self.insnMap.find(insnName)
			addr = None if addrRtl is None else addrRtl.src
			stgId = self.__findFirstAppear(insnName, wdRtl.src)
			if stgId<0:
				raise ValueError, "%s not appear in %s Pipe" % (wd.src, insnName)
			stg = Stage(id=stgId, name=self.pipeLine.StgNameAt(stgId))
			si = StgInsn(insn=insn, stg=stg, addr=addr, wd=wdRtl.src, ctrl=wrRtl.src)
			ret.append(si)
		return ret
			
			
	def __findFirstAppear(self, insnName, src):
		pipeRtl = self.excelRtl.linkRtl
		rtlList = pipeRtl[insnName]
		for i in xrange(self.pipeLine.stgn):
			for rtl in rtlList[i]:
				if rtl.src == src:
					return i
		return -1		
		
		
	def __GenRStgInsn(self, regName, index=""):
		ret = []
		raddr = RG.GenRegRaddr(regName, index="")
		rd = RG.GenRegWd(regName, index="")
		rstg = self.pipeLine.Rstg.id
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
		return ret
		
		