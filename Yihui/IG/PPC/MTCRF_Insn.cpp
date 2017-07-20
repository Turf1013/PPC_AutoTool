/*
 * MTCRF_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "MTCRF_Insn.h"

MTCRF_Insn::MTCRF_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

MTCRF_Insn::~MTCRF_Insn() {
	// TODO Auto-generated destructor stub
}

string MTCRF_Insn::dump(int& x, bool& flag) {
	int fxm = rand()%256;
	sprintf(buf, "%s %d, r%d", name.c_str(), fxm, r1);
	return string(buf);
}

void MTCRF_Insn::setRd(int rid, int value) {
	setRx(1, value);
}

void MTCRF_Insn::setRw(int value) {
	setRx(3, value);
}
