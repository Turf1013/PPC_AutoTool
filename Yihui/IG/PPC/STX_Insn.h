/*
 * STX_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef STX_INSN_H
#define STX_INSN_H

#include "../Insn.h"
#include "arch.h"

class STX_Insn: public Insn {
public:
	STX_Insn(string name, int rn, int bn);
	virtual ~STX_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);

public:
	static const int SIZE = DMSIZE;


private:
	int mask;
};

#endif /* MINSN_H_ */
