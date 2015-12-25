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

