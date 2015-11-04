import logging
import sys
import os
from collections import defaultdict
from scan_re import *
from const_hdl import *

"""
scan_hdl.py include:
1. split the fileList into 2 groups: xxx_def.v, module.v
2. scan_mod_file: scan module.v and ret module List
3. scan_instrDef_file: scan instruction define file, return xo and op dict
"""

def_suffix = "_def"
len_hdl_suffix = len(".v")

def scan_filename(fileList):
	"""
	scan filenames and return 2 List
	1. define list
	2. module list
	"""
	ret_def_List = []
	ret_mod_List = []
	for filename in fileList:
		if filename[:-len_hdl_suffix].endswith(def_suffix):
			ret_def_List.append(filename)
		else:
			ret_mod_List.append(filename)
	return ret_def_List, ret_mod_List
	

def scan_mod_file(filename):
	ret = []
	with open(filename, 'r') as fin:
		foundMod = False
		modName = None
		in_port = [], in_width = []
		out_port = [], out_width = []
		for line in fin:
			if foundMod and re_endmodule.match(line):
				foundMod = False
				is modName:
					ret.append(
						module(name=modName, in_port=in_port, in_width=in_width, out_port=out_port, out_width=out_width)
					)
				modName = None
				in_port = [], in_width = []
				out_port = [], out_width = []
				continue
			if not foundMod:
				'find module name first'
				mgroup = re_module.match(line)
				if mgroup:
					foundMod = True
					modName = mgroup.group('name')
					
			else:
				'find the port & width'
				mgroup = self.re_portWidth.match(line)
				if mgroup:
					direct = mgroup.group('dir')
					width = mgroup.group('width')
					width = width if width else hdl_WIDHTONE
					ports = self.re_portName.findall(line[mgroup.end():])
					ports = map(lambda s:s[:-1].strip(), ports)
					if direct[0] == hdl_INPUT[0]:
						in_port += ports
						in_width += [width] * len(ports)
					else:
						out_port += ports
						out_width += [width] * len(ports)
	return ret

	
def scan_insnDef_file(filename):
	re_instrDef = re.compile(r'[\S]+')
	ret_xo_dict = {}
	ret_op_dict = {}
	ret_op_ldict = defaultdict(list)
	len_define  = len(hdl_DEFINE)
	len_op 		= len(arch_OP)
	len_xo 		= len(arch_XO)
	with open(filename, 'r') as fin:
		for line in fin:
			if line.startswith(hdl_DEFINE):
				defName, def_Val = re_instrDef.findall(line[len_define:])[:2]
				if defName.endswith(arch_OP):
					ret_xo_dict[defName[:-len_op-1]] = defVal
					ret_op_ldict[defVal].append(defName[:-len_op-1])
				elif defName.endswith(arch_XO):
					ret_xo_dict[defName[:-len_xo-1]] = defVal
	return ret_op_dict, ret_xo_dict, ret_op_ldict
	
	
if __name__ == '__main__':
