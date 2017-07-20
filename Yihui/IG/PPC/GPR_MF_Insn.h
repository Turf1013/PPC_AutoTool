/*
 * GPR_MF_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef GPR_MF_INSN_H
#define GPR_MF_INSN_H

#include "../Insn.h"

class GPR_MF_Insn: public Insn {
public:
	GPR_MF_Insn(string name, int rn=1);
	virtual ~GPR_MF_Insn();
	string dump(int& x, bool& flag);
	void setRd(int,int);
	void setRw(int);
private:
	static bool initAlready;
	static vector<int> vspr;
	static bool initVspr() {
		for (int i=0; i<20; ++i)
			vspr.push_back(i);
		return true;
	}
};

#endif /* GPR_MF_Insn */
