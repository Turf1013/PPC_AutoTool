/*
 * MInsn.h
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#ifndef MINSN_H_
#define MINSN_H_

#include "../Insn.h"
#include "arch.h"

class M_Insn: public Insn {
public:
	M_Insn(string name, int rn, int bn);
	virtual ~M_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);

public:
	static const int SIZE = DMSIZE;


private:
	int mask;
};

#endif /* MINSN_H_ */
