#!/usr/bin/env python
from collections import OrderedDict

def fetchFormatDict(line):
	beg = line.find('(') + 1
	line = line[beg:]
	# get the name of Dict
	dictName = line[:line.find('_st')]
	beg = line.find(' ') + 1
	# insert the key with value
	line = line[beg:-3]
	wordList = line.split(', ')
	if len(wordList)%2 == 1:
		raise ValueError, "split function iswrong"
	formatDict = OrderedDict()
	beg = end = 0
	for i in range(0, len(wordList), 2):
		end = beg + int(wordList[i+1])
		formatDict[wordList[i]] = (beg, end)
		beg = end
	return dictName, formatDict

def genPyCode(dictName, formatDict, tabn=0):
	pre = '\t' * tabn
	ret = ''
	# add dict Name statement
	Fpos = dictName.find('_')
	dictName = dictName#dictName[:Fpos+1] + dictName[Fpos+1].lower() + dictName[Fpos+2:]
	print 'dictName =', dictName
	ret += '%s%sDict = {\n' % (pre, dictName)
	for k,v in formatDict.items():
		ret += "%s\t'%s' : %s,\n" % (pre, k, v)
	ret += '%s};\n' % (pre)
	return ret

if __name__ == '__main__':
	preOfCode = "FORM_STRUCT"
	fin = open("./data.in", "r")
	fout = open("./data.out", "w")
	lines = fin.readlines()
	tabn=0
	fin.close()
	slashCnt = 0
	formList = []
	for line in lines:
		if line[0] == '/':
			fout.write('#' + line[2:])
			slashCnt += 1
			continue
		if slashCnt == 2:
			slashCnt = 0
			if not line.startswith(preOfCode):
				continue
			dictName, formatDict = fetchFormatDict(line)
			pyCode = genPyCode(dictName, formatDict, tabn)
			formList.append(dictName)
			fout.write(pyCode+'\n\n')
	formDictCode = "%sPPC_FormDict = {\n" % ('\t'*tabn)
	for item in formList:
		formDictCode += "%s\t'%s' : %sDict,\n" % ('\t'*tabn, item, item)
	formDictCode += '%s};\n\n' % ('\t'*tabn)
	fout.write(formDictCode)
	fout.close()
