//#define LOCAL_TEST
#ifdef LOCAL_TEST
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#else
#include "zyxlib.h"
#endif

void handle_hw_int(void) {}

int bit_count1(int x) {
	int n = 0;

	while (x) {
		++n;
		x = x & (x - 1);
	}

	return n;
}

int bit_count2(int i) {
	i = ((i & 0xAAAAAAAAL) >>  1) + (i & 0x55555555L);
	i = ((i & 0xCCCCCCCCL) >>  2) + (i & 0x33333333L);
	i = ((i & 0xF0F0F0F0L) >>  4) + (i & 0x0F0F0F0FL);
	i = ((i & 0xFF00FF00L) >>  8) + (i & 0x00FF00FFL);
	i = ((i & 0xFFFF0000L) >> 16) + (i & 0x0000FFFFL);
	return i;
}

static char bits[256] =
{
      0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,  /* 0   - 15  */
      1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,  /* 16  - 31  */
      1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,  /* 32  - 47  */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 48  - 63  */
      1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,  /* 64  - 79  */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 80  - 95  */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 96  - 111 */
      3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,  /* 112 - 127 */
      1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,  /* 128 - 143 */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 144 - 159 */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 160 - 175 */
      3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,  /* 176 - 191 */
      2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,  /* 192 - 207 */
      3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,  /* 208 - 223 */
      3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,  /* 224 - 239 */
      4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8   /* 240 - 255 */
};

int bit_count3(int x) {
	unsigned char *ptr = (unsigned char *) &x;
	int n = 0;

	n += bits[ *ptr++ ];
	n += bits[ *ptr++ ];
	n += bits[ *ptr++ ];
	n += bits[ *ptr++ ];

	return n;
}

int bit_count4(int x) {
	int n = bits[x & 0xff];

	if (0 != (x>>=8))
		n += bit_count4(x);

	return n;
}

#ifdef LOCAL_TEST
int main() {
	int i;
	int c1, c2, c3, c4;

	for (i = 0; i < 128; ++i) {
		c1 = bit_count1(i);
		c2 = bit_count2(i);
		c3 = bit_count3(i);
		c4 = bit_count4(i);

		printf("c1 = %d, c2 = %d, c3 = %d, c4 = %d", c1, c2, c3, c4);
		if (c1!=c2 || c1!=c3 || c1!=c4) putchar('*');
		putchar('\n');
	}

	return 0;
}
#else
int c1, c2, c3, c4;
int main() {
	int i;

	for (i = 0; i < 128; ++i) {
		c1 = bit_count1(i);
		c2 = bit_count2(i);
		c3 = bit_count3(i);
		c4 = bit_count4(i);
	}

	return 0;
}
#endif
