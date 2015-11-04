# -*- coding: utf-8 -*-
import os, fnmatch


VFILE_SUFFIX = ".v"
DEF_SUFFIX = "_def" + VFILE_SUFFIX
class Vfile(object):
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
		self.scanAllFile(workDirectory)
	
	
	def chkFileType(self, fileList):
		return filter(lambda x:x.endswith(VFILE_SUFFIX), fileList)
	
		
	# scan all VFile not include directory
	def scanAllFile(self, path):
		fileList = chkFileType(os.listdir(path))
		for fname in fileList:
			if fname.endswith(DEF_SUFFIX):
				self.defFileList.append(path + fname)
			else:
				self.modFileList.append(path + fname)
		
		
	# scan all VFile include directory
	def scanAllFile_(self, fpath):
		self.scanAllFile(self, fpath)
		fileList = os.listdir(fpath)
		for fname in fileList:
			path = os.path.join(fpath, fname)
			if os.path.isdir()
				self.scanAllFile_(self, path)
				
	
	