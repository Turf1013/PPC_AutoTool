#!/usr/bin/env python
import ppc_const
import format
from collections import OrderedDict, defaultdict
import re
import os
import linecache
import logging
from linecache_data import *

'This file is overall checking the binary file. This module is based on bin objdumped by GCC.'

class overall_check(format):

	def __init__(self, insnWidth=32, BigEndian=True):
		super(overall_check, self).__init__(insnWidth, BigEndian)
		self.re_binCode = re.compile(r'\s+')
		self.initConst()


	def initConst(self):
		self.nTest = 30
		self.nWord = self.insnWidth / 8
		self.shiftList = [i*8 for i in range(self.nWord-1, -1, -1)]


	def logConfig(self, fname):
		logging.basicConfig(
			level=logging.DEBUG,
			format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
            datefmt='%a, %d %b %Y %H:%M:%S',
            filename=fname+'.res',
            filemode='w'
		)


	def saveBaseResult(self, fname, errInsnNameSet, unknownInsnNameSet):
		self.logConfig(fname)
		logging.debug(
			'%s\n errInsnNameSet: %s, unknownInsnNameSet: %s',
			str(errInsnNameSet)[-4:-1], str(unknownInsnNameSet)[-4:-1]
		)


	def insnBaseCheck(self, fname):
		'Base Check included opcode & xo check and unknown insn check'
		lines = self.setSourceFile(fname)
		begPos = self.getBegPosOfBin(lines)
		binCodeList, insnNameList = self.disassembleBinCode(lines)
		errInsnNameSet = set()
		unknownInsnNameSet = set()
		for binCode,insnName in zip(binCodeList, insnNameList):
			if insnName in self.insnDict:
				op, xo = self.insnDict[insn_op], self.insnDict[insn_xo]
				insnFormDict = self.insnDict[insn_form]
				oop, xxo = 0, 0
				flag = True
				if insn_op in insnFormDict:
					beg, end = self.insnDict[insn_op]
					oop = getValue(binCode, beg, end)
					flag &= (oop==op)
				if insn_xo in insnFormDict:
					beg, end = self.insnDict[insn_xo]
					xxo = getValue(binCode, beg, end)
					flag &= (xxo==xo)
				if not flag:
					errInsnNameSet.add((insnName, oop, xxo))
			else:
				unknownInsnNameSet.add(insnName)
		return errInsnNameSet, unknownInsnNameSet


	def disassembleBinCode(self, testLines):
		'disassemble the Binary Code of linecache'
		binCodeList = []
		insnNameList = []
		for line in testLines:
			if line[begPos]!=':':
				continue
			line = line[begPos]
			
			# get the bin code
				# use maxSplit to fast split, the first element of split is always null
			wordList = self.re_binCode.split(line, maxSplit=self.nWord+1)[1:]
			wordValue = [int(wordList[j], 16) for j in range(self.nWord)]
			binCode = sum(
				map(lambda x,y: x<<y, wordValue, self.shiftList)
			)
			binCodeList.append(binCode)
			
			# get the mnemonic
			line = wordList[self.nWord]
			insnName = self.re_binCode.split(line, maxSplit=1)[0]
			insnNameList.append(insnName)
		return binCodeList, insnNameList


	def getBegPosOfBin(self, lines):
		# select nTest consecutive lines to get
		# 		Begin Position of Bin Code
		testLines = lines[:self.nTest]
		begPosDict = defaultdict(0)
		for line in testLines:
			begPos = line.find(':')
			if begPos >= 0:
				begPosDict[begPos] += 1
		maxCnt = -1
		maxBegPos = 0
		for begPos,Cnt = begPosDict.items():
			if Cnt > maxCnt:
				maxBegPos = begPos
				maxCnt = Cnt
		return maxBegPos


	def setSourceFile(self, fname):
		try:
			fin = open(fname, "r")
			fin.close()
		except IOError:
			print 'No such file named %s.' % (fname)
			return
		lines = linecache.getlines(fname)
		return lines


	def __str__(self):
		return 'This is overall checking.'

if __name__ == '__main__':
