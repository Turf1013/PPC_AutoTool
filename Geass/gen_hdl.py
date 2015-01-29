import re
from hdl_const import *


'Generate Verilog Code'
re_replaceQuote = re.compile(r'([\'"])')

def Gen_typeStatementCode(typeName, portsWithWidth, tabn):
	"""		
	@function: generate the variable type statement
	@param:
		typeName: name of the type statement
		portsWithWidth: [(portName, portWidth)...]
				type(portName) = str
				type(portWidth) = str
	"""
	retCode = ''
	pre = '\t' * tabn
	for portName, portWidth in portsWithWidth:
		if portWidth:
			retCode += "%s%s %s %s;\n"\
					% (pre, typeName, portWidth, portName)
		else:
			retCode += "%s%s %s;\n"\
					% (pre, typeName, portName)
	return retCode


def Gen_wireStatementCode(portsWithWidth, tabn):
	return Gen_typeStatementCode(WIRE, portsWithWidth, tabn)
	

def Gen_regStatementCode(portsWithWidth, tabn):
	return Gen_typeStatementCode(REG, portsWithWidth, tabn)


def Gen_inputStatementCode(portsWithWidth, tabn):
	return Gen_typeStatementCode(INPUT, portsWithWidth, tabn)


def Gen_outputStatementCode(portsWithWidth, tabn):
	return Gen_typeStatementCode(OUTPUT, portsWithWidth, tabn)


def Gen_initialBlockCode(solution, tabn):
	pre = '\t' * tabn
	solPre = ';\n' + pre + "\t"
	retCode = pre + '%s %s\n' % (INITIAL, BEGIN)
	if isinstance(solution, str):
		solsCodeList = solution[:-1].split(";")
	elif isinstance(solution, list):
		solsCodeList = solution
	else:
		raise TypeError("Gen_initialBlock's solution should be str or list")
		return ''
	retCode += pre + '\t%s;\n' % (solPre.join(solsCodeList))
	return retCode
	

def Gen_alwaysBlockCode(condExp, solutions, elseSolution=None, triggerCond='*', tabn=1):
	if len(condExp)!=len(solutions) or len(solutions)==0:
		return '\t'*tabn + 'gen always block wrong'
	pre = '\t' * tabn
	solPre = ';\n' + pre + '\t'*2
	retCode = pre + '%s @( %s ) %s\n' %\
					(ALWAYS, triggerCond, BEGIN)
	ifNum = 0
	for i,cond in enumerate(condExp):
		sol = solutions[i]
		if isinstance(cond, tuple):
			condCode = Gen_condExpCode(cond)
		else:
			condCode = cond
		if condCode:
			retCode += pre + '\t'
			retCode += "%s ( %s ) %s\n" % (ELSEIF, condCode, BEGIN)\
				 if ifNum else "%s ( %s ) %s\n" % (IF, condCode, BEGIN)
			ifNum += 1
		if isinstance(sol, str):
			solsCodeList = sol[:-1].split(";")
		elif isinstance(sol, list):
			solsCodeList = sol
		else:
			raise TypeError("Gen_alwaysBlock's solution should be str or list")
			return ''
		solsCode = solPre.join(solsCodeList)
		retCode += pre + "\t\t%s;\n" % (solsCode)
		retCode += pre + "\t%s\n" % (END)
	if elseSolution:
		if isinstance(elseSolution, str):
			solsCodeList = elseSolution[:-1].split(";")
		elif isinstance(elseSolution, list):
			solsCodeList = elseSolution
		else:
			raise TypeError("Gen_alwaysBlock's else should be str or list")
			return ''
		solsCode = solPre.join(solsCodeList)
		retCode += pre + "\t%s %s\n" % (ELSE, BEGIN)
		retCode += pre + "\t\t%s;\n" % (solsCode)
		retCode += pre + "\t%s\n" % (END)
	retCode += pre + "%s // end always\n" % (END)
	return retCode
	

def Gen_assignCode(desVarName, condExp, tabn):
	"""
	@function: generate assign line
	@param:
		desName: name of desVar
		condExp: condition expression tuple
	"""
	retCode = ""
	pre = "\t" * tabn
	condCode = ""
	if isinstance(condExp, tuple):
		condCode = Gen_condExpCode(condExp)[1:-1]
	else:
		condCode = condExp
	assignCode = "%s %s = %s;\n" % (ASSIGN, desVarName, condCode)
	retCode += pre + assignCode
	return retCode

def Gen_condExpCode(condExp):
	"""
	@function: Generate condExp
	you can use any logic or arithmetic flag, even bracket
	"""
	try:
		if not isinstance(condExp, tuple):
			raise TypeError("Gen_condExpCode TypeError, should be tuple")
	except TypeError:
		return ''
	retCode = re_replaceQuote.sub('', str(condExp))
	return ''.join(retCode.split(','))

def Gen_includeCode(includeList):
	ret = ''
	for fname in includeList:
		ret += '%s "%s"\n' % (INCLUDE, fname)
	return ret

def Gen_moduleCode(modName, portList):
	'generate module statement code'
	ret = ''
	ret += '%s %s (' % (MODULE, modName)
	for i,port in enumerate(portList[:-1]):
		if i%4 == 0:
			ret += '\n\t'
		ret += '%s, ' % (port)
	if len(portList)%4 == 1:
		ret += '\n\t'
	ret += '%s\n' % (portList[-1])
	ret += ');\n\n'
	return ret
	
def Gen_endmoduleCode():
	return ENDMODULE + '\n'

if __name__ == "__main__":
	c = ("c", "||", "D")
	ta = ("a", "&&", "b", "&&", c)
	print Gen_Verilog.Gen_assignCode("PCWr", ta, 1)