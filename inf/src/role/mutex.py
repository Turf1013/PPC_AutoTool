# -*- coding: utf-8 -*-
import math
from module import Port, Module


mux_din  = "din"
mux_dout = "dout"
mux_sel  = "sel"
class Mutex(Module):
	""" Mutex is Base Mutex as MUX in Verilog
	
	"""

	def __init__(self, name, width, linkedIn):
		self.seln = int(math.ceil(math.log(len(linkedIn), 2)))
		self.muxn = 2 ** self.seln
		self.width = width
		iterable = [
			Port(mux_din+str(i), width) for i in xrange(self.muxn)	# din signal
		] + [
			Port(mux_dout, self.seln),								# select signal
			Port(mux_sel, width),									# dout signal
		]
		self.name = "mux%d" % (self.muxn)
		self.Iname = "%s_%s" % (name, self.name)
		super(Mutex, self).__init__(self.name, iterable)
		self.linkedIn = linkedIn
		for i, linkPort in enumerate(linkedIn):
			self.addLink(iterable[i], linkPort)
		
	
class PortMutex(Mutex):
	""" Port Mutex is one kind of Mutex
	
	"""
	
	def __init__(self, name, width, linkedIn):
		super(PortMutex, self).__init__(name, width, linkedIn)
		self.Iname = "%s_P%s" % (name, self.name)

		
		
class BypassMutex(Mutex):
	""" Bypass Mutex is the other kind of Mutex
	
	"""
	
	def __init__(self, name, width, linkedIn):
		super(BypassMutex, self).__init__(name, width, linkedIn)
		self.Iname = "%s_B%s" % (name, self.name)
		
		
		