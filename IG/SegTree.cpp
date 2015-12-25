/*
 * SegTree.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "SegTree.h"
#include "head.h"

SegTree::SegTree() {
	// TODO Auto-generated constructor stub
	n = 1;
}

SegTree::~SegTree() {
	// TODO Auto-generated destructor stub
}

void SegTree::init(int n, int* C) {
	this->n = n;
	Build(C, 1, n, 1);
	memset(last, 0, sizeof(last));
	memset(cnt, 0, sizeof(cnt));
}

void SegTree::Build(int* C, int l, int r, int rt) {
	if (l == r) {
		tot[rt] = C[l];
		return ;
	}

	int mid = (l + r) >> 1;
	Build(C, lson);
	Build(C, rson);
	PushUp(rt);
}

void SegTree::PushUp(int rt) {
	tot[rt] = tot[rt<<1] + tot[rt<<1|1];
}

int SegTree::Query(int k) {
	return Query(k, 1, n, 1);
}

int SegTree::Query(int k, int l, int r, int rt) {
	if (l == r) {
		return l;
	}

	int mid = (l + r) >> 1;
	if (k <= tot[rt<<1]) {
		return Query(k, lson);
	} else {
		return Query(k-tot[rt<<1], rson);
	}
}

void SegTree::Update(int k) {
	int delta = calDecay(k);
	Update(k, delta, 1, n, 1);
}

void SegTree::Update(int k, int delta, int l, int r, int rt) {
	if (l == r) {
		tot[rt] += delta;
		if (tot[rt] <= 0)
			tot[rt] = 1;
		return ;
	}

	int mid = (l + r) >> 1;

	if (k <= mid)
		Update(k, delta, lson);
	else
		Update(k, delta, rson);
	PushUp(rt);
}

int SegTree::calDecay(int k) {
	int ret;

	if (last[k]) {
		if (k-last[k] <= 5)
			cnt[k] = cnt[k] * 1.4;
		else
			cnt[k] += 1;
	} else {
		ret = 1;
		cnt[k] = 1;
	}
	last[k] = 1;

	return ret;
}

int SegTree::Tot() {
	return tot[1];
}
