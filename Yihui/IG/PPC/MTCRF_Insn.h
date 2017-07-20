/*
 * MTCRF_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef MTCRF_INSN_H
#define MTCRF_INSN_H

#include "../Insn.h"

class MTCRF_Insn: public Insn {
public:
	MTCRF_Insn(string name, int rn);
	virtual ~MTCRF_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
};

#endif /* MTCRF_Insn */
