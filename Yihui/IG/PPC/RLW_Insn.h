/*
 * RLW_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef RLW_Insn_H
#define RLW_Insn_H

#include "../Insn.h"

class RLW_Insn: public Insn {
public:
	RLW_Insn(string name, int rn);
	virtual ~RLW_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
};

#endif /* RLW_Insn */
