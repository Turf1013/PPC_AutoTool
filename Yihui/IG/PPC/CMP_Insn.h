/*
 * CMP_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef CMP_INSN_H
#define CMP_INSN_H

#include "../Insn.h"

class CMP_Insn: public Insn {
public:
	CMP_Insn(string name, int rn=2);
	virtual ~CMP_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
};

#endif /* CMP_Insn */
