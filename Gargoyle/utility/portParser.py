import os
import re
import sys
import logging

"""
portParser is used to parse the port name.
"""
re_port		=	re.compile(r"(?P<mname>\w+)")
re_wtPort	=	re.compile(r"""
(?P<mname>\w+)	# module name
wt				# write
\d*				# digit or not
$
""", re.X)
re_rdPort 	=	re.compile(r"""
(?P<mname>\w+)	# module name
rd				# read
\d*				# digit or not
$
""", re.X)

class portParser(object):

	def __init__(self):
		pass

	@staticmethod
	def is_aRdPort(portName):
		mgroup = re_rdPort.match(portName)
		if mgroup:
			return mgroup.group('mname')
		else:
			return None

	@staticmethod
	def is_aRdPort(portName):
		mgroup = re_rdPort.match(portName)
		if mgroup:
			return mgroup.group('mname')
		else:
			return None

	@staticmethod
	def is_aWtPort(portName):
		mgroup = re_wtPort.match(portName)
		if mgroup:
			return mgroup.group('mname')
		else:
			return None

if __name__ == '__main__':
