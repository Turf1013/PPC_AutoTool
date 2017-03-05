//#define LOCAL_TEST
#ifdef LOCAL_TEST
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#else
#include "zyxlib.h"
#endif

void handle_hw_int(void) {}

#define MAXN 55
int total;
char src[MAXN] = "add";
char des[MAXN] = "aaaaabadaddacadabcbddabccaddaaddcbaaabdcababa";
int next[MAXN];

void kmp(char des[], char src[]){
    int ld = strlen(des);
    int ls = strlen(src);
    int i, j;

    total = i = j = 0;
    while (i < ld) {
        if (des[i] == src[j]) {
            ++i;
            ++j;
        } else {
            j = next[j];
            if (j == -1) {
                j = 0;
                ++i;
            }
        }
        if (j == ls) {
            ++total;
            j = next[j];
        }
    }
}

void getnext(char src[]) {
    int i=0, j = -1;

    next[0] = -1;
    while (i < strlen(src)) {
        if (j==-1 || src[i]==src[j]) {
            ++i;
            ++j;
            next[i] = j;
        } else {
            j = next[j];
        }
    }
}

int main() {
    int n = 1;

    while (n--) {
        getnext(src);
        kmp(des, src);
    }

    return 0;
}

