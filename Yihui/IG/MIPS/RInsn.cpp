/*
 * RInsn.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "RInsn.h"

R_Insn::R_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

R_Insn::~R_Insn() {
	// TODO Auto-generated destructor stub
}

string R_Insn::dump(int& x, bool& flag) {
	if (rn == 2) {
		imm = rand() % 32;
		// sll srl sra
		sprintf(buf, "%s $%d, $%d, %d", name.c_str(), r3, r2, imm);
	} else {
		sprintf(buf, "%s $%d, $%d, $%d", name.c_str(), r3, r1, r2);
	}
	return string(buf);
}

void R_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=2);
	if (rn == 2) {
		// sll srl sra
		setRx(2, value);
	} else {
		setRx(rid, value);
	}
}

void R_Insn::setRw(int value) {
	setRx(3, value);
}
