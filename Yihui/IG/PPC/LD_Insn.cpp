/*
 * LD_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "LD_Insn.h"

LD_Insn::LD_Insn(string name, int rn, int bn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub
	mask = (1<<16) - 1;
	if (bn == 4) {
		mask -= 3;
	} else if (bn == 2) {
		mask -= 1;
	}
}

LD_Insn::~LD_Insn() {
	// TODO Auto-generated destructor stub
}

string LD_Insn::dump(int& x, bool& flag) {
	imm = rand() % SIZE;
	imm &= mask;
	//sprintf(buf, "%s r%d, %d(r%d)", name.c_str(), r2, imm, r1);
	while (r2 == sp)
		r2 = rand() % 32;
	sprintf(buf, "%s r%d, %d(sp)", name.c_str(), r2, imm);
	return string(buf);
}

void LD_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=1);
	if (rn == 2) {
		setRx(1, value);
	}
}

void LD_Insn::setRw(int value) {
	setR2(value);
}
