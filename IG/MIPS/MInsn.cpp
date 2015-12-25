/*
 * MInsn.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "MInsn.h"

M_Insn::M_Insn(string name, int rn, int bn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub
	mask = (1<<16) - 1;
	if (bn == 4) {
		mask -= 3;
	} else if (bn == 2) {
		mask -= 1;
	}
}

M_Insn::~M_Insn() {
	// TODO Auto-generated destructor stub
}

string M_Insn::dump(int& x, bool& flag) {
	imm = rand() % SIZE;
	imm &= mask;
	sprintf(buf, "%s $%d, %d($%d)", name.c_str(), r2, imm, r1);
	return string(buf);
}

void M_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=1);
	if (rn == 2) {
		setRx(1, value);
	}
}

void M_Insn::setRw(int value) {
	setR2(value);
}
