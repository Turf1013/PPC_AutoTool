#include "ppc_arch.h"


#define EN_TRANS(fname, type, n)\
type fname(type val) {\
	int i;\
	type ret = 0;\
	for (i=0; i<n; ++i) {\
        ret <<= 8;\
        ret |= (val & 0xff);\
        val >>= 8;\
	}\
	return ret;\
}

EN_TRANS(En_trans_32, u32, 4)
EN_TRANS(En_trans_64, u64, 8)

