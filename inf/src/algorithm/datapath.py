# -*- coding: utf-8 -*-
from collections import defaultdict
from ..role.ctrlSignal import CtrlSignal, CtrlTriple
from ..util.verilogParser import VerilogParser as VP
from ..util.rtlParser import RtlParser as RP
from ..util.rtlGenerator import RtlGenerator as RG
from ..role.wire import WireSet, Wire

class constForDatapath:
	CLK = "clk"
	RST = "rst_n"
	WIDTH = "WIDTH"
	pipeIDict = {
		"Instr": "[`INSTR_WIDTH-1:0]",
	}
	
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
		mod = self.modMap.find("PC")
		mod.addLink("Wr", "~clr_" % (self.pipeLine.StgNameAt(self.pipeLine.Rstg)))
	
	
		
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
				port = mod.find(rtl.desPort)
				self.wireSet.add( Wire(name=varName, width=port.width, kind="wire", stg=istg) )
				
			elif len(rtlList)>1:
				# mux.dout link (linked in mux generating)
				pass
				
			else:
				src = self.__FindInBypass(src=rtl.src, stg=istg)
				varName = RP.SrcToVar(src=src, srg=stgName)
				mod = self.modMap.find(rtl.desMod)
				mod.addLink(rtl.desPort, varName)
				port = mod.find(rtl.desPort)
				width = port.width
				srcList = RP.SrcToList(src=rtl.src)
				for src in srcList:
					varName = SrcToVar(src=src, stg=stgName)
					self.wireSet.add( Wire(name=varName, width=width, kind="wire", stg=istg) )
	
	
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
		return retCSList, retMuxList
		
	
	
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
		return "%s_%s_%s" % (rtl.desMod, rtl.desPort, self.pipeLine.stgNameAt(istg))
		
	
	# find source in the bypass if source flow through bypass then return rename or return itself
	def __FindInBypass(self, src, istg):
		for rt in self.needBypass:
			if rt.equal(src=src, stg=istg)
				return rt.des
		return src
		
		
	# Generate Verilog code	
	def toVerilog(self, ctrlCode, tabn=1):
		pre = "\t" * tabn
		ret = ""
		# module statement
		ret += "module ppc (\n"
		ret += pre + "%s, %s\n" % (CFD.CLK, CFD.RST)
		ret += ");\n"
		
				
		# wire & reg statement
		wireCode = self.wireSet().toVerilog(tabn=tabn)
		ret += "// wire statement\n" + wireCode + "\n" * 4
		
		# instance all modules
		instanceCode = self.__instanceToVerilog(tabn=tabn) + ctrlCode
		ret += "// Instance Module\n" + instanceCode + "\n" * 4
		
		# instance control 
		ret += 
		
		# pipeReg logic
		pipeCode = self.__pipeToVerilog(tabn = tabn)
		ret += "// Pipe Register\n" + pipeCode + "\n" * 4
		
		# end module
		ret += "endmodule\n"
		return ret
		
		
	def __instanceToVerilog(self, tabn):
		ret = ""
		for mod in self.modMap:
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
		stgn = self.pipeLine.stgn
		self.pipeDictList = [dict()]
		for istg in range(1, stgn):
			self.pipeDictList.append( self.__GenPipePerStg(istg) )
			
			
	def __GenPipePerStg(self, istg):
		pipeRtl = self.excelRtl.pipeRtl[istg]
		rtlSet = set()
		retDict = dict()
		for rtl in pipeRtl
			rtlSet.add(rtl)
		for rtl in rtlSet:
			src = self.__FindInBypass(src=rtl.src, istg=istg)
			inVar = RP.SrcToVar(src=src, stg=self.pipeLine.StgNameAt(istg-1))
			outVar = RP.SrcToVar(src=rtl.src, stg=self.pipeLine.StgNameAt(istg))
			retDict[outVar] = inVar
			
			# add source in reg statement
			if rtl.src in pipeIDict:
				width = pipeIDict[rtl.src]
				inVar = rtl.src
			elif '.' in rtl.src:
				modName, portName = rtl.src.split('.')[:2]
				mod = self.modMap.find(modName)
				port = mod.find(portName)
				width = port.width
			else:
				width = "XXXXXXXXX"
				inVar = rtl.src
				
			self.wireSet.add( wire(name=inVar, width=width, kind="wire", stg=istg-1) )
			self.wireSet.add( wire(name=outVar, width=width, kind="reg", stg=istg) )
		return retDict
			
		
	def __pipeToVerilog(self, tabn):
		ret = ""
		for istg in range(1, stgn):
			ret += self.__pipeToVerilogPerStg(tabn=tabn, istg=istg)
		return ret
		
	
	# pay attention clear & lock
	def __pipeToVerilogPerStg(self, tabn, istg):
		pre = "\t" * tabn
		Rstg = self.pipeLine.Rstg
		stgn = self.pipeLine.stgn
		pipeDict = self.pipeDict[istg]
		stgName = self.pipeLine.StgNameAt(istg)
		ret += pre + "/*****     Pipe_%s     *****/\n" % (stgName)
		ret += pre + "always @( posedge clk or negedge rst_n ) begin\n"
		if istg > Rstg:
			ret += pre + "\t" + "if ( !rst_n || clr_%s ) begin\n" % (self.pipeLine.StgNameAt(istg-1))
		else:
			ret += pre + "\t" + "if ( !rst_n ) begin\n" % (self.pipeLine.StgNameAt(istg))
		for outVar in pipeDict.itekeys():
			ret += pre + "\t\t" + "%s <= 0;\n" % (outVar)
		ret += pre + "\t" + "end\n"
		if istg <= Rstg:
			ret += pre + "\t" + "else if ( !clr_%s )begin\n" % (self.pipeLine.StgNameAt(Rstg))
		else:
			ret += pre + "\t" + "else begin\n"
		for outVar, inVar in pipeDict.iteritems():
			ret += pre + "\t\t" + "%s <= %s;\n" % (outVar, inVar)
		ret += pre + "end // end always\n\n"
		return ret
		