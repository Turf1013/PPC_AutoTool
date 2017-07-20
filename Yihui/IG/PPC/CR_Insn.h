/*
 * CR_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef CR_INSN_H
#define CR_INSN_H

#include "../Insn.h"

class CR_Insn: public Insn {
public:
	CR_Insn(string name, int rn=2);
	virtual ~CR_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
};

#endif /* CR_INSN */
