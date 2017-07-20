/*
 * RLW_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "RLW_Insn.h"

RLW_Insn::RLW_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

RLW_Insn::~RLW_Insn() {
	// TODO Auto-generated destructor stub
}

string RLW_Insn::dump(int& x, bool& flag) {
	int mb = rand()%32, me = rand()%32;
	if (rn == 2) {
		imm = rand() % 32;
		// sll srl sra
		sprintf(buf, "%s r%d, r%d, %d, %d, %d", name.c_str(), r3, r1, imm, mb, me);
	} else {
		sprintf(buf, "%s r%d, r%d, r%d, %d, %d", name.c_str(), r3, r1, r2, mb, me);
	}
	return string(buf);
}

void RLW_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=2);
	if (rn == 2) {
		// sll srl sra
		setRx(2, value);
	} else {
		setRx(rid, value);
	}
}

void RLW_Insn::setRw(int value) {
	setRx(3, value);
}
