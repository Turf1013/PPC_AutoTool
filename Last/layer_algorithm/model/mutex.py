# -*- coding: utf-8 -*-
import re
import math
import logging
from module import Port, Module, CFP
from pipeline import Stage


class constForMutex:
	DIN = "din"
	DOUT = "dout"
	SEL = "sel"
	
	
class CFM(constForMutex):
	pass
	

class Mutex(Module):
	
	@accepts(object, str, int, object, (set, list, tuple))
	def __init__(self, name, width, stg, linkedIn):
		if not isinstance(stg, Stage):
			raise TypeError, "must use Stage(%s) to instance Mutex" % (type(stg))
		self.seln = int(math.ceil(math.log(len(linkedIn), 2)))
		self.muxn = 2 ** self.seln
		self.width = width
		self.stg = stg
		# make sure `din0 - dinx` is at the first
		portList = [
			Port(CFM.mux_din+str(i), CFP.INPUT, width) for i in xrange(self.muxn)	# din signal
		] + [
			Port(CFM.mux_dout, CFP.OUTPUT, self.seln),								# select signal
			Port(CFM.mux_sel, CFP.INPUT, width),									# dout signal
		]
		modName = "mux%d" % (self.muxn)
		self.Iname = "%s_mux" % (name)
		super(Mutex, self).__init__(self.name, portList)
		self.linkedIn = linkedIn
		for i, linkPort in enumerate(linkedIn):
			self.addLink(iterable[i], linkPort)
		
		
	def __hash__(self):
		return self.Iname
		
	
	def GenSelName(self, withStage=True):
		if withStage:
			return "%s_%s_%s" % (self.Iname, CFM.mux_sel, self.stg.name)
		else:
			return "%s_%s" % (self.Iname, CFM.mux_sel)

		
	def GenDoutName(self, withStage=True):
		if withStage:
			return "%s_%s_%s" % (self.Iname, CFM.mux_dout, self.stg.name)
		else:
			return "%s_%s" % (self.Iname, CFM.mux_dout)
	
	
	def __instance(self, tabn=1):
		pre = '\t' * tabn
		ret = ""
		ret += pre + "%s #(%s) %s (\n" % (self.name, self.width, self.Iname)
		n = len(self.linkDict)
		for i,(key, value) in enumerate(self.linkDict.iteritems()):
			if value is None:
				if key.name == CFM.mux_dout:
					value = self.GenDoutName()
				elif key.name == CFM.mux_sel:
					value = self.GenSelName()
				else:
					value = " 0/* empty */ "
				
				# logging.debug("[mux] %s,%s\n" % (key, value))
			if i == n - 1:
				ret += pre + "\t.%s(%s)\n" % (key, value)
			else:
				ret += pre + "\t.%s(%s),\n" % (key, value)
		ret += "%s);\n" % (pre)
		return ret
		
		
	def toVerilog(self, tabn=1):
		return self.__instance(tabn=tabn)
		
		
		
class PortMutex(Mutex):
	""" 
		Port Mutex is one kind of Mutex
	
	"""
	
	def __init__(self, name, width, stg, linkedIn):
		super(PortMutex, self).__init__(name, width, stg, linkedIn)
		self.Iname = "%s_Pmux" % (name)

		
		
class BypassMutex(Mutex):
	"""
		Bypass Mutex is the other kind of Mutex
	
	"""
	
	def __init__(self, name, width, stg, linkedIn):
		super(BypassMutex, self).__init__(name, width, stg, linkedIn)
		self.Iname = "%s_Bmux" % (name)
		