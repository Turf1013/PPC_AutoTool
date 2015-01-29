from auto_ppc_const import *

def isSameModule(srcName, desName):	'check srcName & desName are in same module'
	return srcName.split(RTL_MODTOPORT)[0] ==\
			desName.split(RTL_MODTOPORT)[0]

def isDefine(name):
	return name[0] == '`'

def isValidAddrPair(raddr, waddr):
	if isDefine(raddr) and isDefine(waddr):
		return raddr == waddr
	else:
		return raddr != waddr
	
def isStallVector(rVector, wVector):
	'check read Vector occure stall with write Vector'
	rInstrGrp, raddr, rstage = rVector
	wInstrpGrp, waddr, (wstage, valid) = wVector
	return rstage<wstage and isValidAddrPair and not valid
	
def isBypassVector(rVector, wVector):
	'check read Vector occure stall with write Vector'
	rInstrGrp, raddr, rstage = rVector
	wInstrpGrp, waddr, (wstage, valid) = wVector
	return rstage<wstage and isValidAddrPair and valid
	
def isCtrlPort(portName):
	for suffix in RTL_CUSUFFIX:
		if portName.endswith(suffix):
			return True
	return False

HDL_GENPORT = [HDL_CLK, HDL_RST, HDL_INSTR]	
def isGeneralPort(port):
	for generalPort in HDL_GENPORT:
		if port.startswith(generalPort):
			return True
	return False
	