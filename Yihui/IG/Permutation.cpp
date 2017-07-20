/*
 * Permutation.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "Permutation.h"

Permutation::Permutation(int n=5) {
	// TODO Auto-generated constructor stub
	init(n, NULL);
}

Permutation::Permutation(int n, int* C) {
	// TODO Auto-generated constructor stub
	init(n, C);
}

Permutation::~Permutation() {
	// TODO Auto-generated destructor stub
}

void Permutation::init(int n, int* C) {
	this->n = n;
	if (C == NULL) {
		rep(i, 0, maxst)
			this->C[i] = n;
	} else {
		rep(i, 0, maxst)
			this->C[i] = C[i];
	}
}

void Permutation::getPermutation(vector<vi>& vc) {
	vc.clr();

	dfs(vc, 0);
}

void Permutation::dfs(vector<vi>& vc, int d) {
	if (d == n) {
		if (judge())
			vc.pb(vi(a, a+n));
		return ;
	}

	rep(i, 0, maxst) {
		if (C[i]) {
			--C[i];
			a[d] = i;
			dfs(vc, d+1);
			++C[i];
		}
	}
}

bool Permutation::judge() {
	// \prune 1: stage index before ID only can be NOP
	int i = 0, j = n -1;
	for (i=0; i<rstg; ++i) if (a[i] != NOP)	return false;
	for (; i<n; ++i) if (a[i] != NOP) break;
	// \prune 2: there must be read or write
	if (i >= n) return false;
	// \prune 3: foreach read there must be a write ahead of read
	for (; j>i; --j) {
		if (a[j] == WRITE) break;
		if (a[j] == READ) return false;
	}
	for (; i<n; ++i)  {
		if (a[i] == READ) break;
		if (a[i] == WRITE) return false;
	}
	return i < j;
}
