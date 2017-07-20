/*
 * GPR_MF_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "GPR_MF_Insn.h"

GPR_MF_Insn::GPR_MF_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

GPR_MF_Insn::~GPR_MF_Insn() {
	// TODO Auto-generated destructor stub
}

string GPR_MF_Insn::dump(int& x, bool& flag) {
	if (name == "mfspr") {
		int idx = rand() % (vspr.size());
		int sprn = vspr[idx];
		sprintf(buf, "%s %d, r%d", name.c_str(), sprn, r1);
	} else {
		sprintf(buf, "%s r%d", name.c_str(), r1);
	}
	return string(buf);
}

void GPR_MF_Insn::setRd(int rid, int value) {
	setRx(1, value);
}

void GPR_MF_Insn::setRw(int value) {
	setRx(3, value);
}

vector<int> GPR_MF_Insn::vspr;
bool GPR_MF_Insn::initAlready = GPR_MF_Insn::initVspr();
