
class constForGlobal:
	brDelaySlot = False
	BRFLUSH = "BrFlush"
	PPC = True
	INSTR_WIDTH = "[0:`INSTR_WIDTH-1]" if PPC else "[`INSTR_WIDHT-1:0]"
	
class CFG(constForGlobal):
	pass
