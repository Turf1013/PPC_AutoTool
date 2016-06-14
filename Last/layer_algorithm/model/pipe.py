# -*- coding: utf-8 -*-
import logging
from ..util.verilog import verilog as vlg
from ..util.decorator import accepts, returns
from abc import abstractmethod
import os


class constForPipe:
	INSTR = "Instr"
	INSN_NOP = "`NOP"
	CLK = "clk"
	RST = "rst_n"
	CLR = "clr"
	
class CFP(constForPipe):
	pass
	
	
class BasePipe(object):

	def __init__(self, nxtStg):
		self.dout = dict()
		self.nxtStg = nxtStg
		
		
	@abstractmethod	
	def toVerilog(self, tabn):
		pass
		
		
	def isEmpty(self):
		return len(self.dout) == 0
		
		
	def addFlow(self, din, dout):
		self.dout[dout] = din
		
		
	def __eq__(self, other):
		return self.nxtStg == other.nxtStg
		
		
	def __cmp__(self, other):
		return cmp(self.nxtStg, other.nxtStg)
		
	
	def __repr__(self):
		return "Pipe To %s" % (self.nxtStg.name)
		
	__str__ = __repr__
		
		
class Pipe(BasePipe):
	
	
	def __init__(self, curStg, nxtStg):
		super(Pipe, self).__init__(nxtStg)
		self.curStg = curStg
		
		
	def toVerilog(self, tabn = 1):
		pre = "\t" * tabn
		suf = self.nxtStg.name
		ret = pre + "/*****     Pipe_%s     *****/" % (self.curStg.name)
		ret += pre + "always @( posedge %s or negedge %s ) begin\n" % (CFP.CLK, CFP.RST)
		# add reset
		ret += pre + "\t" + "if ( !%s ) begin\n" % (CFP.RST)
		for din,val in dout.iteritems():
			if din == CFP.INSTR:
				ret += pre + "\t\t" + "%s_%s <= %s;\n" % (din, suf, CFP.NOP)
			else:
				ret += pre + "\t\t" + "%s_%s <= 0;\n" % (din, suf)
		ret += pre + "\t" + "end\n" 
		# add clear
		ret += pre + "\t" + "else if ( %s_%s ) begin\n" % (CFP.CLR)
		for din, val in dout.iteritems():
			if din == CFP.INSTR:
				ret += pre + "\t\t" + "%s_%s <= %s;\n" % (din, suf, CFP.NOP)
			else:
				ret += pre + "\t\t" + "%s_%s <= %s;\n" % (din, suf, val)
		# add else
		ret += pre + "\t" + "else begin\n"
		for din, val in dout.iteritems():
			ret += pre + "\t\t" + "%s_%s <= %s;\n" % (din, suf, val)
		ret += pre + "\t"  + "end\n"
		ret += pre + "\t" + "end // end always\n"
		return ret
	