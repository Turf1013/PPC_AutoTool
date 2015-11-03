import string
import re


"""
arch_insn:
@descrip: function about insn
@include:
1. split_insnGroups: split insn into 2 groups: normal(with unique op) and special(with same op). (may be more later)
"""

def Split_insnGroups(self, op_ldict):
	"""
	split insn into 2 groups: normal & special.
	op_ldict is the dict `key is real value, val in insnName list`
	"""
	ret_ngroup = []
	ret_sgroup = {}
	
	for key, insnList in op_ldict.iteritems():
		if len(insnList)>1:
			ret_sgroup[key] = insnList
		else:
			ret_ngroup.append(insnList[0])
			
	return ret_ngroup, ret_sgroup
