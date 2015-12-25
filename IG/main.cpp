/*
 * main.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "head.h"
#include "MIPS/GenMipsTest.h"

int main() {
	ios::sync_with_stdio(false);
	#ifndef ONLINE_JUDGE
		freopen("data.in", "r", stdin);
		freopen("data.out", "w", stdout);
	#endif

	GenMipsTest gmt("F:/workspace/IG/MIPS/start.S");
	string filename("F:/workspace/IG/code.asm");

	gmt.write(filename);
	puts("end");

	return 0;
}


