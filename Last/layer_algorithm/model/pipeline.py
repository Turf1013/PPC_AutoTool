# -*- coding: utf-8 -*-
import logging
import ..util.decorator import accepts, returns


class Stage(object):

	@accepts(object, (int,str), str)
	def __init__(self, id, name):
		self.id = int(id)
		self.name = name
	
	
	def __add__(self, other):
		if isinstance(other, int):
			return self.id + other
		elif isinstance(other, Stage):
			return self.id + other.id
		else:
			raise TypeError, "%s is not Stage" % (type(other))
			
			
	def __sub__(self, other):
		if isinstance(other, int):
			return self.id - other
		elif isinstance(other, Stage):
			return self.id - other.id
		else:
			raise TypeError, "%s is not Stage" % (type(other))
		
	
	def __eq__(self, other):
		if isinstance(other, int):
			return self.id == other
		elif isinstance(other, Stage):
			return self.id == other.id
		else:
			raise TypeError, "Stage cmp Error"
			
			
	def __repr__(self):
		return "Stage@%d %s" % (self.id, self.name)
		
	__str__ = __repr__
	
	
			
	def __hash__(self):
		return hash(self.id)
		
	
	def __cmp__(self, other):
		return self.id - other.id
		
	
	
class BasePipeline(object):

	@accepts(object, (set,list))
	def __init__(self, stgList):
		self.stgList = tuple(stgList)
		self.stgn = len(stgList)
	
	
	@accepts(object, int)
	def stgAt(self, idx):
		assert idx>=0 and idx<self.stgn
		return self.stgList[idx]
		
		
	@accepts(object, int)	
	def stgNameAt(self, idx):
		return self.stgAt(idx).name
		
		
	def find(self, stg):
		name = sg.name if isinstance(stg, Stage) else str(stg)
		for stg in self.stgList:
			if stg.name == name:
				return stg.id
		return -1
		
		
	def __contains__(self, stg):	
		if isinstance(stg, Stage):
			return stg in self.stgList
		elif isinstance(stg, str):
			return self.find(stg) >= 0
		return False
		
		
	def __len__(self):
		return self.stgn
		
		
	def __iter__(self):
		return iter(self.stgList)
		
		
	def __repr__(self):
		return "Pipeline(%s)" % ", ".join(map(lambda stg:stg.name, self.stgList))
	
	__str__ = __repr__
	
	
	
class Pipeline(BasePipeline):


	def __init__(self, stgList, rStg, wStrg):
		super(Pipeline, self).__init__(stgList)
		self.rStg = rStg
		self.wStg = wStg
			
	
	def __repr__(self):
		ret = super(Pipeline, self).__repr__()
		ret += "rStg = %s, wStg = %s" % (rStg.name, wStrg.name)
		return ret
		
	__str__ = __repr__
	
	
	def formula(self):
		pass