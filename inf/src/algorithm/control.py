# -*- coding: utf-8 -*-
from collections import defaultdict
from ..role.ctrlSignal import CtrlSignal, CtrlTriple
from ..util.verilogParser import VerilogParser as VP
from ..util.rtlParser import RtlParser as RP
from ..util.rtlGenerator import RtlGenerator as RG
from ..util.verilogGenerator import VerilogGenerator as VG
from ..verilog.const_hdl import CFV

class constForControl:
	pass
	
	
class CFC(constForControl):
	pass
	
	
class Control(object):
	""" Control includes all the Logic of Control Signal(included hazard).
	
	Function includes:
	1. Add Control Signal From OutSide;
	2. Generate Control Singal according Inside;
	"""

	def __init__(self, excelRtl, pipeLine, modMap, insnMap):
		self.excelRtl = excelRtl
		self.pipeLine = pipeLine
		self.modMap = modMap
		self.insnMap = insnMap
		self.CSList = []
		
		
	def addCS(self, iterable):
		self.CSList += list(iterable)
		
	
	def GenCS(self):
		self.__GenCSFromRtl()
		
		
	# Generate the Control Logic from Rtl
	def __GenCSFromRtl(self):
		stgn = self.pipeLine.stgn
		for istg in range(stgn):
			csList = self.__GenCSFromRtlPerStg(istg)
			self.CSList += csList
			
		
	def __GenCSFromRtlPerStg(self, istg):
		csDict = dict()
		linkRtl = self.excelRtl.linkRtl
		for insnName,insnRtlList in linkRtl.iteritems():
			rtlList = insnRtlList[istg]
			for rtl in rtlList:
				# rtl need to be Ctrl Link
				if not rtl.isCtrlLink:
					continue
				signalName = VP.DesToVar(cl, rtl.des)
				if singalName not in csDict:
					# Create a CS
					mod = self.modMap.find(rtl.desMod)
					port = mod.find(rtl.desPort)
					width = port.width
					cs = CtrlSignal(name=signalName, width=width)
					# add clr with INF priority to the CtrlSignal
					clr = VG.GenClr(suf=self.pipeLine.StgNameAt(istg))
					cs.add( CtrlTriple(cond=clr, pri=10**5) )
					csDict[signalName] = cs
				else:
					cs = csDict[Name]
				# create a CT
				insn = self.insnMap.find(insnName)
				cond = insn.condition(suf = self.pipeLine.StgNameAt(istg))
				op = rtl.src
				cs.add( CtrlTriple(cond=cond, op=op) )
		return csDict.items()
		
		
	def toVerilog(self, tabn):
		pre = "\t" * tabn
		ret = ""
		
		# module statement
		ret += "module control (\n"
		ret += ");\n"
		
		# control signal
		csCode = self.__CSToVerilog(tabn=tabn)
		ret += "// Ctrl Signal\n" + csCode + "\n" * 4
		# pipe signal
		clrCode = self.__ClrToVerilog(tabn=tabn)
		ret += "// Clear Signal\n" + clrCode + "\n" * 4
		
		# endmodule
		ret += "endmodule\n"
		return ret
		
		
	def __CSToVerilog(self, tabn):
		ret = ""
		for cs in self.CSList:
			ret += cs.toVerilog(tabn=tabn) + "\n"
		return ret
		
		
	def __ClrToVerilog(self, tabn):
		Rstg = self.pipeLine.Rstg
		stgn = self.pipeLine.stgn
		pre = '\t' * tabn
		ret = ""
		ret += pre + "always @(posedge clk or negedge rst_n) begin\n"
		ret += pre + "\t" + "if ( !rst_n ) begin\n"
		for istg in range(Rstg+1, stgn)
			ret += pre + "\t\t" + "clr_%s <= 1'b1;\n" % (self.pipeLine.StgNameAt(istg))
		ret += pre + "\t" + "end\n"
		ret += pre + "\t\t" + "clr_%s <= stall;\n" % (self.pipeLine.StgNameAt(Rstg+1))
		for istg in range(Rstg+2, stgn)
			ret += pre + "\t\t" + "clr_%s <= clr_%s;\n" % (self.pipeLine.StgNameAt(istg), self.pipeLine.StgNameAt(istg-1))
		ret += pre + "\t" + "else begin\n"
		ret += pre + "\t" + "end\n"
		ret += pre + "end // end always\n\n"
		
		ret += pre + "//// same meaning as clr_%s = stall;\n" % (self.pipeLine.StgNameAt(Rstg))
		ret += pre + "always @( * ) begin\n"
		ret += pre + "\t" + "clr_%s <= stall;\n" % (self.pipeLine.StgNameAt(Rstg))
		ret += pre + "end // end always\n\n"
		return ret
		