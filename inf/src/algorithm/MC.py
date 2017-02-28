# -*- coding: utf-8 -*-
from ..glob.glob import CFG

class constForMC:
	INSTR = "Instr"
	INSTR_WIDTH = CFG.INSTR_WIDTH
	MDU_CYCLE = 8
	MDU_NAME = "MDU"
	MDU_INSN = "mcInsn"
	MDU_CNT = "MDU_Cnt"
	PIPE_CNT = "Pipe_Cnt"
	RADDR = "raddr"
	WADDR = "waddr"
	MDU_REG = "GPR"
	STALL_PIPE = "stall_structPipe"
	STALL_MDU = "stall_structMdu"
	STALL_RELEV = "stall_Relev"
	STALL_MC = "stall_mc"
	
class CFMC(constForMC):
	pass
	
	
class MC(object):
	""" MC includes the mechanism for Multi-Cycle instructions
	
	Function includes:
	1. HandleRelevant: relevant condition of all THREE situations
	2. GenStallRelevant: generate verilog of stall-relevant
		2.1 isMulOrDiv
		2.2 desInSrc
		2.3 desInDes
	3. HandleStructHazard: generate verilog of structural hazard
		3.1 HandleStructHazard_inPipe
		3.2 HandleStructHazard_inMDU
	4. toVerilog: generate whole verilog for calculate MCI
	"""
	
	def __init__(self, excelRtl, pipeLine, modMap, insnMap):
		self.excelRtl = excelRtl
		self.pipeLine = pipeLine
		self.modMap = modMap
		self.insnMap = insnMap
		self.Nmc = self.__findNmc()
		self.Pmc = self.__findPmc()
		self.mcInsnNameList = self.__findMCI(self.Pmc)
		print self.__str__()
	
	def __findNmc(self):
		return CFMC.MDU_CYCLE
			
			
			
	def __findPmc(self):
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
			# print insnName, rtlList
			for rtl in rtlList:
				if CFMC.MDU_NAME in rtl.des:
					ret.append(insnName)
					break
		return ret
		
		
	def __genMcInsnBits(self):
		bitNameList = []
		for insnName in self.mcInsnNameList:
			bitName = CFMC.MDU_INSN + "_" + insnName
			bitNameList.append(bitName)
		return " || ".join(bitNameList)
		
		
	def __genMcInsnBitName(self):
		return CFMC.MDU_INSN + "_bit"
		
		
	def __genMcInsnFF(self):
		ret = []
		
		# add statement 
		bitName = self.__genMcInsnBitName()
		regLine = "reg %s;\n" % (bitName)
		ret.append(regLine)
		
		# add always block
		line = "always @(posedge clk or negedge rst_n) begin\n"
		ret.append(line)
		
		# add logic
		line = "\tif (~rst_n) begin\n"
		ret.append(line)
		line = "\t\t%s <= 1'b0;\n" % (bitName)
		ret.append(line)
		line = "\tend\n"
		ret.append(line)
		
		# add else if logic
		line = "\telse if (%s) begin\n" % (bitName)
		ret.append(line)
		line = "\t\t%s <= (%s!=0);\n" % (bitName, CFMC.MDU_CNT)
		ret.append(line)
		line = "\tend\n"
		ret.append(line)
		
		# add else logic
		line = "\telse begin\n"
		ret.append(line)
		line = "\t\t%s <= %s;\n" % (bitName, self.__genMcInsnBits())
		ret.append(line)
		line = "\tend\n"
		ret.append(line)
		
		line = "end // end always\n"
		ret.append(line)
		return ret
		
	
	def HandleRelevant(self):
		rstgName = self.pipeLine.Rstg.name
		isMorD_cond = self.isMulOrDiv(rstgName)
		desInSrc_cond = self.desInSrc()
		desInDes_cond = self.desInDes()
		return [isMorD_cond, desInSrc_cond, desInDes_cond]
		
		
	@staticmethod	
	def calcEncodeLen(x):
		"""
			2^n >= x
		"""
		n = 0
		while 2**n >= x:
			return n
			n += 1
		return -1
		
		
	def GenStallRelevant(self):	
		relevCondList = self.HandleRelevant()
		sigName = CFMC.STALL_RELEV
		ret = []
		
		line = "// logic of stall-relevant in MC\n"
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
			line = "\t\t%s = %s;\n" % (sigName, " || ".join(condList))
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
		return ret
	
	
	def HandleStructHazard(self):
		ret = []
		
		lines = self.HandleStructHazard_inPipe()
		ret += lines
		
		lines = self.HandleStructHazard_inMDU()
		ret += lines
		
		return ret
	
	
	def HandleStructHazard_inPipe(self):
		ret = []
		
		# statement - stall
		wireLine = "wire %s;\n" % (CFMC.STALL_PIPE)
		ret.append(wireLine)
		
		# statement - cnt
		desCnt = 0
		pipeCnt = self.Nmc - 1
		width = calcEncodeLen(pipeCnt)
		regLine = "reg [%d:0] %s;\n" % (width-1, CFMC.PIPE_CNT)
		ret.append(regLine)
		
		# add always block
		line = "always @(posedge clk or negedge rst_n) begin\n"
		ret.append(line)
		
		## add if block
		line = "\tif (~rst_n) begin\n"
		ret.append(line)
		line = "\t\t%s <= %d;\n" % (CFMC.PIPE_CNT, desCnt)
		line = "\tend\n"
		ret.append(line)
		
		## add else if block
		line = "\telse if (%s != %d) begin\n" % (CFMC.PIPE_CNT, desCnt)
		ret.append(line)
		line = "\t\t%s <= %s - 1;\n" % (CFMC.PIPE_CNT, CFMC.PIPE_CNT) 
		ret.append(line)
		line = "\tend\n"
		ret.append(line)
		
		## add else if block
		line = "\telse if (%s) begin\n" % (self.__genMcInsnBits())
		ret.append(line)
		line = "\t\%s <= %d;\n" % (CFMC.PIPE_CNT, pipeCnt-1)
		ret.append(line)
		line = "\tend\n"
		ret.append(line)
		
		## add else block
		line = "\telse begin\n" 
		ret.append(line)
		line = "\t\t%s <= %s;\n" % (CFMC.PIPE_CNT, CFMC.PIPE_CNT)
		ret.append(line)
		line = "\tend\n"
		ret.append(line)
		
		# add end always
		line = "end // end always\n"
		ret.append(line)
		
		# add stall logic
		line = "assign %s = (%s != %d);\n" % (CFMC.STALL_PIPE, CFMC.PIPE_CNT, desCnt)
		ret.append(line)
		
		return ret
		
		
	def HandleStructHazard_inMDU(self):
		ret = []
		
		# statement - stall
		wireLine = "wire %s;\n" % (CFMC.STALL_MDU)
		ret.append(wireLine)
		
		# assign logic
		A = self.Pmc - self.pipeLine.Rstg.id - 1
		line = "assign %s = %s > %d;\n" % (CFMC.STALL_MDU, CFMC.MDU_CNT, A)
		ret.append(line)
		
		return ret
	
		
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
			assignLine = "assign %s_%s = ;" %(
							CFMC.MDU_Insn, insnName, insn.condition()
						)
			ret.append(assignLine)
		
		return ret
	
	
	def __genWaddr(self, regName):
		return self.__genAddr(regName, CFMC.WADDR)
		
		
	def __genRaddr(self, regName):
		return self.__genAddr(regName, CFMC.RADDR)
	
	
	def __genAddr(self, regName, addrName):
		return regName + "." + addrName
	
	
	def findDesAddr(self, insnName, regName="GPR"):
		# some register may have multiple writer ports
		# so using a list as return val would be fine.
		ret = set()
		regWaddr = self.__genWaddr(regName)
		linkRtl = self.excelRtl.linkRtl
		if insnName in linkRtl:
			insnRtlList = linkRtl[insnName]
			rstg = self.pipeLine.Rstg.id
			rtlList = insnRtlList[rstg]
			for rtl in rtlList:
				if regWaddr in rtl.des:
					ret.add(regWaddr)
		return list(ret)
		
		
	def __genDesAddrExp(self, desAddrExp):
		return self.__genAddrExp(CFMC.MDU_INSN, desAddrExp)
		
		
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
			print desAddrExp
			desAddrCond = self.__genDesAddrExp(desAddrExp)
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
		
	__str__ = __repr__
	
	
	def toVerilog(self, tabn=1):
		ret = ""
		prefix = "\t" * tabn
		
		ret += prefix + "// stall of relevant\n"
		stall_relev = map(lambda x: prefix+x, self.GenStallRelevant())
		ret += "".join(stall_relev) + "\n\n"
		
		ret += prefix + "// stall of structural hazard\n"
		stall_struct = map(lambda x: prefix+x, self.HandleStructHazard())
		ret += "".join(stall_struct) + "\n\n"
		
		wireLine = prefix + "wire %s;\n" % (CFMC.STALL_MC)
		ret += wireLine
		assignLine = prefix +"assign %s = %s || %s || %s;\n" % (
					CFMC.STALL_MC, CFMC.STALL_PIPE, CFMC.STALL_MDU, CFMC.STALL_RELEV)
		ret += assignLine	
		
		return ret
	