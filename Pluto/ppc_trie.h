#ifndef PPC_TRIE_H
#define PPC_TRIE_H

#define NXTN 		27 
#define TRIE_MAXN	505

typedef struct{
	int in;
    int next[NXTN];
} Trie_st;

static Trie_st tries[TRIE_MAXN];
static int N;

extern void trie_initial();
extern int  trie_newNode();
extern void trie_create();
extern int  trie_find();

#endif
