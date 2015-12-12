import os
import sys
import math
from ..glob.glob import CFG

class constForMipsPatch:
	PPC = "ppc"
	CONTROL = "control"
	PPC_FILE = PPC + ".v"
	CONTROL_FILE = CONTROL + ".v"
	CsNameList = [
		["SPR_wd0_W_Pmux_sel_W", "NPC_PCB_W"],
		["SPR_wd1_W_Pmux_sel_W", "MSR_rd_W"],
		["SPR_waddr0_W_Pmux_sel_W", "`SRR0_ADDR"],
		["SPR_waddr1_W_Pmux_sel_W", "`SRR1_ADDR"],
		["SPR_wr0_W", "1'b1"],
		["SPR_wr1_W", "1'b1"],
		["BrFlush_D", "1'b1"],
		["NPC_Op_D", "`NPCOp_INT"],
		["stall", "1'b0"],
	]
	INT = "INTE_INT"
	INT_D = "INTE_INT_D"
	INT_W = "INTE_INT_W"
	csPrefix = "/*********   Logic of "
	clrDPrefix = "//// same meaning as clr_D ="
	wirePrefix = "// wire"
	
	
class CFMP(constForMipsPatch):
	pass

class ppcPatch:

	def __init__(self, workDirectory):
		if not os.path.exists(workDirectory):
			raise ValueError, "%s not exists." % (workDirectory)
		self.workDirectory = workDirectory
		self.ctrlLines = []
		self.ppcLines = []
		with open(os.path.join(workDirectory, CFMP.CONTROL_FILE), "r") as fin:
			self.ctrlLines = fin.readlines()
		with open(os.path.join(workDirectory, CFMP.PPC_FILE), "r") as fin:
			self.ppcLines = fin.readlines()
		
		
	def __findPmux(self, name):
		for i,item in enumerate(CFMP.CsNameList):
			if item[0].startswith(name):
				return i
		return -1
		
		
	def __findCs(self, name):
		for i,item in enumerate(CFMP.CsNameList):
			if item[0] == name:
				return i
		return -1
			
			
	def __GenSelFromPPC(self):
		found = False
		tot = 0
		for line in self.ppcLines:
			line = line.strip()
			if not found:
				if not line.startswith("mux"):
					continue
				wordList = line.split(" ")
				if len(wordList) < 3:
					continue
				if wordList[2].endswith("Pmux"):
					id = self.__findPmux(wordList[2])
					if id >= 0:
						found = True
						tot = 0
						dinx = -1
				
			else:
				if line.startswith(".din"):
					tot += 1
					din = line[line.index("(")+1:line.rindex(")")]
					if din == CFMP.CsNameList[id][1]:
						dinx = int(line[4:line.index("(")])
						
				elif line.startswith(");"):
					if dinx == -1:
						raise ValueError, "Patching not found %s" % (CFMP.CsNameList[id])
					width = int(math.log(tot, 2))
					CFMP.CsNameList[id][1] = "%d'd%d" % (width, dinx)
					found = False
					continue
				
				
	def __patchInOut(self):
		nLine = len(self.ctrlLines)
		i = 0
		
		# add INTE_INTD, INTEW at the module block
		while i < nLine:
			line = self.ctrlLines[i]
			if line.startswith("module"):
				i += 1
				break
			i += 1
			
		j = i
		while j < nLine:
			line = self.ctrlLines[j].lstrip()
			if line.startswith("// input"):
				j += 1
				break
			j += 1
		s1 = "\t%s, %s,\n" % (CFMP.INT_D, CFMP.INT_W)
		s2 = "\tinput %s, %s;\n"  % (CFMP.INT_D, CFMP.INT_W)
		L = self.ctrlLines[:i] + [s1] + self.ctrlLines[i:j] + [s2] + self.ctrlLines[j:]
		self.ctrlLines = L
				
				
	def __patchCs(self):
		L = []
		i = 0
		nLine = len(self.ctrlLines)
		while i < nLine:
			rawLine = self.ctrlLines[i]
			line = rawLine.strip()
			if line.startswith(CFMP.csPrefix):
				csName = line[len(CFMP.csPrefix):].split(" ")[0]
				csId = self.__findCs(csName)
				if csId >= 0:
					if "_" in csName:
						suffix = csName[csName.rindex("_"):]
					else:
						# handle stall
						suffix = "_D"
					# add comment
					L.append(rawLine)
					# add always declare
					i += 1
					L.append(self.ctrlLines[i])
					# insert new condition
					line = "\t\tif ( %s%s ) begin\n" % (CFMP.INT, suffix)
					L.append(line)
					line = "\t\t\t%s = %s;\n" % (CFMP.CsNameList[csId][0], CFMP.CsNameList[csId][1])
					L.append(line)
					line = "\t\tend\n"
					L.append(line)
					# add "else" in front of the line
					i += 1
					rawLine = self.ctrlLines[i]
					line = "\t\telse " + rawLine.lstrip()
					L.append(line)
				
			elif line.startswith(CFMP.clrDPrefix):
				# add comment
				L.append(rawLine)
				# add always declare
				i += 1
				L.append(self.ctrlLines[i])
				# fecth clr_D logic
				i += 1
				line = self.ctrlLines[i]
				line = "%s | %s;\n" % (line[:-2], CFMP.INT_D)
				L.append(line)

			
			else:		
				L.append(rawLine)
				
			i += 1

		self.ctrlLines = L
		
			
	def PatchControl(self):
		if not ( CFG.PPC and CFG.IO ):
			return
		self.__GenSelFromPPC()
		self.__patchInOut()
		self.__patchCs()
		with open(os.path.join(self.workDirectory, CFMP.CONTROL_FILE), "w") as fout:
			fout.write("".join(self.ctrlLines))
			
			
	def __patchCtrl(self):
		i = 0
		nLine = len(self.ppcLines)
		while i < nLine:
			line = self.ppcLines[i].lstrip()
			if line.startswith("control"):
				i += 1
				break
			i += 1
		# add INT_D & INT_W
		L = []
		line = "\t\t.%s(%s),\n" % (CFMP.INT_D, CFMP.INT_D)
		L.append(line)
		line = "\t\t.%s(%s),\n" % (CFMP.INT_W, CFMP.INT_W)
		L.append(line)
		self.ppcLines = self.ppcLines[:i] + L + self.ppcLines[i:]
		
		
	def __patchLed(self):
		i = 0
		nLine = len(self.ppcLines)
		while i < nLine:
			line = self.ppcLines[i].lstrip()
			if line.startswith(CFMP.wirePrefix):
				i += 1
				break
			i += 1
		j = i
		while j < nLine:
			line = self.ppcLines[j].lstrip()
			if line.startswith(".LED_dis"):
				break
			j += 1
		s1 = "\twire [7:0] LED_dis;\n"
		line = self.ppcLines[j]
		lpos = line.index("(")
		rpos = line.rindex(")")
		s2 = line[:lpos+1] + "LED_dis" + line[rpos:]
		self.ppcLines = self.ppcLines[:i] + [s1] + self.ppcLines[i:j] + [s2] + self.ppcLines[j+1:]
		
			
	def PatchPpc(self):
		if not ( CFG.PPC and CFG.IO ):
			return
		self.__patchCtrl()
		self.__patchLed()
		with open(os.path.join(self.workDirectory, CFMP.PPC_FILE), "w") as fout:
			fout.write("".join(self.ppcLines))
	


	