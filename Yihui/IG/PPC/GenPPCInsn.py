from random import randint
import shutil
import string

Br_Insn = [
	["B"],
	["BC"],
	["BCCTR"],
	["BCLR"],
]

CMP_Insn = [
	["CMP"],
	["CMPI"],
	["CMPL"],
	["CMPLI"],
]

CR_Insn = [
	["CRAND"],
	["CRANDC"],
	["CREQV"],
	["CRNAND"],
	["CRNOR"],
	["CROR"],
	["CRORC"],
	["CRXOR"],
]

GPR_I_Insn = [
	["ADDI"],
	["ADDIC"],
	["ADDIC."],
	["ADDIS"],
	["ANDIS."],
	["ANDI."],
	["ORI"],
	["ORIS"],
	["SUBFIC"],
	["XORI"],
	["XORIS"],
	["MULLI"],
]

GPR_MF_Insn = [
	["MFCR"],
	["MFSPR"],
	["MFMSR"],
]

GPR_R_Insn = [
	["ADD"],
	["ADDC"],
	["ADDE"],
	["AND"],
	["ANDC"],
	["EQV"],
	["NAND"],
	["NOR"],
	["OR"],
	["ORC"],
	["SLW"],
	["SRAW"],
	["SRAWI"],
	["SRW"],
	["SUBF"],
	["SUBFC"],
	["SUBFE"],
	["XOR"],
	["MULHW"],
	["MULHWU"],
	["MULLW"],
	["DIVW"],
	["DIVWU"],
]

GPR_R2_Insn = [
	["CNTLZW"],
	["EXTSB"],
	["EXTSH"],
	["NEG"],
	["ADDME"],
	["ADDZE"],
	["SUBFME"],
	["SUBFZE"],
]

LD_Insn = [
	["LBZ"],
	["LHZ"],
	["LWZ"],
	["LHA"],
]

LDU_Insn = [
	["LBZU"],
	["LHZU"],
	["LHAU"],
	["LWZU"],
]

LDUX_Insn = [
	["LBZUX"],
	["LHZUX"],
	["LHAUX"],
	["LWZUX"],
]

LDX_Insn = [
	["LBZX"],
	["LHZX"],
	["LWZX"],
	["LHAX"],
	["LHBRX"],
	["LWBRX"],
]

MCRF_Insn = [
	["MCRF"],
]

MTCRF_Insn = [
	["MTCRF"],
]

MTMSR_Insn = [
	["MTMSR"],
]

MTSPR_Insn = [
	["MTSPR"],
]

RLW_Insn = [
	["RLWIMI"],
	["RLWINM"],
	["RLWNM"],
]

ST_Insn = [
	["STB"],
	["STH"],
	["STW"],
]

STU_Insn = [
	["STBU"],
	["STHU"],
	["STWU"],
]

STUX_Insn = [
	["STBUX"],
	["STHUX"],
	["STWUX"],
]

STX_Insn = [
	["STBX"],
	["STHX"],
	["STWX"],
	["STHBRX"],
	["STWBRX"],
]



insnDict = {
	"Br_Insn"     : Br_Insn,
	"CMP_Insn"    : CMP_Insn,
	"CR_Insn"     : CR_Insn,
	"GPR_I_Insn"  : GPR_I_Insn,
	"GPR_MF_Insn" : GPR_MF_Insn,
	"GPR_R_Insn"  : GPR_R_Insn,
	"GPR_R2_Insn" : GPR_R2_Insn,
	"LD_Insn"     : LD_Insn,
	"LD_Insn"     : LDU_Insn,
	"LDX_Insn"    : LDX_Insn,
	"LDX_Insn"    : LDUX_Insn,
	"MCRF_Insn"   : MCRF_Insn,
	"MTCRF_Insn"  : MTCRF_Insn,
	"MTMSR_Insn"  : MTMSR_Insn,
	"MTSPR_Insn"  : MTSPR_Insn,
	"RLW_Insn"    : RLW_Insn,
	"ST_Insn"     : ST_Insn,
	"ST_Insn"     : STU_Insn,
	"STX_Insn"    : STUX_Insn,
	"STX_Insn"    : STX_Insn,
}

	
if __name__ == "__main__":
	tabn = 1
	pre = "\t" * tabn
	with open("F:\Qt_prj\hdoj\data.out", "w") as fout:
		line = "\tInsn* insn;\n"
		fout.write(line)
		
		for className, insnList in insnDict.iteritems():
			fout.write("\n\n\t// initialize %s\n" % className)
			blk = []
			for args in insnList:
				insnName, = args
				insnName = insnName.lower()
				if className == "GPR_R_Insn":
					if insnName=="srawi":
						blk.append("\tinsn = new %s(string(\"%s\"), 2);" % (className, insnName))
						# blk.append("\tinsn->setR1(-1);")
					else:
						blk.append("\tinsn = new %s(string(\"%s\"), 3);" % (className, insnName))
					blk.append("\trvc.pb(insn);")
					blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
				
				elif className == "RLW_Insn":
					if insnName=="rlwimi" or insnName=="rlwinm":
						blk.append("\tinsn = new %s(string(\"%s\"), 2);" % (className, insnName))
						# blk.append("\tinsn->setR1(-1);")
					else:
						blk.append("\tinsn = new %s(string(\"%s\"), 3);" % (className, insnName))
					blk.append("\trvc.pb(insn);")
					blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				elif className == "GPR_MF_Insn":
					blk.append("\tinsn = new %s(string(\"%s\"), 1);" % (className, insnName))
					blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				elif className == "GPR_R2_Insn":
					blk.append("\tinsn = new %s(string(\"%s\"), 2);" % (className, insnName))
					blk.append("\trvc.pb(insn);")
					blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				elif className == "GPR_I_Insn":
					blk.append("\tinsn = new %s(string(\"%s\"), 2);" % (className, insnName))
					blk.append("\trvc.pb(insn);")
					blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				elif className=="LD_Insn" or className=="ST_Insn":
					if insnName[1] == 'b':
						bn = 1
					elif insnName[1] == 'h':
						bn = 2
					else:
						bn = 4
					blk.append("\tinsn = new %s(string(\"%s\"), 1, %d);" % (className, insnName, bn))
					blk.append("\tinsn->setR1(0);")
					if insnName.startswith("l"):
						blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
						
				elif className=="LDX_Insn" or className=="STX_Insn":
					if insnName[1] == 'b':
						bn = 1
					elif insnName[1] == 'h':
						bn = 2
					else:
						bn = 4
					blk.append("\tinsn = new %s(string(\"%s\"), 2, %d);" % (className, insnName, bn))
					blk.append("\tinsn->setR1(0);")
					if insnName.startswith("l"):
						blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				elif className == "Br_Insn":
					blk.append("\tinsn = new %s(string(\"%s\"), 0);" % (className, insnName))
					blk.append("\trvc.pb(insn);")
					# blk.append("\tdelete insn;")
				
				elif className == "CMP_Insn":
					blk.append("\tinsn = new %s(string(\"%s\"), 2);" % (className, insnName))
					blk.append("\twvc.pb(insn);")
					blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				elif className == "CR_Insn":
					blk.append("\tinsn = new %s(string(\"%s\"), 3);" % (className, insnName))
					blk.append("\trvc.pb(insn);")
					blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				elif className == "MCRF_Insn":
					blk.append("\tinsn = new %s(string(\"%s\"), 2);" % (className, insnName))
					blk.append("\trvc.pb(insn);")
					blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				elif className == "MTCRF_Insn":
					blk.append("\tinsn = new %s(string(\"%s\"), 1);" % (className, insnName))
					blk.append("\trvc.pb(insn);")
					blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				elif className == "MTMSR_Insn":
					blk.append("\tinsn = new %s(string(\"%s\"), 1);" % (className, insnName))
					blk.append("\trvc.pb(insn);")
					# blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				elif className == "MTSPR_Insn":
					blk.append("\tinsn = new %s(string(\"%s\"), 1);" % (className, insnName))
					blk.append("\trvc.pb(insn);")
					# blk.append("\twvc.pb(insn);")
					# blk.append("\tdelete insn;")
					
				blk.append("")
			fout.write("\n".join(blk) + "\n\n")
			