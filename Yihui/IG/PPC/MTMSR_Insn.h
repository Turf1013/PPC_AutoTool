/*
 * MTMSR_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef MTMSR_INSN_H
#define MTMSR_INSN_H

#include "../Insn.h"

class MTMSR_Insn: public Insn {
public:
	MTMSR_Insn(string name, int rn);
	virtual ~MTMSR_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
};

#endif /* MTMSR_Insn */
