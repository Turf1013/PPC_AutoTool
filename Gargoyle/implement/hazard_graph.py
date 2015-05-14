import os
import sys
import logging
from collections import defaultdict
from based_graph import Node
from gen_portName import *
from ..utility.portParser import portParser
from ..utility.RTLParser import  RTLParser
from ..utility.portRename import portRename
from ..model.pipeline import pipeline
from ..model.mutexSet import mutex, mutexSet

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
	#	stg: stage of the module
	#	type: type means type of the node, included
	#			read, write, access(read & write, like memroy)
	#			core, pipeLine Register
	#	insnCls: instruction Cluster using this module
	def __init__(self, name, stg, mtype, insnCls):
		Node.__init__(self, name)
		self.insnCls = insnCls
		self.stg = stg
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
		self.ppl = ppl
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
		self.rModule = map(portName.gen_rModName, self.ppl.rModule)
		tmpList = map(
			lambda name, stg: modName(name, stg, modNode.typeDict['read'], []),
			rModule, [rIndex] * len(rModule)
		)
		self.nodeList += tmpList
		self.nodeDict.update(zip(rModule, tmpList))
		
		
		'add write module'
		self.wNodeRng = (len(self.NodeList), len(self.NodeList) + len(self.ppl.wmodule))
		self.wModule = map(portName.gen_wModName, self.ppl.wModule)
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
	def gen_WAR_allCondition(self):
		'iterate all the wModule, from their children we get the module_y'
		for wModuleName in self.wModule:
			'1. prepare the W'
			node_w = self.nodeDict[wModuleName]
			node_x_List = []
			for node_x in node_w.children:
				'check both stg to make sure the connection'
				if node_x.stg < node_w.stg:
					'valid output-write connection'
					node_x_List.append(node_x)
			'get the raw module name of wModule, we can use it to find the rModule'
			mname = portParser.is_atPort(wModuleName)
			
			'2. prepare the R'
			rModuleName = portRename.gen_rModName(mname)
			node_r = self.nodeDict[rModuleName]
			node_y_List = []
			for node_y in node_r.children:
				'check both stg to make sure the connection'
				if node_y.stg >= node_r.stg:
					'valid read-input connection'
					node_y_List.append(node_t)
			
			'3. generate WAR condition'
			self.gen_WAR_aCondition(mname, node_w, node_x_List, node_r, node_y_List)
			
			'4. geneerate WAR bypass mutex'
			self.gen_WAR_bpmux()
			
	
	# @function:
	#	generate bypass mutex
	def gen_WAR_bymux(self):
		pass
		
		
	# @function:
	#	generate the WAR condition between wModule & rModule, bypass data stored into node_y_list
	# @algorithm:
	"""
		_bypass:
		Any stg_i in [stg_x+1, stg_w]
			bypass modOut to node_y
			
		_stall:
		Any stg_i in [stg_r+1, stg_x]
			Any stg_j in [stg_r, min(stg_y, stg_i)]
				if stg_x-stg_i >= stg_y-stg_j:
					stall
				else:
					will get the right data from bypass later
		
		Simplify the _stall, we get:
		Any stg_i in [stg_r+1, stg_x]
			if stg_x-stg_i >= stg_y-stg_r:
				stall at stg_r
		Simplify more, we get
		Any stg_i in [stg_r+1, min(stg_x-stg_y+stg_r, stg_x)]:
			stall 
	"""
	# @param:
	#	mname: name of the module, use it to generate OutPortName
	#	node_w: write back node
	#	node_x_list: node_x directly link to node_w
	#	node_r: read node
	#	node_y_list: node_r directly link to node_x
	# @return:
	#	ret_stall_List: stall condition list
	#	ret_bypass_List: bypass condition list
	#	ret_bpmux_Set: bypass mutex Set	(stg, rModule, rPortIndex, )
	def gen_WAR_aCondition(self, mname, node_w, node_x_List, node_r, node_y_List):
		insn_y_grp_List = []
		stg_w = self.ppl.wIndex
		stg_r = self.ppl.rIndex
		ret_stall_List = []
		ret_bypass_List = []
		
		for node_y in node_y_List:
			insn_y_grp = self.gen_insnGrp(node_y.insnCls, mname, self.ppl.rIndex)
			insn_y_grp_List.append(insn_grp)
		for ix,node_x in enumerate(node_x_List):
			stg_x = node_x.stg
			insn_x_grp = self.gen_insnGrp(stg_x.insnCls, mname, self.ppl.wIndex)
			for iy,node_y in enumerate(node_y_List):
				stg_y = node_y.stg
				insn_y_grp = insn_y_grp_List[iy]
				for stg_i in range(stg_x+1, stg_w+1):
					ret_bypass_List += self.gen_WAR_bypass(stg_i, insn_x_grp, stg_y, insn_y_grp)
					
				for stg_i in range(stg_r+1, min(stg_x-stg_y+stg_r, stg_x)):
					ret_stall_List += self.gen_WAR_stall(stg_i, insn_x_grp, insn_y_grp)
					
		return ret_stall_List, ret_bypass_List
		
	
	# @function:
	#	generate the bypass-necessary-item to handle WAR hazard
	# @algorithm:
	#	bypass condition consists of stg_i, stg_y, wAddr, rAddr, Out
	#
	# @param:
	#
	# @return:
	#	bypass_List:
	#		[(stg_i, stg_y), (wAddr, rAddr), (wInstrGrp_name, rInstrGrp_name)]
	#	bpmux_List:
	#		[]
	def gen_WAR_bypass(self, stg_i, insn_x_grp, stg_y, insn_y_grp):
		ret_bypass_List = []
		
		for x_desPort, x_srcDict in insn_x_grp.iteritems():
			for x_srcPort, x_insn in x_srcDict.iteritems():
				for y_desPort, y_srcDict in insn_y_grp.iteritems():
					for y_srcPort, y_insn in y_srcDic.iteritems():
						ret_bypass_List.append(
							[(stg_i, self.ppl.rIndex), (x_srcPort, y_srcPort), (x_insn, y_insn)]
						)
						
		return ret_bypass_List
		
	
	# @function:
	#	generate the stall-necessary-item to handle WAR stall
	# @algorithm:
	#	stall condition consists of w_stg, r_stg(self.ppl.rIndex), wAddr, rAddr, rInstrGrp_name, wInstrGrp_name
	#	stall only happens in Decode Stage (which means only use instr_D).
	# @param:
	#	stg_i: see the prove process
	#	insn_x_grp: see the prove process
	#	insn_y_grp: see the prove process
	# @return:
	#	[ [(w_stg, r_stg), (wAddr, rAddr), (wInstrGrp_name, rInstrGrp_name)] ]
	def gen_WAR_stall(self, stg_i, insn_x_grp, insn_y_grp):
		"""
		1. because a module may have multiple read port  and multiple write port.
		So need Orthogonal here.
		2. Pay attention R_instr only stays at D-Stage.
		"""
		retList = []
		for x_desPort, x_srcDict in insn_x_grp.iteritems():
			for x_srcPort, x_insn in x_srcDict.iteritems():
				for y_desPort, y_srcDict in insn_y_grp.iteritems():
					for y_srcPort, y_insn in y_srcDic.iteritems():
						retList.append(
							[(stg_i, self.ppl.rIndex), (x_srcPort, y_srcPort), (x_insn, y_insn)]
						)
		return retList
		
		
	
	# @function:
	#	Related to the ISA. may be override later.
	def gen_rInsnGrp(self, insnCls, mname, istg):
		conn = self.connRtls[istg]
		n_rAddr = self.ppl.get_modParameter(mname, 'n_rAddr')
		if n_rAddr:
			name_rAddr_List = map(
				portRename.gen_modrAddrPortName,
				zip([mname]*n_rAddr, range(1, n_rAddr+1))
			)
		else:
			name_rAddr_List = [portRename.gen_modrAddrName(mname)]
		addrDict = dict( zip(name_rAddr_List, [defaultdict(list)]*len(name_rAddr_List)))
		for insn in insnCls:
			srcPort, desPort = conn[insn][istg]
			if desPort in addrDict:
				addrDict[desPort][srcPort].append(insn)
		return addrDict
			
	
	
	def gen_wInsnGrp(self, insnCls, mname, istg):
		conn = self.connRtls[istg]
		n_wAddr = self.ppl.get_modParameter(mname, 'n_wAddr')
		if n_wAddr:
			name_wAddr_List = map(
				portRename.gen_modwAddrPortName,
				zip([mname]*n_wAddr, range(1, n_wAddr+1))
			)
		else:
			name_wAddr_List = [portRename.gen_modwAddrPortName(mname)]
		addrDict = dict( zip(name_wAddr_List, [defaultdict(list)]*len(name_wAddr_List)) )
		for insn in insnCls:
			srcPort, desPort = conn[insn][istg]
			if desPort in addrDict:
				addrDict[desPort][srcPort].append(insn)
		return addrDict
			
	
	
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
	