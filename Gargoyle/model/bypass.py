import logging
import os
import sys

class bypass(object):
	
	def __init__(self, stg_i, stg_y,\
		x_srcPort, y_srcPort, x_insn, y_insn):
		self.stg_i = stg_i
		self.stg_y = stg_y
		self.x_srcPort = x_srcPort
		self.y_srcPort = y_srcPort
		self.x_insn = x_insn
		self.y_insn = y_insn
		
	def __str__(self):
		return """
		Write Info:
		Stage     %s
		wPort     %s
		wInsnGrp  %s
		
		Read Info:
		Stage     %s
		rPort     %s
		rInsnGrp  %s
		""" %\
		(self.stg_i, self.stg_y, self.x_srcPort,\
			self.y_srcPort, self.x_insn, self.y_insn)
			