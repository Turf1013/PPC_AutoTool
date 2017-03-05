# -*- coding: utf-8 -*-
from collections import defaultdict
from ..role.ctrlSignal import CtrlSignal, CtrlTriple
from ..util.verilogParser import VerilogParser as VP
from ..util.rtlParser import RtlParser as RP
from ..util.rtlGenerator import RtlGenerator as RG
from ..util.verilogGenerator import VerilogGenerator as VG
from ..verilog.const_hdl import CFV
from ..role.wire import WireSet, Wire
from ..glob.glob import CFG
from MC import MC as MCI
from MC import CFMC

class constForControl:
	INSTR = "Instr"
	INSTR_WIDTH = CFG.INSTR_WIDTH
	LATCH = "latch"
	PCWR = "PCWr"
	STALL = "stall"
	
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
		self.portList += map(lambda i:CFC.INSTR+"_"+self.pipeLine.StgNameAt(i), range(self.pipeLine.Rstg.id, self.pipeLine.stgn))
		# add clr to wireSet
		for istg in range(self.pipeLine.Rstg.id, self.pipeLine.stgn):
			clrName = "clr_" + self.pipeLine.StgNameAt(istg)
			self.portList.append(clrName)
			self.wireSet.add( Wire(name=clrName, width=1, kind="reg", stg=istg) )
		# add delay slot control signal
		self.__delaySlot()
		# add MDU control signal
		self.__addMCIPort()
		
	
	def __addMCIPort(self):
		MCIPortList = [
			CFC.STALL, CFC.PCWR, CFC.LATCH,
			CFMC.MDU_CNT, CFMC.STALL_EXT, CFMC.MDU_INSN,
			CFMC.MDU_REQ, CFMC.MDU_ACK, CFMC.MDU_RESTORE
		]
		self.portList += MCIPortList
		
		
	def __delaySlot(self):
		if CFG.brDelaySlot or not self.pipeLine.brList:
			return 
		# not support Delay Slot
		rstg = self.pipeLine.Rstg.id
		stgName = self.pipeLine.Rstg.name
		signalName = RP.DesToVar(CFG.BRFLUSH, suf=stgName)
		cs = CtrlSignal(name=signalName, width=1, stg=rstg)
		# add 0 for patch
		cs.add( CtrlTriple(cond="0", pri=10**5) )
		for brInsnName in self.pipeLine.brList:
			cond = self.insnMap.find(brInsnName).condition(suf = stgName)
			cs.add( CtrlTriple(cond=cond, op=1) )
		self.CSList.append(cs)
		self.portList.append(signalName)
		self.wireSet.add( Wire(name=signalName, width=1, kind="reg", stg=rstg) )
		
		
	def addCS(self, iterable):
		for cs in iterable:
			self.wireSet.add( Wire(name=cs.name, width=cs.width, kind="reg", stg=cs.stg) )
			self.portList.append( cs.name )
		self.CSList += list(iterable)
		
		
	
	def GenCS(self):
		self.__GenCSFromRtl()
		if CFG.SHOWINFO:
			self.showInfo()
		
		
	def showInfo(self):
		line = ""
		line += "********************\n"
		line += "Automatic Controller:\n"
		line += "(1) %d control signals\n" % (len(self.CSList))
		line += "********************\n"
		line += "\n\n"
		print line	
		
		
	# Generate the Control Logic from Rtl
	def __GenCSFromRtl(self):
		stgn = self.pipeLine.stgn
		for istg in range(stgn):
			csList = self.__GenCSFromRtlPerStg(istg)
			for cs in csList:
				self.wireSet.add( Wire(name=cs.name, width=cs.width, kind="reg", stg=istg) )
				self.portList.append( cs.name )
			self.CSList += csList
			
		
	def __GenCSFromRtlPerStg(self, istg):
		csDict = dict()
		linkRtl = self.excelRtl.linkRtl
		rstg = self.pipeLine.Rstg.id
		stgName = self.pipeLine.StgNameAt(istg)
		for insnName,insnRtlList in linkRtl.iteritems():
			rtlList = insnRtlList[istg]
			for rtl in rtlList:
				# rtl need to be Ctrl Link
				if not rtl.isCtrlLink():
					continue
				signalName = RP.DesToVar(rtl.des, suf=stgName)
				if signalName not in csDict:
					# Create a CS
					mod = self.modMap.find(rtl.desMod)
					width = mod.find(rtl.desPort).width
					cs = CtrlSignal(name=signalName, width=width, stg=istg)
					# add clr with INF priority to the CtrlSignal
					"""
						``` pay attention to ```
						clr_D comes from decode Insn@D,
						so clr_D is not a part of ctrlSignal's condition
					"""
					if istg <= rstg:
						cs.add( CtrlTriple(cond="0", pri=10**5) )
					else:
						clr = VG.GenClr(suf=self.pipeLine.StgNameAt(istg) )
						cs.add( CtrlTriple(cond=clr, pri=10**5) )
					csDict[signalName] = cs
				else:
					cs = csDict[signalName]
				# create a CT
				insn = self.insnMap.find(insnName)
				cond = insn.condition(suf = self.pipeLine.StgNameAt(istg))
				op = RP.SrcToVar(rtl.src, self.pipeLine.StgNameAt(istg))
				cs.add( CtrlTriple(cond=cond, op=op) )
		return csDict.values()
		
		
	def toVerilog(self, tabn=1):
		pre = "\t" * tabn
		ret = ""
		
		# module statement
		ret += "module control (\n"
		portCode = self.__GenPortVerilog(tabn = tabn)
		ret += portCode
		ret += ");\n"
		
		# input statement
		inputCode = self.__GenInputVerilog(tabn = tabn)
		ret += pre + "// input statement\n" + inputCode + "\n"
		
		# output statement
		outputCode = self.__GenOutputVerilog(tabn = tabn)
		ret += pre + "// output statement\n" + outputCode + "\n"
		
		# wire & reg statement
		wireCode = self.wireSet.toVerilog(tabn = tabn)
		ret += pre + "// wire statement\n" + wireCode + "\n" * 4
		
		# control signal
		csCode = self.__CSToVerilog(tabn = tabn)
		ret += pre + "// control Signal\n" + csCode + "\n" * 4
		
		# MCI related
		if len(MCI.findMCI(self.excelRtl, self.pipeLine)) > 0:
			mci = MCI(self.excelRtl, self.pipeLine, self.modMap, self.insnMap)
			mciCode = mci.toVerilog(tabn = tabn)
			ret += pre + "// MCI supported signal\n" + mciCode + "\n" * 4
		else:
			mciCode = pre + "wire %s;\n\n" % (CFMC.STALL_MC)
			mciCode += pre + "assign %s = 0;\n" % (CFMC.STALL_MC)
			ret += pre + "// no MCI supported\n" + mciCode + "\n" * 4
		
		# pipe signal
		clrCode = self.__ClrToVerilog(tabn = tabn)
		ret += pre + "// clear Signal\n" + clrCode + "\n" * 4
		
		# other signal
		otherCode = self.__OtherToVerilog(tabn = tabn)
		ret += pre + "// other Signals\n" + otherCode + "\n" * 4
		
		# endmodule
		ret += "endmodule\n"
		return ret
		
		
	def __GenPortVerilog(self, tabn):
		pre = "\t" * tabn
		ret = ""
		for i,w in enumerate(self.wireSet):
			if i%5==0:
				ret += "\n" + pre if i else pre
			wname = w.name
			if wname == CFMC.STALL_HAZARD:
				wname = CFMC.STALL
			ret += wname + ", "
		# add insn
		ret += "\n"
		ret += pre + ", ".join(map(lambda i:CFC.INSTR+"_"+self.pipeLine.StgNameAt(i), range(self.pipeLine.Rstg.id, self.pipeLine.stgn)))
		
		# add MDU related
		ret += ",\n"
		MCIPortList = [
			CFMC.MDU_CNT, CFMC.MDU_ACK, CFMC.MDU_REQ, CFMC.STALL_EXT,
			CFMC.MDU_INSN, CFMC.MDU_RESTORE, CFC.PCWR, CFC.LATCH
		]
		ret += pre + ", ".join(MCIPortList) 
		
		
		# add clk & rst_n
		ret += ",\n"
		ret += pre + "clk, rst_n\n"
		return ret
		
	
	def __GenInputVerilog(self, tabn):
		pre = "\t" * tabn
		ret = ""
		ret += pre + "input clk, rst_n;\n"
		instrList = map(lambda i:CFC.INSTR+"_"+self.pipeLine.StgNameAt(i), range(self.pipeLine.Rstg.id, self.pipeLine.stgn))
		ret += pre + "input %s %s;\n" % (CFC.INSTR_WIDTH, ", ".join(instrList))
		
		# add MCI related
		ret += pre + "input [`MDU_CNT_WIDTH-1:0] %s;\n" % (CFMC.MDU_CNT)
		ret += pre + "input %s;\n" % (CFMC.MDU_ACK)
		ret += pre + "input %s;\n" % (CFMC.STALL_EXT)
		
		return ret
	
		
	def __GenOutputVerilog(self, tabn):
		pre = "\t" * tabn
		ret = ""
		
		ret += pre + "/// related to MDU & stall\n"
		ret += pre + "output %s;\n"	% (CFC.LATCH)
		ret += pre + "output %s;\n" % (CFC.PCWR)
		ret += pre + "output %s;\n" % (CFMC.MDU_REQ)
		ret += pre + "output %s;\n" % (CFMC.MDU_RESTORE)
		ret += pre + "output %s %s;\n" % (CFC.INSTR_WIDTH, CFMC.MDU_INSN)
		
		ret += pre + "/// other control signals\n"
		for w in self.wireSet:
			wname = w.name
			if wname == CFMC.STALL_HAZARD:
				wname = CFC.STALL
			ret += VG.GenOutput(name=wname, width=w.width, tabn=tabn)
		
		return ret
		
		
	def __CSToVerilog(self, tabn):
		ret = ""
		for cs in self.CSList:
			ret += cs.toVerilog(tabn=tabn) + "\n"
		return ret
		
		
	def __GenFlush_r_Logic(self):
		ret = []
		
		sigName = "%s_%s" % (CFG.BRFLUSH, self.pipeLine.Rstg.name)
		flipName = "%s_r" % (sigName)
		# add reg statement
		line = "reg %s;\n" % (flipName)
		ret.append(line)
		
		# add always block
		line = "always @(posedge clk or negedge rst_n) begin\n"
		ret.append(line)
		
		## add if
		line = "\tif (~rst_n) begin\n"
		ret.append(line)
		line = "\t\t%s <= 0;\n" % (flipName)
		ret.append(line)
		line = "\tend\n"
		ret.append(line)
		
		## add else 
		line = "\telse begin\n"
		ret.append(line)
		line = "\t\t%s <= %s;\n" % (flipName, sigName)
		ret.append(line)
		line = "\tend\n"
		ret.append(line)
		
		line = "end // end always\n"
		ret.append(line)
		ret.append("\n")
		
		return ret
		
		
	def __OtherToVerilog(self, tabn):
		ret = []
		
		# add stall logic
		line = "assign %s = %s;\n" % (
			CFC.STALL, " | ".join([CFMC.STALL_HAZARD, CFMC.STALL_MC, CFMC.STALL_EXT]))
		ret.append(line)
		
		# add PCWr logic
		line = "assign %s = ~(%s);\n" % (
			CFC.PCWR, " | ".join([CFMC.STALL_HAZARD, CFMC.STALL_MC, CFMC.STALL_EXT]))
		ret.append(line)
		
		# add latch logic
		line = "assign %s = %s;\n" % (
			CFC.LATCH, " | ".join([CFMC.STALL_HAZARD, CFMC.STALL_MC]))
		ret.append(line)
		
		prefix = "\t" * tabn
		return prefix + prefix.join(ret)
		
		
	def __ClrToVerilog(self, tabn):
		rstg = self.pipeLine.Rstg.id
		stgn = self.pipeLine.stgn
		pre = '\t' * tabn
		ret = ""
		
		ret += pre + pre.join(self.__GenFlush_r_Logic())
		
		# add always block
		ret += pre + "always @(posedge clk or negedge rst_n) begin\n"
		
		## add if 
		ret += pre + "\t" + "if (~rst_n) begin\n"
		for istg in range(rstg+1, stgn):
			ret += pre + "\t\t" + "clr_%s <= 1'b1;\n" % (self.pipeLine.StgNameAt(istg))
		ret += pre + "\t" + "end\n"
		
		## add else
		ret += pre + "\t" + "else begin\n"
		# ret += pre + "\t\t" + "clr_%s <= stall;\n" % (self.pipeLine.StgNameAt(rstg+1))
		mcStg = MCI.findPmc(self.excelRtl, self.pipeLine) + 1
		for istg in range(rstg+1, stgn):
			if istg != mcStg:
				ret += pre + "\t\t" + "clr_%s <= clr_%s;\n" % (self.pipeLine.StgNameAt(istg), self.pipeLine.StgNameAt(istg-1))
			else:
				preClr = "clr_%s" % (self.pipeLine.StgNameAt(istg-1))
				flipMcInsnEna = "%s_r" % (CFMC.MDU_INSN_ENA)
				specVal = "(%s) ? 1'b0 : (%s | %s)" % (
					CFMC.MDU_RESTORE, preClr, flipMcInsnEna)
				ret += pre + "\t\t" + "clr_%s <= %s;\n" % (self.pipeLine.StgNameAt(istg), specVal)
		ret += pre + "\t" + "end\n"
		ret += pre + "end // end always\n\n"
		
		clrD = "clr_%s" % (self.pipeLine.Rstg.name)
		flipBrFlush = "%s_%s_r" % (CFG.BRFLUSH, self.pipeLine.Rstg.name)
		clrDVal = " | ".join([
			flipBrFlush, CFMC.STALL_HAZARD, CFMC.STALL_MC])
		ret += pre + "/// logic of %s\n" % (clrD)
		ret += pre + "always @( * ) begin\n"
		ret += pre + "\t" + "%s = %s;\n" % (clrD, clrDVal)
		ret += pre + "end // end always\n\n"
		
		return ret
		
		
	def instance(self, tabn = 1):
		name = "control"
		pre = "\t" * tabn
		ret = ""
		ret += "%s%s I_%s (\n" % (pre, name, name)
		if CFMC.STALL_HAZARD in self.portList:
			self.portList.remove(CFMC.STALL_HAZARD)
		for i,portName in enumerate(self.portList):
			instName = portName
			if i == len(self.portList) - 1:
				ret += pre + "\t.%s(%s)\n" % (portName, instName)
			else:
				ret += pre + "\t.%s(%s),\n" % (portName, instName)
		ret += "%s);\n\n" % (pre)
		return ret