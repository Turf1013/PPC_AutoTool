# -*- coding: utf-8 -*-
import re
import math
import logging
from module import Port, Module
from ..util.verilogGenerator import VerilogGenerator as VG
from ..role.stage import Stage

class constForMutex:
	mux_din  = "din"
	mux_dout = "dout"
	mux_sel  = "sel"
	mux_width = "WIDTH"
	re_Number = re.compile(r"^\d+$")
	
class CFM(constForMutex):
	pass
	
class Mutex(Module):
	""" Mutex is Base Mutex as MUX in Verilog
	
	"""

	def __init__(self, name, width, stg, linkedIn):
		if not isinstance(stg, Stage):
			raise TypeError, "must use Stage(%s) to instance Mutex" % (type(stg))
		self.seln = int(math.ceil(math.log(len(linkedIn), 2)))
		self.muxn = 2 ** self.seln
		self.width = width
		self.stg = stg
		iterable = [
			Port(CFM.mux_din+str(i), width) for i in xrange(self.muxn)	# din signal
		] + [
			Port(CFM.mux_dout, self.seln),								# select signal
			Port(CFM.mux_sel, width),									# dout signal
		]
		self.name = "mux%d" % (self.muxn)
		self.Iname = "%s_Pmux" % (name)
		super(Mutex, self).__init__(self.name, iterable)
		self.linkedIn = linkedIn
		for i, linkPort in enumerate(linkedIn):
			self.addLink(iterable[i], linkPort)
	
	
	def widthRange(self):
		if isinstance(self.width, int) or (isinstance(self.width, str) and CFM.re_Number.match(self.width)):
			return VG.IntToRange(int(self.width))
		else:
			logging.debug("[mux_width] %s %s\n" % (self.Iname, self.width))
			return self.width
		
	
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
		
		
	def instance(self, tabn=1):
		Iname = self.Iname
		pre = '\t' * tabn
		ret = ""
		ret += pre + "%s #(%s) %s(\n" % (self.name, self.width, Iname)
		last = len(self.linkDict) - 1
		for i,(key, value) in enumerate(self.linkDict.iteritems()):
			if value is None:
				if key.name == CFM.mux_dout:
					value = self.GenDoutName()
				elif key.name == CFM.mux_sel:
					value = self.GenSelName()
				else:
					value = " 0/* empty */ "
				
				# logging.debug("[mux] %s,%s\n" % (key, value))
			if i == last:
				ret += pre + "\t.%s(%s)\n" % (key, value)
			else:
				ret += pre + "\t.%s(%s),\n" % (key, value)
		ret += "%s);\n" % (pre)
		return ret
		
		
	def toVerilog(self, tabn=1):
		return self.instance(tabn=tabn)
	
class PortMutex(Mutex):
	""" Port Mutex is one kind of Mutex
	
	"""
	
	def __init__(self, name, width, stg, linkedIn):
		super(PortMutex, self).__init__(name, width, stg, linkedIn)
		self.Iname = "%s_Pmux" % (name)

		
		
class BypassMutex(Mutex):
	""" Bypass Mutex is the other kind of Mutex
	
	"""
	
	def __init__(self, name, width, stg, linkedIn):
		super(BypassMutex, self).__init__(name, width, stg, linkedIn)
		self.Iname = "%s_Bmux" % (name)
		
		
		
