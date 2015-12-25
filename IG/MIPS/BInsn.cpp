/*
 * BInsn.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "BInsn.h"
#include "arch.h"

B_Insn::B_Insn(string name, int rn):
	Insn(name, rn) {
	// TODO Auto-generated constructor stub

}

B_Insn::~B_Insn() {
	// TODO Auto-generated destructor stub
}

string B_Insn::dump(int& x, bool& flag) {
	label = x;
	flag = true;
	#ifdef DELAYSLOT
		if (rn > 2) {
			sprintf(buf, "%s $%d, $%d, %s_%d\n\tnop", name.c_str(), r1, r2, LABEL, label);
		} else {
			// bgez bltz bgtz blez
			sprintf(buf, "%s $%d, %s_%d\n\tnop", name.c_str(), r1, LABEL, label);
		}
	#else
		if (rn > 2) {
			sprintf(buf, "%s $%d, $%d, %s_%d", name.c_str(), r1, r2, LABEL, label);
		} else {
			// bgez bltz bgtz blez
			sprintf(buf, "%s $%d, %s_%d", name.c_str(), r1, LABEL, label);
		}
	#endif

	return string(buf);
}

void B_Insn::setRd(int rid, int value) {
	assert(rid>0 && rid<=2);
	setRx(rid, value);
}

void B_Insn::setRw(int value) {
}
