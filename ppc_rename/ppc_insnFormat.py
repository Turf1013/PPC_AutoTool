from insnFormat import insnFormat
from ppc_const import ppcFieldConst as PFC
		
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
		PFC.XO		:	(22, 30)
		PFC.Rc		: 	(31, 31),
	}
	XoForm = insnFormat(name="XO", fieldDict=XoFormFieldDict)
	
	