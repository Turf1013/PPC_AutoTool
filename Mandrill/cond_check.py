#!/usr/bin/env python
from ppc_const import *
from overall_check import *
from collections import OrderedDict, defaultdict
import re
import logging
import copy
import os
import linecache

'This file is only use for checking some field of insn'

class cond_check(overall_check):

	def __init__(self, insnWidth=32, bigEndian=True):
		super(cond_check, self).__init__(insnWidth, bigEndian)
		self.hasSetCond = False

	def saveCondResult(self, fname, totCnt, errCnt):
		errRate = errCnt*100./totCnt if totCnt>0 else 0
		
		'generate the title of log'
		title = 'Result of Cnt Check:\n\t\t' + self.getTimeStamp() + '\n\t\t\t@Turf1013\n\n'
		resultStr = 'total: %d, error: %d, errRate:%.2f%\n' % (totCnt, errCnt, errRate)
		fout = open(fname, 'w')
		fout.write(title)
		fout.write(resultStr)
		fout.flush()
		fout.close()


	def insnCondCheck(self, fname):
		'filter the insn by mnemonic'
		binCodeList = self.insnFetch(fname, self.insnName)
		'count the error number'
		totCnt = len(binCodeList)
		errCnt = 0
		if totCnt > 0:
			errCnt = reduce(
				lambda x,y:x+y, filter(self.condInvalid, binCodeList)
			)
		return totCnt, errCnt


	def condInvalid(self, binCode):
		for fieldName,fieldFunc in self.cond.items():
			fieldBeg, fieldEnd = self.formDict[fieldName]
			fieldVal = self.getValue(binCode, fieldBeg, fieldEnd)
			if not fieldFunc(fieldVal):
				return True
		return False


	def insnFetch(self, fname, desInsnName):
		'cond Check filter the insn using mnemonic(lower)'
		lines = self.setSourceFile(fname)
		begPos = self.getBegPosOfBin(lines)
		binCodeList, insnNameList = self.disassembleBinCode(lines)
		retBinCodeList = []
		for i, insnName in enumerate(insnNameList):
			if insnName == desInsnName:
				retBinCodeList.append(binCodeList[i])
		return retBinCodeList


	def setCond(self, cond):
		'consider the instance of cond'
		if isinstance(cond, dict):
			'if is a condition dict, supported checking mnemonic and its field'
			if insn_MainKey in cond:
				self.insnName = cond[insn_MainKey].lower()
				self.formDict = self.insnDict[insnName]
				self.cond = {}
				for key,func in cond:
					if key in self.formDict:
						self.cond[key] = func
					else:
						print '%s not in Field of %s' % (key, insnName)	
				self.hasSetCond = True
			else:
				print '%s not exists' % (insnName)


