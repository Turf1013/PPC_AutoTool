# -*- coding: utf-8 -*-
import logging
from ..util.verilog import verilog as vlg
from ..util.decorator import accepts, returns
import os

class constForControl:
	INSTR = "Instr"
	CLK = "clk"
	RST = "rst_n"
	CLR = "clr"
	STALL = "stall"
	
class CFC(constForControl):
	pass
	
	
class BaseControl(object):

	def __init__(self, proc):
		self.proc = proc
		
		
	def 