import os
import re
import sys
import logging


pplr_prefix = 'pplr'
ppc_insnGrp = 'InsnGrp'

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

	@staticmethod
	def gen_rInsnGrp(index, stg):
		return 'r%s_%d_%s' % (ppc_insnGrp, index, stg)

	@staticmethod
	def gen_wInsnGrp(indes, stg):
		return 'w%s_%d_%s' % (ppc_insnGrp, index, stg)

	@staticmethod
	def gen_modwAddrPortName(mname, index=0):
		if index:
			return '%s_waddr_%d' % (mname, index)
		else:
			return '%s_waddr' % (mname)

	@staticmethod
	def gen_modrAddrPortName(mname, index=0):
		if index:
			return '%s_raddr_%d' % (mname, index)
		else:
			return '%s_raddr' % (mname)
