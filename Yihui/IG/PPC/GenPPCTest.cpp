/*
 * GenPPCTest.cpp
 *
 *  Created on: 2015Äê12ÔÂ25ÈÕ
 *      Author: Trasier
 */

#include "GenPPCTest.h"
#include "../GenTest.h"
#include "../head.h"
#include "GPR_I_Insn.h"
#include "Br_Insn.h"
#include "MTCRF_Insn.h"
#include "RLW_Insn.h"
#include "LD_Insn.h"
#include "MCRF_Insn.h"
#include "CMP_Insn.h"
#include "MTMSR_Insn.h"
#include "CR_Insn.h"
#include "STX_Insn.h"
#include "GPR_R_Insn.h"
#include "GPR_MF_Insn.h"
#include "ST_Insn.h"
#include "MTSPR_Insn.h"
#include "LDX_Insn.h"
#include "GPR_R2_Insn.h"


GenPPCTest::GenPPCTest(string filename=string("start.S")) {
	// TODO Auto-generated constructor stub
	init(filename);
}

GenPPCTest::~GenPPCTest() {
	// TODO Auto-generated destructor stub
	set<Insn*> st;
	for (int i=0; i<rvc.size(); ++i)
		st.insert(rvc[i]);
	for (int i=0; i<wvc.size(); ++i)
		st.insert(wvc[i]);
	for (set<Insn*>::iterator iter=st.begin(); iter!=st.end(); ++iter) {
		Insn *ptr = *iter;
		delete ptr;
	}
}

void GenPPCTest::init(string filename) {
	init_Entry(filename);
	init_Insn();
	init_GT();
}

void GenPPCTest::init_Entry(string filename) {
	fstream fin(filename.c_str(), ios::in);

	entry = "";
	string line;
	while (getline(fin, line)) {
		entry += line + "\n";
	}
}

void GenPPCTest::init_GT() {
	GT = new GenTest(n, entry, rvc, wvc);
	vi vc;
	rep(i, 1, 26)
		vc.pb(i);
	GT->setReg(vc);
}

void GenPPCTest::dump(vector<string>& vc) {
	GT->dump(vc);
}

void GenPPCTest::dump(vector<string>& vc, int n) {
	GT->dump(vc, n);
}

void GenPPCTest::write(string filename) {
	GT->write(filename);
}

void GenPPCTest::write(string filename, int n) {
	GT->write(filename, n);
}

void GenPPCTest::init_Insn() {
	Insn* insn;


	// initialize LDX_Insn
	insn = new LDX_Insn(string("lbzux"), 2, 1);
	insn->setR1(0);
	wvc.pb(insn);
	

	insn = new LDX_Insn(string("lhzux"), 2, 2);
	insn->setR1(0);
	wvc.pb(insn);
	

	insn = new LDX_Insn(string("lhaux"), 2, 2);
	insn->setR1(0);
	wvc.pb(insn);
	

	insn = new LDX_Insn(string("lwzux"), 2, 4);
	insn->setR1(0);
	wvc.pb(insn);
	




	// initialize Br_Insn
//	insn = new Br_Insn(string("b"), 0);
//	rvc.pb(insn);
	

	insn = new Br_Insn(string("bc"), 1);
	rvc.pb(insn);
	

//	insn = new Br_Insn(string("bcctr"), 1);
//	rvc.pb(insn);
	

//	insn = new Br_Insn(string("bclr"), 1);
//	rvc.pb(insn);
	




	// initialize MTSPR_Insn
	insn = new MTSPR_Insn(string("mtspr"), 1);
	rvc.pb(insn);
	




	// initialize ST_Insn
	insn = new ST_Insn(string("stbu"), 1, 4);
	insn->setR1(0);
	

	insn = new ST_Insn(string("sthu"), 1, 4);
	insn->setR1(0);
	

	insn = new ST_Insn(string("stwu"), 1, 4);
	insn->setR1(0);
	




	// initialize GPR_MF_Insn
	insn = new GPR_MF_Insn(string("mfcr"), 1);
	wvc.pb(insn);
	

	insn = new GPR_MF_Insn(string("mfspr"), 1);
	wvc.pb(insn);
	

	insn = new GPR_MF_Insn(string("mfmsr"), 1);
	wvc.pb(insn);
	




	// initialize GPR_R2_Insn
	insn = new GPR_R2_Insn(string("cntlzw"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R2_Insn(string("extsb"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R2_Insn(string("extsh"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R2_Insn(string("neg"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	
	insn = new GPR_R2_Insn(string("addme"), 2);
	rvc.pb(insn);
	wvc.pb(insn);


	insn = new GPR_R2_Insn(string("addze"), 2);
	rvc.pb(insn);
	wvc.pb(insn);

	insn = new GPR_R2_Insn(string("subfme"), 2);
	rvc.pb(insn);
	wvc.pb(insn);


	insn = new GPR_R2_Insn(string("subfze"), 2);
	rvc.pb(insn);
	wvc.pb(insn);


	// initialize STX_Insn
	insn = new STX_Insn(string("stbx"), 2, 4);
	insn->setR1(0);
	

	insn = new STX_Insn(string("sthx"), 2, 4);
	insn->setR1(0);
	

	insn = new STX_Insn(string("stwx"), 2, 4);
	insn->setR1(0);
	

	insn = new STX_Insn(string("sthbrx"), 2, 4);
	insn->setR1(0);
	

	insn = new STX_Insn(string("stwbrx"), 2, 4);
	insn->setR1(0);
	




	// initialize MTMSR_Insn
	insn = new MTMSR_Insn(string("mtmsr"), 1);
	rvc.pb(insn);
	




	// initialize GPR_R_Insn
	insn = new GPR_R_Insn(string("add"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("addc"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("adde"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("and"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("andc"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("eqv"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("nand"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("nor"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("or"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("orc"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("slw"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("sraw"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("srawi"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("srw"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("subf"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("subfc"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("subfe"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("xor"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("mulhw"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("mulhwu"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("mullw"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("divw"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_R_Insn(string("divwu"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	




	// initialize MCRF_Insn
	insn = new MCRF_Insn(string("mcrf"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	




	// initialize CMP_Insn
	insn = new CMP_Insn(string("cmp"), 2);
	wvc.pb(insn);
	wvc.pb(insn);
	

	insn = new CMP_Insn(string("cmpi"), 2);
	wvc.pb(insn);
	wvc.pb(insn);
	

	insn = new CMP_Insn(string("cmpl"), 2);
	wvc.pb(insn);
	wvc.pb(insn);
	

	insn = new CMP_Insn(string("cmpli"), 2);
	wvc.pb(insn);
	wvc.pb(insn);
	




	// initialize LD_Insn
	insn = new LD_Insn(string("lbzu"), 1, 1);
	insn->setR1(0);
	wvc.pb(insn);
	

	insn = new LD_Insn(string("lhzu"), 1, 2);
	insn->setR1(0);
	wvc.pb(insn);
	

	insn = new LD_Insn(string("lhau"), 1, 2);
	insn->setR1(0);
	wvc.pb(insn);
	

	insn = new LD_Insn(string("lwzu"), 1, 4);
	insn->setR1(0);
	wvc.pb(insn);
	




	// initialize RLW_Insn
	insn = new RLW_Insn(string("rlwimi"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new RLW_Insn(string("rlwinm"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new RLW_Insn(string("rlwnm"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	




	// initialize CR_Insn
	insn = new CR_Insn(string("crand"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new CR_Insn(string("crandc"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new CR_Insn(string("creqv"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new CR_Insn(string("crnand"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new CR_Insn(string("crnor"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new CR_Insn(string("cror"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new CR_Insn(string("crorc"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new CR_Insn(string("crxor"), 3);
	rvc.pb(insn);
	wvc.pb(insn);
	




	// initialize GPR_I_Insn
	insn = new GPR_I_Insn(string("addi"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("addic"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("addic."), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("addis"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("andis."), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("andi."), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("ori"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("oris"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("subfic"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("xori"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("xoris"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	

	insn = new GPR_I_Insn(string("mulli"), 2);
	rvc.pb(insn);
	wvc.pb(insn);
	




	// initialize MTCRF_Insn
	insn = new MTCRF_Insn(string("mtcrf"), 1);
	rvc.pb(insn);
	wvc.pb(insn);
	






}
