# -*- coding: utf-8 -*-


class Reg(object):
	""" Reg describe the information of Register.
	
	Include:
	1. rn: number of read channels;
	2. wn: number of read channels;
	"""
	def __init__(self, name, rn, wn):
		self.name = name
		self.rn = rn
		self.wn = wn
		
		
	def __hash__(self):
		return hash(self.name)
		
		
	def __eq__(self, other):
		return self.name == other.name
		
		
	def __str__(self):
		return self.name