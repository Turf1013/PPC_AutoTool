# -*- coding: utf-8 -*-
from collections import defaultdict
from ..role.ctrlSignal import CtrlSignal, CtrlTriple
from ..role.wire import WireSet, Wire
from ..role.mutex import PortMutex
from ..util.verilogParser import VerilogParser as VP
from ..util.rtlParser import RtlParser as RP
from ..util.rtlGenerator import RtlGenerator as RG
import logging


class constForDatapath:
	CLK = "clk"
	RST = "rst_n"
	WIDTH = "WIDTH"
	pipeIDict = {
		"Instr": "[`INSTR_WIDTH-1:0]",
	}
	
	pipeRtlIgoreList = [
		"Instr",
	]
	
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
		# add clr_D to PCWr
		pc = self.modMap.find("PC")
		pcWrPort = pc.find("wr")
		pc.addLink(pcWrPort, "~clr_%s" % (self.pipeLine.Rstg.name))
		
	
		
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
				varName = RP.DesToVar(rtl.des)
				mod = self.modMap.find(rtl.desMod)
				logging.debug("[%s] link %s to %s\n" % (mod.name, varName, rtl.desPort))
				mod.addLink(rtl.desPort, varName)
				width = mod.find(rtl.desPort).width
				logging.debug("[wire] %s %s\n" % (width, varName))
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
					logging.debug("[rtl.src] = %s\n" % (rtl.src))
					logging.debug("[srcList] = %s\n" % (str(srcList)))
					for src in srcList:
						varName = RP.SrcToVar(src=src, stg=stgName)
						logging.debug("[wire] %s %s\n" % (width, varName))
						self.wireSet.add( Wire(name=varName, width=width, kind="wire", stg=istg) )
				
			else:
				src = self.__FindInBypass(src=rtl.src, stg=istg)[0]
				varName = RP.SrcToVar(src=src, stg=stgName)
				mod = self.modMap.find(rtl.desMod)
				logging.debug("[%s] link %s to %s\n" % (mod.name, varName, rtl.desPort))
				mod.addLink(rtl.desPort, varName)
				port = mod.find(rtl.desPort)
				width = port.width
				srcList = RP.SrcToList(src=rtl.src)
				logging.debug("[rtl.src] = %s\n" % (rtl.src))
				logging.debug("[srcList] = %s\n" % (str(srcList)))
				for src in srcList:
					varName = RP.SrcToVar(src=src, stg=stgName)
					logging.debug("[wire] %s %s\n" % (width, varName))
					self.wireSet.add( Wire(name=varName, width=width, kind="wire", stg=istg) )
					
				# some srcPort is the output of the module, make them link
				if rtl.srcMod is not None:
					varName = RP.SrcToVar(src=rtl.src, stg=stgName)
					mod = self.modMap.find(rtl.srcMod)
					try:
						logging.debug("[rtl] %s\n" % (rtl))
						mod.addLink(rtl.srcPort, varName)
					except ValueError: 
						pass
						
		for rtl in pipeRtlSet:
			if rtl.srcMod is None or rtl.srcPort is None:
				continue
			varName = RP.SrcToVar(src=rtl.src, stg=stgName)
			mod = self.modMap.find(rtl.srcMod)
			try:
				logging.debug("[rtl] %s\n" % rtl)
				logging.debug("[%s] link %s to %s\n" % (mod.name, varName, rtl.srcPort))
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
			retCSList += retCSList
		return retCSList, retMuxList
		
	
	
	# Generate the Port Mux & Control Signal @istg
	def __GenPortMuxPerStg(self, rtlSet, istg):
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
				pmux = PortMutex(name=name, width=width, linkedIn=linkedIn)
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
							cond = insn.condition(suf = self.pipeLine.StgNameAt(istg))
							src = self.__FindInBypass(src=r.src, stg=istg)[0]
							src = RP.SrcToVar(src=src, stg=self.pipeLine.StgNameAt(istg))
							op = linkedIn.index(src)
							tList.append( CtrlTriple(cond=cond, op=op) )
				cs = CtrlSignal(name=selName, width=selN, iterable=tList)
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
	def toVerilog(self, ctrlCode, pmuxList, bmuxList, tabn=1):
		pre = "\t" * tabn
		ret = ""
		# module statement
		ret += "module ppc (\n"
		ret += pre + "%s, %s\n" % (CFD.CLK, CFD.RST)
		ret += ");\n"
		
				
		# wire & reg statement
		wireCode = self.wireSet.toVerilog(tabn=tabn)
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
		instanceCtrl = ctrlCode
		ret += pre + "// Instance Module\n" + instanceCtrl + "\n" * 4
		
		# pipeReg logic
		pipeCode = self.__pipeToVerilog(tabn = tabn)
		ret += pre + "// Pipe Register\n" + pipeCode + "\n" * 4
		
		# end module
		ret += "endmodule\n"
		return ret
		
		
	def __instanceToVerilog(self, tabn):
		ret = ""
		for modName,mod in self.modMap.iteritems():
			ret += self.__instanceToVerilogPerMod(mod=mod, tabn=tabn)
		return ret
		
			
	def __instanceToVerilogPerMod(self, mod, tabn):
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
			
			logging.debug("[pipe] %s | inVar = %s, outVar = %s\n" % (rtl, inVar, outVar))
			
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
			elif inVar in st:
				retDict[outVar] = inVar
				self.wireSet.add( Wire(name=outVar, width=width, kind="reg", stg=istg+1) )
			else:
				retDict[outVar] = inVar
				self.wireSet.add( Wire(name=inVar, width=width, kind="wire", stg=istg) )
				self.wireSet.add( Wire(name=outVar, width=width, kind="reg", stg=istg+1) )
			
			st.add(outVar)
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
		ret += pre + "always @( posedge clk or negedge rst_n ) begin\n"
		if istg > rstg:
			ret += pre + "\t" + "if ( !rst_n || clr_%s ) begin\n" % (self.pipeLine.StgNameAt(istg-1))
		else:
			ret += pre + "\t" + "if ( !rst_n ) begin\n"
		for outVar in pipeDict.iterkeys():
			ret += pre + "\t\t" + "%s <= 0;\n" % (outVar)
		ret += pre + "\t" + "end\n"
		if istg <= rstg:
			ret += pre + "\t" + "else if ( !clr_%s )begin\n" % (self.pipeLine.StgNameAt(rstg))
		else:
			ret += pre + "\t" + "else begin\n"
		for outVar, inVar in pipeDict.iteritems():
			ret += pre + "\t\t" + "%s <= %s;\n" % (outVar, inVar)
		ret += pre + "\t" + "end\n"
		ret += pre + "end // end always\n\n"
		return ret
		
		
	def __instanceMuxToVerilog(self, muxList, tabn = 1):
		ret = ""
		for mux in muxList:
			ret += mux.toVerilog(tabn = tabn) + "\n"
		return ret
		