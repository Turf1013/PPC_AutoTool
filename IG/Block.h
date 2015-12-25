/*
 * Block.h
 *
 *  Created on: 2015Äê12ÔÂ25ÈÕ
 *      Author: Trasier
 */

#ifndef BLOCK_H_
#define BLOCK_H_

#include "head.h"
#include "Insn.h"

class Block {
public:
	Block(int);
	virtual ~Block();
	void init();
	string toString();
	void dump(vector<string>&);
	void push_back();
	void push_back(string);
	void setLabel(int x);

private:


public:
	const int n;
	const int nopn;
	static const string NOP;
	static const string LBL;
	static const int labelIdx = 2;
	static const int maxl = 555;

private:
	int labeln;
	vector<string> svc;
	char buf[maxl];
};

#endif /* BLOCK_H_ */
