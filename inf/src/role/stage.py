# -*- coding: utf-8 -*-

class constForStage:
	pass
	
class CFS(constForStage):
	pass

class Stage(object):

	def __init__(self, id, name):
		self.id = int(id)
		self.name = name
	
	
	def __str__(self):
		self.name
		
		
	def __repr__(self):
		return "Stage_%d %s" % (self.id, self.name)
		
		
	def __eq__(self, other):
		return self.id == other.id
		
		
	def __hash__(self):
		return hash(self.id)
		
	
	def __cmp__(self, other):
		return self.id - other.id
		
		
