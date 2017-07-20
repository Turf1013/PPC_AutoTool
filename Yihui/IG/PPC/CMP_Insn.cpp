/*
 * CMP_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "CMP_Insn.h"

CMP_Insn::CMP_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

CMP_Insn::~CMP_Insn() {
	// TODO Auto-generated destructor stub
}

string CMP_Insn::dump(int& x, bool& flag) {
	int BF = rand() % 8, L = rand() % 2;
	if (rn == 2) {
		sprintf(buf, "%s %d, %d, r%d, r%d", name.c_str(), BF, L, r1, r2);
	} else {
		int simm = rand() % 65536 - 32768;
		sprintf(buf, "%s %d, %d, r%d, %d", name.c_str(), BF, L, r1, simm);
	}
	return string(buf);
}

void CMP_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=2);
	if (rn == 2) {
		// sll srl sra
		setRx(2, value);
	} else {
		setRx(rid, value);
	}
}

void CMP_Insn::setRw(int value) {
	setRx(3, value);
}
