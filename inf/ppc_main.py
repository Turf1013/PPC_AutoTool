import sys
import os
import shutil
import logging
from src.routine.excel import Excel
from src.routine.vfile import VFile
from src.algorithm.FB import FB
from src.algorithm.datapath import Datapath
from src.algorithm.control import Control
from src.algorithm.MC import MC
from src.patch.ppcPatch import ppcPatch
from src.glob.glob import CFG
from src.compress.compress_ppc import fetch as compressFetch
from src.compress.compress_ppc import dump as compressDump
from src.compress.compress_ppc import compress as compressCtrl


class constForPPCMain:
	compressEna = True
	testMCI = False
	
class CFPM(constForPPCMain):
	pass
	

def move(srcDir, desDir):
	if os.path.exists(srcDir) and os.path.exists(desDir):
		fileList = os.listdir(srcDir)
		for fileName in fileList:
			if fileName.endswith(".v"):
				shutil.copyfile(os.path.join(srcDir, fileName), os.path.join(desDir, fileName))

				
def compress(desDir, filename):
	filepath = os.path.join(desDir, filename)
	lines = compressFetch(filepath)
	lines = compressCtrl(lines)
	compressDump(filepath, lines)
	
	
def testMCI(excelRtl, pipeLine, modMap, insnMap):
	mci = MC(excelRtl, pipeLine, modMap, insnMap)
	lines = mci.toVerilog()
	filename = "F:\Qt_prj\hdoj\data.in"
	with open(filename, "w") as fout:
		fout.write(lines)
	

if __name__ == "__main__":
	srcWorkDirectory = "F:\ppc_project"
	desWorkDirectory = "E:\ppc_project"
	excelName = "ppc_pipeline.xls"
	sheetName = "rtl"
	insnFileName = "instruction_def.v"
	regArgsList = [
		# name	rn wn
		["GPR", 3, 1],
		["SPR", 2, 2],
		["CR", 1, 1],
		["MSR", 1, 1],
	]
	GenFileNameList = [
		"ppc.v",
		"mips.v",
		"control.v",
	]
	brList = [
		"b",
		"bc",
		"bclr",
		"bcctr",
		# "rfi",
	]
	
	# remove ppc.v, mips.v, control.v
	fileList = os.listdir(srcWorkDirectory)
	for fileName in fileList:
		path = os.path.join(srcWorkDirectory, fileName)
		if os.path.isfile(path):
			if fileName in GenFileNameList:
				os.remove(path)
	
	# handle verilog file
	vFile = VFile(workDirectory = srcWorkDirectory)
	includeHead = vFile.GenIncludeHead(tabn = 0)
	insnMap = vFile.GenInsnMap(insnFileName)
	modMap = vFile.GenModuleMap()
	
	# handle excel file
	excelPath = os.path.join(srcWorkDirectory, excelName)
	excel = Excel(path = excelPath)
	pipeLine = excel.GenPipeLine(sheetName, regArgsList, brList)
	excelRtl = excel.GenAllRtl(sheetName)
	
	# test MCI module
	if CFPM.testMCI:
		testMCI(excelRtl, pipeLine, modMap, insnMap)
		exit(0)
		
	# FB algorithm
	fb = FB(excelRtl=excelRtl, pipeLine=pipeLine, modMap=modMap, insnMap=insnMap)
	### Generate the mux and control signal referenced
	csFromFB, muxFromFB = fb.HandleHazard()
	needBypass = fb.needBypass
	
	# Datapath
	dp = Datapath(excelRtl=excelRtl, pipeLine=pipeLine, modMap=modMap, insnMap=insnMap, needBypass=needBypass)
	
	# Control
	ctrl = Control(excelRtl=excelRtl, pipeLine=pipeLine, modMap=modMap, insnMap=insnMap)
	
	# Generate Port Mux
	csFromDP, muxFromDP = dp.GenPortMux()
	
	# add Control Signal
	ctrl.addCS(csFromFB)
	ctrl.addCS(csFromDP)
	ctrl.GenCS()
	
	### Link Module
	dp.LinkMod()
	### Generate Pipe Reg
	dp.GenPipe()
	
	# Generate Verilog
	ctrlCode = ctrl.toVerilog(tabn = 1)
	dpCode = dp.toVerilog(ctrl, pmuxList=muxFromDP, bmuxList=muxFromFB, tabn=1)
	
	
	# Write .v
	vFile.GenCtrlVFile(header=includeHead, code=ctrlCode)
	vFile.GenPPCVFile(header=includeHead, code=dpCode, topFileName="ppc.v")
	
	
	# ppc with INT need patch
	if CFG.PPC and CFG.IO:
		pp = ppcPatch(srcWorkDirectory)
		pp.PatchControl()
		pp.PatchPpc()
	
	# logging.debug("[N of bpmux] %s\n" % (len(muxFromFB)))
	move(srcWorkDirectory, desWorkDirectory)
	
	logging.debug("[N of hazard pairs] %s\n" % (fb.nHazardPair))
	
	# compress the control for better performance
	if CFPM.compressEna:
		compress(desWorkDirectory, "control.v")
	