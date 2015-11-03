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
	def gen_modOutPortName(mname, stg=''):
		ret = '%s_out' % (mname)
		if stg:
			ret += '_%d' % (stg)
		return stg

	@staticmethod
	def gen_rInsnGrp(index, stg):
		return 'r%s_%d_%s' % (ppc_insnGrp, index, stg)

	@staticmethod
	def gen_wInsnGrp(indes, stg):
		return 'w%s_%d_%s' % (ppc_insnGrp, index, stg)

	@staticmethod
	def gen_modwAddrPortName(mname, index='', stg=''):
		if index:
			ret = '%s_waddr_%d' % (mname, index)
		else:
			ret = '%s_waddr' % (mname)
		if stg:
			ret += '_%d' % (stg)

	@staticmethod
	def gen_modrAddrPortName(mname, index='', stg=''):
		if index:
			ret = '%s_raddr_%d' % (mname, index)
		else:
			ret = '%s_raddr' % (mname)
		if stg:
			ret += '_%d' % (stg)

	@staticmethod
	def gen_modRdPortName(mname, index='', stg=''):
		if index:
			ret = '%s_rd_%d' % (mname, index)
		else:
			ret = '%s_rd' % (mname)
		if stg:
			ret += '_%d' % (stg)
		return ret

	@staticmethod
	def gen_bp_modRdPortName(mname, index='', stg=''):
		if index:
			ret = '%s_rd_bp_%d' % (mname, index)
		else:
			ret = '%s_rd_bp' % (mname)
		if stg:
			ret += '_%d' % (stg)
		return ret

	@staticmethod
	def gen_modWtPortName(mname, index='', stg=''):
		if index:
			ret = '%s_wt_%d' % (mname, index)
		else:
			ret = '%s_wt' % (mname)
		if stg:
			ret += '_%d' % (stg)
		return ret
