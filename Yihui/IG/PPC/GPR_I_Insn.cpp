/*
 * GPR_I_Insn.cpp
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#include "GPR_I_Insn.h"
#include "../Insn.h"
#include "../head.h"

GPR_I_Insn::GPR_I_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

GPR_I_Insn::~GPR_I_Insn() {
	// TODO Auto-generated destructor stub
}

string GPR_I_Insn::dump(int& x, bool& flag) {

	if (rn > 1) {
		imm = rand() % 65536;
		sprintf(buf, "%s r%d, r%d, %d", name.c_str(), r2, r1, imm);
	} else {
		// lui
		imm = rand() % 65536;
		sprintf(buf, "%s r%d, %d", name.c_str(), r2, imm);
	}

	return string(buf);
}

void GPR_I_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=1);
	setRx(rid, value);
}

void GPR_I_Insn::setRw(int value) {
	setR2(value);
}
