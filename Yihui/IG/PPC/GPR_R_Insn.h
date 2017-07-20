/*
 * GPR_R_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef GPR_R_INSN_H
#define GPR_R_INSN_H

#include "../Insn.h"

class GPR_R_Insn: public Insn {
public:
	GPR_R_Insn(string name, int rn);
	virtual ~GPR_R_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
};

#endif /* GPR_R_INSN */
