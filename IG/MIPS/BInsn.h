/*
 * BInsn.h
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#ifndef BINSN_H_
#define BINSN_H_

#include "../Insn.h"
#include "../head.h"

class B_Insn: public Insn {
public:
	B_Insn(string name, int rn);
	virtual ~B_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);

private:

};

#endif /* BINSN_H_ */
