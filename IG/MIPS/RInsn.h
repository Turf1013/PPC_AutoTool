/*
 * RInsn.h
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#ifndef RINSN_H_
#define RINSN_H_

#include "../Insn.h"

class R_Insn: public Insn {
public:
	R_Insn(string name, int rn);
	virtual ~R_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);

private:


public:


private:

};

#endif /* RINSN_H_ */
