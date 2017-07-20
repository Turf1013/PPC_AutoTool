/*
 * ST_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "ST_Insn.h"

ST_Insn::ST_Insn(string name, int rn, int bn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub
	mask = (1<<16) - 1;
	if (bn == 4) {
		mask -= 3;
	} else if (bn == 2) {
		mask -= 1;
	}
}

ST_Insn::~ST_Insn() {
	// TODO Auto-generated destructor stub
}

string ST_Insn::dump(int& x, bool& flag) {
	imm = rand() % SIZE;
	imm &= mask;
	//sprintf(buf, "%s r%d, %d(r%d)", name.c_str(), r2, imm, r1);
	sprintf(buf, "%s r%d, %d(sp)", name.c_str(), r2, imm);
	return string(buf);
}

void ST_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=1);
	if (rn == 2) {
		setRx(1, value);
	}
}

void ST_Insn::setRw(int value) {
	setR2(value);
}
