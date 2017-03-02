
class constForGlobal:
	PPC = True
	ARCH = "ppc" if PPC else "mips"
	brDelaySlot = False
	BRFLUSH = "BrFlush"
	INSTR_WIDTH = "[0:`INSTR_WIDTH-1]" if PPC else "[`INSTR_WIDTH-1:0]"
	IO = False
	BigEndian = False
	SHOWINFO = True
	USE_CONVERTER = True
	
class CFG(constForGlobal):
	pass
