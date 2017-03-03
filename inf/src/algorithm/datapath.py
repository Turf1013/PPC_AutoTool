# -*- coding: utf-8 -*-
from collections import defaultdict
from ..role.ctrlSignal import CtrlSignal, CtrlTriple
from ..role.wire import WireSet, Wire
from ..role.mutex import PortMutex
from ..role.stage import Stage
from ..util.verilogParser import VerilogParser as VP
from ..util.rtlParser import RtlParser as RP
from ..util.rtlGenerator import RtlGenerator as RG
from ..glob.glob import CFG
from control import CFC
from MC import MC as MCI
from MC import CFMC
import logging


class constForDatapath:
	INSTR = "Instr"
	ARCH = CFG.ARCH
	CLK = "clk"
	RST = "rst_n"
	WIDTH = "WIDTH"
	CONVERTER_NAME = "insnConverter"
	PRADDR = "PrAddr"
	PRRD = "PrRD"
	PRWD = "PrWD"
	pipeIDict = {
		"Instr": CFG.INSTR_WIDTH,
	}
	pipeRtlIgoreList = [
		"Instr",
	]
	ORGINSTR = "orgInstr"
	NEWINSTR = "newInstr"
	INSTR_WIDTH = "[0:`INSTR_WIDTH-1]"
	
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
		self.pipeList = []
		self.wireSet = WireSet()
		# add PCWr
		self.__addPCWr()
		# add MDU ports
		self.__addMDU()	
		# add insnConverter
		self.__addConverter()
		self.Pmc = MCI.findPmc(excelRtl, pipeLine)
		
		
	def __addConverter(self):
		if not CFG.USE_CONVERTER:
			return 
		portList = [
			[CFMC.STALL_EXT, "[0:0]"],
			[CFC.LATCH, "[0:0]"],
		]
		conv = self.modMap.find(CFD.CONVERTER_NAME)
		for portName, portWidth in portList:
			port = conv.find(portName)
			if port:
				conv.addLink(port, portName)
				ww = Wire(name=portName, width=portWidth, kind="wire", stg=-1)
				self.wireSet.add(ww)
				
		# add din
		port = conv.find("din")
		if port:
			conv.addLink(port, CFD.ORGINSTR)
			ww = Wire(name=CFD.ORGINSTR, width=CFD.INSTR_WIDTH, kind="reg", stg=1)
			self.wireSet.add(ww)
			
		# add dout
		port = conv.find("dout")
		if port:
			conv.addLink(port, CFD.NEWINSTR)
			ww = Wire(name=CFD.NEWINSTR, width=CFD.INSTR_WIDTH, kind="wire", stg=1)
			self.wireSet.add(ww)
			
		
		
	def __findConverter(self):
		rstg = self.pipeLine.Rstg.id
		linkRtl = self.excelRtl.linkRtl
		for insnName,rtlList in linkRtl.iteritems():
			for istg in xrange(0, rstg+1):
				rtls = rtlList[istg]
				for rtl in rtls:
					if CFD.CONVERTER_NAME in rtl.des:
						return True
		return False
	
				
		
	def __addMDU(self):	
		if len(MCI.findMCI(self.excelRtl, self.pipeLine)) == 0:
			return 
		portList = [
			[CFMC.MDU_CNT, "[`MDU_CNT_WIDTH-1:0]"],
			[CFMC.MDU_INSN, "[0:`INSTR_WIDTH-1]"],
			[CFMC.MDU_RESTORE, "[0:0]"],
			[CFMC.MDU_ACK, "[0:0]"],
			[CFMC.MDU_REQ, "[0:0]"],
		]
		mdu = self.modMap.find("MDU")
		for portName, portWidth in portList:
			port = mdu.find(portName[4:])
			if port:
				mdu.addLink(port, portName)
			ww = Wire(name=portName, width=portWidth, kind="wire", stg=-1)
			self.wireSet.add(ww)
			
			
	def __addPCWr(self):		
		# add PCwr to PCWr
		pc = self.modMap.find("PC")
		pcWrPort = pc.find("wr")
		if CFG.IO:
			pc.addLink(pcWrPort, CFC.PCWR)
		else:
			pc.addLink(pcWrPort, CFC.PCWR)
		## add PCWr
		ww = Wire(name=CFC.PCWR, width=1, kind="wire", stg=-1)
		self.wireSet.add(ww)
	
		
	# Add the link
	def LinkMod(self):
		""" Link the module from two aspect:
			1. linkRtl include the input port;
			2. pipeRtl include the output port.
		""" 
		linkRtl = self.excelRtl.linkRtl
		pipeRtl = self.excelRtl.pipeRtl
		stgn = self.pipeLine.stgn
		pipeSet = set()
		for istg in xrange(stgn):
			# link rtl merge
			linkRtlSet = set()
			for insnName, insnRtlList in linkRtl.iteritems():
				linkRtlSet.update(insnRtlList[istg])
			
			# pipe rtl merge
			pipeRtlSet = set()
			for insnName, insnRtlList in pipeRtl.iteritems():
				pipeRtlSet.update(insnRtlList[istg])
			pipeRtlSet -= pipeSet
			self.__LinkModPerStg(linkRtlSet, pipeRtlSet, istg)
			pipeSet |= pipeRtlSet
			
			
	def __LinkModPerStg(self, linkRtlSet, pipeRtlSet, istg):
		stgName = self.pipeLine.StgNameAt(istg)
		d = defaultdict(set)
		for rtl in linkRtlSet:
			d[rtl.des].add(rtl)
			
		for des, linkRtlSet in d.iteritems():
			rtlList = list(linkRtlSet)
			rtl = rtlList[0]
			if rtl.isCtrlLink():
				# Control Signal named as itself
				varName = RP.DesToVar(rtl.des, suf=stgName)
				mod = self.modMap.find(rtl.desMod)
				# logging.debug("[%s] link %s to %s\n" % (mod.name, varName, rtl.desPort))
				mod.addLink(rtl.desPort, varName)
				width = mod.find(rtl.desPort).width
				# logging.debug("[wire] %s %s\n" % (width, varName))
				self.wireSet.add( Wire(name=varName, width=width, kind="wire", stg=istg) )
				
				
			elif len(rtlList)>1:
				# mux.dout link (linked in mux generating)
				for rtl in rtlList:
					if rtl.srcMod is None:
						continue
					varName = RP.SrcToVar(src=rtl.src, stg=stgName)
					mod = self.modMap.find(rtl.srcMod)
					try:
						mod.addLink(rtl.srcPort, varName)
					except ValueError:
						pass
					width = mod.find(rtl.srcPort).width
					srcList = RP.SrcToList(src=rtl.src)
					# logging.debug("[rtl.src] = %s\n" % (rtl.src))
					# logging.debug("[srcList] = %s\n" % (str(srcList)))
					for src in srcList:
						varName = RP.SrcToVar(src=src, stg=stgName)
						# logging.debug("[wire] %s %s\n" % (width, varName))
						self.wireSet.add( Wire(name=varName, width=width, kind="wire", stg=istg) )
				
			else:
				src = self.__FindInBypass(src=rtl.src, stg=istg)[0]
				varName = RP.SrcToVar(src=src, stg=stgName)
				mod = self.modMap.find(rtl.desMod)
				# logging.debug("[%s] link %s to %s\n" % (mod.name, varName, rtl.desPort))
				mod.addLink(rtl.desPort, varName)
				width = mod.find(rtl.desPort).width
				
				# add the desPort to wireSet
				self.wireSet.add( Wire(name=RP.SrcToVar(src=rtl.des, stg=stgName), width=width, kind="wire", stg=istg) )
				
				# add the element in srcList to wireSet
				srcList = RP.SrcToList(src=rtl.src)
				# logging.debug("[rtl.src] = %s\n" % (rtl.src))
				# logging.debug("[srcList] = %s\n" % (str(srcList)))
				for src in srcList:
					varName = RP.SrcToVar(src=src, stg=stgName)
					# logging.debug("[wire] %s %s\n" % (width, varName))
					self.wireSet.add( Wire(name=varName, width=width, kind="wire", stg=istg) )
					
				# some srcPort is the output of the module, make them link
				if rtl.srcMod is not None:
					varName = RP.SrcToVar(src=rtl.src, stg=stgName)
					mod = self.modMap.find(rtl.srcMod)
					try:
						# logging.debug("[rtl] %s\n" % (rtl))
						mod.addLink(rtl.srcPort, varName)
						self.wireSet.add( Wire(name=varName, width=width, kind="wire", stg=istg) )
					except ValueError: 
						pass
						
		for rtl in pipeRtlSet:
			if rtl.srcMod is None or rtl.srcPort is None:
				continue
			varName = RP.SrcToVar(src=rtl.src, stg=stgName)
			mod = self.modMap.find(rtl.srcMod)
			try:
				# logging.debug("[rtl] %s\n" % rtl)
				# logging.debug("[%s] link %s to %s\n" % (mod.name, varName, rtl.srcPort))
				mod.addLink(rtl.srcPort, varName)
			except ValueError: 
				pass
				
	
	# Generate all the Port Mux
	def GenPortMux(self):
		linkRtl = self.excelRtl.linkRtl
		stgn = self.pipeLine.stgn
		retMuxList = []
		retCSList = []
		for istg in xrange(stgn):
			rtlSet = set()
			for insnName, insnRtlList in linkRtl.iteritems():
				rtlSet.update(insnRtlList[istg])
			muxList, csList = self.__GenPortMuxPerStg(rtlSet, istg)
			retMuxList += muxList
			retCSList += csList
		if CFG.SHOWINFO:
			self.showInfo(retCSList, retMuxList)
		return retCSList, retMuxList
		
		
	def showInfo(self, csList, muxList):
		line = ""
		line += "********************\n"
		line += "Automatic Datapath:\n"
		line += "(1) %d port mux\n" % (len(muxList))
		line += "(2) %d core modules:\n" % (len(self.modMap))
		for i,modName in enumerate(self.modMap):
			if i>0 and i%8==0:
				line += "\n"
			line += "\t%s " % (modName)
		line += "\n"
		line += "********************\n"
		line += "\n\n"
		print line		
	
	
	# Generate the Port Mux & Control Signal @istg
	def __GenPortMuxPerStg(self, rtlSet, istg):
		stgName = self.pipeLine.StgNameAt(istg)
		linkRtl = self.excelRtl.linkRtl
		portDict = defaultdict(set)
		for rtl in rtlSet:
			if not rtl.isCtrlLink():
				portDict[rtl.des].add(rtl)
		retMuxList = []
		retCSList = []
		for des,linkSet in portDict.iteritems():
			srcList = map(lambda x:x.src, linkSet)
			srcList = map(lambda src:self.__FindInBypass(src=src,stg=istg)[0], srcList)
			if len(srcList) > 1:
				rtl = list(linkSet)[0]
				# Need to Insert a Port MUX
				name = self.__GenPortMuxIname(rtl, istg)
				linkedIn = self.__GenPortMuxLinkedIn(srcList, istg)
				desMod = self.modMap.find(rtl.desMod)
				width = VP.RangeToInt(desMod.findPortWidth(rtl.desPort))
				
				### Generate the MUX
				pmux = PortMutex(name=name, width=width, stg=Stage(istg, stgName), linkedIn=linkedIn)
				retMuxList.append(pmux)
				
				### Link the MUX dout to orginal module
				doutName = pmux.GenDoutName()
				mod = self.modMap.find(rtl.desMod)
				logging.debug("[%s] link %s to %s\n" % (mod.name, doutName, rtl.desPort))
				mod.addLink(rtl.desPort, doutName)
				
				### Generate the CtrlSignal
				selName = pmux.GenSelName()
				selN = pmux.seln
				tList = []
				for insnName, insnRtlList in linkRtl.iteritems():
					for r in insnRtlList[istg]:
						if r in linkSet:
							insn = self.insnMap.find(insnName)
							cond = insn.condition(suf=stgName)
							src = self.__FindInBypass(src=r.src, stg=istg)[0]
							src = RP.SrcToVar(src=src, stg=stgName)
							op = linkedIn.index(src)
							tList.append( CtrlTriple(cond=cond, op=op) )
				cs = CtrlSignal(name=selName, width=selN, stg=istg, iterable=tList)
				# add 0 for patch
				cs.add( CtrlTriple(cond="0", pri=10**5) )
				retCSList.append(cs)
				
				### Add the selName to Wire 
				self.wireSet.add( Wire(name=selName, width=selN, kind="wire", stg=istg) )
				
		return retMuxList, retCSList
		
		
	# Generate the link of the Mux
	def __GenPortMuxLinkedIn(self, srcList, istg):
		retList = []
		stgName = self.pipeLine.StgNameAt(istg)
		for src in srcList:
			retList.append(RP.SrcToVar(src, stgName))
		return retList	
		
				
	# Generate the instance name of Port Mux
	def __GenPortMuxIname(self, rtl, istg):
		return "%s_%s_%s" % (rtl.desMod, rtl.desPort, self.pipeLine.StgNameAt(istg))
		
	
	# find source in the bypass if source flow through bypass then return rename or return itself
	def __FindInBypass(self, src, stg):
		for rt in self.needBypass:
			if rt.equal(src=src, stg=stg):
				return rt.des, True
		return src, False
		
		
	# Generate Verilog code	
	def toVerilog(self, ctrl, pmuxList, bmuxList, tabn=1):
		pre = "\t" * tabn
		ret = ""
		# module statement
		ret += "module %s (\n" % (CFD.ARCH)
		ret += pre + "%s, %s,\n" % (CFD.CLK, CFD.RST)
		ret += pre + "%s, %s, %s \n" % (CFD.PRADDR, CFD.PRRD, CFD.PRWD)
		ret += ");\n"
		
		# input & output statement
		inputCode = self.__inputToVerilog(tabn=tabn)
		ret += pre + "// input statement\n" + inputCode + "\n" * 2
		outputCode = self.__outputToVerilog(tabn=tabn)
		ret += pre + "// output statement\n" + outputCode + "\n" * 2
				
		# wire & reg statement
		wireCode = self.__wireToVerilog(ctrl, pmuxList, bmuxList, tabn=tabn)
		ret += pre + "// wire statement\n" + wireCode + "\n" * 4
		
		# instance all modules
		instanceCode = self.__instanceToVerilog(tabn=tabn)
		ret += pre + "// Instance Module\n" + instanceCode + "\n" * 4
		
		# instance port mux
		instanceCode = self.__instanceMuxToVerilog(pmuxList, tabn)
		ret += pre + "// Instance Port Mux\n" + instanceCode + "\n" * 4
		
		# instance bypass mux
		instanceCode = self.__instanceMuxToVerilog(bmuxList, tabn)
		ret += pre + "// Instance Bypass Mux\n" + instanceCode + "\n" * 4
		
		# instance control 
		instanceCtrl = self.__instanceCtrlToVerilog(ctrl, tabn)
		ret += pre + "// Instance Controller\n" + instanceCtrl + "\n" * 4
		
		# pipeReg logic
		pipeCode = self.__pipeToVerilog(tabn = tabn)
		ret += pre + "// Pipe Register\n" + pipeCode + "\n" * 4
		
		# assign output
		outputCode = self.__outputLogicToVerilog(tabn = tabn)
		ret += pre + "// output logic\n" + outputCode + "\n" * 4
		
		# add newInstr to Instr
		lines = self.__newInstrToInstr(tabn = tabn)
		ret += pre + "// newInstr to Instr_%s logic\n" % (self.pipeLine.StgNameAt(1)) + lines + "\n" * 4
		
		# end module
		ret += "endmodule\n"
		return ret
		
		
	def __instanceToVerilog(self, tabn):
		ret = ""
		for modName,mod in self.modMap.iteritems():
			ret += self.__instanceToVerilogPerMod(mod=mod, tabn=tabn)
		return ret
		
			
	def __instanceToVerilogPerMod(self, mod, tabn):
		linkn = mod.linkn()
		if linkn == 0:
			# logging.debug("[linkn] %s(%d) create, but not Instance.\n" % (mod.name, linkn))
			return ""
		# add clk & rst_n
		try:
			mod.addLink(CFD.CLK, CFD.CLK)
			mod.addLink(CFD.RST, CFD.RST)
		except:
			pass
		ret = mod.toVerilog(tabn=tabn)
		return ret
		
		
	def GenPipe(self):
		self.pipeDictList = []
		stgn = self.pipeLine.stgn
		rtlAllSet = set()
		rtlAllSet.add(RP.SrcToVar(src="Instr", stg=self.pipeLine.StgNameAt(0)))
		for istg in range(0, stgn-1):
			self.pipeDictList.append( self.__GenPipePerStg(rtlAllSet, istg) )
		self.pipeDictList.append(dict())
	
	
	def __PipeRtlAtStg(self, istg):
		ret = set()
		for insnName, pipeRtlList in self.excelRtl.pipeRtl.iteritems():
			for pipeRtl in pipeRtlList[istg]:
				ret.add(pipeRtl)
		return ret
		
			
	def __GenPipePerStg(self, st, istg):
		pipeRtl = self.__PipeRtlAtStg(istg)
		rtlSet = set()
		retDict = dict()
		for rtl in pipeRtl:
			rtlSet.add(rtl)
		for rtl in rtlSet:
			src, find = self.__FindInBypass(src=rtl.src, stg=istg)
			inVar = RP.SrcToVar(src=src, stg=self.pipeLine.StgNameAt(istg))
			outVar = RP.SrcToVar(src=rtl.src, stg=self.pipeLine.StgNameAt(istg+1))
			
			# logging.debug("[pipe] %s | inVar = %s, outVar = %s\n" % (rtl, inVar, outVar))
			
			# add source in reg statement
			if rtl.src in CFD.pipeIDict:
				width = CFD.pipeIDict[rtl.src]
			elif rtl.srcMod is not None:
				modName, portName = rtl.srcMod, rtl.srcPort
				mod = self.modMap.find(modName)
				width = mod.find(portName).width
			else:
				width = "XXXXXXXXX"
				inVar = rtl.src
				
			if find:
				retDict[outVar] = inVar
				self.wireSet.add( Wire(name=outVar, width=width, kind="reg", stg=istg+1) )
				self.wireSet.add( Wire(name=inVar, width=width, kind="wire", stg=istg) )
				orgSrcName = RP.SrcToVar(src=rtl.src, stg=self.pipeLine.StgNameAt(istg))
				# if orgSrcName not in retDict:
					# self.wireSet.add( Wire(name=orgSrcName, width=width, kind="wire", stg=istg) )
				self.wireSet.add( Wire(name=orgSrcName, width=width, kind="wire", stg=istg) )
				
			elif inVar in st:
				retDict[outVar] = inVar
				self.wireSet.add( Wire(name=outVar, width=width, kind="reg", stg=istg+1) )
				
			else:
				retDict[outVar] = inVar
				self.wireSet.add( Wire(name=inVar, width=width, kind="wire", stg=istg) )
				self.wireSet.add( Wire(name=outVar, width=width, kind="reg", stg=istg+1) )
			
			st.add(outVar)
		
		# update the INSTR for using converter
		if CFG.USE_CONVERTER and istg==0:
			outVar = "%s_%s" % (CFD.INSTR, self.pipeLine.StgNameAt(istg))
			if outVar in retDict:
				inVar = retDict[outVar]
				retDict.pop(outVar)
				retDict[CFD.ORGINSTR] = inVar
		return retDict
			
		
	def __pipeToVerilog(self, tabn):
		ret = ""
		for istg in range(0, self.pipeLine.stgn-1):
			ret += self.__pipeToVerilogPerStg(tabn=tabn, istg=istg)
		return ret
		
	
	# pay attention clear & lock
	def __pipeToVerilogPerStg(self, tabn, istg):
		pre = "\t" * tabn
		rstg = self.pipeLine.Rstg.id
		stgn = self.pipeLine.stgn
		pipeDict = self.pipeDictList[istg]
		stgName = self.pipeLine.StgNameAt(istg)
		ret = ""
		ret += pre + "/*****     Pipe_%s     *****/\n" % (stgName)
		ret += pre + "always @(posedge clk or negedge rst_n) begin\n"
		# handle reset
		ret += pre + "\t" + "if (~rst_n) begin\n"
		for outVar in pipeDict.iterkeys():
			if outVar.startswith(CFD.INSTR):
				ret += pre + "\t\t" + "%s <= `NOP;\n" % (outVar)
			else:
				ret += pre + "\t\t" + "%s <= 0;\n" % (outVar)
		ret += pre + "\t" + "end\n"
		if istg < rstg:
			# 1. check if stall
			ret += pre + "\t" + "else if (stall) begin\n"
			for outVar in pipeDict.iterkeys():
				ret += pre + "\t\t" + "%s <= %s;\n" % (outVar, outVar)
			ret += pre + "\t" + "end\n"
			# 2. check if support delaySlot
			if not CFG.brDelaySlot:
				ret += pre + "\t" + "else if (%s_%s) begin\n" % (CFG.BRFLUSH, self.pipeLine.StgNameAt(rstg))
				for outVar in pipeDict.iterkeys():
					if outVar.startswith(CFD.INSTR):
						ret += pre + "\t\t" + "%s <= `NOP;\n" % (outVar)
					else:
						ret += pre + "\t\t" + "%s <= 0;\n" % (outVar)
				ret += pre + "\t" + "end\n"
			# 3. add else
			
		else:
			# handle clr
			"(1) clear but still pipe the result; "
			if istg == self.Pmc:
				clrCond = "clr_%s && ~%s" % (self.pipeLine.StgNameAt(istg), CFMC.MDU_RESTORE)
			else:
				clrCond = "clr_%s" % (self.pipeLine.StgNameAt(istg))
			ret += pre + "\t" + "else if (%s) begin\n" % (clrCond)
			for outVar, inVar in pipeDict.iteritems():
				if outVar.startswith(CFD.INSTR):
					ret += pre + "\t\t" + "%s <= `NOP;\n" % (outVar)
				else:
					ret += pre + "\t\t" + "%s <= %s;\n" % (outVar, inVar)
			ret += pre + "\t" + "end\n"
			"(2) clear all the value"
			# ret += pre + "\t" + "else if ( clr_%s ) begin\n" % (self.pipeLine.stgNameAt(istg))
			# for outVar, inVar in pipeDict.iteritems():
				# if outVar.startswith(CFD.INSTR):
					# ret += pre + "\t\t" + "%s <= `NOP;\n" % (outVar)
				# else:
					# ret += pre + "\t\t" + "%s <= 0;\n" % (outVar6)
			# ret += pre + "\t" + "end\n"
			
		ret += pre + "\t" + "else begin\n"
		for outVar, inVar in pipeDict.iteritems():
			if istg==self.Pmc and outVar.startswith(CFD.INSTR):
				ret += pre + "\t\t" + "%s <= (%s) ? %s : %s;\n" % (
					outVar, CFMC.MDU_RESTORE, CFMC.MDU_INSN, inVar)
			else:
				ret += pre + "\t\t" + "%s <= %s;\n" % (outVar, inVar)
		ret += pre + "\t" + "end\n"
		ret += pre + "end // end always\n\n"
		return ret
		
		
	def __instanceMuxToVerilog(self, muxList, tabn = 1):
		ret = ""
		for mux in muxList:
			ret += mux.toVerilog(tabn = tabn) + "\n"
		return ret
		
		
	def __inputToVerilog(self, tabn = 1):
		pre = "\t" * tabn
		ret = ""
		ret += pre + "input %s;\n" % (CFD.CLK)
		ret += pre + "input %s;\n" % (CFD.RST)
		return ret
		
		
	def __outputToVerilog(self, tabn = 1):
		pre = "\t" * tabn
		ret = ""
		ret += pre + "output [`ARCH_WIDTH-1:0] %s;\n" % (CFD.PRADDR)
		ret += pre + "output [`ARCH_WIDTH-1:0] %s;\n" % (CFD.PRRD)
		ret += pre + "output [`ARCH_WIDTH-1:0] %s;\n" % (CFD.PRWD)
		return ret 
		
		
	def __instanceCtrlToVerilog(self, ctrl, tabn):
		return ctrl.instance(tabn = tabn)
		
		
	def __wireToVerilog(self, ctrl, pmuxList, bmuxList, tabn):
		# add ctrl signal
		for w in ctrl.wireSet:
			wname = w.name
			if wname == CFMC.STALL_HAZARD:
				wname = CFMC.STALL
			ww = Wire(name=wname, width=w.width, kind="wire", stg=w.stg)
			self.wireSet.add( ww )
			# logging.debug("[wireSet] %d %s\n" % (len(self.wireSet), ww))
		
		# add port mux dout
		for pmux in pmuxList:
			ww = Wire(name=pmux.GenDoutName(), width=pmux.widthRange(), kind="wire", stg=pmux.stg.id)
			self.wireSet.add( ww )
			# logging.debug("[wireSet] %d %s\n" % (len(self.wireSet), ww))
			
			
		# add bypass mux dout
		for bmux in bmuxList:
			ww = Wire(name=bmux.GenDoutName(), width=bmux.widthRange(), kind="wire", stg=bmux.stg.id)
			self.wireSet.add( ww )
			# logging.debug("[wireSet] %d %s\n" % (len(self.wireSet), ww))
			
		return self.wireSet.toVerilog(tabn=tabn)
		
		
	def __outputLogicToVerilog(self, tabn):
		ret = []
		
		## get GPR wd
		PrWd = 0
		gpr = self.modMap.find("GPR")
		if gpr:
			PrWd = gpr.getLink("wd")
			if not PrWd:
				PrWd = 0
		line = "assign %s = %s;\n" % (CFD.PRWD, PrWd)
		ret.append(line)
		
		## get ALU C
		PrAddr = 0
		alu = self.modMap.find("ALU")
		if alu:
			PrAddr = alu.getLink("C")
			if not PrAddr:
				PrAddr = 0
		line = "assign %s = %s;\n" % (CFD.PRADDR, PrAddr)
		ret.append(line)
		
		## get DM rd
		PrRD = 0
		dm = self.modMap.find("DM")
		if dm:
			PrRd = dm.getLink("dout")
			if not PrRd:
				PrRd = 0
		line = "assign %s = %s;\n" % (CFD.PRRD, PrRd)
		ret.append(line)
		
		prefix = "\t" * tabn
		return prefix + prefix.join(ret)
		
		
	def __newInstrToInstr(self, tabn):
		ret = []
		
		# add always block
		line = "always @(*) begin\n"
		ret.append(line)
		
		## add if
		instrName = "%s_%s" % (CFD.INSTR, self.pipeLine.StgNameAt(1))
		line = "\t%s = %s;\n" % (instrName, CFD.NEWINSTR)
		ret.append(line)
		
		line = "end // end always\n"
		ret.append(line)
		
		
		prefix = "\t" * tabn
		return prefix + prefix.join(ret)