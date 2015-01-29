#!/usr/bin/env python

'This file is about the insn format of PPC ISA'

# I-Form: 1 kind
# 6+24+1+1=32
 I_Form = {
	 'AA' = 1,
	 'OPCD' = 6,
	 'LK' = 1),
	 'LI' = 24,
};


# B-Form: 1 kind
# 6+5+5+14+1+1=32
 B_Form = {
	 'BD' = 14,
	 'AA' = 1,
	 'BO' = 5,
	 'BI' = 5,
	 'LK' = 1),
	 'OPCD' = 6,
};


# SC-Form: 1 kind
# 6+14+7+5=32
 SC_Form = {
	 'Reserve0' = 14,
	 'Reserve1' = 5),
	 'OPCD' = 6,
	 'LEV' = 7,
};


# D-Form: 9 kinds
# 6+5+5+16=32
 D_Form = {
	 'RT' = 5,
	 'OPCD' = 6,
	 'RA' = 5,
	 'D' = 16),
};


# DS-Fomr: 2 kinds
# 6+5+5+14+2=32
 DS_Form = {
	 'RT' = 5,
	 'OPCD' = 6,
	 'RA' = 5,
	 'XO' = 2),
	 'DS' = 14,
};


# X-Form: 32 kinds
# 6+5+5+5+10+1=32
 X_Form = {
	 'RT' = 5,
	 'XO' = 10,
	 'RA' = 5,
	 'RB' = 5,
	 'RC' = 1),
	 'OPCD' = 6,
};


# XL-Form: 4 kinds
# 6+5+5+5+10+1=32
 XL_Form = {
	 'BA' = 5,
	 'BB' = 5,
	 'LK' = 1),
	 'BT' = 5,
	 'OPCD' = 6,
	 'XO' = 10,
};


# XFX-Form: 7 kinds
# 6+5+10+10+1=32
 XFX_Form = {
	 'RT' = 5,
	 'Reserve0' = 1),
	 'SPR' = 10,
	 'OPCD' = 6,
	 'XO' = 10,
};


# XFL-Form: 1 kind
# 6+1+8+1+5+10+1=32
 XFL_Form = {
	 'FRB' = 5,
	 'XO' = 10,
	 'Reserve0' = 1,
	 'Reserve1' = 1,
	 'FLM' = 8,
	 'RC' = 1),
	 'OPCD' = 6,
};


# XS-Form: 1 kind
# 6+5+5+5+9+1+1=32
 XS_Form = {
	 'SH0' = 5,
	 'SH1' = 1,
	 'XO' = 9,
	 'RS' = 5,
	 'RA' = 5,
	 'RC' = 1),
	 'OPCD' = 6,
};


# XO-Form: 3 kinds
# 6+5+5+5+1+9+1=32
 XO_Form = {
	 'RT' = 5,
	 'XO' = 9,
	 'OE' = 1,
	 'RA' = 5,
	 'RB' = 5,
	 'RC' = 1),
	 'OPCD' = 6,
};


# A-Form: 4 kinds
# 6+5+5+5+5+5+1=32
 A_Form = {
	 'FRC' = 5,
	 'FRB' = 5,
	 'FRA' = 5,
	 'XO' = 5,
	 'RC' = 1),
	 'FRT' = 5,
	 'OPCD' = 6,
};


# M-Form: 2 kinds
# 6+5+5+5+5+5+1=32
 M_Form = {
	 'ME' = 5,
	 'MB' = 5,
	 'RS' = 5,
	 'RA' = 5,
	 'RB' = 5,
	 'RC' = 1),
	 'OPCD' = 6,
};


# MD-Form: 2 kinds
# 6+5+5+5+6+3+1+1=32
 MD_Form = {
	 'SH0' = 5,
	 'SH1' = 1,
	 'XO' = 3,
	 'MB' = 6,
	 'RS' = 5,
	 'RA' = 5,
	 'RC' = 1),
	 'OPCD' = 6,
};


# MDS-Form: 2 kinds
# 6+5+5+5+6+4+1=32
 MDS_Form = {
	 'XO' = 4,
	 'MB' = 6,
	 'RS' = 5,
	 'RA' = 5,
	 'RB' = 5,
	 'RC' = 1),
	 'OPCD' = 6,
};

if __name__ == '__main__':
	print I_Form['OPCD']