#!/usr/bin/env python
from ppc_const import *
from format import *
from collections import OrderedDict, defaultdict
import re
import os
import sys
import linecache
import logging


'This file is overall checking the binary file. This module is based on bin objdumped by GCC.'

class overall_check(format):

	def __init__(self, insnWidth=32, bigEndian=True):
		super(overall_check, self).__init__(insnWidth, bigEndian)
		self.re_binCode = re.compile(r'\s+')
		self.initConst()
		self.begPos_cache = dict()
		self.logConfig('ppc_check.log')

	def initConst(self):
		self.nTest = 30
		self.nWord = self.insnWidth / 8
		self.shiftList = [i*8 for i in range(self.nWord-1, -1, -1)]


	def logConfig(self, fname):
		logging.basicConfig(
			level=logging.DEBUG,
			format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
            datefmt='%a, %d %b %Y %H:%M:%S',
            filename='.log',
            filemode='w'
		)


	def saveBaseResult(self, fname, errInsnNameSet, unknownInsnNameSet):
		'generate the title of log'
		title = 'Result of Base Check:\n\t\t' + self.getTimeStamp() + '\n\t\t\t@Turf1013\n\n'
		'error Insn'
		errInsnNameStr = 'error %d Instructions (with wrong opcode/xo) included:\n' % (len(errInsnNameSet))
		errInsnNameStr += '%12s\t%8s\t%8s\n' % ('insnName', ' insnOp ', ' insnXo ')
		for i,(insnName, insnOp, insnXo) in enumerate(errInsnNameSet):
			try:
				errInsnNameSet += '%12s %8d %8d\t\n' % (insnName, insnOp, insnXo)
			except TypeError:
				print insnName
		errInsnNameStr += '\n\n'

		'unknown Insn'
		unknownInsnNameStr = 'unknown %d Instructions (with unknown memonic) included:' % (len(unknownInsnNameSet))
		for i,insnName in enumerate(unknownInsnNameSet):
			if i&3 == 0:
				unknownInsnNameStr += '\n'
			try:
				unknownInsnNameStr += '%12s\t' % (insnName)
			except TypeError:
				print insnName
		unknownInsnNameStr += '\n\n'

		'write in file'
		fout = open(fname, 'w')
		fout.write(title)
		fout.write(errInsnNameStr)
		fout.write(unknownInsnNameStr)
		fout.flush()
		fout.close()


	def insnCntCheck(self, fname):
		lines = self.setSourceFile(fname)
		if fname not in self.begPos_cache:
			begPos = self.getBegPosOfBin(lines)
			self.begPos_cache[fname] = begPos
		else:
			begPos = self.begPos_cache[fname]
		binCodeList, insnNameList = self.disassembleBinCode(begPos, lines)
		insnCntDict = defaultdict(int)
		for insnName in insnNameList:
			insnCntDict[insnName] += 1
		return insnCntDict


	def saveCntResult(self, fname, insnCntDict):
		'generate the title of log'
		title = 'Result of Cnt Check:\n\t\t' + self.getTimeStamp() + '\n\t\t\t@Turf1013\n\n'
		'cnt Insn'
		cntStr = 'find %d Instructions included:\n' % (len(insnCntDict))
		for insnName,cnt in insnCntDict.items():
			cntStr += '%12s: %6d\n' % (insnName, cnt)
		fout = open(fname, 'w')
		fout.write(title)
		fout.write(cntStr)
		fout.flush()
		fout.close()


	def insnBaseCheck(self, fname):
		'Base Check included opcode & xo check and unknown insn check'
		lines = self.setSourceFile(fname)
		begPos = self.getBegPosOfBin(lines)
		binCodeList, insnNameList = self.disassembleBinCode(begPos, lines)
		errInsnNameSet = set()
		unknownInsnNameSet = set()
		for binCode,insnName in zip(binCodeList, insnNameList):
			if insnName in self.insnDict:
				aInsnDict = self.insnDict[insnName]
				op, xo = aInsnDict[insn_op], aInsnDict[insn_xo]
				insnFormDict = aInsnDict[insn_form]
				oop, xxo = 0, 0
				flag = True
				if insn_op in insnFormDict:
					beg, end = insnFormDict[insn_op]
					oop = self.getValue(binCode, beg, end)
					flag &= (oop==op)
				if insn_xo in insnFormDict:
					beg, end = insnFormDict[insn_xo]
					xxo = self.getValue(binCode, beg, end)
					flag &= (xxo==xo)
				if not flag:
					errInsnNameSet.add((insnName, oop, xxo))
			else:
				unknownInsnNameSet.add(insnName)
		return errInsnNameSet, unknownInsnNameSet


	def disassembleBinCode(self, begPos, testLines):
		'disassemble the Binary Code of linecache'
		binCodeList = []
		insnNameList = []
		for nline,line in enumerate(testLines):
			if len(line)<=begPos or line[begPos]!=':':
				continue
			line = line[begPos+1:]
			
			# get the bin code
				# use maxSplit to fast split, the first element of split is always null
			wordList = self.re_binCode.split(line, maxsplit=self.nWord+1)[1:]
			# print 'wordList', wordList
			if len(wordList)<self.nWord:
				continue
			try:
				wordValue = [int(wordList[j], 16) for j in range(self.nWord)]
			except ValueError:
				# print 'nline =', nline, 'content =', line
				continue
			binCode = sum(
				map(lambda x,y: x<<y, wordValue, self.shiftList)
			)
			binCodeList.append(binCode)
			
			# get the mnemonic
			line = wordList[self.nWord]
			insnName = self.re_binCode.split(line, maxsplit=1)[0]
			insnNameList.append(insnName)
		print 'binCodeList =', binCodeList, 'insnNameList =', insnNameList
		return binCodeList, insnNameList


	def getBegPosOfBin(self, lines):
		# select nTest consecutive lines to get
		# 		Begin Position of Bin Code
		testLines = lines[:self.nTest]
		begPosDict = defaultdict(int)
		for line in testLines:
			begPos = line.find(':')
			if begPos >= 0:
				begPosDict[begPos] += 1
		maxCnt = -1
		maxBegPos = 0
		for begPos,Cnt in begPosDict.items():
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
	print 'none'
	overallCheck = overall_check()
	print overallCheck
