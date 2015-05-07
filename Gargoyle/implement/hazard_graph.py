import os
import sys
import logging
from based_graph import Node
from gen_portName import *
from ..utility.portParser import portParser
from ..utility.RTLParser import  RTLParser
from ..utility.portRename import portRename

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
	
	
	def add_aInsn(self, insn):
		self.insnSet.add(insn)
	
	
	# @param:
	#	insnCls: insnCluster
	def add_aInsnCls(self, insnCls):
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
	
	# @function:
	#	add a instruction to insnCls
	def add_aInsn(self, insnName):
		self.insnCls.add_aInsn(insnName)
	

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
		self.rNodeRng = ()	# read modNode Range
		self.wNodeRng = ()	# write modNode Range
		
		
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
			pplrName = portRename.gen_pplrName(istg)
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
	#	add a complete data flow to the Graph, only the edges between rIndex and wIndex.
	#	Here I choose to add insnName to the modName, 
	#	because hazard_graph is used to generate hazard condition and stall condition,
	#	we only need these items:
	#	(1) stage info: from self.ppl
	#	(2) insn info: collect in insnCls
	#	(3) read or write: rmodule & wmodule
	#	(4) other info: extremely probability as the hard code.
	# @param:
	#	insnName: name of insn
	def add_aInstr(self, insnName):
		'readPort in pipeRtls'
		insnConn = self.connRtls[insnName]
		insnPipe = self.pipeRtls[insnName]
		for istg in range(self.rIndex, self.wIndex):
			conn = insnConn[istg]
			pipe = insnPipe[istg]
			
	
	# @function:
	# through connection Rtl add insn to modName
	# @param:
	#	conn: connection Rtl
	#	istg: index of stage
	def add_connRtl(self, conn, istg):
		for srcPort,desPort in conn:
			srcm = portParser.is_aRdPort(srcPort)
			desm = portParser.is_aWtPort(wtPort)
			if srcm and desm:
				
	
	
	# @function: 
	def create_allEdge(self):
		pass
	
	
	
	
if __name__ == '__main__':
	