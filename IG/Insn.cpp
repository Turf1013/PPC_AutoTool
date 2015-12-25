/*
 * Insn.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "Insn.h"

Insn::Insn(string name, int rn):
	name(name), rn(rn)	{
	// TODO Auto-generated constructor stub
	r1 = r2 = r3 = imm = label = 0;
}

Insn::~Insn() {
	// TODO Auto-generated destructor stub
}

bool Insn::operator== (const Insn& other) const {
	return name == other.name;
}

void Insn::init() {
	r1 = r2 = r3 = imm = label = 0;
}

void Insn::setR1(int x) {
	if (r1 < 0) {
		cerr << "r1 can't be set" << endl;
	} else {
		r1 = x;
	}
}

void Insn::setR2(int x) {
	if (r2 < 0) {
		cerr << "r2 can't be set" << endl;
	} else {
		r2 = x;
	}
}

void Insn::setR3(int x) {
	if (r3 < 0) {
		cerr << "r3 can't be set" << endl;
	} else {
		r3 = x;
	}
}

void Insn::setRx(int k, int x) {
	if (k == 1) {
		setR1(x);
 	} else if (k == 2) {
 		setR2(x);
 	} else if (k == 3) {
 		setR3(x);
 	} else {
 		cerr << "setRx out of bound, k = " << k << endl;
 	}
}

void Insn::setImm(int x) {
	imm = x;
}

void Insn::setLabel(int x) {
	label = x;
}

string Insn::getName() const {
	return name;
}
