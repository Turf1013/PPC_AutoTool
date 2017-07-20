/*
 * GPR_R2_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "GPR_R2_Insn.h"

GPR_R2_Insn::GPR_R2_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

GPR_R2_Insn::~GPR_R2_Insn() {
	// TODO Auto-generated destructor stub
}

string GPR_R2_Insn::dump(int& x, bool& flag) {
	sprintf(buf, "%s r%d, r%d", name.c_str(), r3, r1);
	return string(buf);
}

void GPR_R2_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=2);
	if (rn == 2) {
		// sll srl sra
		setRx(2, value);
	} else {
		setRx(rid, value);
	}
}

void GPR_R2_Insn::setRw(int value) {
	setRx(3, value);
}
