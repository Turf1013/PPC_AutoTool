# -*- coding: utf-8 -*-
import logging
from decorator import accepts, returns

class constForVerilog:
	INPUT = 1
	OUPUT = 0
	MODULE = "module"
	ENDMODULE = "endmodule"
	OP = "+-*/"
	moduleIgnoreList = [
		"FF",
		"FFW",
		"mux2",
		"mux4",
		"mux8",
		"mux16",
		"mux32",
		"mux64",
	]
	DEFINE = "`define"
	DEFINE_SUFFIX = "_def"
	re_rtlConst = re.compile(r"`\w+|\d+")
	re_rtlVariable = re.compile(r"[\`\'\.\w]+")
	re_rtlNumber = re.compile(r"^\d+$")
	re_hdlNumber = re.compile(r"^\d+'(b[01]+|d\d+|h[a-f\d]+)$")
	re_hdlConst  = re.compile(r"^`[\_\w]+$")

	
class CFV(constForVerilog):
	pass


class Parser:
	
	@staticmethod
	@accepts(str)
	@returns(dict)
	def ParseDefnDict(filename):
		ret = dict()
		with open(filename, "r") as fin:
			for line in fin:
				line = line.strip()
				if not line.startswith(CFV.DEFINE):
					continue
				L = line.split()
				if len(L) != 3:
					continue
				ret[L[1]] = L[2]
		return ret
		
	
	@staticmethod
	@accepts(str, dict)
	@returns(int)
	def ParseExp(s, d):
		s = "".join(s.split())
		n, i, e, var = len(s), 0, "", ""
		while i < n:
			if s[i] in '(':
				e += s[i]
			elif s[i] in ')+-*/':
				if var.isdigit():
					e += var
				elif var:
					assert var in d
					e += str(d[var])
				e += s[i]
				var = ''
			else:
				var += s[i]
			i += 1
		if var.isdigit():
			e += var
		else:
			assert var in d
			e += str(d[var])
		
		return eval(e)
		

	@staticmethod
	@accepts(str, dict)
	@returns(int)
	def ParseWidth(exp, widthDict):
		"""
			widthDict is a `defn dict` parse from `_def.v`, we just want `INT`.
			some supported type of exp:
			1. [31:0]
			2. [`INSTR-1:0]
			3. [`WA*(`WB+`WC)-X:`WA+Y]
		"""
		lexp, rexp = exp.split(':')
		return abs(Parser.ParseExp(lexp, widthDict) - Parser.ParseExp(rexp, widthDict)) + 1


	@staticmethod
	def ParseModule(lines, widthDict):
		modName = lines[0].split()[1]
		portList = []
		for line in lines[1:]:
			L = line.split()
			if L[0] == 'input':
				dir = CFV.INPUT
			elif L[0] == 'output':
				dir = CFV.OUTPUT
			else:
				continue
			if L[1].startswith('['):
				assert L[1].endswith(']')
				width = ParseWidth(L[1][1:-1], widthDict)
				subline = "".join(L[2:])
			else:
				subline = "".join(L[1:])
				width = 1
			
			portNames = map(lambda s:s[:-1] if s.endswith(';') else s, subline.split(','))
			portList += map(lambda name: Port(name, dir, width), portNames)
		return modMame, portList
			
	
	
		
class Generator:
		
	@staticmethod
	def GenInsnFieldDefn(fieldName):
		return "`" + fieldName.upper()
		
		
		
class Judger:
	
	@staticmethod
	def isVerilogFile(filename):
		return filename.endswith('.v')
	
	@staticmethod
	def isDefineFile(filename):
		return Judger.isVerilogFile(filename) and filename[:-2].endswith(CFV.DEFINE_SUFFIX)
		
	
class Transfer:
		
	@staticmethod
	def SrcToVar(src, suf=""):
		def repl(matchobj):
			val = matchobj.group(0)
			if CFV.re_rtlConst.match(val):
				return val
			else:
				return val + "_" + suf
		return CFV.re_rtlVariable.sub(repl, src.replace(".", "_"))
		
	
	@staticmethod
	def DesToVar(des, suf=""):
		if suf:
			return des.replace(".", "_") + "_" + suf
		else:
			return des.replace(".", "_")
			
			
	@staticmethod
	def SrcToList(src):
		m = CFV.re_rtlVariable.findall(src)
		m = filter(lambda s:not (CFV.re_rtlNumber.match(s) or CFV.re_hdlNumber.match(s) or CFV.re_hdlConst.match(s)), m)
		return m
	
	
class verilog(Parser, Generator, Judger, Transfer):
	pass
	
	