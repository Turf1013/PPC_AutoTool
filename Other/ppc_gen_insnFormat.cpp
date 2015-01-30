#include <iostream>
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <map>
#include "ppc_format.h"
#include "ppc_opcode.h"
using namespace std;

#define MAXL 55

char formBuf[PPC_FORM_N][MAXL] = {
	"I_Form",
	"B_Form",
	"SC_Form",
	"D_Form",
	"DS_Form",
	"X_Form",
	"XL_Form",
	"XFX_Form",
	"XFL_Form",
	"XS_Form",
	"XO_Form",
	"A_Form",
	"M_Form",
	"MD_Form",
	"MDS_Form"
};

int main() {
	int n = OP_N;

	freopen("data.out", "w", stdout);

	// insnDict is the top Dict contains all subDict
	// subDict includes the 
	printf("insnDict = {\n");
	for (int i=0; i<n; ++i) {
		printf("\t'%s' = {\n", mnemonics[i]);
		// add the attribute of insn
		printf("\t\t'op': %d,\n", Primary_Op[i]);
		printf("\t\t'xo': %d,\n", Extend_Op[i]);
		printf("\t\t'form': %sDict,\n", formBuf[Forms[i]]);
		printf("\t};\n");
	}
	printf("};\n");

	return 0;
}