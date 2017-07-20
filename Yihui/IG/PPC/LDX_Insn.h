/*
 * LDX_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef LDX_INSN_H
#define LDX_INSN_H

#include "../Insn.h"
#include "arch.h"

class LDX_Insn: public Insn {
public:
	LDX_Insn(string name, int rn, int bn);
	virtual ~LDX_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);

public:
	static const int SIZE = DMSIZE;


private:
	int mask;
	static const int sp = 1;
};

#endif /* MINSN_H_ */
