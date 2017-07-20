/*
 * MTSPR_Insn.h
 *
 *  Created on: 2017.7.20
 *      Author: Trasier
 */

#ifndef MTSPR_INSN_H
#define MTSPR_INSN_H

#include "../Insn.h"
#include <vector>
using namespace std;

class MTSPR_Insn: public Insn {
public:
	MTSPR_Insn(string name, int rn);
	virtual ~MTSPR_Insn();
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

#endif /* MTSPR_Insn */
