#!/usr/bin/env python
from cond_check import *
import sys
import time

class Mandrill(cond_check):

	resultFileSuffix = '.res'

	def __init__(self, insnWidth=32, bigEndian=True):
		super(Mandrill, self).__init__(insnWidth, bigEndian)
		self.isSetCon = False


	def baseCheckFiles(self):
		errInsnNameSet = set()
		unknownInsnNameSet = set()
		for fileName in self.fileList:
			errInsnNameSetTmp, unknownInsnNameSetTmp = self.baseCheckOneFile(fileName)
			errInsnNameSet = errInsnNameSet.union(errInsnNameSetTmp)
			unknownInsnNameSet = unknownInsnNameSet.union(unknownInsnNameSetTmp)
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


	def cntCheckFiles(self):
		insnCntDict = defaultdict(int)
		for fileName in self.fileList:
			insnCntDictTmp = self.cntCheckOneFile(fileName)
			# print 'insnCntDictTmp =', insnCntDictTmp
			for insnName in insnCntDictTmp:
				insnCntDict[insnName] += insnCntDictTmp[insnName]
		self.saveCntTopResult(insnCntDict)
		# print insnCntDict
		logging.error(insnCntDict)


	def saveBaseTopResult(self, errInsnNameSet, unknownInsnNameSet):
		baseTopFileName = 'baseTop_' + self.genTopSuffix()
		# print 'baseTopFileName =', baseTopFileName
		# print 'errInsnNameSet =', errInsnNameSet
		baseTopFileName = self.genResultFileName(baseTopFileName)
		self.saveBaseResult(baseTopFileName, errInsnNameSet, unknownInsnNameSet)


	def saveCondTopResult(self, totCnt, errCnt):
		condTopFileName = 'condTop_' + self.insnName + self.genTopSuffix()
		condTopFileName = self.genResultFileName(condTopFileName)
		self.saveCondResult(condTopFileName, totCnt, errCnt)


	def saveCntTopResult(self, insnCntDict):
		cntTopFileName = 'cntTop_' + self.genTopSuffix()
		cntTopFileName = self.genResultFileName(cntTopFileName)
		# print 'cntTopFileName =', cntTopFileName
		# print 'insnCntDict =', insnCntDict
		self.saveCntResult(cntTopFileName, insnCntDict)


	def baseCheckOneFile(self, fname):
		errInsnNameSet, unknownInsnNameSet = self.insnBaseCheck(fname)
		fname = self.genResultFileName(fname, '_base')
		self.saveBaseResult(fname, errInsnNameSet, unknownInsnNameSet)
		return errInsnNameSet, unknownInsnNameSet


	def condCheckOneFile(self, fname):
		totCnt, errCnt = self.insnCondCheck(self, fname)
		fname = self.genResultFileName(fname, '_cond')
		self.saveCondResult(fname, totCnt, errCnt)
		return totCnt, errCnt


	def cntCheckOneFile(self, fname):
		insnCntDict = self.insnCntCheck(fname)
		fname = self.genResultFileName(fname, '_cnt')
		self.saveCntResult(fname, insnCntDict)
		return insnCntDict


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
		return time.strftime("v%m%d_%H%M", time.localtime())

	def genResultFileName(self, fname, ftype=''):
		return self.trunc(fname) + ftype + self.resultFileSuffix

	def __str__(self):
		return 'Mandrill is a tool to check insn based on GCC compiled bin file'


if __name__ == '__main__':
	mandrill = Mandrill()
	if len(sys.argv)>1:
		fname = sys.argv[1:]
	else:
		fpath = './'
		fname = 'a.txt'
	suffix = '.txt'
	mandrill.setTestFiles(fname, suffix)
	mandrill.baseCheckFiles()
	mandrill.cntCheckFiles()