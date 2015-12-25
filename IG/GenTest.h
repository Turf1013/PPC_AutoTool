/*
 * GenTest.h
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#ifndef GENTEST_H_
#define GENTEST_H_

#include "head.h"
#include "Insn.h"
#include "Permutation.h"
#include "Block.h"
#include "Rng.h"

class GenTest {
public:
	GenTest(int, string, vector<Insn*>, vector<Insn*>);
	GenTest(int, string, vector<Insn*>, vector<Insn*>, int*);
	virtual ~GenTest();
	void write(string);
	void write(string, int);
	void dump(vector<string>&);
	void dump(vector<string>&, int);
	void init();
	void init(string);
	void init(vector<Insn*>, vector<Insn*>);
	void init(string, vector<Insn*>, vector<Insn*>);
	void setEntry(string);
	void setRvc(vector<Insn*>);
	void setWvc(vector<Insn*>);
	void setReg(const vi&);

protected:
	void init_Reg();
	void init_Rng();
	void init_Entry(string);
	void init_Ivc(vector<Insn*>, vector<Insn*>);
	void genHazard(vector<string>&);
	Block genBlock(const vi&);
	void updateBlock(const vi&);
	Insn* randrInsn(int);
	Insn* randwInsn(int);
	bool valid(vi vc);
#ifdef DEBUG
	void updateBlock(const vi&, int&);
#endif

public:
	const int n;
#ifdef DEBUG
	static const int maxl = 55;
#endif

protected:
	int labeln;
	string entry;
	vector<Insn*> rvc, wvc;
	vi regvc;
	Rng rRng, wRng;
	Permutation *perm;
	Block *blk;

#ifdef DEBUG
	static const string op;
	char buf[maxl];
#endif
};

#endif /* GENTEST_H_ */
