import os
import re
import sys
import logging


pplr_prefix = 'pplr'

class portRename(object):

	def __init__(self):
		pass

	@staticmethod
	def gen_pplrName(istage):
		return '%s_%d' % (pplr_prefix, istage)

	@staticmethod
	def gen_rModName(mname):
		return '%s_r' % (mname)

	@staticmethod
	def gen_wModName(mname):
		return '%s_w' % (mname)
		
		
	@staticmethod
	def gen_modOutPortName(mname):
		return '%s_out' % (mname)