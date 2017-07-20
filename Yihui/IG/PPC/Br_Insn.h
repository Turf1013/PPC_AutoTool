/*
 * Br_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef BR_INSN_H
#define BR_INSN_H

#include "../Insn.h"
#include "../head.h"

class Br_Insn: public Insn {
public:
	Br_Insn(string name, int rn);
	virtual ~Br_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);

private:
	static bool initAlready;
	static vector<string> vop;
	static bool init() {
		vop.push_back("lt");
		vop.push_back("le");
		vop.push_back("gt");
		vop.push_back("ge");
		vop.push_back("eq");
		vop.push_back("ne");
		vop.push_back("nl");
		vop.push_back("ng");
		return true;
	}
};

#endif /* BR_INSN_H_ */
