/*
 * GenPPCTest.h
 *
 *  Created on: 2015Äê12ÔÂ25ÈÕ
 *      Author: Trasier
 */

#ifndef GENPPCTEST_H
#define GENPPCTEST_H

#include "../GenTest.h"
#include "../head.h"

class GenPPCTest {
public:
	GenPPCTest(string);
	virtual ~GenPPCTest();
	void write(string);
	void write(string, int);
	void dump(vector<string>&);
	void dump(vector<string>&, int);

private:
	void init(string);
	void init_GT();
	void init_Entry(string);
	void init_Insn();
	GenTest *GT;

public:
	static const int n = 5;

private:
	vector<Insn*> rvc;
	vector<Insn*> wvc;
	string entry;
};

#endif /* GenPPCTest_H_ */
