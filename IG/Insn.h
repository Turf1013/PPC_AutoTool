/*
 * Insn.h
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#ifndef INSN_H_
#define INSN_H_

#include "head.h"

class Insn {
public:
	Insn(string name, int rn);
	virtual ~Insn();
	bool operator== (const Insn& oth) const;
	void setImm(int);
	void setLabel(int);
	void init();
	void setRx(int,int);
	void setR1(int);
	void setR2(int);
	void setR3(int);
	virtual string dump(int&, bool&)=0;
	virtual void setRd(int,int)=0;
	virtual void setRw(int)=0;
	string getName() const;

protected:

public:
	const static int maxl = 55;
	const int rn;

protected:
	char buf[maxl];
	string name;
	int r1, r2, r3;
	int imm;
	int label;
};

#endif /* INSN_H_ */
