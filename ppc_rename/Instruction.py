from insnFormat import insnFormat

class constForInstruction:
	insnWidth = 32

class CFI(constForInstruction):
	pass


class Instruction(object):

	def __init__(self, name, form, code=0):
		if not instance(form, insnFormat):
			raise TypeError, "use insnFormat to instance Instruction"
		self.name = name
		self.form = form
		self.code = code
	
	
	def __valBetween(self, beg, end, bigEndian=True):
		if bigEndian:
			beg = CFI.insnWidth-1-beg
			end = CFI.insnWidth-1-end
			
		width = beg - end + 1
		mask = (1<<width)-1
		mask <<= end
		ret = self.code & mask
		ret >>= end
		return ret
		
		
	def __setBetween(self, beg, end, value):
		if bigEndian:
			beg = CFI.insnWidth-1-beg
			end = CFI.insnWidth-1-end
		
		width = beg - end + 1
		mask = (1<<width) - 1
		self.code = (self.code & ~mask) | ((value & mask) << end)
	
	
	def valAt(self, field):
		if field not in self.form:
			raise ValueError, "%s not in %s" % (field, self.form)
		return self.__valBetween(*self.form.find(field))
	
	
	def binAt(self, field):
		return bin(self.valAt(field))
	
	
	def getVal(self, beg, end, value, bigEndian=True):
		if bigEndian:
			(beg, end) = (min(beg, end), max(beg, end))
		else:
			(beg, end) = (max(beg, end), min(beg, end))
		return self.__valBetween(beg, end):
	
	
	def getField(self. field):
		return self.valAt(field)
	
		
	def setVal(self, beg, end, value, bigEndian=True):
		if bigEndian:
			(beg, end) = (min(beg, end), max(beg, end))
		else:
			(beg, end) = (max(beg, end), min(beg, end))
		self.__setBetween(beg, end, value)
		
	
	def setField(self, field, value):
		if field not in self.form:
			raise ValueError, "%s not in %s" % (field, self.form)
		beg, end = self.form.find(field)
		return self.setVal(beg, end, value)
		
		
	def toCode(self):
		return self.code
		
		
	def __eq__(self, other):
		if isinstance(other, Instruction):
			return self.code == other.code
		else:
			raise TypeError, "use Instruction to compare with Instruction"
	
	
	def __hash__(self):
		return hash(self.code)
		
		
	def __str__(self):
		return "%s: %s" % (self.name, self.code)
		
		