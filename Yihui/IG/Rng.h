/*
 * Rng.h
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#ifndef RNG_H_
#define RNG_H_

#include "SegTree.h"

class Rng {
public:
	Rng();
	Rng(int n);
	virtual ~Rng();
	int randint();
	void init(int k);

private:

public:
	const static int maxn = 105;

private:
	SegTree ST;
	int n;
	int *C;
};

#endif /* RNG_H_ */
