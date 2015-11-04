# -*- coding: utf-8 -*-
import re
import os
from ..verilog.const_hdl import *
from ..verilog.gen_hdl import GenVerilog
from ..role.instruction import Insn
from ..role.module import Module, Port

class constForVFile:
	pass
	
class CFV(constForVFile):
	
	VFILE_SUFFIX = ".v"
	DEF_SUFFIX = "_def" + VFILE_SUFFIX
	
	# re using by scan
	re_moduleName 	= 	re.compile(r'\s*%s\s+(?P<name>[\w_]+)\s*' % (hdl_MODULE))
	re_endmodule	=	re.compile(r'\s*%s' % (hdl_ENDMODULE))
	re_portWidth 	= 	re.compile(r'\s*(?P<dir>%s|%s)\s+(?P<width>\[[\w`:_+-]+\])?' % (hdl_INPUT, hdl_OUTPUT))
	re_portName 	= 	re.compile(r'\s*[\w_]+\s*[,;]')	
	re_insnDef		= 	re.compile(r'\S+')
	
	OP = "_OP"
	XO = "_XO"
	
	

class VFile(object):
	""" Vfile means Access all kinds of *.v file.
	
	Vfile includes:
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
		self.workDir = workDirectory
		self.modFileList = []
		self.defFileList = []
		self.__scanAllDir(workDirectory)
	
	
	def chkFileType(self, fileList):
		return filter(lambda x:x.endswith(CFV.VFILE_SUFFIX), fileList)
	
		
	# scan all VFile not include directory
	def __scanAllFile(self, path):
		fileList = self.chkFileType(os.listdir(path))
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
		
	
	#  generate all the core Module class
	def GenAllModule(self):
		fileList = [os.path.join(*item) for item in self.modFileList]
		retModList = []
		for fileName in fileList:
			retModList += self.__GenModule(fileName)
		return retModList
		
	
	# scan the .v file and generate all the module in the file. (one file may contains several modules)
	def __GenModule(self, fileName):
		retModList = []
		with open(fileName, "r") as fin:
			foundMod = False
			modName = None
			portList = []
			for line in fin:
				if foundMod and CFV.re_endmodule.match(line):
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
						width = width if width else hdl_WIDTHONE
						portNameList = CFV.re_portName.findall(line[mgroup.end():])
						# delete ',;' and space
						portNameList = map(lambda s:s[:-1].lstrip(), portNameList)
						portList += [Port(name, width) for name in portNameList]
	
		return retModList
		
	
	# generate all the instuction information we need to implement
	def GenAllInsn(self, fileName):
		if not os.path.exists(fileName) or not os.path.isfile(fileName):
			raise SystemError, "%s not exists or contains instruction" % (fileName)
		retInsnList = []
		with open(fileName, "r") as fin:
			opDict = dict()
			xoDict = dict()
			for line in fin:
				if line.startswith(hdl_DEFINE):
					defName, defVal = CFV.re_insnDef.findall(line)[1:3]
					if defName.endswith(CFV.OP):
						opDict[defName[:-len(CFV.OP)]] = defVal
						xoDict[defName[:-len(CFV.OP)]] = None
					elif defName.endswith(CFV.XO):
						xoDict[defName[:-len(CFV.XO)]] = defVal
						
			for name,op in opDict.iteritems():
				xo = xoDict[name] if name in xoDict else None
				retInsnList.append( Insn(name=name, op=op, xo=xo) ) 
				
		return retInsnList	
		
		


	