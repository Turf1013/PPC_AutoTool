/*
 * CR_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "CR_Insn.h"

CR_Insn::CR_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

CR_Insn::~CR_Insn() {
	// TODO Auto-generated destructor stub
}

string CR_Insn::dump(int& x, bool& flag) {
	sprintf(buf, "%s %d, %d, %d", name.c_str(), r3, r1, r2);
	return string(buf);
}

void CR_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=2);
	if (rn == 2) {
		// sll srl sra
		setRx(2, value);
	} else {
		setRx(rid, value);
	}
}

void CR_Insn::setRw(int value) {
	setRx(3, value);
}
