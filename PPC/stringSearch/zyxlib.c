#include "zyxlib.h"

void memcpy(char *des, char *src, int sz) {
	src += sz - 1;
	des += sz - 1;

	while (sz-- > 0) {
		*des = *src;
		--des;
		--src;
	}
}

int strlen(char *s) {
	int ret = 0;

	while (*s != '\0') {
		++ret;
		++s;
	}

	return ret;
}
