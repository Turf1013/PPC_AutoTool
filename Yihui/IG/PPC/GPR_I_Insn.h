/*
 * GPR_I_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef GPR_I_INSN_H
#define GPR_I_INSN_H

#include "../Insn.h"

class GPR_I_Insn: public Insn {
public:
	GPR_I_Insn(string name, int rn);
	virtual ~GPR_I_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
};

#endif /* IINSN_H_ */
