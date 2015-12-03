

class constForInsnFormat:
	FORM = "Form"


class CFIF(constForInsnFormat):
	pass


class insnFormat(object):

	def __init__(self, name, fieldDict):
		self.name = name
		if not instance(fieldDict, dict):
			raise TypeError, "use dict to instance instruction format"
		self.fieldDict = fieldDict
		
		
	def __eq__(self, other):
		if isinstance(other, insnFormat):
			return self.name == other.name
		else:
			raise TypeError, "use insnFormat to compare with insnFormat"
		
		
	def __hash__(self):
		return hash(self.name)
		
	
	def __str__(self):
		return "%s-%s" % (self.name, CFIF.FORM)
			

	def __contains__(self, field):
		return field in self.fieldDict
		
		
	def __iter__(self):
		return self.fieldDict.iteritems()
		
		
	def find(self, field):
		return self.fieldDict[field]
		