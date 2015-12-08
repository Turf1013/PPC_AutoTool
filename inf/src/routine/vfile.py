# -*- coding: utf-8 -*-
import re
import os
import logging
from collections import defaultdict
from ..verilog.const_hdl import constForVerilog as CFVL
from ..verilog.gen_hdl import GenVerilog
from ..role.instruction import Insn
from ..role.module import Module, Port
from ..role.moduleMap import ModuleMap
from ..role.instructionMap import InsnMap
from ..util.verilogGenerator import VerilogGenerator as VG


class constForVFile:
	VFILE_SUFFIX = ".v"
	TB_VFILE_SUFFIX = "_tb.v"
	DEF_SUFFIX = "_def" + VFILE_SUFFIX
	
	# re using by scan
	re_moduleName 	= 	re.compile(r'\s*%s\s+(?P<name>[\w_]+)\s*' % (CFVL.MODULE))
	re_endmodule	=	re.compile(r'\s*%s' % (CFVL.ENDMODULE))
	re_portWidth 	= 	re.compile(r'\s*(?P<dir>%s|%s)\s+(?P<width>\[[\w`:_+-]+\])?' % (CFVL.INPUT, CFVL.OUTPUT))
	re_portName 	= 	re.compile(r'\s*[\w_]+\s*[,;]')	
	re_insnDef		= 	re.compile(r'\S+')
	
	OP = "_OP"
	XO = "_FUNCT"
	
	controlFileName = "control.v"
	ppcFileName = "mips.v"
	
	moduleIgnoreList = [
		"FF",
		"FFW",
		"mux2",
		"mux4",
		"mux8",
		"mux16",
		"mux32",
		"mux64",
	]
	
class CFV(constForVFile):
	pass
	

class VFileModule(object):

	def __init__(self, modList):
		for mod in modList:
			self.modDict[mod.name] = mod
			
			
	def find(self, name):
		return self.modDict[name]
	

class VFile(object):
	""" Vfile means Access all kinds of *.v file.
	
	Vfile Function includes:
	1. Generate all the Core Module;
	2. Generate all the Insn;
	3. Generate all the define `include head;
	4. Write a define .v;
	5. Write the Control.v;
	6. Write the PPC.v;
	
	"""

	def __init__(self, workDirectory):
		if not os.path.exists(workDirectory):
			raise SystemError, "%s not exists" % (workDirectory)
		if not os.path.isdir(workDirectory):
			raise TypeError, "%s is not dir" % (workDirectory)
		self.workDirectory = workDirectory
		self.modFileList = []
		self.defFileList = []
		self.__scanAllDir(workDirectory)
	
	
	def __chkFileType(self, fileList):
		return filter(lambda x:x.endswith(CFV.VFILE_SUFFIX), fileList)
	
		
	# scan all VFile not include directory
	def __scanAllFile(self, path):
		fileList = self.__chkFileType(os.listdir(path))
		for fname in fileList:
			if fname.endswith(CFV.DEF_SUFFIX):
				self.defFileList.append((path, fname))
			else:
				self.modFileList.append((path, fname))
		
		
	# scan all VFile include directory
	def __scanAllDir(self, fpath):
		self.__scanAllFile(fpath)
		fileList = os.listdir(fpath)
		for fname in fileList:
			path = os.path.join(fpath, fname)
			if os.path.isdir(path):
				self.__scanAllDir(self, path)
	
	
	# generate the `include head
	def GenIncludeHead(self, tabn=0):
		#### Join the complete Path
		# fileList = [os.path.join(*item) for item in self.defFileList]
		fileList = [item[1] for item in self.defFileList]
		return GenVerilog.genIncludeCode(fileList, tabn)
	
	
	# generate the Module Map
	def GenModuleMap(self):
		modList = self.GenAllModule()
		return ModuleMap(iterable=modList)
		
		
	# generate the Instruction Map
	def GenInsnMap(self, fileName):
		insnList = self.GenAllInsn(fileName)
		return InsnMap(iterable=insnList)
	
	
	#  generate all the core Module class
	def GenAllModule(self):
		fileList = [os.path.join(*item) for item in self.modFileList]
		retModList = []
		for fileName in fileList:
			retModList += self.__GenModule(fileName)
		return retModList
		
	
	# scan the .v file and generate all the module in the file. (one file may contains several modules)
	def __GenModule(self, fileName):
		if fileName.endswith(CFV.TB_VFILE_SUFFIX):
			return []
		retModList = []
		with open(fileName, "r") as fin:
			foundMod = False
			modName = None
			portList = []
			for line in fin:
				if foundMod and CFV.re_endmodule.match(line):
					if modName not in CFV.moduleIgnoreList:
						retModList.append(Module(name=modName, iterable=portList))
					foundMod = False
					modName = None
					portList = []
					continue
					
				if not foundMod:
					# find module name first
					mgroup = CFV.re_moduleName.match(line)
					if mgroup:
						foundMod = True
						modName = mgroup.group("name")
						
				else:
					# find the port
					mgroup = CFV.re_portWidth.match(line)
					if mgroup:
						width = mgroup.group("width")
						width = width if width else CFVL.WIDTHONE
						portNameList = CFV.re_portName.findall(line[mgroup.end():])
						# delete ',;' and space
						portNameList = map(lambda s:s[:-1].lstrip(), portNameList)
						portList += [Port(name, width) for name in portNameList]
	
		return retModList
		
	
	# generate all the instuction information we need to implement
	def GenAllInsn(self, fileName):
		"""
			some insn may have multiple field to locate the insn.
			1. use defaultdict( dict() ) to get all possible field;
			2. Instance instruction with fieldDict;
			3. the defName in ```instruction_def.v```` must end with "_" + fieldName.
		"""
		fileName = os.path.join(self.workDirectory, fileName)
		if not os.path.exists(fileName) or not os.path.isfile(fileName):
			raise SystemError, "%s not exists or contains instruction" % (fileName)
		retInsnList = []
		with open(fileName, "r") as fin:
			fieldDict = defaultdict( dict )
			insnNameSet = set()
			for line in fin:
				line = line.strip()
				
				if line.startswith(CFVL.DEFINE):
					defName, defVal = CFV.re_insnDef.findall(line)[1:3]
					underlinePos = defName.rindex("_")
					fieldName = defName[underlinePos+1:]
					insnName = defName[:underlinePos]
					insnNameSet.add( insnName )
					fieldDict[fieldName][insnName] = VG.GenInsnFieldDef(defName)
					# logging.debug("[vfile-Insn] fieldName=%s, insnName=%s, defName=%s\n" % (fieldName, insnName, defName))
					
			for insnName in insnNameSet:
				d = dict()
				for fieldName,insnFieldDict in fieldDict.iteritems():
					if insnName in insnFieldDict:
						d[fieldName] = insnFieldDict[insnName]
						
				retInsnList.append( Insn(name=insnName, fieldDict=d) )
				
		return retInsnList	
		
		
	def __WriteVFile(self, path, header="", code=""):
		with open(path, "w") as fout:
			fout.write(header)
			fout.write("\n")
			fout.write(code)
			fout.write("\n")
			
		
	def GenCtrlVFile(self, header, code):
		path = os.path.join(self.workDirectory, CFV.controlFileName)
		self.__WriteVFile(path=path, header=header, code=code)
		
		
	def GenPPCVFile(self, header, code, topFileName=CFV.ppcFileName):
		path = os.path.join(self.workDirectory, topFileName)
		self.__WriteVFile(path=path, header=header, code=code)
		

	@classmethod
	def checkInsnDef(cls, fileName):
		with open(fileName, "r") as fin:
			nameSet = set()
			valSet = set()
			opSet = set()
			insnSet = set()
			needXO = False
			for line in fin:
				if line.endswith("\n"):
					line = line[:-1]
					if not line:
						continue
					dataList = re.split("\s+", line)
					if len(dataList) < 3:
						print dataList
						continue
					name = dataList[1]
					val = dataList[2]
					
					if name.endswith("_XO"):
						print "%s need to add format" % (name)
					
					if name in nameSet:
						print "%s define repeated" % (name)
					nameSet.add(name)	
					
					# print "name = %s, val = %s" % (name, val)
					insnName = '_'.join(name.split('_')[:-1])
					if needXO and not name.endswith("XO"):
						print "%s should add XO" % (insnName)
					
					if name.endswith("OPCD") and val in opSet:
						needXO = True
					else:
						needXO  = False
						
					if name.endswith("OPCD"):
						opSet.add(val)
					else:
						if val in valSet:
							print "%s's XO has already got one." % (insnName)
						valSet.add(val)
						
	