import re
from collections import defaultdict
from collections import OrderedDict

class constForCompress:
	CTRL_TOKEN = "// control Signal"
	x = 0
	
class CFCS(constForCompress):
	pass
	

def dump(desFileName, lines):
	with open(desFileName, "w") as fout:
		fout.write("".join(lines))
		fout.write("\n")

		
def fetch(srcFileName):
	ret = []
	with open(srcFileName, "r") as fin:
		ret = fin.readlines()
		ret.append('\n')
	return ret
	
	
def mycomp(t1, t2):
	exp1, exp2 = t1[-1], t2[-1]
	stg1 = exp1[exp1.index('_')+1:]
	stg2 = exp2[exp2.index('_')+1:]
	return cmp(stg1, stg2)

	
def mycomp2(t1, t2):
	exp1, exp2 = t1[-1], t2[-1]
	stg1 = int(exp1[exp1.rindex('_')+1:])
	stg2 = int(exp2[exp2.rindex('_')+1:])
	return cmp(stg1, stg2)
	

		
def genAssign(pairs):
	assignList = []
	for exp, wire in pairs:
		assignLine = "\tassign %s = %s;\n" % (wire, exp)
		assignList.append(assignLine)	
	assignList.append("\n")
	assignList.append("\n")
	
	wireList = []
	line = "\twire "
	for i,(exp, wire) in enumerate(pairs):
		line += wire
		if i==len(pairs)-1 or (i>0 and i%6==0):
			line += ";\n"
			wireList.append(line)
			line = "\twire "
		else:
			line += ", "
	wireList.append("\n")
	wireList.append("\n")
	
	ret = wireList + assignList
	return ret
	
	
def genAssignMean(d):
	pairs = sorted(d.items(), mycomp)
	ret = genAssign(pairs)
	return ret
	
	
def genAssignMess(d):
	pairs = sorted(d.items(), mycomp2)
	ret = genAssign(pairs)
	return ret
	
	
def ishex(s):
	pat = re.compile(r"^[0-9a-h\_]+$")
	mobj = pat.search(s)
	return mobj is not None
	
	
def isConst(s):
	n = len(s)
	i = 0
	while i<n and s[i].isdigit():
		i += 1
	if i>=n:
		return True
	if s[i]!="'":
		return False
	i += 1
	if i+1>=n:
		return False
	if s[i]=='b':
		i += 1
		while i<n and (s[i]=='0' or s[i]=='1'):
			i += 1
		return i>=n
	elif s[i]=='d':
		return s[i+1:].isdigit()
	elif s[i]=='h':
		return ishex(s[i+1:])
	else:
		return False
		
		
def update(line, expDict):
	# print len(expDict)
	# print line
	L = line.split()
	stage = ''
	insn = ''
	for e in L:
		if e.startswith('`'):
			insn = e[1:e.rindex('_')].capitalize()
		elif e.startswith('Instr'):
			stage = e[e.index('_')+1:e.index('`')]
	exp = "%s_Instr_%s" % (insn, stage)
	expDict[line] = exp
	return exp		
	
	
def isBypassCond(line):
	vec = line.split('&&')
	return len(vec) >= 5
	
	
class BypassPair(object):
	
	def __init__(self, stg, addr, sel):
		self.stg = stg
		self.addr = addr
		self.sel = sel
		
	def __hash__(self):
		return hash(self.__str__())
		
	def __str__(self):
		return "%s: %s @%s" % (self.sel, self.addr, self.stg)
		
	def __repr__(self):
		return self.__str__()
		
		
	def __eq__(self, other):
		return self.addr==other.addr and self.sel==other.sel and self.stg==other.stg
		
	def __cmp__(self, other):
		return cmp(self.stg, other.stg)
	
	
def transferBypassCond(rawLine):
	line = rawLine[rawLine.index('(')+1:rawLine.rindex(')')]
	line = line.replace('(', '')
	line = line.replace(')', '')
	line = "".join(line.split())
	return line
	
def transferBypassSel(rawLine):
	return rawLine.strip()
	
	
def transferBypassLine(lines):
	condLine, selLine = lines
	return transferBypassCond(condLine), transferBypassSel(selLine)
	
	
def transferCondLine(line):
	return line.split("&&")
	ret = []
	length = len(line)
	i = 0
	while i<length:
		if line[i]=='(':
			e = i + 1
			while e<length and line[e]!=')':
				e += 1
			ret.append(line[i+1:e])
			i = e + 1
		elif line[i]=='&':
			i += 1
		else:
			e = i
			while e<length and line[e]!='&':
				e += 1
			ret.append(line[i:e])
			i = e + 1
	return ret		
	
	
def updateBypassLine(lines, expDict, condDict):
	# ~clr_{wInsn} && ~clr_{rInsn} && {rInsn} && {wInsn} && Addr_{rInsn}==Addr_{wInsn} && Addr_{rInsn}!=0
	condLine, selLine = transferBypassLine(lines)
	# print condLine
	condList = transferCondLine(condLine)
	i = 0
	n = len(condList)
	addrCondList = []
	rInsn, wInsn = None, None
	while i < n:
		if i==0:
			# print lines[0]
			# print condLine
			# print condList
			# ~clr_{wInsn} && ~clr_{rInsn}
			# if not isConst(condList[i+1]):
				# condDict['0'] = "%s | %s" % (condList[i][1:], condList[i+1][1:])
			# else:
				# condDict['0'] = "%s" % (condList[i][1:])
			i += 1
		elif i==2:
			# {rInsn}
			rInsn = condList[i]
		elif i==3:
			# {wInsn}
			wInsn = condList[i]
		elif not isConst(condList[i]):
			# {Addr}
			# print condList[i]
			if condList[i] in expDict:
				val = expDict[condList[i]]
			else:
				val = "addr_Exp_%s" % (len(expDict))
				expDict[condList[i]] = val
			addrCondList.append(val)
		i += 1
	stg = condList[0][condList[0].index('_')+1:]
	addr = " && ".join(addrCondList)
	sel = selLine.strip().split()[-1][:-1]
	bp = BypassPair(stg, addr, sel)
	if 'rInsn' not in condDict[bp]:
		condDict[bp]['rInsn'] = set()	
	if 'wInsn' not in condDict[bp]:
		condDict[bp]['wInsn'] = set()
		
	condDict[bp]['rInsn'].add(rInsn)
	condDict[bp]['wInsn'].add(wInsn)
	# print addrCondList
	# print addr
	# print "".join(lines) + "\n"
	# print bp
	# print 
	# CFCS.x += 1
	
			
def parseDesPort(lines):
	for i in xrange(len(lines)):
		line = lines[i].lstrip()
		if line.startswith("if"):
			line = lines[i+1].strip()
			return line.split()[0]
	return ""
	
	
def	getInteger(s):
	s = s.strip()
	slen = len(s)
	ret = 0
	i = 0
	while i<slen and s[i].isdigit():
		ret = ret*10 + int(s[i])
		i += 1
	return ret
	
	
def	parseDesWidth(lines):
	for i in xrange(len(lines)):
		line = lines[i].lstrip()
		if line.startswith("if"):
			line = lines[i+1].strip()
			return getInteger(line.split()[2])
	return 1

	
	
def blockToAssign(desWidth, desPort, condDict):
	# zeroCond = condDict['0']
	# condDict.pop('0')
	keys = sorted(condDict.keys())
	ret = ""
	ret += "\twire [0:%d] %s_tmp;\n" % (desWidth-1, desPort)
	ret += "\tassign %s_tmp =\n" % (desPort)
	# ret += "\t\t(%s) ? 0:\n" % (zeroCond)
	for bp in keys:
		insnDict = condDict[bp]
		rInsnCond = "(%s)" % (" | ".join(insnDict['rInsn']))
		wInsnCond = "(%s)" % (" | ".join(insnDict['wInsn']))
		if bp.addr:
			cond = "~clr_%s & %s &\n\t\t\t %s &\n\t\t\t %s" % (bp.stg, bp.addr, rInsnCond, wInsnCond)
		else:
			cond = "~clr_%s &\n\t\t\t %s &\n\t\t\t %s" % (bp.stg, rInsnCond, wInsnCond)
		ret += "\t\t(%s) ? %s:\n" % (cond, bp.sel)
	ret += "\t\t0;\n"
	ret += "\talways @(%s_tmp) begin\n" % (desPort)
	ret += "\t\t%s = %s_tmp;\n" % (desPort, desPort)
	ret += "\tend // end always\n\n"
	return ret
	
	
def compressBlock(lines, expDict):
	condDict = defaultdict(dict)
	i = 0
	n = len(lines)
	while i < n:
		if isBypassCond(lines[i]):
			updateBypassLine(lines[i:i+2], expDict, condDict)
			i += 2
		i += 1
	desPortName = parseDesPort(lines)
	desWidth = parseDesWidth(lines)
	return [blockToAssign(desWidth, desPortName, condDict)]
	
	
def compressBypass(lines, expDict):
	ret = []
	n = len(lines)
	i = 0
	while i < n:
		if "Logic of" in lines[i] and "Bmux_sel" in lines[i]:
			j = i
			while i < n:
				line = lines[i].strip()
				if not line:
					break
				i += 1
			block = lines[j+1:i]
			ret.append(lines[j])
			ret += compressBlock(block, expDict)
		else:
			ret.append(lines[i])
		i += 1
	return ret
	
def compressStall(lines, expDict):
	ret = []
	n = len(lines)
	i = 0
	while i < n:
		if "Logic of stall" in lines[i]:
			j = i
			while i < n:
				line = lines[i].strip()
				if not line:
					break
				i += 1
			block = lines[j+1:i]
			ret.append(lines[j])
			ret += compressBlock(block, expDict)
		else:
			ret.append(lines[i])
		i += 1
	return ret
		
		
def compressNormal(lines, assignDict):
	# Instr_E`OP == `MTHI_OP && Instr_E`FUNCT == `MTHI_FUNCT
	pat = re.compile("Instr_(?P<stage>\w+)`OPCD == `(?P<Insn>\w+)_OPCD(\s*&&\s*Instr_\w+`\w+ == `(?P<Insn2>\w+)_\w+)?")
	ret = []
	def expRepl(mobj):
		return update(mobj.group(0), assignDict)
	for line in lines:
		mobj = pat.search(line)
		if mobj:
			# print mobj.group(0)
			ret.append(pat.sub(expRepl, line))
		else:
			ret.append(line)
	return ret
	
	
def compressExp(lines, expDict):
	ret = []
	n = len(lines)
	i = 0
	while i < n:
		if "Logic of" in lines[i]:
			j = i
			while i < n:
				line = lines[i].strip()
				if not line:
					break
				i += 1
			block = lines[j+1:i]
			ret.append(lines[j])
			ret += compressNormal(block, expDict)
		else:
			ret.append(lines[i])
			i += 1
	return ret
	
def getPortName(line):
	words = line.split()
	for word in words[::-1]:
		if word and not word.startswith("*"):
			return word
	return None
	
	
def getCond(line):
	words = line.split()
	ret = ""
	ignoreList = [
		"else",
		"if",
		"begin",
		"(",
		")"
	]
	for word in words:
		if word not in ignoreList:
			ret += word
	return ret
		
	
def getVal(line):
	words = line.split()
	ret = words[-1]
	if ret.endswith(';'):
		ret = ret[:-1]
	return ret
	
	
def getWidth(condDict, portName):
	for res in condDict.iterkeys():
		if "'" in res:
			x = int(res[:res.index("'")])
			return "[0:%d]" % (x-1)
	if "wr" in portName:
		return "[0:0]"
	if "Op" in portName:
		prefix = portName[:portName.index("Op")+2]
		prefix = prefix[:-3] + "Op"
		return "[0:`%s_WIDTH-1]" % (prefix)
	return "[0:0]"
	
	
def toCondition(condList):
	ret = ""
	for i,cond in enumerate(condList):
		if i==0:
			ret += "(%s)" % (cond)
		else:
			ret += "||(%s)" % (cond)
	return ret
	
	
def compressAlways(lines):
	portName = getPortName(lines[0])
	n = len(lines)
	i = 1
	condDict = OrderedDict()
	while i < n:
		if "if" in lines[i]:
			cond = getCond(lines[i])
			if cond != '0':
				val = getVal(lines[i+1])
				if val not in condDict:
					condDict[val] = []
				condDict[val].append(cond)
			i += 2
		else:
			i += 1
	width = getWidth(condDict, portName)
	ret = ""
	ret += "\twire %s %s_tmp;\n" % (width, portName)
	ret += "\tassign %s_tmp =\n" % (portName)
	for res, condList in condDict.iteritems():
		ret += "\t\t(%s) ? %s:\n" % (toCondition(condList), res)
	ret += "\t\t0;\n"
	ret += "\talways @( %s_tmp ) begin\n" % (portName)
	ret += "\t\t%s = %s_tmp;\n" % (portName, portName)
	ret += "\tend // end always\n\n"
	return ret;
	
	
def compressAgain(lines):
	n = len(lines)
	i = 0
	ret = []
	while i < n:
		if "Logic" in lines[i] and "Bmux" not in lines[i] and "stall" not in lines[i]:
			j = i
			while i < n:
				line = lines[i].strip()
				if not line:
					break
				i += 1
			block = lines[j:i]
			# ret.append(lines[j])
			ret += compressAlways(block)
		else:
			ret.append(lines[i])
			i += 1
	return ret;

	
def mergeAssign(lines, assigns):
	n = len(lines)
	i = 0
	ret = []
	while i < n:
		line = lines[i].lstrip()
		if line.startswith(CFCS.CTRL_TOKEN):
			ret = lines[:i] + assigns + ["\n\n"] + lines[i:]
			break
		i += 1
	if not ret:
		ret = lines + assigns
	return ret
	
	
def compress(lines):
	assignDict = dict()
	tmp = []
	ret = compressExp(lines, assignDict)
	tmp += genAssignMean(assignDict)
	assignDict.clear()
	ret = compressBypass(ret, assignDict)
	ret = compressStall(ret, assignDict)
	tmp += genAssignMess(assignDict)
	ret = compressAgain(ret)
	ret = mergeAssign(ret, tmp)
	return ret
	
	
if __name__ == "__main__":
	srcFileName = "F:\Qt_prj\hdoj\data.in"
	desFileName = "F:\Qt_prj\hdoj\data.out"
	lines = fetch(srcFileName)
	dump(desFileName, compress(lines))
	# print CFCS.x