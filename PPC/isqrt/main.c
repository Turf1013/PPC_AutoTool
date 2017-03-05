//#define LOCAL_TEST
#ifdef LOCAL_TEST
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#else
#include "zyxlib.h"
#endif

void handle_hw_int(void) {}

struct int_sqrt {
    unsigned sqrt;
	unsigned frac;
};

unsigned long TOP2BITS(unsigned long x) {
	return (x & (3L << 30)) >> 30;
}

void usqrt(unsigned long x, struct int_sqrt *q) {
	unsigned long a = 0L;
	unsigned long r = 0L;
	unsigned long e = 0L;
	unsigned long val = x;

	int i;

	for (i=0; i<32; ++i) {
		r = (r << 2) + TOP2BITS(x);
		x <<= 2;
		a <<= 1;
		e = (a << 1) + 1;
		if (r >= e) {
			r -= e;
			++a;
		}
	}


    q->sqrt = a>>16;
    q->frac = val - q->sqrt * q->sqrt;
}

#ifdef LOCAL_TEST
int main() {
	int i;
	struct int_sqrt q;

	for (i = 0; i < 101; ++i) {
		usqrt(i, &q);
		printf("sqrt(%3d) = %2d, remainder = %2d\n",
                  i, q.sqrt, q.frac);
	}

	return 0;
}
#else
struct int_sqrt q;
int main() {
	int i;

	for (i=0; i<101; ++i) {
		usqrt(i, &q);
	}

	return 0;
}
#endif
