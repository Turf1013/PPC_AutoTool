/*
 * LD_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef LD_INSN_H
#define LD_INSN_H

#include "../Insn.h"
#include "arch.h"

class LD_Insn: public Insn {
public:
	LD_Insn(string name, int rn, int bn);
	virtual ~LD_Insn();
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
