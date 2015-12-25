/*
 * IInsn.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "IInsn.h"
#include "../Insn.h"
#include "../head.h"

I_Insn::I_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

I_Insn::~I_Insn() {
	// TODO Auto-generated destructor stub
}

string I_Insn::dump(int& x, bool& flag) {

	if (rn > 1) {
		imm = rand() % 65536 - 32768;
		sprintf(buf, "%s $%d, $%d, %d", name.c_str(), r2, r1, imm);
	} else {
		// lui
		imm = rand() % 65536;
		sprintf(buf, "%s $%d, %d", name.c_str(), r2, imm);
	}

	return string(buf);
}

void I_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=1);
	setRx(rid, value);
}

void I_Insn::setRw(int value) {
	setR2(value);
}
