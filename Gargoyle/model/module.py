import sys
import os
import logging
import string
from itertools import izip

info_pattern = string.Template("""
[$name]:
In:
$In
Out:
$Out
""")

class module(object):

	def __init__(self, name, in_port, in_width, out_port, out_width):
		self.name = name
		self.in_port = in_port
		self.in_width = in_width
		self.out_port = out_port
		self.out_width = out_width
		
		in_str = '\t' + '\n\t'.join(
					map(lambda t: "%s: %s" % (t[0], t[1]), izip(in_port, in_width))
				) + '\n'
		out_str = '\t' + '\n\t'.join(
					map(lambda t: "%s: %s" % (t[0], t[1]), izip(out_port, out_width))
				) + '\n'
		self.info_dict = {
			'name'	: self.name,
			'In'	: in_str,
			'Out'	: out_str,
		}
		
		
	def __str__(self):
		return info_pattern.safe_substitute(self.info_dict)
		
		
if __name__ == '__main__':
	params_dict = {
		'name' 		: 'mux4',
		'in_port' 	: ['d0', 'd1', 'd2', 'd3', 's'],
		'in_width' 	: [2, 2, 2, 2, 2],
		'out_port' 	: ['y'],
		'out_width'	: [8],
	}
	mod = module(**params_dict)
	print mod
	