/*
 * GenMipsTest.cpp
 *
 *  Created on: 2015Äê12ÔÂ25ÈÕ
 *      Author: Trasier
 */

#include "GenMipsTest.h"
#include "../GenTest.h"
#include "../head.h"
#include "BInsn.h"
#include "RInsn.h"
#include "MInsn.h"
#include "IInsn.h"


GenMipsTest::GenMipsTest(string filename=string("start.S")) {
	// TODO Auto-generated constructor stub
	init(filename);
}

GenMipsTest::~GenMipsTest() {
	// TODO Auto-generated destructor stub
	for (int i=0; i<rvc.size(); ++i)
		delete rvc[i];
	for (int i=0; i<wvc.size(); ++i)
		delete wvc[i];
}

void GenMipsTest::init(string filename) {
	init_Entry(filename);
	init_Insn();
	init_GT();
}

void GenMipsTest::init_Entry(string filename) {
	fstream fin(filename.c_str(), ios::in);

	entry = "";
	string line;
	while (getline(fin, line)) {
		entry += line + "\n";
	}
}

void GenMipsTest::init_GT() {
	GT = new GenTest(n, entry, rvc, wvc);
	vi vc;
	rep(i, 1, 26)
		vc.pb(i);
	GT->setReg(vc);
}

void GenMipsTest::dump(vector<string>& vc) {
	GT->dump(vc);
}

void GenMipsTest::dump(vector<string>& vc, int n) {
	GT->dump(vc, n);
}

void GenMipsTest::write(string filename) {
	GT->write(filename);
}

void GenMipsTest::write(string filename, int n) {
	GT->write(filename, n);
}

void GenMipsTest::init_Insn() {
	Insn* insn;


	// initialize I_Insn
	insn = new I_Insn(string("addi"), 2);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new I_Insn(string("addiu"), 2);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new I_Insn(string("andi"), 2);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new I_Insn(string("ori"), 2);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new I_Insn(string("xori"), 2);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new I_Insn(string("lui"), 1);
	wvc.pb(insn);

	insn = new I_Insn(string("slti"), 2);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new I_Insn(string("sltiu"), 2);
	rvc.pb(insn);
	wvc.pb(insn);




	// initialize R_Insn
	insn = new R_Insn(string("add"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("addu"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("sub"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("subu"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("slt"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("sltu"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("srl"), 2);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("sra"), 2);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("sll"), 2);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("sllv"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("srav"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("srlv"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("and"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("or"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("xor"), 3);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new R_Insn(string("nor"), 3);
	rvc.pb(insn);
	wvc.pb(insn);




	// initialize M_Insn
	insn = new M_Insn(string("lb"), 1, 1);
	insn->setR1(0);
	wvc.pb(insn);

	insn = new M_Insn(string("lbu"), 1, 1);
	insn->setR1(0);
	wvc.pb(insn);

	insn = new M_Insn(string("lh"), 1, 2);
	insn->setR1(0);
	wvc.pb(insn);

	insn = new M_Insn(string("lhu"), 1, 2);
	insn->setR1(0);
	wvc.pb(insn);

	insn = new M_Insn(string("lw"), 1, 4);
	insn->setR1(0);
	wvc.pb(insn);

	insn = new M_Insn(string("sb"), 2, 1);
	insn->setR1(0);
	rvc.pb(insn);

	insn = new M_Insn(string("sh"), 2, 2);
	insn->setR1(0);
	rvc.pb(insn);

	insn = new M_Insn(string("sw"), 2, 4);
	insn->setR1(0);
	rvc.pb(insn);




	// initialize B_Insn
	insn = new B_Insn(string("beq"), 3);
	rvc.pb(insn);

	insn = new B_Insn(string("bne"), 3);
	rvc.pb(insn);

	insn = new B_Insn(string("bgez"), 2);
	rvc.pb(insn);

	insn = new B_Insn(string("blez"), 2);
	rvc.pb(insn);

	insn = new B_Insn(string("bgtz"), 2);
	rvc.pb(insn);

	insn = new B_Insn(string("bltz"), 2);
	rvc.pb(insn);



}
