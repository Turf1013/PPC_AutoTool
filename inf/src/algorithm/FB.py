# -*- coding: utf-8 -*-
import logging
from ..role.hazard import StgInsn, StgReg, RW_Hazard, Stall_Hazard, RW_InsnGrp, InsnGrp
from ..role.ctrlSignal import CtrlSignal, CtrlTriple
from ..role.stage import Stage
from ..util.rtlParser import RtlParser as RP
from ..util.rtlGenerator import RtlGenerator as RG
from ..util.verilogParser import VerilogParser as VP
from ..util.verilogGenerator import VerilogGenerator as VG


class constForFB:
	STALL = "stall"
	CLR = "clr"
	
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
		self.nHazardPair = 0
	
	def __str__(self):
		return "Forward and Backward Algorithm"
		
		
	# Handle all the possible hazard pair (stall and bypass)
	def HandleHazard(self):
		retCsList = []
		retMuxList = []
		# bypass
		for reg in self.pipeLine.regList:
			csList, muxList = self.__HandleHazardPerReg(reg)
			retCsList += csList
			retMuxList += muxList
		# stall
		retCsList.append( self.__HandleStall() )
		return retCsList, retMuxList
		
		
	def __HandleStall(self):
		rstg = self.pipeLine.Rstg.id
		stgn = self.pipeLine.stgn
		cs = CtrlSignal(name=CFFB.STALL, width=1, stg=rstg)
		# add clear 
		"""
			``` pay attention to ```
			clr_D comes from decode Insn@D,
			so clr_D is not a part of ctrlSignal's condition
		"""
		cs.add( CtrlTriple(cond="0", pri=10**5) )
		for insnGrp in self.stallHazard:
			binsn = insnGrp.Binsn
			for finsn in insnGrp.FinsnSet:
				if binsn.addr is None and finsn.addr is None:
					# no addr
					cond = "%s && %s && %s" % (binsn.condition(), finsn.condition(), finsn.ctrlCondition())
					# if finsn.ctrl=="1'b1":
						# cond = "%s && %s" % (binsn.condition(), finsn.condition())
					# else:
						# cond = "%s && %s && %s" % (binsn.condition(), finsn.condition(), finsn.ctrl)
					# add clear
				else:
					baddr = RP.SrcToVar(binsn.addr, stg=self.pipeLine.StgNameAt(binsn.stg))
					faddr = RP.SrcToVar(finsn.addr, stg=self.pipeLine.StgNameAt(finsn.stg))
					addrCond = "(%s == %s)" % (baddr, faddr)
					cond = "%s && %s && %s && %s" % (binsn.condition(), finsn.condition(), finsn.ctrlCondition(), addrCond)
					# if finsn.ctrl=="1'b1":
						# cond = "%s && %s && %s" % (binsn.condition(), finsn.condition(), addrCond)
					# else:
						# cond = "%s && %s && %s && %s" % (binsn.condition(), finsn.condition(), finsn.ctrl, addrCond)
				if finsn.stg.id == rstg:
					clrFinsn = "1'b1"
				else:
					clrFinsn = "~%s_%s" % (CFFB.CLR, finsn.stg.name)
				if binsn.stg.id == rstg:
					clrBinsn = "1'b1"
				else:
					clrBinsn = "~%s_%s" % (CFFB.CLR, binsn.stg.name)
				noclear = "%s && %s && " % (clrFinsn, clrBinsn)
				cond = noclear + cond
				op = 1
				pri = stgn - finsn.stg.id
				ct = CtrlTriple(cond=cond, op=op, pri=pri)
				cs.add(ct)
		return cs
		
			
	def __HandleHazardPerReg(self, reg):
		# logging.debug("[reg] reg = %s, rn = %s, wn = %s\n" % (reg.name, reg.rn, reg.wn))
		regName = reg.name
		wInsnList = []
		rInsnList = []
		
		if reg.wn > 1:
			# Generate Write StgInsn
			for i in range(reg.wn):
				wStgInsnList = self.__GenWStgInsn(regName, index=i)
				wInsnList.append( wStgInsnList )
		else:
			wInsnList.append( self.__GenWStgInsn(regName))
			
		if reg.rn > 1:
			# Generate Read StgInsn
			for i in range(reg.rn):
				rStgInsnList = self.__GenRStgInsn(regName, index=i)
				rInsnList.append(rStgInsnList)
		else:
			rInsnList.append( self.__GenRStgInsn(regName) )
			
		rstg = self.pipeLine.Rstg.id
		stgn = self.pipeLine.stgn
		retCsList = []
		retMuxList = []
		# iterate every read channels
		for rIndex in range(reg.rn):
			rwHazard = RW_Hazard(name=regName, index=rIndex)
			rStgInsnList = rInsnList[rIndex]
			for binsn in rStgInsnList:
				insnGrps = []
				for istg in range(0, stgn):
					stg = Stage(istg, self.pipeLine.StgNameAt(istg))
					insnGrps.append(
						RW_InsnGrp(Binsn=StgInsn(insn=binsn.insn, stg=stg, addr=binsn.addr))
					)
				stallGrp = InsnGrp(Binsn=StgInsn(insn=binsn.insn, stg=self.pipeLine.Rstg, addr=binsn.addr))
				for wStgInsnList in wInsnList:
					for finsn in wStgInsnList:
						self.__HandleInsnPair(finsn, binsn, insnGrps, stallGrp)
				# if has valid stall condition
				if len(stallGrp) > 0:
					self.stallHazard.add(stallGrp)
				# if has valid send condtion
				for grp in insnGrps:
					# if rIndex==1:
						# logging.debug( "[len(grp)] %d\n" % (len(grp)) )
					if len(grp) > 0:
						rwHazard.add(grp)
			# handle current channel of reg
			csList, muxList = self.__HandleRW(rwHazard)
			retCsList += csList
			retMuxList += muxList
			logging.debug("[N of bmux] %s" % (len(muxList)))
		return retCsList, retMuxList
		
	
		
	def __HandleRW(self, hazard):
		rstg = self.pipeLine.Rstg.id
		stgn = self.pipeLine.stgn
		regName = hazard.name
		rn = self.pipeLine.findReg(regName).rn
		index = hazard.index
		# logging.debug("[Handle_RW] regName = %s, index = %s\n" % (regName, index))
		retCsList = []
		retMuxList = []
		for istg in range(rstg, stgn):
			curGrp = filter(lambda grp: grp.Binsn.stg==istg, hazard.insnGrpSet)
			# logging.debug("[len(curGrp)] %d\n" % (len(curGrp)))
			if len(curGrp) == 0:
				continue
			linkedSet = reduce(lambda ast,bst: ast|bst, map(lambda g:g.linkedIn, curGrp))
			# add raw rd to the first index
			### Generate the MUX
			stgName = self.pipeLine.StgNameAt(istg)
			if rn == 1:
				rd = RG.GenRegRd(name=hazard.name)
			else:
				rd = RG.GenRegRd(name=hazard.name, index=index)
			rdName = RP.SrcToVar(src=rd, stg=stgName)
			linkedIn = [rdName] + list(linkedSet)
			# logging.debug("[hazard] %s\n" % (hazard.name))
			# logging.debug("[linked] %s\n" % (linkedIn))
			if rn == 1:
				stgReg = StgReg(name=hazard.name, index="", stg=istg, stgName=stgName, iterable=linkedIn)
				src = RG.GenRegRd(name=regName)
			else:
				stgReg = StgReg(name=hazard.name, index=index, stg=istg, stgName=stgName, iterable=linkedIn)
				src = RG.GenRegRd(name=regName, index=index)
			mux = stgReg.toBypassMux(stg = Stage(istg, stgName))
			# logging.debug("[hazard] %s@%s\n" % (mux.Iname, istg))
			### Insert Into needBypass
			selName = mux.GenSelName()
			# logging.debug("[bypass_sel] %s\n" % (selName))
			doutName = mux.GenDoutName(withStage=False)
			rt = RdTriple(src=src, des=doutName, stg=istg)
			self.needBypass.add(rt)
			### Generate control singla referenced
			cs = CtrlSignal(name=selName, width=mux.seln, stg=istg)
			# add clr
			"""
				``` pay attention to ```
				clr_D comes from decode Insn@D,
				so clr_D is not a part of ctrlSignal's condition
			"""
			if istg <= rstg:
				cs.add( CtrlTriple(cond="0", pri=10**5) )
			else:
				clr = VG.GenClr(suf=self.pipeLine.StgNameAt(istg))
				cs.add( CtrlTriple(cond=clr, pri=10**5) )
			for g in curGrp:
				binsn = g.Binsn
				# if index==1:
					# logging.debug("[Handle_RW] binsn = %s, addr = %s, index = %s:\n" % (binsn, binsn.addr, index))
				for finsn in g:
					# if index==1:
						# logging.debug("\t[handle_RW] finsn = %s, addr = %s.\n" % (finsn, finsn.addr))
					if binsn.addr is None and finsn.addr is None:
						# no addr
						# check if finsn wr is 1'b1
						cond = "%s && %s && %s" % (binsn.condition(), finsn.condition(), finsn.ctrlCondition())
						# if finsn.ctrl=="1'b1":
							# cond = "%s && %s" % (binsn.condition(), finsn.condition())
						# else:
							# cond = "%s && %s && %s" % (binsn.condition(), finsn.condition(), finsn.ctrlCondition())
							
					else:
						baddr = RP.SrcToVar(binsn.addr, stg=self.pipeLine.StgNameAt(binsn.stg))
						faddr = RP.SrcToVar(finsn.addr, stg=self.pipeLine.StgNameAt(finsn.stg))
						addrCond = "(%s == %s)" % (baddr, faddr)
						cond = "%s && %s && %s && %s" % (binsn.condition(), finsn.condition(), finsn.ctrlCondition(), addrCond)
						# if finsn.ctrl=="1'b1":
							# cond = "%s && %s && %s" % (binsn.condition(), finsn.condition(), addrCond)
						# else:
							# cond = "%s && %s && %s && %s" % (binsn.condition(), finsn.condition(), finsn.ctrlCondition(), addrCond)
					"""
						``` pay attention to ```
						clr_D comes from decode Insn@D,
						so clr_D is not a part of ctrlSignal's condition
					"""	
					if finsn.stg.id == rstg:
						clrFinsn = "1'b1"
					else:
						clrFinsn = "~%s_%s" % (CFFB.CLR, finsn.stg.name)
					if binsn.stg.id == rstg:
						clrBinsn = "1'b1"
					else:
						clrBinsn = "~%s_%s" % (CFFB.CLR, binsn.stg.name)
					noclear = "%s && %s && " % (clrFinsn, clrBinsn)
					cond = noclear + cond	
					data = RP.SrcToVar(src=finsn.wd, stg=self.pipeLine.StgNameAt(finsn.stg))
					op = linkedIn.index(data)
					pri = stgn - finsn.stg.id
					ct = CtrlTriple(cond=cond, op=op, pri=pri)
					cs.add(ct)
			retCsList.append(cs)
			retMuxList.append(mux)
		return retCsList, retMuxList
	
	
	def __HandleInsnPair(self, finsn, binsn, rwGrps, stallGrp):
		self.__HandleInsnPair_fast(finsn, binsn, rwGrps, stallGrp)
		# self.__HandleInsnPair_slow(finsn, binsn, rwGrps, stallGrp)
	
	
	def __HandleInsnPair_slow(self, finsn, binsn, rwGrps, stallGrp):
		# if finsn.insn.name.upper()=="LW" and binsn.insn.name.upper()=="ORI":
			# logging.debug("[Lw-Ori] wp = %d, rp = %d\n" % (finsn.stg.id, binsn.stg.id))
		wbstg = self.pipeLine.Wstg.id
		dstg = self.pipeLine.Rstg.id
		ustg = binsn.stg.id
		estg = finsn.stg.id
		for rstg in xrange(dstg, ustg+1):
			for wstg in xrange(rstg+1, wbstg+1):
				if wstg>estg:
					wInsn = StgInsn(insn=finsn.insn, stg=Stage(wstg, self.pipeLine.StgNameAt(wstg)), addr=finsn.addr, wd=finsn.wd, ctrl=finsn.ctrl)
					rwGrps[rstg].addInsn(wInsn)
					# add the sendData to hazard's linkedIn
					sendData = RP.SrcToVar(src=finsn.wd, stg=self.pipeLine.StgNameAt(wstg))
					rwGrps[rstg].addLink(sendData)
				else:
					stg = Stage(wstg, self.pipeLine.StgNameAt(wstg))
					wInsn = StgInsn(insn=finsn.insn, stg=stg, addr=finsn.addr, ctrl=finsn.ctrl)
					stallGrp.addInsn(wInsn)
				# update hazard pair
				self.nHazardPair += 1
		
				
	def __HandleInsnPair_fast(self, finsn, binsn, rwGrps, stallGrp):
		# if finsn.insn.name.upper()=="LW" and binsn.insn.name.upper()=="ORI":
			# logging.debug("[Lw-Ori] wp = %d, rp = %d\n" % (finsn.stg.id, binsn.stg.id))
		wstg = self.pipeLine.Wstg.id
		rstg = self.pipeLine.Rstg.id
		# the 1-st condition of send
		for w in range(finsn.stg.id+1, wstg+1):
			# add the predessor insn to insn groups
			wInsn = StgInsn(insn=finsn.insn, stg=Stage(w, self.pipeLine.StgNameAt(w)), addr=finsn.addr, wd=finsn.wd, ctrl=finsn.ctrl)
			rwGrps[rstg].addInsn(wInsn)
			# add the sendData to hazard's linkedIn
			sendData = RP.SrcToVar(src=finsn.wd, stg=self.pipeLine.StgNameAt(w))
			rwGrps[rstg].addLink(sendData)
			
			# update hazard pair
			self.nHazardPair += 1
		
		# the 2-nd condition of send
		mn = min(finsn.stg.id, binsn.stg.id)
		w = finsn.stg + 1
		stg = Stage(w, self.pipeLine.StgNameAt(w))
		wInsn = StgInsn(insn=finsn.insn, stg=stg, addr=finsn.addr, wd=finsn.wd, ctrl=finsn.ctrl)
		for r in range(rstg+1, mn+1):
			rwGrps[r].addInsn(wInsn)
			sendData = RP.SrcToVar(src=finsn.wd, stg=self.pipeLine.StgNameAt(w))
			rwGrps[r].addLink(sendData)
			
			# update hazard pair
			self.nHazardPair += 1
		
		# the 3-rd condition of send (useless)
		# for r in range(mn+1, binsn.stg.id+1):
			# wInsn = StgInsn(insn=finsn.insn, stg=Stage(r+1, self.pipeLine.StgNameAt(r+1)), addr=finsn.addr, wd=finsn.wd)
			# rwGrps[r].addInsn(wInsn)
			# sendData = RP.SrcToVar(src=finsn.wd, stg=self.pipeLine.StgNameAt(r+1))
			# rwGrps[r].addLink(sendData)
			
		# the condition of stall
		delta = finsn.stg.id - binsn.stg.id
		if delta > 0:
			for d in range(1, delta+1):
				stg = Stage(rstg+d, self.pipeLine.StgNameAt(rstg+d))
				wInsn = StgInsn(insn=finsn.insn, stg=stg, addr=finsn.addr, ctrl=finsn.ctrl)
				stallGrp.addInsn(wInsn)
				
				# update hazard pair
				self.nHazardPair += 1
			
		
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
			if wrRtl is None or wdRtl is None:
				continue
			insn = self.insnMap.find(insnName)
			logging.debug("[WStgInsn] insn = %s" % (insn.name))
			addr = None if addrRtl is None else addrRtl.src
			stgId = self.__findFirstAppear(insnName, wdRtl.src)
			if stgId<0:
				raise ValueError, "%s not appear in %s Pipe" % (wdRtl.src, insnName)
			stg = Stage(id=stgId, name=self.pipeLine.StgNameAt(stgId))
			logging.debug("[WStgInsn] reg = %s, ctrl = %s" % (regName, wrRtl.src))
			si = StgInsn(insn=insn, stg=stg, addr=addr, wd=wdRtl.src, ctrl=wrRtl.src)
			ret.append(si)
		return ret
			
			
	def __findFirstAppear(self, insnName, src):
		pipeRtl = self.excelRtl.pipeRtl
		rtlList = pipeRtl[insnName]
		for i in xrange(self.pipeLine.stgn):
			for rtl in rtlList[i]:
				if rtl.src == src:
					return i
		# print self.pipeLine.stgn
		linkRtl = self.excelRtl.linkRtl
		rtlList = linkRtl[insnName]
		for i in xrange(self.pipeLine.stgn):
			for rtl in rtlList[i]:
				if rtl.src == src:
					return i - 1
		return -1
		
		
	def __GenRStgInsn(self, regName, index=""):
		ret = []
		raddr = RG.GenRegRaddr(regName, index=index)
		rd = RG.GenRegRd(regName, index=index)
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
				if rtl.des == raddr:
					addrRtl = rtl
					break
			insn = self.insnMap.find(insnName)
			addr = None if addrRtl is None else addrRtl.src
			logging.debug("[StgInsn] regName=%s, index=%s, addr=%s, insn=%s\n" % (regName, index, addr, insnName))
			stg = Stage(ustg, self.pipeLine.StgNameAt(ustg))
			si = StgInsn(insn=insn, stg=stg, addr=addr)
			ret.append(si)
		return ret
		
		