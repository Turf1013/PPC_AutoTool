# -*- coding: utf-8 -*-
import os
import re
import math
import logging
from copy import deepcopy
from abc import abstractmethod
from ..Util.decorator import accetps, returns 
import json


class BaseSpec(object):

	def __init__(self, filename):
		if not os.path.isfile(filename):
			raise ValueError, "%s is unvalid filename" % (filename)
		self.filename = filename
		
	
	@abstractmethod
	def Parse(self):
		pass
		
	
def Spec(BaseSpec):
	
	def __init__(self, filename):
		super(Spec, self).__init__(filename)
		
		
	def	__getLines(self, filename):
		ret = ""
		with open(filename, "r") as fin:
			for line in fin:
				ret += line.strip()
		return ret
		
		
	def __parse(self):
		rawLine = self.__getLines(self.filename)
		d = json.loads(rawLine)
		return d
		
		
	def Parse(self):
		return self.__parse()
		
		