import os
import sys
import logging


class Node(object):
	'based node of graph'
	
	def __init__(self, name):
		self.name = name
		self.connections = []
		
		
	def add_edge(self, node):
		'add the child for this node'
		self.connections.append(node)
	
	
	def remove_edge(self, node):
		try:
			self.connnections.remove(node)
		except ValueError as ve:
			print "%s not in [%s]'s childList" % (node.name, self.name)
		
		
	def __iter__(self):
		return iter(self.connections)
	
	
	def __repr__(self):
		return 'Node[%s]: %d children' % (self.name, len(self.connections))
		
	
if __name__ == '__main__':
	