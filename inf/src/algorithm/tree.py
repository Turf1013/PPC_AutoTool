# -*- coding: utf-8 -*-


class Node(object):

	def __init__(self, fa, child=None):
		self.fa = fa
		self.stg = stg
		self.deep = deep
		self.child = child
		
	def __str__(self):
		pass
		
		
class Tree(object):
	
	def __init__(self, reg, rt=None):
		self.reg = reg
		self.rt = rt
		
	
	
class WTree(Tree):
	
	def __init__(self, reg, rt=None):
		super(WTree, self).__init__(reg, rt)
		
		
	# dfs a tree can generate the condition according path
	def dfs(self, rt):
		 