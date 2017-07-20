/*
 * main.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "head.h"

#define PPC

#ifdef MIPS
#include "MIPS/GenMipsTest.h"

int main() {
	ios::sync_with_stdio(false);
	#ifndef ONLINE_JUDGE
		freopen("data.in", "r", stdin);
		freopen("data.out", "w", stdout);
	#endif

	GenMipsTest gmt("F:/workspace/IG/MIPS/start.S");
	string filename("I:/code.S");

	gmt.write(filename);
	puts("end");

	return 0;
}
#else
#include "PPC/GenPPCTest.h"

int main() {
	ios::sync_with_stdio(false);
	#ifndef ONLINE_JUDGE
		freopen("data.in", "r", stdin);
		freopen("data.out", "w", stdout);
	#endif

	GenPPCTest gmt("F:/workspace/IG/PPC/start.S");
	string filename("I:/code.S");

	gmt.write(filename);
	puts("end");

	return 0;
}
#endif


