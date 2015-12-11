
class constForGlobal:
	PPC = True
	ARCH = "ppc" if PPC else "mips"
	brDelaySlot = False
	BRFLUSH = "BrFlush"
	INSTR_WIDTH = "[0:`INSTR_WIDTH-1]" if PPC else "[`INSTR_WIDHT-1:0]"
	
class CFG(constForGlobal):
	pass
