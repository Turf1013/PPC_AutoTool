/*
 * Permutation.h
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#ifndef PERMUTATION_H_
#define PERMUTATION_H_
#include "head.h"

class Permutation {
public:
	Permutation(int n);
	Permutation(int n, int* C);
	virtual ~Permutation();
	void init(int n, int* C);
	void getPermutation(vector<vi>& vc);

private:
	void dfs(vector<vi>& vc, int d);
	bool judge();

public:
	static const int maxn = 10;
	static const int maxst = 3;
	static const int NOP = 0;
	static const int READ = 1;
	static const int WRITE = 2;
	static const int rstg = 1;

private:
	int a[maxn];
	int C[maxst];
	int n;
};

#endif /* PERMUTATION_H_ */
