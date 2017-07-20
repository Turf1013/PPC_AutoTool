/*
 * GPR_R2_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef GPR_R2_Insn_H
#define GPR_R2_Insn_H

#include "../Insn.h"

class GPR_R2_Insn: public Insn {
public:
	GPR_R2_Insn(string name, int rn);
	virtual ~GPR_R2_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
};

#endif /* GPR_R2_Insn */
