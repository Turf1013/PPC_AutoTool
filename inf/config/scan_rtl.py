import string
import re
import sys

from .access_execel import Access_Excel
from ..utility.RTLParser import RTLParser
from ..arch.arch_parser import merge_in_stage

class read_Excel(Access_Excel):
	begRow = 0
	begCol = 0
	
	def __init__(self, path, sheeName):
		Access_Excel.__init__(path=path, sheeName=sheetName)
		self.insnBoundry = None
		self.endRow = self.get_NRow()
		self.endCol = self.get_NCol()
	
	def Get_insnBoundry(self):
		if self.insnBoundry is None:
			self.Gen_insnBoundry()
		return self.insnBoundry
		
		
	def Gen_insnBoundry(self):
		c_index = self.begCol
		f_row = self.begRow + 1
		t_row = self.endRow
		self.insnBoundry = []
		for r_index in range(f_row, t_row):
			insn = self.Get_OneCell(r_index, c_index)
			if insn:
				'replace addi. with addi_'
				insnName = insn[:-1] + '_' if insn[-1]=='.' else insn
				self.insnBoundry.append((insnName, r_index))
		'Add the end boundry'
		self.insnBoundry.append(('none', t_row))
		
		
	def Get_insnRtl(self):
		ret_conn_dict = {}
		ret_pipe_dict = {}
		ret_unknown_dict = {}
		for i in xrange(len(self.insnBoundry)-1):
			insnName, f_row = self.insnBoundry[i]
			t_row = self.insnBoundry[i+1][-1]
			conn, pipe, unknown = map(
				merge_in_stage, self.Get_aInsnRtl(f_row, t_row)
			)
			ret_conn_dict[insnName] = conn
			ret_pipe_dict[insnName] = pipe
			ret_unknown_dict[insnName] = unknown
		
		return ret_conn_dict, ret_pipe_dict, ret_unknown_dict
		
		
	def Get_aInsnRtl(self, f_row, t_row):
		ret_conn = []
		ret_pipe = []
		ret_unknown = []
		
		for i_col in xrange(self.begCol+1, self.endCol):
			rtls = RTLParser.strip_space(self.Get_OneCol(i_col, f_row, t_row))
			rtls = filter(lambda s: len(s)>0, rtls)
			conn, pipe, unknown = RTLParser.split_rtls(rtls)
			ret_conn.append(conn)
			ret_pipe.append(pipe)
			ret_unknown.append(unknown)
			
		return ret_conn, ret_pipe, ret_unknown
	