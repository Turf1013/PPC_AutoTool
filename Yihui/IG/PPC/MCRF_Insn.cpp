/*
 * MCRF_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "MCRF_Insn.h"

MCRF_Insn::MCRF_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

MCRF_Insn::~MCRF_Insn() {
	// TODO Auto-generated destructor stub
}

string MCRF_Insn::dump(int& x, bool& flag) {
	int bf = r3 % 8, bfa = r1 % 8;
	sprintf(buf, "%s %d, %d", name.c_str(), bf, bfa);
	return string(buf);
}

void MCRF_Insn::setRd(int rid, int value) {
	setRx(1, value);
}

void MCRF_Insn::setRw(int value) {
	setRx(3, value);
}
