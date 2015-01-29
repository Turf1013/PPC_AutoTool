from Access_Excel import *
from gen_hdl import *
import ErrRobot
from collections import *
from operator import itemgetter
from auto_ppc_const import *
from auto_ppc_check import *
from auto_ppc_name import *
import math
import copy
import re
import os
import itertools

global NULL
NULL = ""

def dict_dictAsValue():
	return defaultdict(dict)
	
def dict_listAsValue():
	return defaultdict(list)

class Auto_PPC_ErrRobot(ErrRobot.ErrRobot):
	'Error Dictionary'
	PROGRAM_BUG = -2
	DEFAULT = -1
	MULTISRC_INTO_ONEDES = 0
	PORT_UNCONNECTED = 1
	PORT_NOMODULE = 2
	UNDEF_MODULE = 3
	UNKNOWN_FLOW = 4
	NO_ADDR = 5
	INVALID_WORKPATH = 7
	INVALID_INSTR = 8
	errDict = {
		PROGRAM_BUG: "Program BUG, WOO!!! there's a bug, fix it ASAP",
		DEFAULT: "Unexpectable error",
		MULTISRC_INTO_ONEDES: "In One stage Multiple Sources connect into One destionation",
		PORT_UNCONNECTED: "still has unconnected ports",
		PORT_NOMODULE: "port has no father module",
		UNDEF_MODULE: "Undefined module name",
		UNKNOWN_FLOW: "Unknown Flow port",
		NO_ADDR: "Insn have a invalid addr port",
		INVALID_WORKPATH: 'work path is not directory',
		INVALID_INSTR: 'invalid instr'
	}
		
	def __init__(self):
		super(Auto_PPC_ErrRobot, self).__init__(self.errDict)
		
		
class Auto_PPC_Pipeline():
	'With reading PPC RTL description, auto Generate HDL Code'
	begRow_glb = 0
	begCol_glb = 0
	
	def __init__(self, workPath, excelPath, rtlSheetName, instrdef_fname,\
					readPortWithStage, wbStage='W'):
		self.AE = Access_Excel(excelPath, rtlSheetName)
		self.ErrRobot = Auto_PPC_ErrRobot()
		if not workPath.endswith('\\'):
			workPath += '\\'
		self.workPath = workPath
		if not os.path.isdir(self.workPath):
			self.ErrRobot.addErr(INVALID_WORKPATH, workpath)
		self.begRow = self.begRow_glb		# start row of rtl sheet
		self.begCol = self.begCol_glb		# start column of rtl sheet
		self.endRow = self.AE.Get_NRow()
		self.endCol = self.AE.Get_NCol()
		self.cuPortDict = dict()
		self.outputPortSet = set()
		self.initRE()
		'do some setting'
		self.Set_readPort(readPortWithStage)
		self.Set_pipeLineStage(wbStage)
		self.Gen_includeCode()
		
	def initRE(self):
		'RE helps to faster replace'
		self.re_moduleName = re.compile(r'\s*%s\s+(?P<name>[\w_]+)\s*' % (MODULE))
		self.re_endmodule = re.compile(r'\s*%s' % (ENDMODULE))
		self.re_portWidth = re.compile(r'\s*(?P<direct>input|output)\s+(?P<width>\[[\w`:_+-]+\])?')
		self.re_portName = re.compile(r'\s*[\w_]+\s*[,;]')
		self.re_delSpace = re.compile(r'\s+')
		
		self.re_portVar = re.compile(r'[a-zA-Z][\w.]*')
		self.re_rtlInstr = re.compile(r'Instr')
		self.re_rtlCond = re.compile(r'([\w.\'`]+)')
		self.re_portAddr = re.compile(r'[a-zA-Z.]+(\d+)')
	
	def autoGen(self):
		self.createModuleTb_fromAllFiles()
		opDict = self.Get_OpAndXoFromOneFile(instrdef_fname)
		self.Gen_instrGoups(opDict)
		# print self.instrSGrp
		self.Get_instrBoundry(self.begCol)
		self.Check_instrInRtl()
		self.createRtlTree()
		
		'handle all hazard first and generate the hdl code'
		self.handleAllHazard()
		hazardInoutCode_forCu, hazardWireCode_forCu,\
			hazardAssignCode_forCu, hazardWireCode_forDp,\
				hazardUtilizeCode_forDp = self.Gen_hazardHDLCode(tabn = 1)
		self.Gen_ctrl(hazardInoutCode_forCu, hazardWireCode_forCu, hazardAssignCode_forCu)
		self.Gen_dp(hazardWireCode_forDp, hazardUtilizeCode_forDp)
		
	def Gen_dp(self, hazardWireCode, hazardUtilizeCode, modName=HDL_CPU, tabn = 1):
		'generate datapath HDL code'
		inoutCode = ''
		wireCode = ''
		regCode = ''
		utilizeCode = ''
		alwaysCode = ''
		assignCode = ''
		
		'utilize normal module'
		wireTmp, utilizeTmp = self.Gen_dpUtilizeCode(tabn)
		wireCode += wireTmp
		utilizeCode += utilizeTmp
		
		'utilize cu'
		wireTmp, utilizeTmp = self.Gen_utilizeCu(tabn)
		wireCode += wireTmp
		utilizeCode += utilizeTmp
		
		'utilize normal mux'
		utilizeTmp = self.Gen_dpMuxCode(tabn)
		utilizeCode += utilizeTmp
		
		'add pipe always block'
		regTmp, alwaysTmp = self.Gen_dpPipeCode(tabn)
		alwaysCode += alwaysTmp
		regCode += regTmp
		'wireCode need to add Instr_F here'
		wireCode += Gen_wireStatementCode(
			[(Gen_INSTROfStage(self.stageNames[0]), HDL_INSTR_WIDTH)], tabn
		)
		
		'add hazard code'
		wireCode += hazardWireCode
		utilizeCode += hazardUtilizeCode
		
		'dp module statement'
		portList = [HDL_CLK, HDL_RST]
		inoutCode += Gen_inputStatementCode(zip(portList, ['']*2), tabn)
		moduleCode = Gen_moduleCode(modName, portList)
		
		'open the file'
		fout = open(modName+DOTV, 'w')
		
		'write the include code'
		fout.write(self.includeCode)
		
		'write the module statement'
		fout.write(moduleCode)
		
		'write the inout statement'
		fout.write(inoutCode + '\n')
		
		'write the wire statement'
		fout.write(wireCode + '\n')
		
		'write the reg statement'
		fout.write(regCode + '\n')
		
		'write the assign code'
		fout.write(assignCode)
		
		'write the utilize code'
		fout.write(utilizeCode)
		
		'write the always block'
		fout.write(alwaysCode)
		
		'endmodule'
		fout.write(Gen_endmoduleCode())
		
		fout.close()
		
	def Gen_dpUtilizeCode(self, tabn = 1):
		ret_wireCode = ''
		ret_utilizeCode = ''
		'merge all desport of connect to module'
		modPortDict = defaultdict(dict)
		for i_stage,connectDict in self.connectTree.items():
			for desPort in connectDict.keys():
				modName,portName = desPort.split(RTL_MODTOPORT)[:2]
				if portName not in modPortDict[modName]:
					modPortDict[modName][portName] = i_stage
		'merge all flow to module'
		for i_stage,pipeDict in self.pipeTree.items():
			for pipePort in pipeDict.keys():
				if RTL_MODTOPORT not in pipePort:
					continue
				modName,portName = pipePort.split(RTL_MODTOPORT)[:2]
				if portName not in modPortDict[modName]:
					modPortDict[modName][portName] = i_stage
		'merege all srcPort of connect to module'
		for i_stage,connectDict in self.connectTree.items():
			for srcPortDict in connectDict.values():
				for srcPort in srcPortDict.keys():					
					if RTL_MODTOPORT not in srcPort:
						continue
					self.outputPortSet.add(srcPort)
					modName,portName = srcPort.split(RTL_MODTOPORT)[:2]
					if portName not in modPortDict[modName]:
						modPortDict[modName][portName] = i_stage
					
		'search all using value to generate HDL Code'
		for modName,portDict in modPortDict.items():
			wireCode, utilizeCode = self.Gen_utilizeCode(modName, portDict, tabn)
			ret_wireCode += wireCode
			ret_utilizeCode += utilizeCode
		
		print ret_wireCode
		print ret_utilizeCode
		
		return ret_wireCode, ret_utilizeCode
	
	def Gen_utilizeCu(self, tabn):
		'add the control to module table'
		'add the control port to outputList for generating the wire statement'
		modName = HDL_CONTROL
		self.moduleTb[modName] = self.cuPortDict
		'add clk, rst_n, Instr_X to module table'
		self.moduleTb[modName][HDL_CLK] = ''
		self.moduleTb[modName][HDL_RST] = ''
		for instrName in [Gen_INSTROfStage(name) for name in self.stageNames[1:]]:
			self.moduleTb[modName][instrName] = HDL_INSTR_WIDTH
	
		'must rewrite the utilize code'
		pre = '\t' * tabn
		modName = HDL_CONTROL
		utilizeCode = pre + '%s U_%s (' % (modName, modName)
		wireList = []
		portList = self.cuPortDict.items()
		for i,(portName,portWidth) in enumerate(portList[:-1]):
			if not isGeneralPort(portName):
				wireList.append((portName, portWidth))
			if i%4 == 0:
				utilizeCode += '\n' + pre + '\t'
			utilizeCode += '.%s(%s), ' % (portName, portName)
		if len(portList)%4 == 1:
			utilizeCode += '\n' + pre + '\t'
		portName,portWidth = portList[-1]
		if not isGeneralPort(portName):
			wireList.append((portName, portWidth))
		utilizeCode += '.%s(%s)\n' % (portName, portName)
		utilizeCode += pre + ');\n\n'
		
		ret_utilizeCode = utilizeCode
		ret_wireCode = Gen_wireStatementCode(wireList, tabn)	
		return ret_wireCode, ret_utilizeCode
				
	def Gen_utilizeCode(self, modName, portDict, tabn, utilizeCu=False):
		'generate the utilize HDL Code of modName'
		utilizeCode = ''
		wireCode = ''
		pre = '\t' * tabn
		utilizeCode += pre + '%s U_%s (' % (modName, modName)
		portList = self.moduleTb[modName].items()
		if len(portList) == 0:
			self.ErrRobot.addErr(UNDEF_MODULE, 'module', modName)
			return wireCode, utilizeCode
		wireList = []
		for i,(port,width) in enumerate(portList[:-1]):
			if i%4 == 0:
				utilizeCode += '\n' + pre + '\t'
			if isGeneralPort(port):
				srcPortName = port
			else:
				rawPortName = '%s.%s' % (modName, port)
				if port in portDict:
					i_stage = portDict[port]
					stageName = self.stageNames[i_stage]
					if isCtrlPort(rawPortName):
						srcPortName = Gen_portName(rawPortName)
					else:
						portName = Gen_portName(rawPortName, stageName)
						if rawPortName in self.connectTree[i_stage]:
							srcPortDict = self.connectTree[i_stage][rawPortName]
							if len(srcPortDict.keys()) > 1:
								'means need a mux'
								srcPortName = portName
							else:
								srcPort = srcPortDict.keys()[0]
								'if a bypass port, we must redict to bypasport'
								if self.isBypassPort(srcPort, i_stage):
									srcPortName = Gen_muxName(srcPort, stageName, isbypass=True)
								else:
									srcPortName = Gen_portName(srcPort, stageName)
						else:
							srcPortName = portName
				else:
					srcPortName = Gen_portName(rawPortName)
					self.ErrRobot.addErr(
						self.ErrRobot.PORT_UNCONNECTED, 'module', rawPortName
					)
				if self.isOutputPort(rawPortName):
					'means output, generate the wire code'
					wireList.append((portName, width))
					
			utilizeCode += '.%s(%s), ' % (port, srcPortName)
			
		if len(portList)%4 == 1:
			utilizeCode += '\n' + pre + '\t'
		port,width = portList[-1]
		if isGeneralPort(port):
			srcPortName = port
		else:
			rawPortName = '%s.%s' % (modName, port)
			if port in portDict:
				i_stage = portDict[port]
				stageName = self.stageNames[i_stage]
				if isCtrlPort(rawPortName):
					srcPortName = Gen_portName(rawPortName)
				else:
					portName = Gen_portName(rawPortName, stageName)
					if rawPortName in self.connectTree[i_stage]:
						srcPortDict = self.connectTree[i_stage][rawPortName]
						if len(srcPortDict.keys()) > 1:
							'means need a mux'
							srcPortName = portName
						else:
							srcPort = srcPortDict.keys()[0]
							'if a bypass port, we must redict to bypasport'
							if self.isBypassPort(srcPort, i_stage):
								srcPortName = Gen_muxName(srcPort, stageName, isbypass=True)
							else:
								srcPortName = Gen_portName(srcPort, stageName)
					else:
						srcPortName = portName		
			else:
				srcPortName = Gen_portName(rawPortName)
				self.ErrRobot.addErr(
					self.ErrRobot.PORT_UNCONNECTED, 'module', rawPortName
				)
			if self.isOutputPort(rawPortName):
				'means output, generate the wire code'
				wireList.append((portName, width))
				
		utilizeCode += '.%s(%s)\n' % (port, srcPortName)
		utilizeCode += pre + ');\n\n'
		
		wireCode = Gen_wireStatementCode(wireList, tabn)
		return wireCode, utilizeCode
		
	def Gen_dpMuxCode(self, tabn):
		ret_utilizeCode = ''
		
		for i_stage,connectDict in self.connectTree.items():
			for desPort,srcDict in connectDict.items():
				if isCtrlPort(desPort) or len(srcDict)<=1:
					continue
				'it must be a mux'
				desPortName = Gen_portName(desPort, self.stageNames[i_stage])
				'because the bypass we need to update the srcPort'
				srcPortList = self.Update_srcPortList(srcDict.keys(), i_stage)
				utilizeCode = self.Gen_muxHDLCode(
					desPort, i_stage, srcPortList, tabn
				)
				ret_utilizeCode += utilizeCode
		
		return ret_utilizeCode
	
	def Update_srcPortList(self, portList, i_stage):
		ret_srcPortList = []
		for port in portList:
			if self.isBypassPort(port, i_stage):
				'when bypass port, we add the portName with i_stage is None'
				bpPortName = Gen_muxName(port, self.stageNames[i_stage], isbypass=True)
				ret_srcPortList.append((bpPortName, None))
			else:
				ret_srcPortList.append((port, i_stage))
		return ret_srcPortList
	
	def Gen_dpPipeCode(self, tabn):
		'generate the pipe always block for dp'
		ret_alwaysCode = ''
		regList = []
		triggerCond = HDL_CLKWITHRSTCOND
		for i_stage,srcDict in self.pipeTree.items()[:-1]:
			srcStageName = self.stageNames[i_stage]
			desStageName = self.stageNames[i_stage+1]
			pipeRegName = Gen_pipeRegWrName(srcStageName)
			'generate the pipe assignment pair'
			pipePairList = []
			for srcPort in srcDict:
				srcPortName = Gen_portName(srcPort, srcStageName)
				desPortName = Gen_portName(srcPort, desStageName)
				pipePairList.append((desPortName, srcPortName))
				'add to reg statement'
				portWidth = self.Get_portWidthFromModuleTb(srcPort)
				regList.append((desPortName, portWidth))
			'generate the condList, solutionList'
			condList = [HDL_RSTCOND, pipeRegName]
			solutionList = [ ['%s <= 0' %(item[0]) for item in pipePairList] ]
			solutionList += [ ['%s <= %s' %(item[0], item[1]) for item in pipePairList] ]
			alwaysCode = Gen_alwaysBlockCode(
				condList, solutionList, elseSolution=None, triggerCond=triggerCond, tabn=tabn
			)
			ret_alwaysCode += '\t'*tabn + '/*****     Pipe_%s     *****/\n' % (desStageName)
			ret_alwaysCode += alwaysCode + '\n' 
			
		ret_regCode = Gen_regStatementCode(regList, tabn)	
		return ret_regCode, ret_alwaysCode
		
	def Gen_ctrl(self, hazardInoutCode, hazardWireCode, hazardAssignCode, modName=HDL_CONTROL, tabn = 1):
		'generate the whole cu code, and return utilize CU code'
		ret_inoutCode = ''
		ret_wireCode = ''
		ret_regCode = ''
		ret_assignCode = ''
		ret_alwaysCode = ''
		
		'generate the normal logic about cu'
		inoutCode, wireCode, assignCode = self.Gen_cuHDLCode(tabn)
		ret_inoutCode += inoutCode
		ret_wireCode += wireCode
		ret_assignCode += assignCode
		
		'generate the flush related code'
		inoutCode, wireCode, regCode,\
				assignCode, alwaysCode = self.Gen_cuFlushCode(tabn)
		ret_inoutCode += inoutCode
		ret_wireCode += wireCode
		ret_regCode += regCode
		ret_assignCode += assignCode
		ret_alwaysCode += alwaysCode
		
		'add clk, rst_n, instr to ret_inoutCode'
		portList = [HDL_CLK, HDL_RST]
		widthList = ['']*2
		portList += [Gen_INSTROfStage(name) for name in self.stageNames[1:]]
		widthList += [HDL_INSTR_WIDTH] * (self.stageNum-1)
		inoutCode = Gen_inputStatementCode(zip(portList, widthList), tabn)
		ret_inoutCode = inoutCode + ret_inoutCode
		
		'add the code coming from hazard array'
		ret_inoutCode += hazardInoutCode
		ret_wireCode += hazardWireCode
		ret_assignCode += hazardAssignCode
		
		'open the control.v for writing'
		fout = open(modName+DOTV, 'w')
		'insert the include code'
		fout.write(self.includeCode)
		
		'insert the module statement code'
		moduleCode = Gen_moduleCode(modName, portList+self.cuPortDict.keys())
		fout.write(moduleCode)
		
		'insert the inout statement code'
		fout.write(ret_inoutCode+'\n')
		
		'insert other code'
		fout.write(ret_wireCode+'\n')
		fout.write(ret_regCode+'\n')
		fout.write(ret_assignCode+'\n')
		fout.write(ret_alwaysCode+'\n')
		fout.write(Gen_endmoduleCode())
		
		'close the control.v'
		fout.close()	
		
	def Gen_cuHDLCode(self, tabn = 1):
		'generate the HDL Code about the Ctrl'
		ret_inoutCode = ''
		ret_wireCode = ''
		ret_assignCode = ''
		
		for i_stage in range(self.stageNum):
			inoutCode, wireCode, assignCode =\
					self.Gen_cuHDLCodeOfaStage(i_stage, tabn)
			ret_inoutCode += inoutCode
			ret_wireCode += wireCode
			ret_assignCode += assignCode
		
		'generate PCWr'
		portName = Gen_portName(RTL_PCWr)
		condExp = '~(%s)' % ( ' || '.join([
			Gen_stallName(self.stageNames[i_stage]) for i_stage in self.stallStageSet
		]) )
		ret_inoutCode += Gen_outputStatementCode([(portName, '')], tabn)
		ret_assignCode += Gen_assignCode(portName, condExp, tabn)
		self.cuPortDict[portName] = ''
		
		print ret_inoutCode
		print ret_wireCode
		print ret_assignCode
		
		return ret_inoutCode, ret_wireCode,ret_assignCode
	
	def Gen_cuFlushCode(self, tabn = 1):
		ret_inoutCode = ''
		ret_wireCode = ''
		ret_regCode = ''
		ret_assignCode = ''
		ret_alwaysCode = ''
		
		'always logic about flush'
		triggerCond = HDL_CLKWITHRSTCOND
		condExp = HDL_RSTCOND
		solutions = [
			"%s_r <= 1'b1" % Gen_flushName(stageName) for stageName in self.stageNames
		]
		elseSolution = [
			"%s_r <= 1'b0" % Gen_flushName(self.stageNames[0])
		] + [
			"%s_r <= %s" % (Gen_flushName(self.stageNames[i+1]),\
							  Gen_flushName(self.stageNames[i]))\
			for i in range(self.stageNum-1)
		]
		flushrAlwaysCode = Gen_alwaysBlockCode(
			[condExp], [solutions], elseSolution, triggerCond, tabn
		)
		ret_alwaysCode += flushrAlwaysCode

		'generate the HDL code of flush'
		flushList = []
		flushrList = []
		for i_stage in range(self.stageNum):
			flushName = Gen_flushName(self.stageNames[i_stage])
			flushrName = flushName + '_r'
			flushList.append( (flushName, '') )
			flushrList.append( (flushrName, '') )
			if i_stage in self.stallStageSet:
				stallName = Gen_stallName(self.stageNames[i_stage])
				assignCode = Gen_assignCode(
					flushName, (stallName, '||', flushrName), tabn
				)
				'we add stall wire here'
				ret_wireCode += Gen_wireStatementCode([(stallName, '')], tabn)
				
			else:
				assignCode = Gen_assignCode(
					flushName, flushrName, tabn
				)
			ret_assignCode += assignCode
		ret_assignCode += '\n'		
		ret_wireCode += Gen_wireStatementCode(flushList, tabn)
		ret_regCode += Gen_regStatementCode(flushrList, tabn)
		
		'generate the HDL code of pipeRegWr'
		pipeRegList = []
		stallList = list(self.stallStageSet)
		for i_stage in range(self.stageNum):
			pipeRegName = Gen_pipeRegWrName(self.stageNames[i_stage])
			pipeRegList.append( (pipeRegName, '') )
			if i_stage <= stallList[-1]:
				begIndex = 0 if i_stage not in stallList else stallList.index(i_stage)
				stallNames = [
					Gen_stallName(self.stageNames[i])\
					for i in stallList[begIndex:]
				]
				condExp = '~(%s)' % (' || '.join(stallNames))
			else:
				condExp = "1'b1"
			assignCode = Gen_assignCode(
				pipeRegName, condExp, tabn,
			)
			ret_assignCode += assignCode
			self.cuPortDict[pipeRegName] = ''
		ret_assignCode += '\n'
		ret_wireCode += Gen_wireStatementCode(pipeRegList, tabn)
		ret_inoutCode += Gen_outputStatementCode(pipeRegList, tabn)
		
		
		print ret_inoutCode
		print ret_wireCode
		print ret_regCode
		print ret_assignCode
		print ret_alwaysCode
		
		return ret_inoutCode, ret_wireCode, ret_regCode,\
				ret_assignCode, ret_alwaysCode
	
	def Gen_cuHDLCodeOfaStage(self, i_stage, tabn = 1):
		ret_inoutCode = ''
		ret_wireCode = ''
		ret_assignCode = ''
		
		stageName = self.stageNames[i_stage]
		flushName = Gen_flushName(stageName)
		pre = '\t' * (tabn + 1)
		linkStr = ' :\n' + pre
		for desPort, srcPortDict in self.connectTree[i_stage].items():
			condList = []
			if isCtrlPort(desPort):
				'ctl port, like op, wr'
				desPortName = Gen_portName(desPort)
				width = '`%s_%s' % (desPortName, HDL_WIDTH)
				for srcPort, instrGrp in srcPortDict.items():
					instrList = self.Gen_instrCond(instrGrp, i_stage)
					# condExp = ' || '.join(instrList)
					condExp = self.Gen_multiCondExp(instrList, ' || ', tabn+1)
					sol = Gen_portName(srcPort, stageName)
					condList.append('(%s) ? %s' % (condExp, sol))
				width = '[%s-1:0]' % (width)
			
			elif len(srcPortDict) > 1:
				'is a mux'
				desPortName = Gen_selName(desPort, '')
				width = len(srcPortDict)
				for i, (srcPort, instrGrp) in enumerate(srcPortDict.items()):
					instrList = self.Gen_instrCond(instrGrp, i_stage)
					# condExp = ' || '.join(instrList)
					condExp = self.Gen_multiCondExp(instrList, ' || ', tabn+1)
					sol = "%d'd%d" % (width, i)
					condList.append('(%s) ? %s' % (condExp, sol))
				width = '[%d:0]' % (width-1)
			
			else:
				continue
				
			condExp = ''	
			if isCtrlPort(desPort):	
				'ctrl port must check funsh first of all'
				condExp += '%s ? 0 :' % (flushName)
			condExp += '\n' + pre + linkStr.join(condList)
			condExp += ' : 0'
			ret_assignCode += Gen_assignCode(desPortName, condExp, tabn) + '\n'
			ret_wireCode += Gen_wireStatementCode([(desPortName, width)], tabn)
			ret_inoutCode += Gen_outputStatementCode([(desPortName, width)], tabn)
			self.cuPortDict[desPortName] = width
			
		return ret_inoutCode, ret_wireCode, ret_assignCode
	
	def Gen_multiCondExp(self, condExp, linkStr, tabn):
		pre = '\t' * tabn
		ret = ''
		i = 1
		while i < len(condExp):
			if i%3 == 0:
				ret += '\n' + pre + ' '
			ret += '%s%s' % (condExp[i], linkStr)
			i += 1
		ret += condExp[-1]
		return ret
	
	def handleAllHazard(self):
		self.bypassDataList = defaultdict(dict_listAsValue)
		self.rInstrGrpDict = defaultdict(OrderedDict)
		self.wInstrGrpDict = defaultdict(OrderedDict)
		self.stallCondList = []
		self.bpCondDict = dict()
		for readPort in self.readPortDict:
			self.handleOneHazard(readPort)
			
	def Gen_hazardHDLCode(self, tabn = 1):
		ret_inoutCode_forCu = ''
		ret_wireCode_forCu = ''
		ret_assignCode_forCu = ''
		ret_wireCode_forDp = ''
		ret_utilizeCode_forDp = ''
		
		'generate hazard code for Ctrl'
		# logic for instr group
		wireInstrCode, assignInstrCode = self.Gen_instrGrpCode(tabn)
		ret_wireCode_forCu += wireInstrCode
		ret_assignCode_forCu += assignInstrCode
		# logic for stall
		stallAssignCode = self.Gen_stallHDLCode(self.stallCondList, tabn)
		# logic for bypass
		inoutCode, wireBpCode, assignBpCode = self.Gen_bypassCuHDLCode(tabn)
		ret_inoutCode_forCu += inoutCode
		ret_wireCode_forCu += wireBpCode
		ret_assignCode_forCu += assignBpCode
		
		'generate hazard code for Datapath'
		bpWireCode, bpUtilizeCode = self.Gen_bypassMuxHDLCode(tabn)
		ret_wireCode_forDp += bpWireCode
		ret_utilizeCode_forDp += bpUtilizeCode
		
		print ret_inoutCode_forCu
		print wireInstrCode
		print assignInstrCode
		print stallAssignCode
		print wireBpCode
		print assignBpCode
		print ret_utilizeCode_forDp
		
		return ret_inoutCode_forCu, ret_wireCode_forCu, ret_assignCode_forCu,\
			   ret_wireCode_forDp, ret_utilizeCode_forDp
		
	def handleOneHazard(self, readPort, tabn = 1):
		readStage = self.readPortDict[readPort]
		rdArray_D, rdArray_E = self.createRdArray(readPort)
		wdArray, wdGrpDict = self.createWdArray(readPort)
		
		self.printRdArray(rdArray_D, readStage)
		self.printRdArray(rdArray_E, readStage+1)
		self.printWdArray(readPort, wdArray, wdGrpDict)
		'generate the stallCondList and bpCondList'
		stallCondList, bpCondList =\
			self.handleOnePairArray(readPort, rdArray_D, wdArray, wdGrpDict)
		self.bpCondDict[(readPort, readStage)] = bpCondList
		
		tmpList, bpCondList =\
			self.handleOnePairArray(readPort, rdArray_E, wdArray, wdGrpDict)
		stallCondList += tmpList
		self.bpCondDict[(readPort, readStage+1)] = bpCondList
		
		'condition stall must collect together and generate at the last'
		'condition bypass can generate at one, or collect together'
		self.stallCondList += stallCondList
		# self.printInstrGrpDict(printRd=True)
		# self.printInstrGrpDict(printRd=False)
		# stallCode = self.Gen_stallHDLCode(stallCondList, readStage, tabn)
		
	def handleOnePairArray(self, readPort, rdArray, wdArray, wdGrpDict):
		'handle one pair array'
		writePort = Gen_WdPortByRdPort(readPort)
		rGrpOrderedDict = self.rInstrGrpDict[readPort]
		wGrpOrderedDict = self.wInstrGrpDict[writePort]
		ret_stallList = []
		ret_bpList = []
		readStage = self.readPortDict[readPort]
		stageRange = self.wbStage - readStage
		for rVector in rdArray:
			rInstr = tuple(rVector[0])
			rStage = rVector[-1]
			bpDataList = self.bypassDataList[readPort][rStage]
			i_wInstrGrp = 0; i = 0
			'located at PortName subArray'
			for wdPortName,grpNum in wdGrpDict.items():
				for j in range(grpNum * stageRange):
					wVector = wdArray[j+i]
					wInstr = tuple(wVector[0])
					wStage = wVector[-1][0]
					if isStallVector(rVector, wVector):
						'if a stall, generate the Verilog Code'
						wStage -= (rVector[-1] - readStage)
						i_rInstrGrp = self.indexOfInstrOrderDict(\
									rGrpOrderedDict, rInstr)
						i_wInstrGrp = self.indexOfInstrOrderDict(\
									wGrpOrderedDict, wInstr)
						rGrpOrderedDict[rInstr].add(readStage)
						wGrpOrderedDict[wInstr].add(wStage)
						stallCond = self.Gen_stallHDLCond(i_rInstrGrp, i_wInstrGrp,\
											readPort, rVector, wVector)
						ret_stallList.append( (readStage, stallCond) )
						
					elif isBypassVector(rVector, wVector):
						'if a bypass, generate the Verilog Code'
						'And may add write data port name with stage to self.bypassDataList'
						i_rInstrGrp = self.indexOfInstrOrderDict(\
									rGrpOrderedDict, rInstr)
						i_wInstrGrp = self.indexOfInstrOrderDict(\
									wGrpOrderedDict, wInstr)
						rGrpOrderedDict[rInstr].add(rStage)
						wGrpOrderedDict[wInstr].add(wStage)
						if (wdPortName, wStage) not in bpDataList:
							bpDataIndex = len(bpDataList)
							bpDataList.append( (wdPortName, wStage) )
						else:
							bpDataIndex = bpDataList.index( (wdPortName, wStage) )
						bpCond = self.Gen_bypassHDLCond(i_rInstrGrp, i_wInstrGrp,\
								readPort, rVector, wVector)
						ret_bpList.append( (wStage, bpCond, bpDataIndex) )		
						
					else:
						'hazard not exsist'
				i += grpNum * stageRange	
		'sort the list because the priority'
		ret_stallList.sort(key=itemgetter(0))
		ret_bpList.sort(key=itemgetter(0))
		return ret_stallList, ret_bpList
		
	def Gen_stallHDLCode(self, stallCondList, tabn):
		"""
		assign stall_X = 
			(rGrp && wGrp && raddr==waddr)
		"""
		ret_HDLCode = ""
		'sort the cond list to generate the stall if we have multiple stall'
		# stallCondList.sort(key=itemgetter(0))
		stageSet = set([item[0] for item in stallCondList])
		self.stallStageSet = stageSet
		pre = '\t' * (tabn + 1)
		linkStr = ' || \n' + pre
		for stage in stageSet:
			stallName = Gen_stallName(self.stageNames[stage])
			stallConds = [item[1] for item in\
						filter(lambda item:item[0]==stage, stallCondList)]
			stallCond = '\n' + pre + linkStr.join(stallConds)
			ret_HDLCode += Gen_assignCode(stallName, stallCond, tabn)
		return ret_HDLCode
		
	def Gen_bypassMuxHDLCode(self, tabn):
		ret_wireCode = ""
		ret_utilizeCode = ""
		'generate bypassMux HDL Code'
		wireList = []
		for readPort,bypassDict in self.bypassDataList.items():
			for rStage,dataList in bypassDict.items():
				if len(dataList) > 0:
					utilizeCode = self.Gen_muxHDLCode(
						readPort, rStage, [(readPort,rStage)] + dataList, tabn, isbypass=True
					)
					'generate the wire code'
					bpPortName = Gen_muxName(readPort, self.stageNames[rStage], isbypass=True)
					bpPortWidth = self.Get_portWidthFromModuleTb(readPort)
					wireList.append((bpPortName, bpPortWidth))
					ret_utilizeCode += utilizeCode
					
		ret_wireCode += Gen_wireStatementCode(wireList, tabn)
		return ret_wireCode, ret_utilizeCode
	
	def Gen_bypassCuHDLCode(self, tabn):
		ret_inoutCode = ''
		ret_wireCode = ''
		ret_assignCode = ''
		bpCondDictItems = sorted(self.bpCondDict.items(), key=lambda item: item[0][-1])
		for (readPort, rStage),bypassCondList in bpCondDictItems:
			# print 'readPort =', readPort, 'rStage =', rStage
			inoutCode, wireCode, assignCode = self.Gen_bpCuAssignCode(
				readPort, rStage, bypassCondList, tabn
			)
			ret_inoutCode += inoutCode
			ret_wireCode += wireCode
			ret_assignCode += assignCode
		return ret_inoutCode, ret_wireCode, ret_assignCode
		
	def Gen_bpCuAssignCode(self, readPort, rStage, bypassCondList, tabn):
		pre = '\t' * (tabn + 1)
		linkStr = ' :\n' + pre
		bpSelName = Gen_selName(
			readPort, self.stageNames[rStage], isbypass=True
		)
		maxLen = max([len(item[1]) for item in bypassCondList])
		condList = ['(%*s) ? %d' % (maxLen, item[1], item[2]+1) for item in bypassCondList]
		condList.append(' '*(maxLen+2) + '   0 ')
		condExp = '\n' + pre + linkStr.join(condList)
		ret_assignCode = Gen_assignCode(bpSelName, condExp, tabn) + '\n'
		dataLength = len(self.bypassDataList[readPort][rStage])
		bpSelWidth = int (
			math.ceil(math.log(dataLength, 2))
		)
		bpSelWidth = '[%d:0]' % (bpSelWidth-1)
		ret_wireCode = Gen_wireStatementCode([(bpSelName, bpSelWidth)], tabn)
		ret_inoutCode = Gen_outputStatementCode([(bpSelName, bpSelWidth)], tabn)
		
		'add bypass select to self.cuPortDict'
		self.cuPortDict[bpSelName] = bpSelWidth
		return ret_inoutCode, ret_wireCode, ret_assignCode
		
	def Gen_muxHDLCode(self, port, i_stage, dataList, tabn, isbypass=False):
		ret = ''
		'generate the mux codes'
		stageName = self.stageNames[i_stage]
		if isbypass:
			utilizeName = Gen_muxName(port, stageName, isbypass=True)
			selName = Gen_selName(port, stageName, isbypass=True)
			yName = utilizeName
		else:
			utilizeName = Gen_muxName(port, stageName)
			selName = Gen_selName(port, stageName)
			yName = utilizeName
		muxn = 2 ** int( 
			math.ceil( math.log(len(dataList), 2) )
		)
		pre = '\t' * tabn
		modName, portName = port.split(RTL_MODTOPORT)[:2]
		portWidth = self.moduleTb[modName][portName]
		begWidth,endWidth = portWidth[1:-1].split(':')[:2]
		if ARCH_BE:
			'if we use the beg endian'
			dataWidth = '(%s)-(%s)+1' % (endWidth, begWidth)
		else:
			dataWidth = '(%s)-(%s)+1' % (begWidth, endWidth)
		# add utilize name
		muxName = '%s%d' % (HDL_MUX, muxn)
		ret += pre + '%s #(%s) U_%s_%s (' % (muxName, dataWidth, utilizeName, muxName)
		'add parameter'
		for i,(dataPort,dataStage) in enumerate(dataList):
			if (i&3) == 0:
				ret += '\n' + pre + '\t'
			if dataStage:
				stageName = self.stageNames[dataStage]
			else:
				stageName = ''
			dataPortName = Gen_portName(dataPort, stageName)
			ret += '.d%d(%s), ' % (i, dataPortName)
		i += 1
		while i < muxn:
			if (i&3) == 0:
				ret += '\n' + pre + '\t'
			ret += '.d%d(%s), ' % (i, HDL_MUXDEFAULT)
			i += 1
		# add the select 
		ret += '\n' + pre + '\t' + '.s(%s), ' % (selName)
		ret += '.y(%s)' % (yName)
		ret += '\n' + pre + ');\n\n'
		return ret
	
	def Gen_instrGrpCode(self, tabn):	
		ret_wireCode = ''
		ret_assignCode = ''
		
		'read instr group'
		wireCode, assignCode = self.Gen_grpCodeByDict(
			self.rInstrGrpDict, HDL_RGRP_PRE, tabn
		)
		ret_wireCode += wireCode; ret_assignCode += assignCode
		
		'write instr group'
		wireCode, assignCode = self.Gen_grpCodeByDict(
			self.wInstrGrpDict, HDL_WGRP_PRE, tabn
		)
		ret_wireCode += wireCode; ret_assignCode += assignCode
		
		return ret_wireCode, ret_assignCode
		
	def Gen_grpCodeByDict(self, instrGrpDict, grpType, tabn):
		ret_wireCode = ''
		ret_assignCode = ''
		
		for port,grpOrderDict in instrGrpDict.items():
			for iGrp,(instrGrp,stageSet) in enumerate(grpOrderDict.items()):
				for i_stage in stageSet:
					grpName = Gen_instrGrpName(
						Gen_portName(port, self.stageNames[i_stage]),
						grpType, iGrp
					)
					ret_wireCode += Gen_wireStatementCode(
						[(grpName, None)], tabn
					)
					ret_assignCode += self.Gen_instrGrpAssignCode(
						instrGrp, grpName, i_stage, tabn
					)
					
		return ret_wireCode, ret_assignCode
		
	def Gen_instrGrpAssignCode(self, instrGrp, grpName, i_stage, tabn):
		condList = self.Gen_instrCond(instrGrp, i_stage)
		pre = '\t' * (tabn + 1)
		linkStr = ' || \n' + pre
		condExp = '\n' + pre + linkStr.join(condList)
		condExp = '~%s && (%s\n%s)' % (
			Gen_flushName(self.stageNames[i_stage]),
			condExp, '\t'*tabn
		)
		ret = Gen_assignCode(grpName, condExp, tabn) + '\n'
		return ret
		
	def Gen_instrCond(self, instrGrp, i_stage):
		condList = []
		INSTR_ofStage = Gen_INSTROfStage(self.stageNames[i_stage])
		for instrName in instrGrp:
			cond = '%s[`%s] == %5s_%s' % (INSTR_ofStage, HDL_OPCD, '`'+instrName.upper(), HDL_OPCD)
			if instrName not in self.instrNGrp:
				field = SPECIAL_RULE[self.Get_specialInstrOp(instrName)]
				cond += ' && %s[`%s] == %5s_%s' % (INSTR_ofStage, field, '`'+instrName.upper(), field)
			condList.append('(%s)' % (cond))
		return condList
		
	def Gen_stallHDLCond(self, i_rGrp, i_wGrp, readPort, rVector, wVector):
		"""
		assign stall_X = 
			(rGrp && wGrp && raddr==waddr)
		"""
		print 'in Gen_stallHDLCond'
		print 'rVector =',rVector, 'wVector =', wVector
		readStage = self.readPortDict[readPort]
		raddr, rStage = rVector[-2:]
		waddr, (wStage,valid) = wVector[-2:]
		'stall only occurs at rInstr@D, so we subf wStage'
		wStage -= (rStage-readStage)
		rStageName = self.stageNames[readStage]
		wStageName = self.stageNames[wStage]
		readPortName = Gen_portName(readPort, self.stageNames[readStage])
		ret_stallAssignCond = "(%s && %s && %s==%s)" % (
			Gen_instrGrpName(readPortName, HDL_RGRP_PRE, i_rGrp),
			Gen_instrGrpName(readPortName, HDL_WGRP_PRE, i_wGrp),
			Gen_portName(raddr, rStageName),
			Gen_portName(waddr, wStageName),
		)
		return ret_stallAssignCond
		
	def Gen_bypassHDLCond(self, i_rGrp, i_wGrp, readPort, rVector, wVector):
		"""
		assign bypass_X_Bp = 
			(rGrp && wGrp && raddr==waddr) ? bpDataIndex:
		"""
		raddr, rStage = rVector[-2:]
		waddr, (wStage, valid) = wVector[-2:]
		readStage = self.readPortDict[readPort]
		readPortName = Gen_portName(readPort, self.stageNames[readStage])
		writePortName = Gen_portName(
			Gen_WdPortByRdPort(readPort),
			self.stageNames[wStage]
		)
		ret_bpAssignCond = "%s && %s && %s==%s" % (
			Gen_instrGrpName(readPortName, HDL_RGRP_PRE, i_rGrp),
			Gen_instrGrpName(writePortName, HDL_WGRP_PRE, i_wGrp),
			Gen_portName(raddr, self.stageNames[rStage]),
			Gen_portName(waddr, self.stageNames[wStage]),
		)
		return ret_bpAssignCond
	
	def Gen_hanzardCode(self, rdArray, readStage, readPort, wdArray):
		ret_wireCode = ''
		ret_regCode = ''
		ret_wireCode = ''
		ret_wireCode = ''
		
	def createRdArray(self, readPort):
		"""
		we use the method to handle hazard from beginning
		only two stages may bypass:
			(1) the stage to read data, named by D
				indeed only for branch
			(2) the next stage just after read data, named by E
				meet stall we must stall from read Stage(D)
		"""
		'create readPort Array'
		"""
					i_stage		raddr
		instrGrp0
		...
		instrGrpN
		"""
		readStage = self.readPortDict[readPort]
		rowVector_D = self.createItemOfRdArray(\
						readPort, readStage, fromPipe=False)
		rowVector_E = self.createItemOfRdArray(\
						readPort, readStage, fromPipe=True)
		return rowVector_D,rowVector_E
	
	def createItemOfRdArray(self, readPort, readStage, fromPipe=False):
		'Get_instrGrpFrom is a function'
		if fromPipe:
			'means get instr from pipe'
			instrGrp = self.Get_instrGrpFromPipe(readPort, readStage)
			'readStage actually is E'
			itemStage = readStage + 1
		else:
			instrGrp = self.Get_instrGrpFromConnect(readPort, readStage)
			itemStage = readStage
		print 'stage =', self.stageNames[readStage], 'readPort =', readPort, 'instrGrp =', instrGrp
		conSubTree = self.connectTree[readStage]
		addr = Gen_PortAddrByPortName(readPort)
		ret_itemList = []
		if addr not in conSubTree:
			'means not need raddr, like CR.CR'
			ret_itemList.append([instrGrp, None, readStage])
		else:
			instrSet= set(instrGrp)
			for srcName,instrSubGrp in conSubTree[addr].items():
				interSet = instrSet & set(instrSubGrp)
				if len(interSet) > 0:
					ret_itemList.append([\
						interSet & set(instrSubGrp), srcName, itemStage
					])
		return ret_itemList
		
	def createItemOfWdArray(self, writePort, writeDataPort, Get_instrGrpFrom):
		'Get_instrGrpFrom is a function'
		writeStage = self.wbStage
		writeDict = self.connectTree[writeStage][writePort]
		instrGrp = Get_instrGrpFrom(writeDataPort, writeStage)
		# print 'stage =', self.stageNames[writeStage], 'port =', writeDataPort, 'instrGrp =', instrGrp
		conSubTree = self.connectTree[writeStage]
		addr = Gen_PortAddrByPortName(writePort, isWaddr=True)
		ret_itemList = []
		if addr not in conSubTree:
			'means not need raddr, like CR.CR'
			ret_itemList.append([instrGrp, None, writeStage])
		else:
			instrSet= set(instrGrp)
			for srcName,instrSubGrp in conSubTree[addr].items():
				# print 'addr =', addr, 'instrSubGrp =', instrSubGrp
				interSet = instrSet & set(instrSubGrp)
				if len(interSet) > 0:
					ret_itemList.append([
						interSet, srcName, writeStage
					])
		return ret_itemList
	
	def createWdArray(self, readPort):
		'create writePort Array'
		"""
					  instrGrp0  instrGrpN
					   E  M  W	  E  M  W
		i_stage,ena   
		waddr
		"""
		readStage = self.readPortDict[readPort]
		writeStage = self.wbStage
		writePort = Gen_WdPortByRdPort(readPort)
		conSubTree = self.connectTree[writeStage]
		writeDict = conSubTree[writePort]
		'writeDataDict key:writeData, value: num of group'
		wdGrpDict = dict()
		ret_itemList = []
		for wdPortName in writeDict:
			rowVector_W = self.createItemOfWdArray(\
							writePort, wdPortName, self.Get_instrGrpFromConnect)
			print 'rowVector_W =', rowVector_W
			for i_stage in range(readStage+1, writeStage):
				'if want to update the send rule, we can change here'
				'default rule is all data can be sent after a pipe'
				if wdPortName in self.pipeTree[i_stage-1]:
					'means i+1 stage has valid output Wd Data Port Name'
					ret_itemList += [vector[:2]+[(i_stage,1)] for vector in rowVector_W]
				else:
					ret_itemList += [vector[:2]+[(i_stage,0)] for vector in rowVector_W]
			'when we want to optimize the wb write data after mux bypass, we can update here'
			ret_itemList += [vector[:2]+[(writeStage,1)] for vector in rowVector_W]
			wdGrpDict[wdPortName] = len(rowVector_W)
		return ret_itemList, wdGrpDict
		
	def Get_instrGrpFromConnect(self, srcPort, i_stage):
		'Use srcPort Get instr group from Connect at i_stage'
		ret_instrGrp = []
		for srcPortDict in self.connectTree[i_stage].values():
			# print srcPortDict
			ret_instrGrp += srcPortDict.get(srcPort, [])
		return ret_instrGrp
	
	def Get_instrGrpFromPipe(self, srcPort, i_stage):
		'Use srcPort Get instr group from Pipe at i_stage'
		return self.pipeTree[i_stage].get(srcPort, [])
		
	def createRtlTree(self):
		'create a RTL Tree'
		self.connectTree = dict( [(i_stage, defaultdict(dict_listAsValue))\
									for i_stage in range(self.stageNum)] )
		self.pipeTree = defaultdict(dict_listAsValue)							
		for i in range(len(self.instrBoundry)-1):
			instrName, s_row = self.instrBoundry[i]
			t_row = self.instrBoundry[i+1][-1]
			rtlOfOneInstr = self.Get_rtlOfOneInstr(s_row, t_row)
			self.insertRtlToTree(instrName, rtlOfOneInstr)
	
	def insertRtlToTree(self, instrName, rtlOfOneInstr):
		'insert rtl of one instr into tree'
		for i_stage,rtlList in enumerate(rtlOfOneInstr):
			self.insertRtlToStage(instrName, i_stage, rtlList)
	
	def insertRtlToStage(self, instrName, i_stage, rtlList):
		'insert Rtl to One stage'
		conSubTree = self.connectTree[i_stage]
		pipeSubTree = self.pipeTree[i_stage]
		for rtl in rtlList:
			if RTL_CONNECT in rtl:
				srcName, desName = rtl.split('->')[:2]
				if not isSameModule(srcName, desName):
					if desName not in conSubTree:
						conSubTree[desName] = defaultdict(list)
					conSubTree[desName][srcName].append(instrName)
			elif RTL_PIPE in rtl:
				srcName = rtl[:-len(RTL_PIPE)]
				pipeSubTree[srcName].append(instrName)
				
	def Get_rtlOfOneInstr(self, s_row, t_row):
		ret = []
		for i_col in range(self.begCol+1, self.endCol):
			rtls = self.delSpace(self.AE.Get_OneCol(i_col, s_row, t_row))
			ret.append( filter(lambda x: len(x)>0, rtls ) )
		return ret
	
	def Get_portWidthFromModuleTb(self, rawPortName):
		if RTL_MODTOPORT not in rawPortName:
			return HDL_INSTR_WIDTH if rawPortName == HDL_INSTR else '[xxxx:0]'
		modName,portName = rawPortName.split(RTL_MODTOPORT)[:2]
		return self.moduleTb[modName][portName]
	
	def createModuleTb_fromAllFiles(self):
		'create Module Table from All Files'
		self.moduleTb = defaultdict(dict)
		fileList = os.listdir(self.workPath)
		for fname in filter(lambda name: name.endswith(DOTV) and\
									not name.endswith(HDL_DEFFILE), fileList):
			'fname must end like .v and not _def.v'
			self.createModuleTb_fromOneFile(self.workPath+fname)
		
	def createModuleTb_fromOneFile(self, fname):
		'fname is absolute path'
		fin = open(fname, "r")
		modNotFound = True
		endNotFound = True
		for line in fin:
			if self.re_endmodule.match(line):
				modNotFound = True
				self.moduleTb[moduleName] = dict(zip(modPorts, modWidth))
				continue
			if modNotFound:
				mgroup = self.re_moduleName.match(line)
				if mgroup:
					modNotFound = False
					moduleName = mgroup.group('name')
					modPorts = []
					modWidth = []
			else:
				mgroup = self.re_portWidth.match(line)
				if mgroup:
					direct = mgroup.group('direct')
					width = mgroup.group('width')
					width = width if width else HDL_WIDTHONE
					'find all ports, they share same width'
					subline = line[mgroup.end():]
					ports = self.re_portName.findall(subline)
					'strip the space and ,|;'
					modPorts += [port[:-1].strip() for port in ports]
					modWidth += [width] * len(ports)
		fin.close()
	
	def Get_instrBoundry(self, c_index):
		'Get instr Boundry, for reading rtl by instr'
		f_row = self.begRow + 1
		t_row = self.AE.Get_NRow()
		self.instrBoundry = []
		for r_index in range(f_row, t_row):
			instr = self.AE.Get_OneCell(r_index, c_index)
			if instr:
				instrName = instr[:-1]+'_' if instr[-1]=='.' else instr
				self.instrBoundry.append((instrName, r_index))
		'Add the end boundry'
		self.instrBoundry.append(("None", t_row))
	
	def Check_instrInRtl(self):
		'check if some instr has not implemented'
		instrInRtl = self.instrNGrp
		instrSpecial = reduce(lambda x,y: x.values()+y.values(),\
						self.instrSGrp)
		for item in instrSpecial:
			instrInRtl += item
		instrInHDL = self.xoTb.keys()
		# print 'instrInHDL =', instrInHDL
		# print 'instrInRtl =', instrInRtl
		instrNotHave = set(instrInHDL) ^ set(instrInRtl)	
		# print instrNotHave
		self.ErrRobot.addErr(self.ErrRobot.INVALID_INSTR, str(instrNotHave))
	
	def Gen_instrGoups(self, opDict):
		'classify some special insn into groups'
		self.instrNGrp = []
		self.instrSGrp = []
		for key,instrLst in opDict.items():
			if len(instrLst) > 1:
				self.instrSGrp.append({key:instrLst})
			else:
				self.instrNGrp.append(instrLst[0])
				
	def Get_OpAndXoFromOneFile(self, fname):
		'read instruction_def.v and get OP and XO'
		fin = open(fname, "r")
		re_instrDef = re.compile(r'[\S]+')
		self.xoTb = {}
		self.opTb = {}
		ret_opDict = defaultdict(list)
		lenOfDefine = len(DEFINE)
		lenOfOp = len(HDL_OPCD)
		lenOfXo = len(HDL_XO)
		for line in fin:
			if line.startswith(DEFINE):
				defName, defVal = re_instrDef.findall(line)[1:3]
				if defName.endswith(HDL_OPCD):
					self.opTb[defName[:-lenOfOp-1]] = defVal
					ret_opDict[defVal].append(defName[:-lenOfOp-1])
				elif  defName.endswith(HDL_XO):
					self.xoTb[defName[:-lenOfXo-1]] = defVal
		fin.close()
		return ret_opDict
	
	def Set_readPort(self, readPortWithStage):
		'readPortWithStage must be dict or will raise an error'
		'dict can instance by [()...]'
		if isinstance(readPortWithStage, dict):
			self.readPortDict = readPortWithStage
		elif isinstance(readPortWithStage, list):
			self.readPortDict = dict(readPortWithStage)
		else:
			raise TypeError("Set_readPort parameter should be dict()")
	
	def Set_pipeLineStage(self, wbStage):
		'set the num & name of stage'
		self.stageNames = self.AE.Get_OneRow(self.begRow,\
							self.begCol+1, self.endCol)
		self.stageNum = len(self.stageNames)
		if isinstance(wbStage, int):
			self.wbStage = wbStage
		else:
			self.wbStage = self.stageNames.index(wbStage)
		
	def indexOfInstrOrderDict(self, instrDict, instrGrp):
		if instrGrp in instrDict.keys():
			ret_index = instrDict.keys().index(instrGrp)
		else:
			ret_index = len(instrDict.keys())
			instrDict[instrGrp] = set()
		return ret_index
	
	def Get_specialInstrOp(self, instrName):
		instrName = instrName.upper()
		for sInstrDict in self.instrNGrp:
			for specialOp,instrList in sInstrDict.items():
				if instrName in instrList:
					return specialOp
		return None
	
	def isBypassPort(self, rawPortName, i_stage):
		for readPort,bypassDict in self.bypassDataList.items():
			for rStage in bypassDict:
				if readPort==rawPortName and rStage==i_stage:
					return True
		return False
		
	def isOutputPort(self, portName):
		return portName in self.outputPortSet
		# for connectDict in self.connectTree.values():
			# for srcPortDict in connectDict.values():
				# if portName in srcPortDict.keys():
					# return True
		# return False
		
	def delSpace(self, strLine):
		if isinstance(strLine, str) or isinstance(strLine, unicode):
			return self.re_delSpace.sub('', strLine)
		elif isinstance(strLine, list):
			return [self.delSpace(item) for item in strLine]
		else:
			return strLine
	
	def Gen_includeCode(self):
		'generate the inclue code'
		fileList = os.listdir(self.workPath)
		defList = []
		for fname in fileList:
			if fname.endswith(HDL_DEFFILE):
				defList.append(fname)
		self.includeCode = Gen_includeCode(defList) + '\n'
	
	def printBypassDataDict(self):
		print 'print Bypass Data Dict'
		for readPort,bypassDict in self.bypassDataList.items():
			print 'readPort =', readPort
			for rStage,dataList in bypassDict.items():
				print self.stageNames[rStage], '=>', dataList
				
	def printInstrGrpDict(self, printRd=True):
		if printRd:
			print '\nread Instr Group'
			instrpGrpDict = self.rInstrGrpDict
		else:
			print '\nwrite Instr Group'
			instrpGrpDict = self.wInstrGrpDict
		for port,grpOrderDict in instrpGrpDict.items():
			print 'port =', port
			for instrGrp,stageSet in grpOrderDict.items():
				print instrGrp, "=>", stageSet
			print
	
	def printSpecialInstr(self):
		print '\nprint Special Instr'
		for sInstrDict in self.instrSGrp:
			for specialOp,instrList in sInstrDict.items():
				print specialOp, '=>', instrList
			print
	
	def printConnectTree(self):
		print '\n    Print Connect Tree    '
		for i_stage,connectDict in self.connectTree.items():
			print 'stage:', self.stageNames[i_stage]
			for desName,srcDict in connectDict.items():
				print 'desName: ', desName
				for srcName,instrList in srcDict.items():
					print srcName,'=>',instrList
				print
			print '\n'
		
	def printPipeTree(self):
		print '\n    Print Pipe Tree    '
		for i_stage,srcDict in self.pipeTree.items():
			print 'stage:', self.stageNames[i_stage]
			for srcName,instrList in srcDict.items():
				print srcName,'=>',instrList
			print
			
	def printRdArray(self, rdArray, i_stage):
		print '\nRead Array Of', self.stageNames[i_stage]
		for i,vector in enumerate(rdArray):
			print i, ':', vector
		print '\n'
			
	def printWdArray(self, readPort, wdArray, wdGrpDict):
		print '\nwrite Array Of', readPort
		readStage = self.readPortDict[readPort]
		writeStage = self.wbStage
		writePort = Gen_WdPortByRdPort(readPort)
		wdDict = self.connectTree[writeStage][writePort]
		i = 0
		for wdPortName,instrGrp in wdDict.items():
			print 'wdata:', wdPortName, 'instr:', instrGrp
			for i_stage in range(readStage, writeStage):
				j = i + wdGrpDict[wdPortName]
				print 'vector:', wdArray[i]
				for k in range(i+1, j):
					print '       ', wdArray[k]
				i = j
			print 
		print '\n'
		
	def printModuleTb(self):
		for modName in self.moduleTb:
			print "%s {" % (modName)
			for portName, portWidth in self.moduleTb[modName].items():
				print "\t%s => %s" % (portName, portWidth)
			print "}\n"
		print '\n'
		
	def printError(self):
		print 'error'
		self.ErrRobot.printErr()
	
if __name__ == "__main__":
	workPath = ".\\"
	excelPath = ".\\mips_pipeline.xls"
	rtlSheetName = "RTL"
	instrdef_fname = "instruction_def.v"
	readPortWithStage = [('GPR.rd1', 1), ('GPR.rd2', 1)]
	APP = Auto_PPC_Pipeline(workPath, excelPath,\
			rtlSheetName, instrdef_fname, readPortWithStage)
	APP.autoGen()
	APP.Gen_dpUtilizeCode()
	APP.printError()
	APP.printBypassDataDict()
	# APP.printSpecialInstr()
	# APP.printConnectTree()
	APP.printPipeTree()
	APP.printModuleTb()