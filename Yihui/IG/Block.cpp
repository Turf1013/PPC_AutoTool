/*
 * Block.cpp
 *
 *  Created on: 2015Äê12ÔÂ25ÈÕ
 *      Author: Trasier
 */

#include "Block.h"
#include "head.h"

const string Block::NOP = string("nop");
const string Block::LBL = string(LABEL);

Block::Block(int n):
	n(n), nopn(n) {
	// TODO Auto-generated constructor stub
	labeln = -1;
}

Block::~Block() {
	// TODO Auto-generated destructor stub
}

void Block::init() {
	svc.clr();
	labeln = -1;
}

void Block::push_back() {
	svc.pb("\t" + Block::NOP);
}

void Block::push_back(string s) {
	svc.pb("\t" + s);
}

string Block::toString() {
	string ret;
	int sz = SZ(svc);

	rep(i, 0, sz)
		ret += svc[i] + "\n";

	rep(i, 0, nopn) {
		if (labeln>=0 && i==labelIdx) {
			sprintf(buf, "%s_%d:", Block::LBL.c_str(), labeln);
			ret += "\t" + string(buf) + "\n";
		}
		ret += "\t" + Block::NOP + "\n";
	}

	return ret;
}

void Block::dump(vector<string>& vc) {
	vc.insert(vc.end(), all(svc));

	rep(i, 0, nopn) {
		if (labeln>=0 && i==labelIdx) {
			sprintf(buf, "%s_%d:", Block::LBL.c_str(), labeln);
			vc.pb( "\t" + string(buf) );
		}
		vc.pb( "\t" + Block::NOP );
	}
}

void Block::setLabel(int labeln) {
	this->labeln = labeln;
}
