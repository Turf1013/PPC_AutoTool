/*
 * Rng.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "Rng.h"
#include "head.h"

Rng::Rng() {
	// TODO Auto-generated constructor stub
	C = NULL;
	init(n = 1);
}


Rng::Rng(int n):
	n(n)	{
	// TODO Auto-generated constructor stub
	C = NULL;
	init(n);
}

Rng::~Rng() {
	// TODO Auto-generated destructor stub
}

void Rng::init(int n) {
	this->n = n;
	if (n == 0) {
		cerr << "Rng init with 0" << endl;
		return ;
	}
	delete C;
	C = new int[n+1];

	rep(i, 1, n+1)
		C[i] = 256;
	ST.init(n, C);
}

int Rng::randint() {
	int tot = ST.Tot();
	int kth = rand() % tot + 1;
	int ret = ST.Query(kth);

#ifdef DEBUG
//	printf("randint, ret = %d, n = %d\n", ret, n);
#endif
	assert(ret>=1 && ret<=n);

	// possiblity decay
	ST.Update(ret);
	return ret;
}
