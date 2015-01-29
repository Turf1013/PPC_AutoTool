#include "ppc_trie.h"
#include "ppc_opcode.h"

void trie_inital() {
	N = -1;
	trie_newNode();
}

int trie_newNode() {
	int j;
	
	++N;
	tries[N].in = -1;
	for (j=0; j<NXTN; ++j)
		tries[N].next[j] = 0;
	return N;	
}

void trie_create(char str[], int in) {
	int i = 0, id;
	int p = 0;
	
	while ( str[i] ) {
		if (str[i] == '.')
			id = 26;
		else	
			id = str[i] - 'a';
		if (tries[p].next[id] == 0) {
			tries[p].next[id] = trie_newNode();
		}
		p = tries[p].next[id];
	}
	
	tries[p].in = in;
}

int find(char str[]) {
	int i = 0, id;
	int p = 0;
	
	while ( str[i] ) {
		if (str[i] == '.')
			id = 26;
		else
			id = str[i] - 'a';
		if (tries[p].next[id] == 0)	
			return -1;
		p = tries[p].next[id];
	}
	
	return tries[p].in;
}