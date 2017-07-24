/*
 * GenTest.cpp
 *
 *  Created on: 2015Äê12ÔÂ24ÈÕ
 *      Author: Trasier
 */

#include "GenTest.h"
#include "head.h"

#ifdef DEBUG
	const string GenTest::op = string("nrw");
#endif

GenTest::GenTest(int n, string entry, vector<Insn*> rvc,  vector<Insn*> wvc):
	n(n), entry(entry) {
	// TODO Auto-generated constructor stub
	perm = new Permutation(n);
	init(rvc, wvc);
	// using nopNum to control the number of NOP after the block.
	int nopNum = 3;
	blk = new Block(nopNum);
}

GenTest::GenTest(int n, string entry, vector<Insn*> rvc, vector<Insn*> wvc, int* C):
	n(n), entry(entry) {
	// TODO Auto-generated constructor stub
	perm = new Permutation(n, C);
	init(entry, rvc, wvc);
	// using nopNum to control the number of NOP after the block.
	int nopNum = 3;
	blk = new Block(nopNum);
}

GenTest::~GenTest() {
	// TODO Auto-generated destructor stub
}

void GenTest::setEntry(string entry) {
	this->entry = entry;
}

void GenTest::setReg(const vi& vc) {
	regvc.assign(all(vc));
}

void GenTest::setRvc(vector<Insn*> vc) {
	rvc.assign(all(vc));
}

void GenTest::setWvc(vector<Insn*> vc) {
	wvc.assign(all(vc));
}

void GenTest::init_Rng() {
	rRng.init(SZ(rvc));
	wRng.init(SZ(wvc));
}

void GenTest::init_Reg() {
	regvc.clr();
	rep(i, 2, 32) {
		regvc.pb(i);
	}
}

void GenTest::init_Ivc(vector<Insn*> rvc, vector<Insn*> wvc) {
	setRvc(rvc);
	setWvc(wvc);
	init_Rng();
}

void GenTest::init() {
	init_Rng();
	init_Reg();
	labeln = 1;
}

void GenTest::init_Entry(string entry) {
	this->entry = entry;
}

void GenTest::init(string entry) {
	init_Entry(entry);
	init();
}

void GenTest::init(vector<Insn*> rvc, vector<Insn*> wvc) {
	init_Ivc(rvc, wvc);
	init();
}

void GenTest::init(string entry, vector<Insn*> rvc, vector<Insn*> wvc) {
	init(entry);
	init(rvc, wvc);
}

void GenTest::write(string filename) {
	vector<string> vc;
	dump(vc);
	int sz = SZ(vc);
	fstream fout(filename.c_str(), ios::out);

	if (!fout) {
		cerr << "can not open " << filename << endl;
		return ;
	}

	rep(i, 0, sz) {
		fout << vc[i] << endl;
	}

	fout.close();
}

void GenTest::write(string filename, int n) {
	vector<string> vc;
	dump(vc, n);
	int sz = SZ(vc);
	fstream fout(filename.c_str(), ios::out);

	if (!fout) {
		cerr << "can not open " << filename << endl;
		return ;
	}

	rep(i, 0, sz) {
		fout << vc[i] << endl;
	}

	fout.close();
}

void GenTest::dump(vector<string>& vc) {
	vc.clr();
	vc.pb(entry);
	genHazard(vc);

	// return to start
	vc.pb(string("_loop:\n"));
	vc.pb(string("\tb _loop\n"));
	vc.pb(string("\t" + Block::NOP));
	vc.pb(string("\t" + Block::NOP));
}

void GenTest::dump(vector<string>& vc, int n) {
	vc.clr();
	vc.pb(entry);
	rep(i, 0, n)
		genHazard(vc);

	// return to start
	vc.pb(string("_loop:\n"));
	vc.pb(string("\tb _loop\n"));
	vc.pb(string("\t" + Block::NOP));
	vc.pb(string("\t" + Block::NOP));
}

void GenTest::genHazard(vector<string>& vc) {
	vector<vi> pvc;
	perm->getPermutation(pvc);
	int sz = SZ(pvc);

	rep(i, 0, sz) {
		rep(j, 0, caseN) {
#ifdef DEBUG
			int id;
			updateBlock(pvc[i], id);
			string str("\t# ");
			rep(j, 0, n)
				str += op[pvc[i][j]];
			sprintf(buf, " regid = %d", regvc[id]);
			str += string(buf);
			vc.pb(str);
#else
			updateBlock(pvc[i]);
#endif
			blk->dump(vc);
			vc.pb("\n");
		}
	}
}

void GenTest::updateBlock(const vi& vc) {
	blk->init();
	int a;
	Insn* insn;
	int regid = rand() % SZ(regvc);
	bool flag = false, fflag = false;

	rep(i, 0, n) {
		a = vc[i];
		if (a == perm->NOP) {
			//blk->pb();
			int tmpId = rand() % SZ(regvc);
			while (tmpId == regid) {
				tmpId = rand() % SZ(regvc);
			}
			insn = randrInsn(tmpId);
			blk->pb(insn->dump(labeln, fflag=false));
		} else if (a == perm->READ) {
			insn = randrInsn(regid);
			blk->pb(insn->dump(labeln, fflag=false));
		} else {
			insn = randwInsn(regid);
			blk->pb(insn->dump(labeln, fflag=false));
		}
		if (fflag)
			flag = true;
	}

	if (flag)
		blk->setLabel(labeln++);
}

#ifdef DEBUG
void GenTest::updateBlock(const vi& vc, int& id) {
	blk->init();
	int a;
	Insn* insn;
	int regid = rand() % SZ(regvc);
	bool flag = false, fflag = false;

	rep(i, 0, n) {
		a = vc[i];
		if (a == perm->NOP) {
			//blk->pb();
			int tmpId = rand() % SZ(regvc);
			while (tmpId == regid) {
				tmpId = rand() % SZ(regvc);
			}
			insn = randrInsn(tmpId);
			blk->pb(insn->dump(labeln, fflag=false));
		} else if (a == perm->READ) {
			insn = randrInsn(regid);
			blk->pb(insn->dump(labeln, fflag=false));
		} else {
			insn = randwInsn(regid);
			blk->pb(insn->dump(labeln, fflag=false));
		}
		if (fflag)
			flag = true;
	}

	if (flag)
		blk->setLabel(labeln++);

	id = regid;
}
#endif

Block GenTest::genBlock(const vi& vc) {
	Block blk(n);
	int a;
	Insn* insn;
	int regid = rand() % SZ(regvc);
	bool flag = false, fflag;

	rep(i, 0, n) {
		a = vc[i];
		if (a == Permutation::NOP) {
			//blk->pb();
			int tmpId = rand() % SZ(regvc);
			while (tmpId == regid) {
				tmpId = rand() % SZ(regvc);
			}
			insn = randrInsn(tmpId);
			blk.pb(insn->dump(labeln, fflag=false));
		} else if (a == Permutation::READ) {
			insn = randrInsn(regid);
			blk.pb(insn->dump(labeln, fflag=false));
		} else {
			insn = randwInsn(regid);
			blk.pb(insn->dump(labeln, fflag=false));
		}
		if (fflag)
			flag = true;
	}

	if (flag)
		blk.setLabel(labeln++);

	return blk;
}

bool GenTest::valid(vi vc) {
	return true;
}

Insn* GenTest::randrInsn(int regid) {
	//int id = rRng.randint() - 1;
	int id = rand() % (rvc.size());
	Insn* insn = rvc[id];
	int rn = insn->rn - 1;

	if (rn <= 0) {
		cout << insn->getName() << endl;
	}
	//assert(rn > 0);

	if (rn == 1) {
		insn->setRd(1, regvc[regid]);
	} else if (rn == 2) {
		int mask = rand() & 1;
		insn->setRd(mask+1, regvc[regid]);
		insn->setRd((mask^1)+1, regvc[rand()%SZ(regvc)]);
	}
	insn->setRw(regvc[rand()%SZ(regvc)]);

	return insn;
}

Insn* GenTest::randwInsn(int regid) {
	//int id = wRng.randint() - 1;
	int id = rand() % (wvc.size());
	Insn* insn = wvc[id];
	int rn = insn->rn - 1;

	if (rn == 1) {
		insn->setRd(1, regvc[rand()%SZ(regvc)]);
	} else if (rn == 2) {
		insn->setRd(1, regvc[rand()%SZ(regvc)]);
		insn->setRd(2, regvc[rand()%SZ(regvc)]);
	}

	insn->setRw(regvc[regid]);
	return insn;
}
