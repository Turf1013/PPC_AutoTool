/*
 * IInsn.h
 *
 *  Created on: 2015��12��24��
 *      Author: Trasier
 */

#ifndef IINSN_H_
#define IINSN_H_

#include "../Insn.h"

class I_Insn: public Insn {
public:
	I_Insn(string name, int rn);
	virtual ~I_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
};

#endif /* IINSN_H_ */
