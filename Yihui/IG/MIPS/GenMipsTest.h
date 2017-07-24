/*
 * GenMipsTest.h
 *
 *  Created on: 2015Äê12ÔÂ25ÈÕ
 *      Author: Trasier
 */

#ifndef GENMIPSTEST_H_
#define GENMIPSTEST_H_

#include "../GenTest.h"
#include "../head.h"

class GenMipsTest {
public:
	GenMipsTest(string);
	virtual ~GenMipsTest();
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

#endif /* GENMIPSTEST_H_ */
