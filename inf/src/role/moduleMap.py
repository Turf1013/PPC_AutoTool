# -*- coding: utf-8 -*-
import logging
from ..util.log import log
from ..role.module import Module, Port


class constForModuleMap:
	pass
	
class CFMM(constForModuleMap):
	pass
	
	
class ModuleMap(dict):

	def __init__(self, iterable=None):
		dict.__init__(self)
		if iterable is not None:
			self.update(zip(map(lambda mod:mod.name, iterable), iterable))
		
		
	def find(self, modName):
		return self.get(modName)
		
	
	def chkLink(self):
		l = []
		for modName, mod in self.iteritems():
			l.append(self.__chkLinkPerMod(mod))
		log.println("\n".join(l))
		
		
	def __chkLinkPerMod(self, mod):
		unLinkList = mod.chkLink()
		s = "[%s] UnLink Table:\n" % (mod)
		for i, port in enumerate(unLinkList):
			s += "%d. %s\n" % (i+1, port.name)
		s += "Total: %d\n" % (len(unLinkList))
		return s
			
