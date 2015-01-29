from auto_ppc_const import *
from hdl_const import *
import re

'This module is using to name port, module or something like that.'

def Gen_muxName(port, stageName, isbypass=False):
	portName = Gen_portName(port, stageName)
	if isbypass:
		return '%s_%s' % (portName, HDL_BYPASS)
	else:
		return '%s' % (portName)
	
def Gen_selName(port, stageName, isbypass=False):
	portName = Gen_portName(port, stageName)
	if isbypass:
		return '%s_%s_%s' % (portName, HDL_BYPASS, HDL_MUX_SEL)
	else:
		return '%s_%s' % (portName, HDL_MUX_SEL)
	
def Gen_PortAddrByPortName(portName, isWaddr=False):
	'used only for read and write port'
	modName, portName = portName.split(RTL_MODTOPORT)[:2]
	if isWaddr:
		'like GPR.waddr, SPR.waddr'
		return "%s.%s" % (modName, RTL_WADDR)
	else:
		if modName == portName:
			return "%s.%s" % (modName, RTL_RADDR)
		else:
			'like GPR.rd1, GPR.rd'
			return "%s.%s%s" %\
					(modName, RTL_RADDR, portName[len(RTL_RDPORT):])

def Gen_WdPortByRdPort(rdPort):
	'used for generate Write Port Name according to read Port Name'
	modName, portName = rdPort.split(RTL_MODTOPORT)[:2]
	return '%s.%s%s' % (modName, modName, RTL_WDPORT)

def Gen_instrGrpName(grpName, grpType, grpIndex):
	if isinstance(grpIndex, int):
		return '%s_%s_%d' % (grpName, grpType, grpIndex)
	else:
		return '%s_%s_%s' % (grpName, grpType, grpIndex)

re_rtlPort = re.compile(r'(.[a-zA-Z][\w.]*)')		
def Gen_portName(portNameExp, suffix=""):
	'Gen_portName is the most important name function'
	'suffix can be null or stageName'
	
	# nested function define to use gloval variable
	def Gen_OnePortName(matchobj):
		pname = matchobj.group(0)
		if pname[0] == '`' or pname[0] == '\'':
			return pname
			
		slice = pname.split('.')
		ret = ""
		if len(slice) < 2:
			if suffix:
				ret = pname + '_' + suffix
			else:
				ret = pname
			return ret
			
		if len(slice[0]) < len(slice[1]) and slice[1].startswith(slice[0]):
			ret = slice[1]
		else:
			ret = slice[0] + '_' + slice[1]
		if suffix:
			ret += '_' + suffix
		return ret
		
	return re_rtlPort.sub(Gen_OnePortName, portNameExp)
	
def Gen_INSTROfStage(stageName):
	return '%s_%s' % (HDL_INSTR, stageName)

def Gen_flushName(stageName):
	return '%s_%s' % (HDL_FLUSH, stageName)
	
def Gen_stallName(stageName):
	return "%s_%s" % (HDL_STALL, stageName)
	
def Gen_pipeRegWrName(stageName):
	return "%s_%s" % (HDL_PIPEREGWR, stageName)
	
if __name__ == "__main__":
	name = "PC.PCWr"
	print Gen_portName(name)
	name = "Instr[15:11]"
	print Gen_portName(name, "D")
	name = "(rA==0)?0:Instr"
	print Gen_portName(name, "E")
	name = "GPR.rd1"
	print Gen_portName(name, "F")
	name = "XER.XER[`x:0]"
	print Gen_portName(name, "W")