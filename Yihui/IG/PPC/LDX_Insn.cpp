/*
 * LDX_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "LDX_Insn.h"

LDX_Insn::LDX_Insn(string name, int rn, int bn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub
	mask = (1<<16) - 1;
	if (bn == 4) {
		mask -= 3;
	} else if (bn == 2) {
		mask -= 1;
	}
}

LDX_Insn::~LDX_Insn() {
	// TODO Auto-generated destructor stub
}

string LDX_Insn::dump(int& x, bool& flag) {
	//sprintf(buf, "%s r%d, r%d, r%d", name.c_str(), r3, r1, r2);
	while (r2 == sp)
		r2 = rand() % 32;
	sprintf(buf, "%s r%d, sp, r%d", name.c_str(), r3, r2);
	return string(buf);
}

void LDX_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=1);
	if (rn == 2) {
		setRx(1, value);
	}
}

void LDX_Insn::setRw(int value) {
	setR2(value);
}
