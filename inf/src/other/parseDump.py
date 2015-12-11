import re
import os

class constForParseDump:
	prefix = "10000100:	"
	re_prefix = re.compile("^[0-9a-f]{8}:")
	re_logPrefix = re.compile("^0x[0-9a-f]{8}:")
	re_space = re.compile("\s+")
	textBegin = "Disassembly of section .text:"
	dataBegin = "Disassembly of section .data:"
	bssBegin  = "Disassembly of section .bss:"
	logBegin = 11
	logSize	 = 21
	NOP = "60000000"
	
class CFPD(constForParseDump):
	pass
	

class logBlock(object):

	def __init__(self, NIP=0, LR=0, CTR=0, XER=0, MSR=0, GPR=range(32), CR=0):
		self.NIP = NIP
		self.LR = LR
		self.CTR = CTR
		self.XER = XER
		self.MSR = MSR
		self.GPR = GPR
		self.CR = CR
	

	def toLog(self):
		ret = ""
		ret += "NIP %08x\n" % (self.NIP)
		ret += "CR %08x LR %08x CTR %08x MSR %08x XER %08x" %\
				(self.CR, self.LR, self.CTR, self.MSR, self.XER)
		for i in xrange(0, 32, 4):
			ret += "GPR%02d" % (i)
			for j in range(0, 4):
				ret += " %08x" % (self.GPR[i+j])
			ret += "\n"
		return ret
		
		
	def __str__(self):
		return self.toLog()


class parseDump:


	@classmethod
	def GenCode(cls, fileName):
		if not os.path.exists(fileName):
			raise ValueError, "%s not exists" % (fileName)
		ret = []
		paddr = None
		with open(fileName, "r") as fin:
			lines = fin.readlines()
			for line in lines:
				if line.startswith(CFPD.dataBegin):
					break
				if CFPD.re_prefix.match(line):
					dataList = CFPD.re_space.split(line)
					if len(dataList) >= 5:
						addr = int(line[:8], base=16)
						if paddr is not None:
							# fill with NOP
							for ii in xrange(paddr, addr-4, 4):
								ret.append(CFPD.NOP)
						paddr = addr
						code = "".join(dataList[1:5])
						ret.append(code)
		ret.append(CFPD.NOP)
		return ret
		
		
	@classmethod
	def GenData(cls, fileName):
		if not os.path.exists(fileName):
			raise ValueError, "%s not exists" % (fileName)
		ret = []
		paddr = None
		with open(fileName, "r") as fin:
			lines = fin.readlines()
			nLine = len(lines)
			for i in xrange(nLine):
				line = lines[i]
				if line.startswith(CFPD.dataBegin):
					for j in xrange(i, nLine):
						line = lines[j]
						if line.startswith(CFPD.bssBegin):
							break
						if CFPD.re_prefix.match(line):
							dataList = CFPD.re_space.split(line)
							if len(dataList) >= 5:
								addr = int(line[:8], base=16)
								if paddr is not None:
									# fill with NOP
									for ii in xrange(paddr, addr-4, 4):
										ret.append(CFPD.NOP)
								paddr = addr
								code = "".join(dataList[1:5])
								ret.append(code)
					break
		return ret
		
		
	@classmethod
	def GenNormLog(cls, fileName):
		if not os.path.exists(fileName):
			raise ValueError, "%s not exists" % (fileName)
		ret = []
		lines = []
		with open(fileName, "r") as fin:
			lines = fin.readlines()[CFPD.logBegin:]
		nLine = len(lines)
		# print nLine
		block = logBlock()
		i = 0
		while i < nLine:
			if i+CFPD.logSize > nLine:
				print "not complete block."
				break
			line = lines[i].rstrip()
			if CFPD.re_logPrefix.match(line):
				insnLine = line
			else:
				cls.__checkBlock(i, lines)
				i += CFPD.logSize-1
				continue
			for j in range(1, CFPD.logSize):
				line = lines[i+j].rstrip()
				L = line.split(" ")
				if j == 0:
					# 0 is insn
					insnLine = line
					
				elif j == 1:
					# 1 is NIP
					# NIP
					block.NIP = int(L[1], 16)
					# LR
					block.LR = int(L[3], 16)
					# CTR
					block.CTR = int(L[5], 16)
					# XER
					block.LR = int(L[7], 16)
					
				elif j == 2:
					# 2 is MSR
					block.MSR = int(L[1], 16)
					
				elif j < 11:
					# 3-10 is GPR
					rix = (j - 3) * 4
					for k in range(0, 4):
						block.GPR[rix+k] = int(L[k+1], 16)
						
				elif j == 11:
					# 11 is CR
					block.CR = int(L[1], 16)
			ret.append(block.toLog())
			ret.append(insnLine)
			i += CFPD.logSize
		return ret
	
	
	@classmethod
	def __checkBlock(cls, ix, lines):
		i = ix - CFPD.logSize + 1
		j = ix
		flag = False
		for k in xrange(0, CFPD.logSize-1):
			if lines[i].rstrip() != lines[j].rstrip():
				flag = True
				break
		if flag:
			print "@Line%d not equal." % (ix)
	
	
	@classmethod
	def WriteFile(cls, fileName, lineList):
		lines = "\n".join(lineList)
		with open(fileName, "w") as fout:
			fout.write(lines)
			
		
if __name__ == "__main__":
	srcFileName = "F:\Qt_prj\hdoj\data.in"
	desFileName = "F:\Qt_prj\hdoj\data.out"
	
	L = parseDump.GenNormLog(srcFileName)
	parseDump.WriteFile(desFileName, L)
	