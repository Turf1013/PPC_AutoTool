#!/usr/bin/env python

'This file is about the insn format of PPC ISA'

# I-Form: 1 kind
# 6+24+1+1=32
I_FormDict = {
	'OPCD' = (0, 6),
	'LI' = (6, 30),
	'AA' = (30, 31),
	'LK' = (31, 32),
};


# B-Form: 1 kind
# 6+5+5+14+1+1=32
B_FormDict = {
	'OPCD' = (0, 6),
	'BO' = (6, 11),
	'BI' = (11, 16),
	'BD' = (16, 30),
	'AA' = (30, 31),
	'LK' = (31, 32),
};


# SC-Form: 1 kind
# 6+14+7+5=32
SC_FormDict = {
	'OPCD' = (0, 6),
	'Reserve0' = (6, 20),
	'LEV' = (20, 27),
	'Reserve1' = (27, 32),
};


# D-Form: 9 kinds
# 6+5+5+16=32
D_FormDict = {
	'OPCD' = (0, 6),
	'RT' = (6, 11),
	'RA' = (11, 16),
	'D' = (16, 32),
};


# DS-Fomr: 2 kinds
# 6+5+5+14+2=32
DS_FormDict = {
	'OPCD' = (0, 6),
	'RT' = (6, 11),
	'RA' = (11, 16),
	'DS' = (16, 30),
	'XO' = (30, 32),
};


# X-Form: 32 kinds
# 6+5+5+5+10+1=32
X_FormDict = {
	'OPCD' = (0, 6),
	'RT' = (6, 11),
	'RA' = (11, 16),
	'RB' = (16, 21),
	'XO' = (21, 31),
	'RC' = (31, 32),
};


# XL-Form: 4 kinds
# 6+5+5+5+10+1=32
XL_FormDict = {
	'OPCD' = (0, 6),
	'BT' = (6, 11),
	'BA' = (11, 16),
	'BB' = (16, 21),
	'XO' = (21, 31),
	'LK' = (31, 32),
};


# XFX-Form: 7 kinds
# 6+5+10+10+1=32
XFX_FormDict = {
	'OPCD' = (0, 6),
	'RT' = (6, 11),
	'SPR' = (11, 21),
	'XO' = (21, 31),
	'Reserve0' = (31, 32),
};


# XFL-Form: 1 kind
# 6+1+8+1+5+10+1=32
XFL_FormDict = {
	'OPCD' = (0, 6),
	'Reserve0' = (6, 7),
	'FLM' = (7, 15),
	'Reserve1' = (15, 16),
	'FRB' = (16, 21),
	'XO' = (21, 31),
	'RC' = (31, 32),
};


# XS-Form: 1 kind
# 6+5+5+5+9+1+1=32
XS_FormDict = {
	'OPCD' = (0, 6),
	'RS' = (6, 11),
	'RA' = (11, 16),
	'SH0' = (16, 21),
	'XO' = (21, 30),
	'SH1' = (30, 31),
	'RC' = (31, 32),
};


# XO-Form: 3 kinds
# 6+5+5+5+1+9+1=32
XO_FormDict = {
	'OPCD' = (0, 6),
	'RT' = (6, 11),
	'RA' = (11, 16),
	'RB' = (16, 21),
	'OE' = (21, 22),
	'XO' = (22, 31),
	'RC' = (31, 32),
};


# A-Form: 4 kinds
# 6+5+5+5+5+5+1=32
A_FormDict = {
	'OPCD' = (0, 6),
	'FRT' = (6, 11),
	'FRA' = (11, 16),
	'FRB' = (16, 21),
	'FRC' = (21, 26),
	'XO' = (26, 31),
	'RC' = (31, 32),
};


# M-Form: 2 kinds
# 6+5+5+5+5+5+1=32
M_FormDict = {
	'OPCD' = (0, 6),
	'RS' = (6, 11),
	'RA' = (11, 16),
	'RB' = (16, 21),
	'MB' = (21, 26),
	'ME' = (26, 31),
	'RC' = (31, 32),
};


# MD-Form: 2 kinds
# 6+5+5+5+6+3+1+1=32
MD_FormDict = {
	'OPCD' = (0, 6),
	'RS' = (6, 11),
	'RA' = (11, 16),
	'SH0' = (16, 21),
	'MB' = (21, 27),
	'XO' = (27, 30),
	'SH1' = (30, 31),
	'RC' = (31, 32),
};


# MDS-Form: 2 kinds
# 6+5+5+5+6+4+1=32
MDS_FormDict = {
	'OPCD' = (0, 6),
	'RS' = (6, 11),
	'RA' = (11, 16),
	'RB' = (16, 21),
	'MB' = (21, 27),
	'XO' = (27, 31),
	'RC' = (31, 32),
};


PPC_FormDict = {
	'I_Form' = I_FormDict,
	'B_Form' = B_FormDict,
	'SC_Form' = SC_FormDict,
	'D_Form' = D_FormDict,
	'DS_Form' = DS_FormDict,
	'X_Form' = X_FormDict,
	'XL_Form' = XL_FormDict,
	'XFX_Form' = XFX_FormDict,
	'XFL_Form' = XFL_FormDict,
	'XS_Form' = XS_FormDict,
	'XO_Form' = XO_FormDict,
	'A_Form' = A_FormDict,
	'M_Form' = M_FormDict,
	'MD_Form' = MD_FormDict,
	'MDS_Form' = MDS_FormDict,
};

insnDict = {
	'twi' = {
		'OPCD': 3,
		'XO': 0,
		'form': D_FormDict,
	};
	'mulli' = {
		'OPCD': 7,
		'XO': 0,
		'form': D_FormDict,
	};
	'subfic' = {
		'OPCD': 8,
		'XO': 0,
		'form': D_FormDict,
	};
	'cmpli' = {
		'OPCD': 10,
		'XO': 0,
		'form': D_FormDict,
	};
	'cmpi' = {
		'OPCD': 11,
		'XO': 0,
		'form': D_FormDict,
	};
	'addic' = {
		'OPCD': 12,
		'XO': 0,
		'form': D_FormDict,
	};
	'addic.' = {
		'OPCD': 13,
		'XO': 0,
		'form': D_FormDict,
	};
	'addi' = {
		'OPCD': 14,
		'XO': 0,
		'form': D_FormDict,
	};
	'addis' = {
		'OPCD': 15,
		'XO': 0,
		'form': D_FormDict,
	};
	'bc' = {
		'OPCD': 16,
		'XO': 0,
		'form': B_FormDict,
	};
	'sc' = {
		'OPCD': 17,
		'XO': 0,
		'form': SC_FormDict,
	};
	'b' = {
		'OPCD': 18,
		'XO': 0,
		'form': I_FormDict,
	};
	'mcrf' = {
		'OPCD': 19,
		'XO': 0,
		'form': XL_FormDict,
	};
	'bclr' = {
		'OPCD': 19,
		'XO': 16,
		'form': XL_FormDict,
	};
	'crnor' = {
		'OPCD': 19,
		'XO': 33,
		'form': XL_FormDict,
	};
	'rfi' = {
		'OPCD': 19,
		'XO': 50,
		'form': XL_FormDict,
	};
	'crxor' = {
		'OPCD': 19,
		'XO': 193,
		'form': XL_FormDict,
	};
	'crand' = {
		'OPCD': 19,
		'XO': 257,
		'form': XL_FormDict,
	};
	'bcctr' = {
		'OPCD': 19,
		'XO': 528,
		'form': XL_FormDict,
	};
	'rlwimi' = {
		'OPCD': 20,
		'XO': 0,
		'form': M_FormDict,
	};
	'rlwinm' = {
		'OPCD': 21,
		'XO': 0,
		'form': M_FormDict,
	};
	'rlwnm' = {
		'OPCD': 23,
		'XO': 0,
		'form': M_FormDict,
	};
	'ori' = {
		'OPCD': 24,
		'XO': 0,
		'form': D_FormDict,
	};
	'oris' = {
		'OPCD': 25,
		'XO': 0,
		'form': D_FormDict,
	};
	'xori' = {
		'OPCD': 26,
		'XO': 0,
		'form': D_FormDict,
	};
	'xoris' = {
		'OPCD': 27,
		'XO': 0,
		'form': D_FormDict,
	};
	'andi.' = {
		'OPCD': 28,
		'XO': 0,
		'form': D_FormDict,
	};
	'andis.' = {
		'OPCD': 29,
		'XO': 0,
		'form': D_FormDict,
	};
	'cmp' = {
		'OPCD': 31,
		'XO': 0,
		'form': X_FormDict,
	};
	'subfc' = {
		'OPCD': 31,
		'XO': 8,
		'form': XO_FormDict,
	};
	'addc' = {
		'OPCD': 31,
		'XO': 10,
		'form': XO_FormDict,
	};
	'mulhwu' = {
		'OPCD': 31,
		'XO': 11,
		'form': XO_FormDict,
	};
	'mfcr' = {
		'OPCD': 31,
		'XO': 19,
		'form': XFX_FormDict,
	};
	'lwarx' = {
		'OPCD': 31,
		'XO': 20,
		'form': X_FormDict,
	};
	'lwzx' = {
		'OPCD': 31,
		'XO': 23,
		'form': X_FormDict,
	};
	'slw' = {
		'OPCD': 31,
		'XO': 24,
		'form': X_FormDict,
	};
	'cntlzw' = {
		'OPCD': 31,
		'XO': 26,
		'form': X_FormDict,
	};
	'and' = {
		'OPCD': 31,
		'XO': 28,
		'form': X_FormDict,
	};
	'cmpl' = {
		'OPCD': 31,
		'XO': 32,
		'form': X_FormDict,
	};
	'subf' = {
		'OPCD': 31,
		'XO': 40,
		'form': XO_FormDict,
	};
	'andc' = {
		'OPCD': 31,
		'XO': 60,
		'form': X_FormDict,
	};
	'mulhw' = {
		'OPCD': 31,
		'XO': 75,
		'form': XO_FormDict,
	};
	'mfmsr' = {
		'OPCD': 31,
		'XO': 83,
		'form': X_FormDict,
	};
	'lbzx' = {
		'OPCD': 31,
		'XO': 87,
		'form': X_FormDict,
	};
	'neg' = {
		'OPCD': 31,
		'XO': 104,
		'form': XO_FormDict,
	};
	'nor' = {
		'OPCD': 31,
		'XO': 124,
		'form': X_FormDict,
	};
	'subfe' = {
		'OPCD': 31,
		'XO': 136,
		'form': XO_FormDict,
	};
	'adde' = {
		'OPCD': 31,
		'XO': 138,
		'form': XO_FormDict,
	};
	'mtcrf' = {
		'OPCD': 31,
		'XO': 144,
		'form': XFX_FormDict,
	};
	'mtmsr' = {
		'OPCD': 31,
		'XO': 146,
		'form': X_FormDict,
	};
	'stwcx.' = {
		'OPCD': 31,
		'XO': 150,
		'form': X_FormDict,
	};
	'stwx' = {
		'OPCD': 31,
		'XO': 151,
		'form': X_FormDict,
	};
	'wrteei' = {
		'OPCD': 31,
		'XO': 163,
		'form': X_FormDict,
	};
	'subfze' = {
		'OPCD': 31,
		'XO': 200,
		'form': XO_FormDict,
	};
	'addze' = {
		'OPCD': 31,
		'XO': 202,
		'form': XO_FormDict,
	};
	'stbx' = {
		'OPCD': 31,
		'XO': 215,
		'form': X_FormDict,
	};
	'addme' = {
		'OPCD': 31,
		'XO': 234,
		'form': XO_FormDict,
	};
	'mullw' = {
		'OPCD': 31,
		'XO': 235,
		'form': XO_FormDict,
	};
	'add' = {
		'OPCD': 31,
		'XO': 266,
		'form': XO_FormDict,
	};
	'lhzx' = {
		'OPCD': 31,
		'XO': 279,
		'form': X_FormDict,
	};
	'xor' = {
		'OPCD': 31,
		'XO': 316,
		'form': X_FormDict,
	};
	'mfspr' = {
		'OPCD': 31,
		'XO': 339,
		'form': XFX_FormDict,
	};
	'lhax' = {
		'OPCD': 31,
		'XO': 343,
		'form': X_FormDict,
	};
	'sthx' = {
		'OPCD': 31,
		'XO': 407,
		'form': X_FormDict,
	};
	'orc' = {
		'OPCD': 31,
		'XO': 412,
		'form': X_FormDict,
	};
	'or' = {
		'OPCD': 31,
		'XO': 444,
		'form': X_FormDict,
	};
	'divwu' = {
		'OPCD': 31,
		'XO': 459,
		'form': XO_FormDict,
	};
	'mtspr' = {
		'OPCD': 31,
		'XO': 467,
		'form': XFX_FormDict,
	};
	'nand' = {
		'OPCD': 31,
		'XO': 476,
		'form': X_FormDict,
	};
	'divw' = {
		'OPCD': 31,
		'XO': 491,
		'form': XO_FormDict,
	};
	'lwbrx' = {
		'OPCD': 31,
		'XO': 534,
		'form': X_FormDict,
	};
	'srw' = {
		'OPCD': 31,
		'XO': 536,
		'form': X_FormDict,
	};
	'sync' = {
		'OPCD': 31,
		'XO': 598,
		'form': X_FormDict,
	};
	'stwbrx' = {
		'OPCD': 31,
		'XO': 662,
		'form': X_FormDict,
	};
	'lhbrx' = {
		'OPCD': 31,
		'XO': 790,
		'form': X_FormDict,
	};
	'sraw' = {
		'OPCD': 31,
		'XO': 792,
		'form': X_FormDict,
	};
	'srawi' = {
		'OPCD': 31,
		'XO': 824,
		'form': X_FormDict,
	};
	'sthbrx' = {
		'OPCD': 31,
		'XO': 918,
		'form': X_FormDict,
	};
	'extsh' = {
		'OPCD': 31,
		'XO': 922,
		'form': X_FormDict,
	};
	'extsb' = {
		'OPCD': 31,
		'XO': 954,
		'form': X_FormDict,
	};
	'lwz' = {
		'OPCD': 32,
		'XO': 0,
		'form': D_FormDict,
	};
	'lbz' = {
		'OPCD': 34,
		'XO': 0,
		'form': D_FormDict,
	};
	'stw' = {
		'OPCD': 36,
		'XO': 0,
		'form': D_FormDict,
	};
	'stb' = {
		'OPCD': 38,
		'XO': 0,
		'form': D_FormDict,
	};
	'lhz' = {
		'OPCD': 40,
		'XO': 0,
		'form': D_FormDict,
	};
	'lha' = {
		'OPCD': 42,
		'XO': 0,
		'form': D_FormDict,
	};
	'sth' = {
		'OPCD': 44,
		'XO': 0,
		'form': D_FormDict,
	};
	'lmw' = {
		'OPCD': 46,
		'XO': 0,
		'form': D_FormDict,
	};
	'stmw' = {
		'OPCD': 47,
		'XO': 0,
		'form': D_FormDict,
	};
	'lbzu' = {
		'OPCD': 35,
		'XO': 0,
		'form': D_FormDict,
	};
	'lhzu' = {
		'OPCD': 41,
		'XO': 0,
		'form': D_FormDict,
	};
	'lhau' = {
		'OPCD': 43,
		'XO': 0,
		'form': D_FormDict,
	};
	'lwzu' = {
		'OPCD': 33,
		'XO': 0,
		'form': D_FormDict,
	};
	'stbu' = {
		'OPCD': 39,
		'XO': 0,
		'form': D_FormDict,
	};
	'sthu' = {
		'OPCD': 45,
		'XO': 0,
		'form': D_FormDict,
	};
	'stwu' = {
		'OPCD': 37,
		'XO': 0,
		'form': D_FormDict,
	};
	'subfme' = {
		'OPCD': 31,
		'XO': 232,
		'form': XO_FormDict,
	};
};

if __name__ == '__main__':
	print I_Form['OPCD']