/*
 * STX_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "STX_Insn.h"

STX_Insn::STX_Insn(string name, int rn, int bn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub
	mask = (1<<16) - 1;
	if (bn == 4) {
		mask -= 3;
	} else if (bn == 2) {
		mask -= 1;
	}
}

STX_Insn::~STX_Insn() {
	// TODO Auto-generated destructor stub
}

string STX_Insn::dump(int& x, bool& flag) {
	//sprintf(buf, "%s r%d, r%d, r%d", name.c_str(), r3, r1, r2);
	sprintf(buf, "%s r%d, sp, r%d", name.c_str(), r3, r2);
	return string(buf);
}

void STX_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=1);
	if (rn == 2) {
		setRx(1, value);
	}
}

void STX_Insn::setRw(int value) {
	setR2(value);
}
