import os
import re
import sys
import logging

from ..configuration.const_rtl import *

"""
RTLParser is used for parsing the RTL.
"""
re_space = re.compile(r'\s+')

class RTLParser(object):

	def __init__(self):
		pass
	
	@staticmethod
	def strip_space(s):
		if isinstance(s, str) or isinstance(s, unicode):
			return re_space.sub('', s)
		elif isinstance(s, list):
			return map(RTLParser.strip_space, s)

			
	@staitcmethod
	def split_rtl(s):
		ret_conn = []
		ret_pipe = []
		ret_unknown = []
		if rtl_CONNECT in s:
			srcPort, desPort = rtl.split(rtl_CONNECT)[:2]
			if not RTLParser.port_is_same_mod(srcPort, desPort):
				ret_conn.append((srcPort, desPort))
		elif rtl_PIPE in s:
			srcPort = rtl.split(rtl_PIPE)[:1]
			ret_pipe.append(srcPort)
			
		return ret_conn, ret_pipe, ret_unknown
			
			
	@staticmethod
	def split_rtls(s):
		if isinstance(s, str):
			return RTLParser.split_rtl(s)
		ret_conn = []
		ret_pipe = []
		ret_unknown = []
		if isinstance(s, list):
			for ss in s:
				conn, pipe, unknown = RTLParser.split_rtl(ss)
				ret_conn += conn
				ret_pipe += pipe
				ret_unknown += unknown
				
		return ret_conn, ret_pipe, ret_unknown
			

if __name__ == '__main__':
	