# -*- coding: utf-8 -*-
from ..util.verilogGenerator import VerilogGenerator as VG


class constForCtrlSignal:
	defaultValue = 0

class CFCS(constForCtrlSignal):
	pass


class CtrlTriple(object):
	""" Ctrl Triple is a triple included condtion, OP and priority.
	Because If-Else has priority, reload __cmp__ is necessary.
	
	"""
	
	def __init__(self, cond, op=0, pri=0):
		self.cond = cond
		self.op = op
		self.pri = pri

		
	def __eq__(self, other):
		return self.cond==other.cond and self.op==other.op
		
		
	def __cmp__(self, other):
		return other.pri - self.pri
	

class CtrlSignal(object):
	
	def __init__(self, name, width, stg, iterable=None):
		self.name = name
		self.width = width
		self.stg = stg
		if iterable is not None:
			self.st = set(iterable)
		else:
			self.st = set()
			
			
	def add(self, t):
		if not isinstance(t, CtrlTriple):
			raise TypeError, "Only CtrlTriple can add into CtrlSignal"
		self.st.add(t)
		
		
	def __len__(self):
		return len(self.st)
		
		
	def __hash__(self):
		return hash(self.name)
		
	
	def __eq__(self, other):
		return self.name == other.name
		
	
	def __contains__(self, t):
		if not isinstance(t, CtrlTriple):
			raise TypeError, "Only CtrlTriple can add into CtrlSignal"
		return t in self.st
	
	
	def sorted(self):
		return sorted(list(self.st))
	
		
	# Tranfer the ctronl signal to Verilog, Using ```always``` block to describe the control signal
	def toVerilog(self, tabn=1):
		return VG.GenCtrlSignalAlways(name=self.name, width=self.width, L=self.sorted(), tabn=tabn, default=CFCS.defaultValue)
		
		