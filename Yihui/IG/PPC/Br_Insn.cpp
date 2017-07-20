/*
 * Br_Insn.cpp
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#include "Br_Insn.h"
#include "arch.h"

Br_Insn::Br_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

Br_Insn::~Br_Insn() {
	// TODO Auto-generated destructor stub
}

string Br_Insn::dump(int& x, bool& flag) {
	label = x;
	flag = true;
	int LK = rand() % 2;
	
	if (rn == 0) {
		if (LK == 1)
			sprintf(buf, "%sl %s_%d", name.c_str(), LABEL, label);
		else
			sprintf(buf, "%s %s_%d", name.c_str(), LABEL, label);
	} else {
		int idx = rand() % 8;
		if (LK == 1)
			sprintf(buf, "b%s%sl %s_%d", vop[idx].c_str(), name.substr(2).c_str(), LABEL, label);
		else
			sprintf(buf, "b%s%s %s_%d", vop[idx].c_str(), name.substr(2).c_str(), LABEL, label);
	}

	return string(buf);
}

void Br_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=2);
	setRx(rid, value);
}

void Br_Insn::setRw(int value) {
}


vector<string> Br_Insn::vop;
bool Br_Insn::initAlready = Br_Insn::init();
