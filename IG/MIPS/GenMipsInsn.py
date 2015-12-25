from random import randint
import shutil
import string

MInsn = [
	["lb"],
	["lbu"],
	["lh"],
	["lhu"],
	["lw"],
	["sb"],
	["sh"],
	["sw"],
]

RInsn = [
	["add"],
	["addu"],
	["sub"],
	["subu"],
	["slt"],
	["sltu"],
	["srl"],
	["sra"],
	["sll"],
	["sllv"],
	["srav"],
	["srlv"],
	["and"],
	["or"],
	["xor"],
	["nor"],
]

IInsn = [
	["addi"],
	["addiu"],
	["andi"],
	["ori"],
	["xori"],
	["lui"],
	["slti"],
	["sltiu"],
]

BInsn = [
	["beq"],
	["bne"],
	["bgez"],
	["blez"],
	["bgtz"],
	["bltz"],
]

insnDict = {
	"R_Insn" : RInsn,
	"I_Insn" : IInsn,
	"M_Insn" : MInsn,
	"B_Insn" : BInsn,
}

	
if __name__ == "__main__":
	tabn = 1
	pre = "\t" * tabn
	with open("data.out", "w") as fout:
		line = "\tInsn* insn;\n"
		fout.write(line)
		
		for className, insnList in insnDict.iteritems():
			fout.write("\n\n\t// initialize %s\n" % className)
			blk = []
			for args in insnList:
				insnName, = args
				if className == "R_Insn":
					if insnName=="sll" or insnName=="sra" or insnName=="srl":
						blk.append("\tinsn = new %s(string(\"%s\"), 2);" % (className, insnName))
						# blk.append("\tinsn->setR1(-1);")
					else:
						blk.append("\tinsn = new %s(string(\"%s\"), 3);" % (className, insnName))
					blk.append("\trvc.pb(insn);");
					blk.append("\twvc.pb(insn);");
					
				elif className == "I_Insn":
					if insnName == "lui":
						blk.append("\tinsn = new %s(string(\"%s\"), 1);" % (className, insnName))
						# blk.append("\tinsn->setR1(-1);")
						blk.append("\twvc.pb(insn);");
					else:
						blk.append("\tinsn = new %s(string(\"%s\"), 2);" % (className, insnName))
						blk.append("\trvc.pb(insn);");
						blk.append("\twvc.pb(insn);");
					
				elif className == "M_Insn":
					if insnName[1] == 'b':
						bn = 1
					elif insnName[1] == 'h':
						bn = 2
					else:
						bn = 4
					blk.append("\tinsn = new %s(string(\"%s\"), 1, %d);" % (className, insnName, bn))
					blk.append("\tinsn->setR1(0);");
					if insnName.startswith("l"):
						blk.append("\twvc.pb(insn);");
					
				elif className == "B_Insn":
					if insnName.endswith('z'):
						blk.append("\tinsn = new %s(string(\"%s\"), 1);" % (className, insnName))
						# blk.append("\tinsn->setR2(-1);")
					else:
						blk.append("\tinsn = new %s(string(\"%s\"), 2);" % (className, insnName))
					blk.append("\trvc.pb(insn);");
				
				blk.append("")
			fout.write("\n".join(blk) + "\n\n")
			