/*
 * MTSPR_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */
 
#include "MTSPR_Insn.h"

MTSPR_Insn::MTSPR_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

MTSPR_Insn::~MTSPR_Insn() {
	// TODO Auto-generated destructor stub
}

string MTSPR_Insn::dump(int& x, bool& flag) {
	sprintf(buf, "%s %d, r%d", name.c_str(), r3, r1);
	return string(buf);
}

void MTSPR_Insn::setRd(int rid, int value) {
	setRx(1, value);
}

void MTSPR_Insn::setRw(int value) {
	int idx = rand() % (vspr.size());
	setRx(3, vspr[idx]);
}

vector<int> MTSPR_Insn::vspr;
bool MTSPR_Insn::initAlready = MTSPR_Insn::initVspr();
