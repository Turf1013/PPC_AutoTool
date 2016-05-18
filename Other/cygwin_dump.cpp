/**
	\author	Trasier
	\data	04/28
	\usage
		./main `xxx\xxx\*.bin.txt`
		or ./main then input the filepath. 
	\dump
		`insn.coe`: the code of instruction
		`data.coe`: the value of defined global data
*/
#include <iostream>
#include <sstream>
#include <ftream>
#include <string>
#include <map>
#include <queue>
#include <set>
#include <stack>
#include <vector>
#include <deque>
#include <bitset>
#include <algorithm>
#include <cstdio>
#include <cmath>
#include <ctime>
#include <cstring>
#include <climits>
#include <cctype>
#include <cassert>
#include <functional>
#include <iterator>
#include <iomanip>
using namespace std;

#define sti				set<int>
#define stpii			set<pair<int, int> >
#define mpii			map<int,int>
#define vi				vector<int>
#define pii				pair<int,int>
#define vpii			vector<pair<int,int> >
#define rep(i, a, n) 	for (int i=a;i<n;++i)
#define per(i, a, n) 	for (int i=n-1;i>=a;--i)
#define clr				clear
#define pb 				push_back
#define mp 				make_pair
#define fir				first
#define sec				second
#define all(x) 			(x).begin(),(x).end()
#define SZ(x) 			((int)(x).size())
#define lson			l, mid, rt<<1
#define rson			mid+1, r, rt<<1|1


#define LOCAL_DEBUG

const string section_prefix = "Disassembly of section ";
const string section_text_prefix = section_prefix + ".text";
const string section_data_prefix = section_prefix + ".data";
const string address_prefix = "bfc00000:	";
const string default_fill = "00000000";
const int BEGLENGTH = address_prefix.length();


inline bool ishex(char ch) {
	return (ch>='0' && ch<='9') || (ch>='a' && ch<='f');
}

static bool beginwith(const string& line, const string& prefix) {
	const int len = line.length();
	const int plen = prefix.length();

	if (plen > len)	return false;

	rep(i, 0, plen)
		if (line[i] != prefix[i])
			return false;

	return true;
}

void dump(const string& filename) {
	ifstream fin(filename.c_str());
	ofstream codeFout("insn.coe");
	ofstream dataFout("data.coe");

	if (!fin.is_open()) {
		cerr << filename << " not exists" << endl;
		abort();
	}
	
	codeFout << "memory_initialization_radix=16;" << "\n";
	codeFout << "memory_initialization_vector=" << "\n";
	dataFout << "memory_initialization_radix=16;" << "\n";
	dataFout << "memory_initialization_vector=" << "\n";
	
	string line;
	bool dumpCode = false, dumpData = false;
	unsigned int curaddr = 0, tmp;
	bool isaddr;

	while (getline(fin, line)) {
		int len = line.length();
		if (len < BEGLENGTH)
			continue;

		isaddr = line[8] == ':';
		if (isaddr) {
			tmp = 0;
			rep(i, 0, 8) {
				if (!ishex(line[i])) {
					isaddr = false;
					break;
				}
				tmp = tmp * 16 + (isdigit(line[i]) ? line[i]-'0' : line[i]-'a'+10);
			}
		}

		if (isaddr) {
			if (curaddr == 0) curaddr = tmp;
			while (curaddr+4 < tmp) {
				if (dumpCode)
					codeFout << default_fill  << endl;
				else if (dumpData)
					dataFout << default_fill  << endl;
				curaddr += 4;
			}

			if (dumpCode)
				codeFout << line.substr(BEGLENGTH, 8) << endl;
			else if (dumpData)
				dataFout << line.substr(BEGLENGTH, 8) << endl;
			curaddr = tmp;
		}

		if (beginwith(line, section_prefix)) {
			dumpCode = dumpData = false;
			if (beginwith(line, section_text_prefix)) {
				dumpCode = true;
			} else if (beginwith(line, section_data_prefix)) {
				curaddr = 0;
				dumpData = true;
			}
		}
	}

	fin.close();
	dataFout.close();
	codeFout.close();
}

int main(int argc, char **argv) {
	string filename;
	
	if (argc > 1) {
		filename = string(argv[1]);
	} else {
		cout << "input *.elf.txt filename: ";
		cin >> filename;
	}

	dump(filename);

	return 0;
}
