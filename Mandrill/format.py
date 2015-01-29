#!/usr/bin/env python
import ppc_insnFormat

'This file is the format of instructions. Very simple but waste of time.'

class format(object):

	def __init__(self, insnWidth=32, bigEndian = True):
		self.bigEndian = BigEndian
		self.insnWidth = insnWidth
		self.formDict = ppc_format.formDict
		self.insnDict = ppc_format.insnDict
		if bigEndian:
			self.transToBigEndian()


	def transToBigEndian(self):
		'PPC is a bigEndian, we need to transfer the range of fields in insn to BigEndian'
		for name,aFormDict in self.formDict.iteritems():
			for fieldName,boundry in aFormDict.iteritems():
				aFormDict[fieldName] = (self.insnWidth-boundry[0], self.insnWidth-boundry[1])


	def getValue(self, int insn, int beg, int end):
		'get the value in insn from beg to end, included end'
		length = abs(beg - end)
		if beg < end:
			beg, end = end, beg
		ret = insn>>end
		mask = int("1"*length)
		return ret & mask


	def getFormDict(self):
		return self.formDict

	def getInsnDict(self):
		return self.insnDict

	def __str__():
		return 'format of insn'


if __name__ == "__main__":