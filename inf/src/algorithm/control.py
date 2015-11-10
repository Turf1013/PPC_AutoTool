# -*- coding: utf-8 -*-
from collections import defaultdict
from ..role.ctrlSignal import CtrlSignal, CtrlTriple
from ..util.verilogParser import VerilogParser as VP
from ..util.rtlParser import RtlParser as RP
from ..util.rtlGenerator import RtlGenerator as RG
from ..util.verilogGenerator import VerilogGenerator as VG
from ..verilog.const_hdl import CFV
from ..role.wire import WireSet, Wire

class constForControl:
	INSTR = "Instr"
	INSTR_WIDTH = "[`INSTR_WIDTH-1:0]" 
	
	
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
		self.wireSet = WireSet()
		self.portList = []	
		# add clk, rst_n, instr to portList
		self.portList.append( "clk" )
		self.portList.append( "rst_n" )
		self.portList += map(lambda i:CFC.INSTR+"_"+self.pipeLine.StgNameAt(i), range(self.pipeLine.Rstg, self.pipeLine.stgn))
		# add clr to wireSet
		for istg in range(self.pipeLine.Rstg, self.pipeLine.stgn):
			clrName = "clr_" + self.pipeLine.StgNameAt(istg)
			self.portList.append(clrName)
			self.wireSet.add( Wire(name=clrName, width=1, kind="reg", stg=istg) )
		
		
	def addCS(self, iterable):
		for cs in iterable:
			self.wireSet.add( Wire(name=cs.name, width=cs.width, kind="reg") )
			self.portList.add( cs.name )
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
		
		# wire & reg statement
		wireCode = self.wireSet().toVerilog(tabn=tabn)
		ret += "// wire statement\n" + wireCode + "\n" * 4
		
		# control signal
		csCode = self.__CSToVerilog(tabn=tabn)
		ret += "// Ctrl Signal\n" + csCode + "\n" * 4
		
		# pipe signal
		clrCode = self.__ClrToVerilog(tabn=tabn)
		ret += "// Clear Signal\n" + clrCode + "\n" * 4
		
		# endmodule
		ret += "endmodule\n"
		return ret
	
	def __GenInputVerilog(self, tabn):
		pre = "\t" * tabn
		ret = ""
		ret += pre + "input clk, rst_n;\n"
		instrList = map(lambda i:CFC.INSTR+"_"+self.pipeLine.StgNameAt(i), range(self.pipeLine.Rstg, self.pipeLine.stgn))
		ret += pre + "input %s %s;\n" % (INSTR_WIDTH, ", ".join(instrList))
		return ret
	
		
	def __GenOutputVerilog(self, tabn):
		pre = "\t" * tabn
		ret = ""
		for w in self.wireSet:
			ret += VG.GenOutput(name=w.name, width=w.width, tabn=tabn)
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
		
	def instance(self, tabn):
		name = "control"
		pre = "\t" * tabn
		ret += "%s%s I_%s(\n" % (pre, name, name)
		last = len(self.portList) - 1
		for port in self.portList:
			if i == last:
				ret += pre + "\t.%s(%s)\n" % (port, port)
			else:
				ret += pre + "\t.%s(%s),\n" % (port, port)
		ret += "%s);\n\n" % (pre)
		return ret