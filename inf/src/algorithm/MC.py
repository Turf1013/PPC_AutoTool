# -*- coding: utf-8 -*-
from ..glob.glob import CFG

class constForMC:
	INSTR = "Instr"
	INSTR_WIDTH = CFG.INSTR_WIDTH
	MDU_CYCLE = 8
	MDU_NAME = "MDU"
	MDU_INSN = "mcInsn"
	RADDR = "raddr"
	WADDR = "waddr"
	MDU_REG = "GPR"
	
class CFMC(constForMC):
	pass
	
	
class MC(object):
	""" MC includes the mechanism for Multi-Cycle instructions
	
	Function includes:
	1. 
	"""
	
	def __init__(self, excelRtl, pipeLine, modMap, insnMap):
		self.excelRtl = excelRtl
		self.pipeLine = pipeLine
		self.modMap = modMap
		self.insnMap = insnMap
		self.Nmc = self.__findNmc()
		self.Pmc = self.__findPmc()
		self.mcInsnNameList = self.__findMCI(self.Pmc)
	
	
	def __findNmc():
		return CFMC.MDU_CYCLE
			
			
			
	def __findPmc():
		linkRtl = self.excelRtl.linkRtl
		stgn = self.pipeLine.stgn
		for insnName,insnRtlList in linkRtl.iteritems():
			for istg in xrange(stgn):
				rtlList = insnRtlList[istg]
				for rtl in rtlList:
					if CFMC.MDU_NAME in rtl.des:
						return istg
		return -1
			
		
	def __findMCI(self, Pmc):
		"""
		Here, MCI indicates multiply and divide instructions.
		Therefore, any instructions using MDU belongs to MCI.
		"""
		linkRtl = self.excelRtl.linkRtl
		istg = Pmc
		ret = []
		for insnName,insnRtlList in linkRtl.iteritems():
			rtlList = insnRtlList[istg]
			for rtl in rtlList:
				if CFMC.MDU_NAME in rtl.des:
					ret.append(insnName)
					break
		return ret
		
	
	def HandleRelevant(self):
		isMorD_cond = self.isMulOrDiv()
		desInSrc_cond = self.desInSrc()
		desInDes_cond = self.desInDes()
		return [isMorD_cond, desInSrc_cond, desInDes_cond]
		
		
	def GenStallCond(self):	
		relevCondList = self.HandleRelevant()
		sigName = "stall_mc"
		ret = []
		
		line = "// logic of stall in MC\n"
		ret.append(line)
		
		# reg statement
		wireLine = "reg %s;\n" % (sigName)
		ret.append(wireLine)
		
		# always block
		line = "always @( * ) begin\n"
		ret.append(line)
		
		'1. isMulorDiv'
		cond = relevCondList[0]
		if not cond:
			cond = "0"
		line = "\tif ( %s ) begin\n"
		ret.append(line)
		line = "\t\t%s = 1'b1;\n" % (sigName)
		ret.append(line)
		line = "\tend\n"
		ret.append(line)
		
		inSrcDict = relevCondList[1]
		inDesDict = relevCondList[1]
		insnNameSet = set(inSrcDict.keys()) | set(inDesDict.keys())
		for insnName in insnNameSet:
			line = "\telse if ( % s) begin\n" % (insnCond)
			ret.append(line)
			
			# add src & des condiiton
			condList = []
			if insnName in inSrcDict:
				condList += inSrcDict[insnName]
			if insnName in inDesDict:
				condList += inDesDict[insnName]
			line = "\t\t%s = %s;\n"
					%(sigName, " || ".join(condList))
			ret.append(line)
			
			line = "\tend\n" 
			ret.append(line)
		
		# add else lines
		line = "\telse begin\n"
		ret.append(line)
		line = "\t\t%s = 1'b0;" % (sigName)
		ret.append(line)
		line = "\tend\n"
		ret.append(line)
		
		line = "end // end always \n"
		ret.append(line)
		
	
	def HandleStructHazard(self):
		self.HandleStructHazard_inPipe()
		self.HandleStructHazard_inMDU()
		
	
	def HandleStructHazard_inPipe(self):
		
		
	def HandleStructHazard_inMDU(self):
		
	
		
	def isMulOrDiv(self, suf):
		condList = []
		for mcInsnName in self.mcInsnNameList:
			insn = self.insnMap.find(mcInsnName)
			cond = insn.condition(suf)
			condList.append(cond)
		return " || ".join(condList)
		
		
	def GenMcInsnBit(self, insn=CFMC.MDU_INSN):
		ret = []
		
		wireLine = "wire " + ", ".join(
				map(lambda x:CFMC.MDU_INSN + "_" + x, self.mcInsnNameList)
			) + ";"
		ret.append(wireLine)
		
		for insnName in mcInsnNameList:
			insn = self.insnMap.find(insnName)
			assignLine = "assign %s_%s = ;"
						%(CFMC.MDU_Insn, insnName, insn.condition())
			ret.append(assignLine)
		
		return ret
	
	
	def __genWaddr(self, regName):
		return self.__genAddr(regName, CFMC.WADDR)
		
		
	def __genRaddr(self, regName):
		return self.__genAddr(regName, CFMC.RADDR)
	
	
	def __genAddr(self, regName, addrName):
		return regName + "." + addrName
	
	
	def findDesAddr(insnName, regName="GPR"):
		# some register may have multiple writer ports
		# so using a list as return val would be fine.
		ret = set()
		regWaddr = self.__genWAddr(regName)
		if insnName in linkRtl:
			insnRtlList = linkRtl[insnName]
			rstg = self.pipeLine.Rstg.id
			rtlList = insnRtlList[rstg]
			for rtl in rtlList:
				if regWaddr in rtl.des:
					ret.add(regWaddr)
		return list(ret)
		
		
	def __genDesAddrExp(self, desAddrExp):
		return self.__genAddrExp(CFMC.MDU_INSN, desAddrExp):
		
		
	def __genAddrExpAtRstg(self, addrExp):
		rstgName = self.pipeLine.Rstg.name
		instrName = CFMC.INSTR + "_" + rstgName
		return self.__genAddrExp(instrName, addrExp)
	
	
	def __genAddrExpAtWstg(self, addrExp):
		wstgName = self.pipeLine.Wstg.name
		instrName = CFMC.INSTR + "_" + wstgName
		return self.__genAddrExp(instrName, addrExp)
		
		
	def __genAddrExp(self, repInstr, addrExp):
		return repInstr.join(addrExp.split(CFMC.INSTR))
		
		
	def desInSrc(self):
		retDict = dict()
		regName = CFMC.MDU_REG
		for insnName in self.mcInsnNameList:
			bitName = "%s_%s" % (CFMC.MDU_INSN, insnName)
			desAddrExp = self.findDesAddr(insnName, regName)
			desAddrCond = self.__genDesAddrExp(desAddr)
			condDict = self.findSrcAddrExp(regName)
			condList = []
			for insnCond, srcAddrExp in condDict:
				srcAddrCond = self.__genAddrExpAtRstg(srcAddrExp)
				cond = "(%s && %s==%s)" % (insnCond, srcAddrCond, desAddrCond)
				condList.append(cond)
			retDict[insnName] = condList
		return retDcit
		
		
	def findSrcAddrExp(self, regName):
		"""
			`findSrcAddrExp`
			1. Return a dict, using insnName as key and expression of the srcPorts for the 
				insnName as a value
		"""
		retDict = dict()
		rstg = self.pipeLine.Rstg.id
		regRaddr = self.__genRaddr(regName)
		for insnName, insnRtlList in linkRtl.iteritems():
			rtlList = insnRtlList[rstg]
			condSet = set()
			for rtl in rtlList:
				if regRaddr in rtl.des:
					condSet.add(rtl.src)
			retDict[insnName] = list(condSet)
		return retDict
		
	
	def findDesAddrExp(self, regName):
		retDcit = dict()
		rstg = self.pipeLine.Rstg.id
		wstg = self.pipeLine.Wstg.id
		regWaddr = self.__genWaddr(regName)
		for insnName, insnRtlList in linkRtl.iteritems():
			rtlList = insnRtlList[wstg]
			condSet = set()
			for rtl in rtlList:
				if regWaddr in rtl.des:
					condSet.add(rtl.src)
			retDict[insnName] = list(condSet)
		return retDict
		
		

	def desInDes(self):
		"""
			`desInDes`
			1. Return a dict, using insnName as key and expression of the desPort for the
				insnName as a value
		"""
		retDict = dict()
		regName = CFMC.MDU_REG
		for insnName in self.mcInsnNameList:
			bitName = "%s_%s" % (CFMC.MDU_INSN, insnName)
			desAddrExp = self.findDesAddr(insnName, regName)
			desAddrCond_mc = self.__genDesAddrExp(desAddr)
			condDict = self.findDesAddrExp(regName)
			condList = []
			for insnCond, desAddrExp in condDict:
				desAddrCond = self.__genAddrExpAtRstg(desAddrExp)
				cond = "(%s && %s==%s)" % (insnCond, desAddrCond, desAddrCond_mc)
				condList.append(cond)
			retDict[insnName] = condList
		return retDcit

		
	def __repr__(self):
		ret = ""
		ret += "********************\n"
		ret += CFMC.MDU_NAME + "\n"
		ret += CFMC.MDU_INSN + ":\n"
		for i,insnName in enumerate(self.mcInsnNameList):
			if i>0 and i%5==0:
				ret += "\n"
				ret += insnName + "\t"
		ret += "\n"
		PmcName = self.pipeLine.StgNameAt(self.Pmc)
		ret += "Pmc = %s, Nmc = %s\n" % (PmcName, self.Nmc)
		ret += "********************\n"
		return ret
		
	__str__ == __repr__
	