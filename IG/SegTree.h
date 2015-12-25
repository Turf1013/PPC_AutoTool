/*
 * SegTree.h
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#ifndef SEGTREE_H_
#define SEGTREE_H_

class SegTree {
public:
	SegTree();
	virtual ~SegTree();
	void init(int n, int* C);
	int Query(int k);
	void Update(int k);
	int Tot();

private:
	void Build(int *C, int l, int r, int rt);
	int Query(int k, int l, int r, int rt);
	void Update(int k, int delta, int l, int r, int rt);
	void PushUp(int rt);
	int calDecay(int k);

public:
	const static int maxn = 205;

private:
	int tot[maxn<<2];
	int last[maxn];
	int cnt[maxn];
	int n;

};

#endif /* SEGTREE_H_ */

