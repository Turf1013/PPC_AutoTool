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
	
	
	def __iadd__(self, insn):
		self.insnSet.add(isn)
		return self
	
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
		'core'		: 	4,
		'pplr'		:	5,
		'unknown'	: 	6,
	}
	
	
	# @param:
	#	name: name of the module
	#	stgn: num of the module need to finish work
	#	type: type means type of the node, included
	#			read, write, access(read & write, like memroy)
	#			core, pipeLine Register
	#	insnCls: instruction Cluster using this module
	def __init__(self, name, stgn, mtype, insnCls):
		Node.__init__(self, name)
		self.insnCls = insnCls
		self.stgn = stgn
		self.mtype = mtype
		if mtype == typeDict['core']:
			self.mout = portRename.gen_modOutPortName(name)
		self.children = []
	
	# @function:
	#	add a instruction to insnCls
	def add_aInsn(self, insnName):
		self.insnCls.add_aInsn(insnName)
	
	
	# @function:
	#	add a Edge to current node
	def add_aEdge(self, mnode):
		if mnode not in self.children:
			self.children.append(mnode)
	
	
	def __contains__(self, mnode):
		return mnode in self.chidren
		
		
	def __iadd__(self, insn):
		self.insnCls += insn
		return self
	
	
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
				lambda name, stg: modName(name, stg, modNode.typeDict['core'], []),
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
		rModule = map(portName.gen_rModName, self.ppl.rModule)
		tmpList = map(
			lambda name, stg: modName(name, stg, modNode.typeDict['read'], []),
			rModule, [rIndex] * len(rModule)
		)
		self.nodeList += tmpList
		self.nodeDict.update(zip(rModule, tmpList))
		
		
		'add write module'
		self.wNodeRng = (len(self.NodeList), len(self.NodeList) + len(self.ppl.wmodule))
		wModule = map(portName.gen_wModName, self.ppl.wModule)
		tmpList = map(
			lambda name, stg: modName(name, stg, modNode.typeDict['write'], []),
			wModule, [rIndex] * len(wModule)
		)
		self.nodeList += tmpList
		self.nodeDict.update(zip(wModule, tmpList))
	
	
	# @function:
	#	generate hazard condition from the graph. There are some lemmas as follows:
	#	(1) if there exists a edge(name as E_w, w->x) from wModule to module_x(neither rmodule or wModule), 
	#		means until stg_x(Sx for short) module_x Output can used as bypass.
	#			the pipeline stage build base on lemma_1
	#	(2) if there exists a edge(name as E_r, r->y) from rModule to module_y, 
	#		and wModule here is the same module as rModule but with different stage. (Such as SPR, GPR, CR).
	#		means @stg_y(Sy for short) module_y must get valid input(come from rModule or bypass).
	#	(3) Then we can prove
	#		(a) Sx > Sy,	Sr=S0 Sw=Sk+1
	#		Stage:						 V
	#			.. Sr S1 S2 S3 .. Sy .. Sx .. Sk Sw
	#			   .. Sr S1 S2 S3 .. Sy .. Sx .. Sk Sw
	#					...... (x-y-1) stage ....	
	#				  .. Sr S1 S2 S3 .. Sy .. Sx .. Sk Sw
	#					...... (y-1) stage ....	
	#				                 .. Sr S1 S2 S3 .. Sy .. Sx .. Sk Sw
	#		i. for any Stage s in (Sx, Sw]
	#			if exist Stage ss, And ss < s and is_WAR(Insn_ss & Insn_s)
	#				add bypass from s send to Sy. (no need to stall)
	#		ii. for any stage s in [Sr, Sx]
	#			if exist Stage ss, And ss < min(s,Sy) and is_WAR(Insn_ss & Insn_s)
	#				if Sx-s < Sy-ss:
	#					if Sx+sy-ss > Sw:
	#						no need to add bypass
	#					elsif Sx+Sy-ss == Sw: 
	#						add bypass (actually inner bypass, such as GPR, CR, SPR)
	#					else:
	#						add bypass from Sx+Sy-ss to Sy. (no need to stall)
	#				else:
	#					stall Insn_ss for t cycle, here t=(Sx-Sy)-(s-ss)+1 statisfy
	#						Sx-(s+t) < Sy-ss (Insn_ss still @ss because of stall)
	#						t > (Sx-s)-(Sy-ss) = (Sx-Sy) - (s-ss).
	#						we need stall as short as possible, so t = (Sx-Sy) - (s-ss) + 1
	#					Indeed we need to stall Insn_ss from rStg, 
	#						because during the stalling, some bypass-data may write-back and not bypass any-more.
	#						But when we stall Insn_ss at rStg, we can read from GPR the latest result.
	#						when the insn starts to pipe, we still can get bypass result if possible.
	#					In summary, when is_WAR( Insn_@Stage ss-(ss-Sr) & Insn_@Stage s-(ss-Sr) )
	#						Insn_@Stage ss-(ss-Sr) need to stall (Sx-Sy)-(s-ss)+1 cycle.
	#
	#		(b) Sx == Sy, Sr=S0 Sw=Sk+1
	#		Stage:						 V
	#			.. Sr S1 S2 S3 .. Sx .. Sk Sw
	#			   .. Sr S1 S2 S3 .. Sx .. Sk Sw
	#		i.	for any Stage s in (Sx, Sw]
	#				if exist Stage ss, And ss < s and is_WAR(Insn_ss & Insn_s)
	#					add bypass from s send to Sy. (no need to stall)
	#		ii. for any Stage s in (Sr, Sx]
	#				if exist Stage ss, And ss < min(s,Sy) and is_WAR(Insn_ss & Insn_s)
	#					if Sx-s < Sy-ss (always True):
	#						(It's always early enough to bypass)
	#						if Sx+sy-ss > Sw:
	#							no need to add bypass
	#						elsif Sx+Sy-ss == Sw: 
	#							add bypass (actually inner bypass, such as GPR, CR, SPR)
	#						else:
	#							add bypass from Sx+Sy-ss to Sy. (no need to stall)
	#				**** because when Sx==Sy, Sx-s<Sy-ss always fits. ****
	#
	#		(c) Sx < Sy, Sr=S0 Sw=Sk+1
	#		Stage:						    V
	#			.. Sr S1 S2 S3 .. Sx .. Sy .. Sk Sw
	#			   .. Sr S1 S2 S3 .. Sx .. Sy .. Sk Sw
	#		i.	It's always early enough to bypass from Insn_s to Insn_ss as long as ss<s
	#			for any Stage ss in (Sr, Sy] and s>ss
	#				if is_WAR(Insn_ss, Insn_s)
	#					add bypass from s to Sy.
	def gen_hazardCondition(self):
		pass
	
	
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
		rdPortList = []
		for srcPort in insnPipe[self.rIndex]:
			if portParser.is_aRdPort(srcPort):
				rdPortList.append(srcPort)
		
		for rdPort in rdPortList:
			self.add_aInstr(insnName, rdPort)
	
	
	def add_allInstr(self):
		for insnName in self.connRtls.keys():
			self.add_aInstr(self, insnName)
	
			
	# @function
	#	add a Instr Path to the graph, path here means multible edges
	# @algorithm:
	#	bfs
	#		 _______
	#		|		->ALU
	#	RF_rr1
	#		|____________->MEM
	#
	def add_aInstrPath(self, insn, rdPort):
		insnConn = self.connRtls[insn]
		insnPipe = self.pipeRtls[insn]
		Q = [(rdPort, self.rIndex)]
		while Q:
			pipePort, cstg = Q.pop(0)
			mod_Pipe = self.gen_portModName(pipePort, cstg)
			if mod_Pipe in self.nodeDict:
				mod_Pipe_Node = self.nodeDict[mod_Pipe]
			else:
				raise KeyError, 'current modName[%s] not in Graph' % (mod_Pipe)
				return 
			'only consider next stage'
			istg = cstg+1
			conn = insnConn[istg]
			"""
			if the src appears in the connection list,
			then need to add an edge between mod_Pipe and mod_desPort
			"""
			for i,val in enumerate(map(lambda src:src==mod_Pipe, zip(*conn))):
				if val:
					_, desPort = conn[i]
					mod_desPort = self.gen_portModName(desPort, cstg)
					if mod_desPort in self.nodeDict:
						mod_desPort_Node = self.nodeDict[mod_desPort]
					else:
						raise KeyError, 'current modName[%s] not in Graph' % (mod_Pipe)
						return
					self.add_aEdge(mod_Pipe_Node, mod_desPort_Node)
					if istg == self.ppl.wIndex:
						'add direct inverse edge'
						self.add_aEdge(mod_desPort_Node, mod_Pipe_Node)
			
			if istg < self.ppl.wIndex:
				'add more port to Q'	
				pipe = insnPipe[istg]
				for pipePort in pipe:
					if portParser.is_aDataPort(pipePort):
						Q.append((pipePort, istg))
	
	
	# @function:
	#	add a Edge between u_mname and v_mname
	#	if the Edge already exists, then just add the insn into v_mname
	def add_aEdge(u_mname, v_mname, insn):		
		mod_Pipe_Node.add_aEdge(mod_desPort_Node)
		mod_desPort_Node.add_aInstr(insn)
		
	
	# @function:
	#	generate the module Name according the pipeName
	#	different from generate the portModName,
	#	because pipeName only use as source
	def gen_pipeModName(pipeName, istg):
		mname = portParser.is_aPort(portName)
		if mname in self.ppl.rModule:
			return portRename.gen_rModuleName(mname)
		else:
			return mname
	
	
	# @function:
	#	generate the module Name according the portName & istg
	def get_portModName(portName, istg):
		mname = portParser.is_aPort(portName)
		if not mname:
			return None
		if istg==self.rIndex and mname in self.ppl.rModule:
			return portRename.gen_rModuleName(mname)
		elif istg==self.wIndex and mname in self.ppl.wModule:
			return portRename.gen_rModuleName(mname)
		else:
			return mname
				
						
	# @function
	#	add the pipe RTL to the graph
	# @param:
	#	pipe: pipe RTL
	def add_pipeRtl(self, pipe, istg, insnName):
		for srcPort in pipe:
			srcm = portParser.is_aRdPort(srcPort)
			if not srcm:
				continue
			if istg==self.rIndex and srcm in self.ppl.rModule:
				srcm = portRename.gen_rModuleName(srcm)
			elif istg==self.wIndex and srcm in self.ppl.wModule:
				'this condition may not happend'
				srcm = portRename.gen_wModuleName(srcm)
			if srcm in nodeDict:
				modNode = nodeDict[srcm]
				modeNode.add_aInsn(in)
			else:
				raise KeyError, 'current modName[%s] not in Graph' % (srcm)
				
	
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
	