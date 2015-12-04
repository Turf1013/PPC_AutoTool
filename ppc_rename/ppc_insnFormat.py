from insnFormat import insnFormat
from ppc_const import ppcFieldConst as PFC
		
class constForPpcInsnFormat:
	INSTR = "instr"
	

class CFPIF(constForPpcInsnFormat):
	pass
		
class ppcInsnFormat:
	
	DFormFieldDict = {
		PFC.OPCD	: 	(0, 5),
		PFC.RT		: 	(6, 10),
		PFC.RD		:	(6, 10),
		PFC.RS		:	(6, 10),
		PFC.RA		:	(11, 15),
		PFC.D		:	(16, 31),
		PFC.SI		: 	(16, 31),
	}
	DForm = insnFormat(name="D", fieldDict=DFormFieldDict)
	
	DsFormFieldDict = {
		PFC.OPCD	: 	(0, 5),
		PFC.RD		:	(6, 10),
		PFC.RT		: 	(6, 10),
		PFC.RS		: 	(6, 10),
		PFC.RA		:	(11, 15),
		PFC.DS		:	(16, 29),
		PFC.XO		: 	(30, 31),
	}
	DsForm = insnFormat(name="DS", fieldDict=DsFormFieldDict)
	
	XFormFieldDict = {
		PFC.OPCD	: 	(0, 5),
		PFC.RT		: 	(6, 10),
		PFC.RA		:	(11, 15),
		PFC.RB		:	(16, 20),
		PFC.XO		: 	(21, 30),
	}
	XForm = insnFormat(name="X", fieldDict=XFormFieldDict)
	
	XoFormFieldDict = {
		PFC.OPCD	: 	(0, 5),
		PFC.RT		: 	(6, 10),
		PFC.RA		:	(11, 15),
		PFC.RB		:	(16, 20),
		PFC.OE		: 	(21, 21),
		PFC.XO		:	(22, 30),
		PFC.Rc		: 	(31, 31),
	}
	XoForm = insnFormat(name="XO", fieldDict=XoFormFieldDict)
	
	
	fieldDictList = [
		("D",	DFormFieldDict),
		("DS", 	DsFormFieldDict),
		("X", 	XFormFieldDict),
		("XO", 	XoFormFieldDict),
	]
	
	@classmethod
	def GenFormatDef(cls):
		defList = []
		for formName, formDict in cls.fieldDictList:
			defList.append( cls.__GenFormatDefPerForm(formName, formDict) )
		return "\n".join(defList)
		
	
	@classmethod
	def __GenFormatDefPerForm(cls, formName, formDict):
		ret = ""
		ret += "// define %s-Form\n" % (formName)
		for name, rng in formDict.iteritems():
			ret += "`define %s_%s_WIDTH %d\n" % (formName, name, rng[1]-rng[0]+1);
			ret += "`define %s_%s [%d:%d]\n" % (formName, name, rng[0], rng[1]);
		return ret	
		
		
	@classmethod
	def GenFormatAssign(cls):
		assignList = []
		for formName, formDict in cls.fieldDictList:
			assignList.append( cls.__GenFormatAssignPerForm(formName, formDict) )
		return "\n".join(assignList)
		
		
	@classmethod
	def __GenFormatAssignPerForm(cls, formName, formDict):
		ret = ""
		ret += "// assign %s-Form\n" % (formName)
		for name in formDict.iterkeys():
			fieldName = "%s_%s" % (formName, name)
			ret += "assign %s = %s`%s;\n" % (fieldName, CFPIF.INSTR, fieldName)
		return ret
		
		
	@classmethod
	def GenFormatWire(cls):
		wireList = []
		for formName, formDict in cls.fieldDictList:
			wireList.append( cls.__GenFormatWirePerForm(formName, formDict) )
		return "\n".join(wireList)
		
		
	@classmethod
	def	__GenFormatWirePerForm(cls, formName, formDict):
		ret = ""
		ret += "// wire %s-Form\n" % (formName)
		for name in formDict.iterkeys():
			fieldName = "%s_%s" % (formName, name)
			ret += "wire [0:`%s_WIDTH-1] %s;\n" % (fieldName, fieldName)
		return ret
		
		
if __name__ == "__main__":
	defLines = ppcInsnFormat.GenFormatDef()
	wireLines = ppcInsnFormat.GenFormatWire()
	assignLines = ppcInsnFormat.GenFormatAssign()
	fileName = "F:\Qt_prj\hdoj\data.out"
	
	with open(fileName, "w") as fout:
		fout.write(defLines)
		fout.write(wireLines)
		fout.write(assignLines)
		
	
		