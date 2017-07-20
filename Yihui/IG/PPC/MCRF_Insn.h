/*
 * MCRF_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef MCRF_INSN_H
#define MCRF_INSN_H

#include "../Insn.h"

class MCRF_Insn: public Insn {
public:
	MCRF_Insn(string name, int rn);
	virtual ~MCRF_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
};

#endif /* MCRF_Insn */
