#!/usr/bin/env python
import chond_check
import overall_check
import sys
import time

class Mandrill(chond_check):

	def __init__(self, insnWidth=32, bigEndian=True):
		super(Mandrill, self).__init__(insnWidth, bigEndian)
		self.isSetCon = False

	def baseCheckFiles(self):
		errInsnNameSet = set()
		unknownInsnNameSet= set()
		for fileName in self.fileList:
			errInsnNameSetTmp, unknownInsnNameSetTmp = self.baseCheckOneFile(fileName)
			errInsnNameSet.add(errInsnNameSetTmp)
			unknownInsnNameSet.add(unknownInsnNameSetTmp)
		self.saveBaseTopResult(errInsnNameSet, unknownInsnNameSet)


	def condCheckFiles(self):
		if not self.hasSetCond:
			print 'condition not set'
			return
		totCnt = 0
		errCnt = 0
		for fileName in self.fileList:
			totTmp, errTmp = self.condCheckOneFile(fileName)
			totCnt += totTmp
			errCnt += errTmp
		self.saveCondTopResult(totCnt, errCnt)


	def saveBaseTopResult(self, errInsnNameSet, unknownInsnNameSet):
		baseTopFileName = 'baseTop_' + self.genTopSuffix()
		self.saveCondResult(baseTopFileName, errInsnNameSet, unknownInsnNameSet)


	def saveCondTopResult(self, totCnt, errCnt):
		condTopFileName = 'condTop_' + self.insnName + self.genTopSuffix()
		self.saveCondResult(condTopFileName, totCNt, errCnt)


	def baseCheckOneFile(self, fname):
		errInsnNameSet, unknownInsnNameSet = self.insnBaseCheck(fname)
		self.saveBaseResult(fname, errInsnNameSet, unknownInsnNameSet)
		return errInsnNameSet, unknownInsnNameSet


	def condCheckOneFile(self, fname):
		totCnt, errCnt = self.insnCondCheck(self, fname)
		self.saveCondResult(fname, totCnt, errCnt)
		return totCnt, errCnt


	def setTestFiles(self, fname, suffix='.log'):
		self.suffix = suffix
		if isinstance(fname, str):
			fileList = [fname]
		elif isinstance(fname, (list,tuple)):
			fileList = list(fname)
		else:
			print 'not supported this type:', type(fname)
			return
		self.suffix = suffix
		self.fileList = fileList


	def setTestDirectory(self, fpath, suffix='.log'):
		if not os.path.isdir(fpath):
			print fpath, 'is not directory'
			return
		self.suffix = suffix
		filterList = filter(lambda s: s.endswith(suffix), os.listdir(fpath))
		self.fileList = map(
			lambda x,y: x+y,
			[fpath]*len(filterList), filterList
		)


	def genTopSuffix(self):
		return time.strftime('v%m%d_%H%M', time.localtime())


	def __str__(self):
		return 'Mandrill is a tool to check insn based on GCC compiled bin file'


if __name__ == '__main__':