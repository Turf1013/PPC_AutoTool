import os
import sys

class constForMipsPatch:
	MIPS = "mips"
	CONTROL = "control"
	MIPS_FILE = MIPS + ".v"
	CONTROL_FILE = CONTROL + ".v"
	
class CFMP(constForMipsPatch):
	pass

class mipsPatch:

	def __init__(self, workDirectory):
		if not os.path.exists(workDirectory):
			raise ValueError, "%s not exists." % (workDirectory)
		self.workDirectory = workDirectory
		self.ctrlLines = []
		self.mipsLines = []
		with open(os.path.join(workDirectory, CFMP.CONTROL_FILE), "r") as fin:
			self.ctrlLines = fin.readlines()
		with open(os.path.join(workDirectory, CFMP.MIPS_FILE), "r") as fin:
			self.mipsLines = fin.readlines()
			
			
	def __patchBypass(self):
		newCtrlLines = []
		findBMux = False
		
		for line in self.ctrlLines:
			lline = line.lstrip()
			if not findBMux:
				if lline.startswith("/*") and "Bmux" in lline:
					findBMux = True
				newCtrlLines.append(line)
				continue
					
			
			if lline.startswith("else if"):
				eleList = line.split("(")
				ele = eleList[-1]
				raddr = ele[:ele.index(" ")]
				ele_ = ele[:ele.index(")")+1] + " && (%s != 0)" % (raddr) + ele[ele.index(")")+1:]
				eleList[-1] = ele_
				newCtrlLines.append( "(".join(eleList) )
				
			else:
				if lline.startswith("else begin"):
					findBMux = False
				newCtrlLines.append(line)
					
		self.ctrlLines = newCtrlLines
			
		
	
	def __patchStall(self):
		newCtrlLines = []
		findBMux = False
		
		for line in self.ctrlLines:
			lline = line.lstrip()
			if not findBMux:
				if lline.startswith("/*") and "stall" in lline:
					findBMux = True
				newCtrlLines.append(line)
				continue
					
			if lline.startswith("if"):
				line = line.replace("clr_D", "0")
				newCtrlLines.append(line)
				
			elif lline.startswith("else if"):
				eleList = line.split("(")
				ele = eleList[-1]
				raddr = ele[:ele.index(" ")]
				ele_ = ele[:ele.index(")")+1] + " && (%s != 0)" % (raddr) + ele[ele.index(")")+1:]
				eleList[-1] = ele_
				newCtrlLines.append( "(".join(eleList) )
				
			else:
				if lline.startswith("else begin"):
					findBMux = False
				newCtrlLines.append(line)
					
		self.ctrlLines = newCtrlLines
		
			
	def PatchControl(self):
		self.__patchBypass()
		self.__patchStall()
		with open(os.path.join(self.workDirectory, CFMP.CONTROL_FILE), "w") as fout:
		# with open(os.path.join(workDirectory, CFMP.CONTROL_FILE+".bk"), "w") as fout:
			fout.write("".join(self.ctrlLines))
			
			
	def PatchMips(self):
		with open(os.path.join(self.workDirectory, CFMP.MIPS_FILE), "w") as fout:
		# with open(os.path.join(workDirectory, CFMP.MIPS_FILE+".bk"), "w") as fout:
			fout.write("".join(self.mipsLines))
	


	