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
		self.hasSetWanted = False

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
		
	def saveCollectResult(self, fname, collectDict):
		'generate the title of log'
		title = 'Result of field Collect:\n\t\t' + self.getTimeStamp() + '\n\t\t\t@Turf1013\n\n'
		resultStr = ''
		for fieldName,valList in collectDict.iteritems():
			valSet = sorted(set(valList))
			resultStr += '[%s] => %s:\n' % (fieldName, str(valSet))
			resultStr += '\ttotal = %d\n' % (len(valList))
			for val in valSet:
				resultStr += '\t%d: %d\n' % (val, valList.count(val))
			resultStr += '\n\n'
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
	
	
	def handle_SPR(self, val):
		"""
		though [SPR] from 11 to 20(included)
		buf sprn = {SPR[5:9], SPR[4:0]}
		"""
		mask = 992	# 31<<5
		return ( (val&mask)>>5 ) | ( (val<<5)&mask )
		
		
	def insnCondCollect(self, fname):
		'filter the insn by mnemonic'
		binCodeList = self.insnFetch(fname, self.insnName)
		# print 'binCodeList =\n', binCodeList
		'get the insnBinCode fits the condDict'
		validBinCodeList = filter(self.condInvalid, binCodeList)
		# print 'validBinCodeList =\n', validBinCodeList
		retDict = dict()
		for fieldName in self.wantedList:
			valList = []
			# print 'fieldName =', fieldName
			# print 'insnForm =', self.insnFormDict
			if fieldName in self.insnFormDict:
				# print 'fieldName =', fieldName
				fieldBeg, fieldEnd = self.insnFormDict[fieldName]
				# print 'fieldBeg =', fieldBeg, 'fieldEnd =', fieldEnd
				for binCode in validBinCodeList:
					# print 'binCode =', binCode
					fieldVal = self.getValue(binCode, fieldBeg, fieldEnd)
					if fieldName == 'SPR':
						fieldVal = self.handle_SPR(fieldVal)
					valList.append(fieldVal)
			retDict[fieldName] = valList
		return retDict

		
	def condInvalid(self, binCode):
		if len(self.cond)==0:
			return True
		for fieldName,fieldFunc in self.cond.items():
			fieldBeg, fieldEnd = self.insnFormDict[fieldName]
			fieldVal = self.getValue(binCode, fieldBeg, fieldEnd)
			if not fieldFunc(fieldVal):
				return True
		return False


	def insnFetch(self, fname, desInsnName):
		'cond Check filter the insn using mnemonic(lower)'
		lines = self.setSourceFile(fname)
		begPos = self.getBegPosOfBin(lines)
		binCodeList, insnNameList = self.disassembleBinCode(begPos, lines)
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
				self.formDict = self.insnDict[self.insnName]
				self.insnFormDict = self.formDict[insn_form]
				self.cond = {}
				for key,func in cond.iteritems():
					if key==insn_MainKey:
						continue
					if key in self.insnFormDict:
						self.cond[key] = func
					else:
						print '%s not in Field of %s' % (key, self.insnName)	
				self.hasSetCond = True
			else:
				print '%s not exists' % (self.insnName)

	def setWanted(self, wantedList):
		if isinstance(wantedList, list):
			self.hasSetWanted = True
			self.wantedList = [item.upper() for item in wantedList]
		
if __name__ == '__main__':
	from ppc_insnFormat import *
	print I_FormDict
	