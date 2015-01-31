#!/usr/bin/env python
import ppc_insnFormat
import time

'This file is the format of instructions. Very simple but waste of time.'

class format(object):

	def __init__(self, insnWidth=32, bigEndian=True):
		self.bigEndian = bigEndian
		self.insnWidth = insnWidth
		self.formDict = ppc_insnFormat.PPC_FormDict
		self.insnDict = ppc_insnFormat.insnDict
		if bigEndian:
			self.transToBigEndian()


	def transToBigEndian(self):
		'PPC is a bigEndian, we need to transfer the range of fields in insn to BigEndian'
		for name,aFormDict in self.formDict.iteritems():
			for fieldName,boundry in aFormDict.iteritems():
				aFormDict[fieldName] = (self.insnWidth-boundry[0], self.insnWidth-boundry[1])


	def getValue(self, insn, beg, end):
		'get the value in insn from beg to end, not included end'
		length = abs(beg - end)
		if beg < end:
			beg, end = end, beg
		ret = insn>>end
		mask = int("1"*length) if length else 0
		return ret & mask


	def trunc(self, line):
		for i in range(len(line)-1,-1,-1):
			if line[i] == '.':
				return line[:i]
		return line


	def getTimeStamp(self):
		return time.strftime('%a, %d %b %Y %H:%M:%S', time.localtime())


	def getFormDict(self):
		return self.formDict


	def getInsnDict(self):
		return self.insnDict


	def testFormDict(self):
		print 'format of X-Form'
		xFormDict = self.formDict['X_Form']
		for key,value in xFormDict.items():
			print key, '=>', value
		print


	def testInsnDict(self):
		print 'format of addi'
		addiInsnDict = self.insnDict['addi']
		for key,value in addiInsnDict.items():
			print key, '=>', value
		print


	def __str__(self):
		return 'format of insn'


if __name__ == "__main__":
	print 'format.py'
	fm = format(32, True)
	fm.testFormDict()
	fm.testInsnDict()

