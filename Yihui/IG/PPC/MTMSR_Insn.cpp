/*
 * MTMSR_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "MTMSR_Insn.h"

MTMSR_Insn::MTMSR_Insn(string name, int rn=1):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

MTMSR_Insn::~MTMSR_Insn() {
	// TODO Auto-generated destructor stub
}

string MTMSR_Insn::dump(int& x, bool& flag) {
	sprintf(buf, "%s r%d", name.c_str(), r1);
	return string(buf);
}

void MTMSR_Insn::setRd(int rid, int value) {
	setRx(1, value);
}

void MTMSR_Insn::setRw(int value) {
	setRx(3, value);
}
