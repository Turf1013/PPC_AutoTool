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
		PFC.FRS		:	(6, 10),
		PFC.FRT		:	(6, 10),
		PFC.RA		:	(11, 15),
		PFC.D		:	(16, 31),
		PFC.SI		: 	(16, 31),
		PFC.UI		: 	(16, 31),
		PFC.BF		:	(6, 8),
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
		PFC.FRT		: 	(6, 10),
		PFC.FRS		: 	(6, 10),
		PFC.BT		: 	(6, 10),
		PFC.TO		: 	(6, 10),
		PFC.RS		: 	(6, 10),
		PFC.RA		:	(11, 15),
		PFC.FRA		:	(11, 15),
		PFC.RB		:	(16, 20),
		PFC.FRB		:	(16, 20),
		PFC.NB		:	(16, 20),
		PFC.SH		:	(16, 20),
		PFC.XO		: 	(21, 30),
		PFC.SR		: 	(12, 15),
		PFC.Rc		:	(31, 31),
		PFC.BF		:	(6, 8),
		PFC.BFA		:	(11, 13),
		PFC.TH		:	(7, 10),
		
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
	
	IFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.LI		:	(6, 29),
		PFC.AA		:	(30, 30),
		PFC.LK		:	(31, 31),
	}
	IForm = insnFormat(name="I", fieldDict=IFormFieldDict)
	
	BFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.BO		:	(6, 10),
		PFC.BI		:	(11, 15),
		PFC.BD		:	(16, 29),
		PFC.AA		:	(30, 30),
		PFC.LK		:	(31, 31),
	}
	BForm = insnFormat(name="B", fieldDict=BFormFieldDict)
	
	ScFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.LEV		:	(20, 26),
	}
	ScForm = insnFormat(name="SC", fieldDict=ScFormFieldDict)
	
	XlFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.BT		: 	(6, 10),
		PFC.BA		:	(11, 15),
		PFC.BB		:	(16, 20),
		PFC.BO		:	(6, 10),
		PFC.BF		:	(6, 8),
		PFC.BI		:	(11, 15),
		PFC.BFA		:	(11, 13),
		PFC.XO		:	(21, 30),
		PFC.LK		: 	(31, 31),
	}
	XlForm = insnFormat(name="XL", fieldDict=XlFormFieldDict)
	
	XfxFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.RT		: 	(6, 10),
		PFC.RS		: 	(6, 10),
		PFC.SPR		:	(11, 20),
		PFC.TBR		:	(11, 20),
		PFC.FXM		:	(12, 19),
		PFC.XO		:	(21, 30),
	}
	XfxForm = insnFormat(name="XFX", fieldDict=XfxFormFieldDict)
	
	XflFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.FLM		:	(7, 14),
		PFC.FRB		:	(16, 20),
		PFC.XO		:	(21, 30),
		PFC.Rc		: 	(31, 31),
	}
	XflForm = insnFormat(name="XFX", fieldDict=XflFormFieldDict)
	
	XsFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.RS		: 	(6, 10),
		PFC.RA		: 	(11, 15),
		PFC.SHH		:	(16, 20),
		PFC.XO		:	(21, 29),
		PFC.SHL		:	(30, 30),
		PFC.Rc		: 	(31, 31),
	}
	XsForm = insnFormat(name="XFX", fieldDict=XsFormFieldDict)
	
	AFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.FRT		: 	(6, 10),
		PFC.FRA		: 	(11, 15),
		PFC.FRB		:	(16, 20),
		PFC.FRC		:	(21, 25),
		PFC.XO		:	(26, 30),
		PFC.Rc		:	(31, 31),
	}
	AForm = insnFormat(name="A", fieldDict=AFormFieldDict)
	
	MFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.RS		: 	(6, 10),
		PFC.RA		: 	(11, 15),
		PFC.RB		:	(16, 20),
		PFC.SH		:	(16, 20),
		PFC.MB		:	(21, 26),
		PFC.ME		:	(27, 30),
		PFC.Rc		:	(31, 31),
	}
	MForm = insnFormat(name="A", fieldDict=MFormFieldDict)
	
	MdFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.RS		: 	(6, 10),
		PFC.RA		: 	(11, 15),
		PFC.SHH		:	(16, 20),
		PFC.MB		:	(21, 25),
		PFC.ME		:	(21, 25),
		PFC.XO		:	(26, 29),
		PFC.SHL		:	(30, 30),
		PFC.Rc		:	(31, 31),
	}
	MdForm = insnFormat(name="A", fieldDict=MdFormFieldDict)
	
	MdsFormFieldDict = {
		PFC.OPCD	:	(0, 5),
		PFC.RS		: 	(6, 10),
		PFC.RA		: 	(11, 15),
		PFC.SH		:	(16, 20),
		PFC.MB		:	(21, 25),
		PFC.ME		:	(21, 25),
		PFC.XO		:	(26, 30),
		PFC.Rc		:	(31, 31),
	}
	MdsForm = insnFormat(name="A", fieldDict=MdsFormFieldDict)
	
	fieldDictList = [
		("I", 	IFormFieldDict),
		("D",	DFormFieldDict),
		("DS", 	DsFormFieldDict),
		("X", 	XFormFieldDict),
		("XO", 	XoFormFieldDict),
		("B",	BFormFieldDict),
		("XL",	XlFormFieldDict),
		("XFX",	XfxFormFieldDict),
		("XFL",	XflFormFieldDict),
		("XS",	XsFormFieldDict),
		("A",	AFormFieldDict),
		("M",	MFormFieldDict),
		("MD",	MdFormFieldDict),
		("MDS",	MdsFormFieldDict),
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
		
	
	@classmethod
	def GenFormatFieldDef(cls):
		lines = []
		for formName, formDict in cls.fieldDictList:
			line = "\n// define %s-Form" % (formName)
			lines.append(line)
			for fieldName, fieldRange in formDict.iteritems():
				# define width
				line = "`define %s%s_WIDTH %d" % (formName, fieldName, abs(fieldRange[0]-fieldRange[1])+1)
				lines.append(line)
				# define range
				line = "`define %s%s [%d:%d]" % (formName, fieldName, fieldRange[0], fieldRange[1])
				lines.append(line)
		return "\n".join(lines)
		
		
		
		
if __name__ == "__main__":
	# defLines = ppcInsnFormat.GenFormatDef()
	# wireLines = ppcInsnFormat.GenFormatWire()
	# assignLines = ppcInsnFormat.GenFormatAssign()
	# fileName = "F:\Qt_prj\hdoj\data.out"
	
	# with open(fileName, "w") as fout:
		# fout.write(defLines)
		# fout.write(wireLines)
		# fout.write(assignLines)
		
	
	line = 	ppcInsnFormat.GenFormatFieldDef()
	desFileName = "F:\Qt_prj\hdoj\data.out"
	with open(desFileName, "w") as fout:
		fout.write(line)
		