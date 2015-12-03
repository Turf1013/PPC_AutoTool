

def GenInsnLogic(insnList):
	opfield = "[0:5]"
	xofield = "[21:30]"
	ret = ""
	for insn in insnList:
		if insn.endswith("x"):
			opcd = "`" + insn.upper() + "_OPCD"
			xo = "`" + insn.upper() + "_XO"
			line = "assign %s = (instr%s == %s) && (instr%s == %s) ;\n" % (insn, opfield, opcd, xofield, xo)
			
		else:
			opcd = "`" + insn.upper() + "_OPCD"
			line = "assign %s = (instr%s == %s) ;\n" % (insn, opfield, opcd)
		ret += line
	return ret
	

if __name__ == "__main__":
	opfield = "[0:5]"
	xofield = "[21:30]"
	insnList = []
	with open("data.in", "r") as fin:
		for insn in fin:
			insnList.append( insn[:-1] )
	
	lines = GenInsnLogic(insnList)
	with open("data.out", "w") as fout:
		fout.write(lines)
	