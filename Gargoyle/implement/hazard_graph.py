import os
import sys
import logging
from based_graph import Node
from gen_portName import *

"""
Gargoyle handle the hazard based on Graph Theory.
I got my idea from LCA & LP problem.
Thanks for Tarjan solving many hard problmem in Graph Theory.
1. Why I choose Graph?
In Geass Version, I use tree to handle the hazard between different stages.
I find that is really compilcated because tree is unidirectional.
Sine execution is in-order, hazard here especially means WAR.
while tree only presents the order of pipeline,
Graph presents the read & write relationship better than tree.
Futhermore, using node attr we can find the link between core-module & instruction.

2. Implement Tricks?

"""

class insnCluster(object):
	'insnCluster is a cluster converge with instruction'
	
	# @param:
	#	insnList: instruction List
	def __init__(self, name, insnList):
		if isinstance(insnList, (tuple, list)):
			self.insnSet = set(insnList)
		elif isinstance(insnList, (set)):
			self.insnSet = insnList
		else:
			raise TypeError, 'using tuple or list construct insnCluster'
	
	
	def add_insn(self, insn):
		self.insnSet.add(insn)
	
	
	# @param:
	#	insnCls: insnCluster
	def add_insnCls(self, insnCls):
		self.insnSet |= insnCls.insnSet
	
	
	def __iter__(self):
		return iter(self.insnSet)
	
			
	def __repr__(self):
		return 'Cluster[%s]:\n' % (self.name) + str(self.insnSet)
	

	
class modNode(Node):
	'modNode means module Node, a node structure of our graph'
	
	typeDict = {
		'root'		:	0,
		'read'		:	1,
		'write'		:	2,
		'access'	:	3,
		'func'		: 	4,
		'pplr'		:	5,
		'calc'		:	6,
		'unknown'	: 	7,
	}
	
	# @param:
	#	name: name of the module
	#	stgn: num of the module need to finish work
	#	type: type means type of the node, included
	#			read, write, access(read & write, like memroy)
	#			function, pipeLine Register, calculate
	#	insnCls: instruction Cluster using this module
	def __init__(self, name, stgn, mtype, insnCls):
		Node.__init__(self, name)
		self.insnCls = insnCls
		self.stgn = stgn
		self.mtype = 
	

class harzard_Graph(object):
	
	# @param:
	#	ppl: 	pipeline description
	#	rtls:	RTL setences
	def __init__(self, ppl, connRtls, pipeRtls):
		self.root = modNode(
			name='root', stgn=0, type=0, insnCls=None
		)
		self.connRtls = connRtls
		self.pipeRtls = pipeRtls
		self.nodeList = []
		self.nodeDict = {}
		
	# @function: create core Module node (ALU, MDU, etc)
	def create_allModNode(self):
		'add middle module to the list'
		for istg in range(self.ppl.rIndex+1, self.ppl.wIndex):
			nameList = self.module[istg]
			stgList  = [istg] * len(nameList)
			tmpList = map(
				lambda name, stg: modName(name, stg, modNode.typeDict['unknown'], []),
				nameList, stgList
			)
			self.nodeList += tmpList
			self.nodeDict.update(zip(nameList, tmpList))
			'add pipeline register module from every stage'
			pplrName = gen_pplrName(istg)
			self.nodeList.append(
				modName(pplrName, istg, modNode.typeDict['pplr'], [])
			)
			self.nodeDict[pplrName] = self.nodeList[-1]
			
		
		'add read module'
		self.rNodeRng = (len(self.NodeList), len(self.NodeList) + len(self.ppl.rmodule))
		tmpList += map(
			lambda name, stg: modName(name, stg, modNode.typeDict['read'], []),
			self.ppl.rmodule, [rIndex] * len(self.ppl.rmodule)
		)
		self.nodeList += tmpList
		self.nodeDict.update(zip(self.ppl.rmodule, tmpList))
		
		
		'add write module'
		self.wNodeRng = (len(self.NodeList), len(self.NodeList) + len(self.ppl.wmodule))
		tmpList += map(
			lambda name, stg: modName(name, stg, modNode.typeDict['write'], []),
			self.ppl.wmodule, [rIndex] * len(self.ppl.wmodule)
		)
		self.nodeList += tmpList
		self.nodeDict.update(zip(self.ppl.wmodule, tmpList))
	
	
	# @function:
	def add_OneInstr(self):
		'readPort in pipeRtls'
		
		
	
	# @function: 
	def create_allEdge(self):
		pass
	
	
	
	
if __name__ == '__main__':
	