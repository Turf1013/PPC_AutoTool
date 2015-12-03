from ppc_insnFormat import ppcInsnFormat as PIF
from ppc_const import ppcFieldConst as PFC
from Instruction import Instruction
from insnFormat import insnFormat



class constForInsnRename:
	addi = Instruction(name="addi", form=PIF.DForm)
	addi.setField(PFC.OPCD, 14)
	
	add = Instruction(name="add", form=PIF.XoForm)
	add.setField(PFC.OPCD, 31)
	add.setField(PFC.XO, 266)
	
	lbz = Instruction(name="lbz", form=PIF.DForm)
	lbz.setField(PFC.OPCD, 34)
	
	lhz = Instruction(name="lhz", form=PIF.DForm)
	lhz.setField(PFC.OPCD, 40)
	
	lwz = Instruction(name="lwz", form=PIF.DForm)
	lwz.setField(PFC.OPCD, 32)
	
	lha = Instruction(name="lha", form=PIF.DForm)
	lha.setField(PFC.OPCD, 42)
	
	ld = Instruction(name="ld", form=PIF.DsForm)
	ld.setField(PFC.OPCD, 58)
	ld.setField(PFC.XO, 0)
	
	lwzx = Instruction(name="lwzx", form=PIF.XForm)
	lwzx.setField(PFC.OPCD, 31)
	lwzx.setField(PFC.XO, 23)
	
	lwax = Instruction(name="lwax", form=PIF.XForm)
	lwax.setField(PFC.OPCD, 31)
	lwax.setField(PFC.XO, 341)
	
	ldx = Instruction(name="ldx", form=PIF.XForm)
	ldx.setField(PFC.OPCD, 31)
	ldx.setField(PFC.XO, 21)
	
	lhax = Instruction(name="lhax", form=PIF.XForm)
	lhax.setField(PFC.OPCD, 31)
	lhax.setField(PFC.XO, 343)
	
	lhzx = Instruction(name="lhzx", form=PIF.XForm)
	lhzx.setField(PFC.OPCD, 31)
	lhzx.setField(PFC.XO, 279)
	
	lbzx = Instruction(name="lbzx", form=PIF.XForm)
	lbzx.setField(PFC.OPCD, 31)
	lbzx.setField(PFC.XO, 87)
	
	stb = Instruction(name="stb", form=PIF.DForm)
	stb.setField(PFC.OPCD, 38)
	
	stbx = Instruction(name="stbx", form=PIF.XForm)
	stbx.setField(PFC.OPCD, 31)
	stbx.setField(PFC.XO, 215)
	
	sth = Instruction(name="sth", form=PIF.DForm)
	sth.setField(PFC.OPCD, 44)
	
	sthx = Instruction(name="sthx", form=PIF.XForm)
	sthx.setField(PFC.OPCD, 31)
	sthx.setField(PFC.XO, 407)
	
	stw = Instruction(name="stw", form=PIF.DForm)
	stw.setField(PFC.OPCD, 36)
	
	stwx = Instruction(name="stwx", form=PIF.XForm)
	stwx.setField(PFC.OPCD, 31)
	stwx.setField(PFC.XO, 151)
	
	std = Instruction(name="std", form=PIF.DForm)
	std.setField(PFC.OPCD, 62)
	
	stdx = Instruction(name="stdx", form=PIF.XForm)
	stdx.setField(PFC.OPCD, 31)
	stdx.setField(PFC.XO, 149)
	

class CFIR(constForInsnRename):
	pass

class insnRename(object):

	@classmethod
	def rename(cls, insn):
		if insn.name == "lbzu":
			return cls.lbzu_rename(insn)
			
		elif insn.name == "lwzu":
			return cls.lwzu_rename(insn)
			
		elif insn.name == "ldu":
			return cls.ldu_rename(insn)
			
		elif insn.name == "lhzu":
			return cls.lhzu_rename(insn)
			
		elif insn.name == "lhau":
			return cls.lhau_rename(insn)
			
		elif insn.name == "lbzux":	
			return cls.lbzux_rename(insn)
		
		elif insn.name == "ldux":
			return cls.ldux_rename(insn)
			
		elif insn.name == "lhaux":
			return cls.lhaux_rename(insn)
			
		elif insn.name == "lhzux":
			return cls.lhzux_rename(insn)
			
		elif insn.name == "lwzux":
			return cls.lwzux_rename(insn)
			
		elif insn.name == "lwaux":
			return cls.lwaux_rename(insn)
		
		elif insn.name == "lmw":
			return cls.lmw_rename(insn)
		
		elif insn.name == "stmw":
			return cls.stmw_rename(insn)
		
		elif insn.name == "stbu":
			return cls.stbu_rename(insn)
			
		elif insn.name == "stdu":
			return cls.stdu_rename(insn)
			
		elif insn.name == "sthu":
			return cls.sthu_rename(insn)
			
		elif insn.name == "stwu":
			return cls.stwu_rename(insn)
			
		elif insn.name == "stbux":
			return cls.stbux_rename(insn)
			
		elif insn.name == "sthux":
			return cls.sthux_rename(insn)
			
		elif insn.name == "stwux":
			return cls.stwux_rename(insn)
		
		elif insn.name == "stdux":
			return cls.stdux_rename(insn)
					
		else:
			return []
			
			
	@classmethod
	def stbux_rename(cls, insn):
		"""
			stbux RS, RA, RB
			->	stbx RS, RA, RB
			->	add RA, RA, RB
		"""
		ret = []
		
		CFIR.stbx.setField(PFC.RS, insn.getField(PFC.RS))
		CFIR.stbx.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.stbx.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.stbx.toCode())
		
		CFIR.add.setField(PFC.RT, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RB, insn.getField(PFC.RB) )
		ret.append(CFIR.add.toCode())
		
		return ret
		
	
	@classmethod
	def sthux_rename(cls, insn):
		"""
			sthux RS, RA, RB
			->	sthx RS, RA, RB
			->	add RA, RA, RB
		"""
		ret = []
		
		CFIR.sthx.setField(PFC.RS, insn.getField(PFC.RS))
		CFIR.sthx.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.sthx.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.sthx.toCode())
		
		CFIR.add.setField(PFC.RT, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RB, insn.getField(PFC.RB) )
		ret.append(CFIR.add.toCode())
		
		return ret
		
	
	@classmethod
	def stdux_rename(cls, insn):
		"""
			stdux RS, RA, RB
			->	stdx RS, RA, RB
			->	add RA, RA, RB
		"""
		ret = []
		
		CFIR.stdx.setField(PFC.RS, insn.getField(PFC.RS))
		CFIR.stdx.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.stdx.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.stdx.toCode())
		
		CFIR.add.setField(PFC.RT, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RB, insn.getField(PFC.RB) )
		ret.append(CFIR.add.toCode())
		
		return ret	
	
	
	@classmethod
	def stwux_rename(cls, insn):
		"""
			stwux RS, RA, RB
			->	stwx RS, RA, RB
			->	add RA, RA, RB
		"""
		ret = []
		
		CFIR.stwx.setField(PFC.RS, insn.getField(PFC.RS))
		CFIR.stwx.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.stwx.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.stwx.toCode())
		
		CFIR.add.setField(PFC.RT, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RB, insn.getField(PFC.RB) )
		ret.append(CFIR.add.toCode())
		
		return ret
	
	
	@classmethod
	def stbu_rename(cls, insn):
		"""
			stbu RS, D(RA)
			->	stb RS, D(RA)
			->	addi RA, RA, D
		"""
		ret = []
		
		CFIR.stb.setField(PFC.RS, insn.getField(PFC.RS))
		CFIR.stb.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.stb.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.stb.toCode())
		
		CFIR.addi.setField(PFC.RT, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.addi.toCode())
		
		return ret
		
	@classmethod
	def sthu_rename(cls, insn):
		"""
			sthu RS, D(RA)
			->	sth RS, D(RA)
			->	addi RA, RA, D
		"""
		ret = []
		
		CFIR.sth.setField(PFC.RS, insn.getField(PFC.RS))
		CFIR.sth.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.sth.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.sth.toCode())
		
		CFIR.addi.setField(PFC.RT, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.addi.toCode())
		
		return ret
		
		
	@classmethod
	def stwu_rename(cls, insn):
		"""
			stwu RS, D(RA)
			->	stw RS, D(RA)
			->	addi RA, RA, D
		"""
		ret = []
		
		CFIR.stw.setField(PFC.RS, insn.getField(PFC.RS))
		CFIR.stw.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.stw.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.stw.toCode())
		
		CFIR.addi.setField(PFC.RT, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.addi.toCode())
		
		return ret
	
	
	@classmethod
	def stdu_rename(cls, insn):
		"""
			stdu RS, D(RA)
			->	std RS, D(RA)
			->	addi RA, RA, D
		"""
		ret = []
		
		CFIR.std.setField(PFC.RS, insn.getField(PFC.RS))
		CFIR.std.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.std.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.std.toCode())
		
		CFIR.addi.setField(PFC.RT, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.addi.toCode())
		
		return ret
	
	@classmethod
	def stmw_rename(cls, insn):
		"""
			!!! may cross the bound because of D+=4.
			stmw $29, 0($0)
			-> stw $29, 0($0)
			-> stw $30, 4($0)
			-> stw $31, 8($0)
		"""
		ret = []
		d = insn.getField(PFC.D)
		r = insn.getField(PFC.RS)
		CFIR.stw.setField(PFC.RA, insn.getField(PFC.RA))
		while r <= 31:
			CFIR.stw.setField(PFC.RS, r)
			CFIR.stw.setField(PFC.D, d)
			ret.append(CFIR.stw.toCode())
			r += 1
			d += 4
		return ret
	
	
	@classmethod
	def lmw_rename(cls, insn):
		"""
			!!! may cross the bound because of D+=4.
			lmw $29, 0($0)
			-> lwz $29, 0($0)
			-> lwz $30, 4($0)
			-> lwz $31, 8($0)
		"""
		ret = []
		d = insn.getField(PFC.D)
		r = insn.getField(PFC.RD)
		CFIR.lwz.setField(PFC.RA, insn.getField(PFC.RA))
		while r <= 31:
			CFIR.lwz.setField(PFC.RD, r)
			CFIR.lwz.setField(PFC.D, d)
			ret.append(CFIR.lwz.toCode())
			r += 1
			d += 4
		return ret
		
			
	@classmethod
	def lbzu(cls, insn):
		"""
			lbzu RT, D(RA)
			->	lbz RT, D(RA)
			->	addi RT, RA, D
		"""
		ret = []
		
		CFIR.lbz.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.lbz.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.lbz.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.lbz.toCode())
		
		CFIR.addi.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.addi.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.addi.toCode())
		
		return ret
	
	
	@classmethod
	def lhzu(cls, insn):
		"""
			lhzu RT, D(RA)
			->	lhz RT, D(RA)
			->	addi RT, RA, D
		"""
		ret = []
		
		CFIR.lhz.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.lhz.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.lhz.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.lhz.toCode())
		
		CFIR.addi.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.addi.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.addi.toCode())
		
		return ret	
	
	
	@classmethod
	def lhau(cls, insn):
		"""
			lhau RT, D(RA)
			->	lha RT, D(RA)
			->	addi RT, RA, D
		"""
		ret = []
		
		CFIR.lha.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.lha.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.lha.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.lha.toCode())
		
		CFIR.addi.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.addi.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.addi.toCode())
		
		return ret	
	
	
	@classmethod
	def lwzu(cls, insn):
		"""
			lwzu RT, D(RA)
			->	lwz RT, D(RA)
			->	addi RT, RA, D
		"""
		ret = []
		
		CFIR.lwz.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.lwz.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.lwz.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.lwz.toCode())
		
		CFIR.addi.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.addi.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.D,  insn.getField(PFC.D) )
		ret.append(CFIR.addi.toCode())
		
		return ret
			
			
	@classmethod
	def ldu(cls, insn):
		"""
			ldu RT, D(RA)
			->	ld RT, D(RA)
			->	addi RT, RA, D
		"""
		ret = []
		
		CFIR.ld.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.ld.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.ld.setField(PFC.DS, insn.getField(PFC.DS))
		ret.append(CFIR.ld.toCode())
		
		CFIR.addi.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.addi.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.addi.setField(PFC.D,  insn.getField(PFC.DS)<<2)
		ret.append(CFIR.addi.toCode())
		
		return ret
			
	@classmethod
	def lbzux_rename(cls, insn):
		"""
			lbzux RT, RA, RB
			->	lbzx RT, RA, RB
			->	add RT, RA, RB
		"""
		ret = []
		
		CFIR.lbzx.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.lbzx.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.lbzx.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.lbzx.toCode())
		
		CFIR.add.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.add.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.add.toCode())
		
		return ret	
		
	
	@classmethod
	def ldux_rename(cls, insn):
		"""
			ldux RT, RA, RB
			->	ldx RT, RA, RB
			->	add RT, RA, RB
		"""
		ret = []
		
		CFIR.ldx.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.ldx.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.ldx.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.ldx.toCode())
		
		CFIR.add.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.add.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.add.toCode())
		
		return ret

			
	@classmethod
	def lhaux_rename(cls, insn):
		"""
			lhaux RT, RA, RB
			->	lhax RT, RA, RB
			->	add RT, RA, RB
		"""
		ret = []
		
		CFIR.lhax.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.lhax.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.lhax.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.lhax.toCode())
		
		CFIR.add.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.add.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.add.toCode())
		
		return ret	
		
		
	@classmethod
	def lhzux_rename(cls, insn):
		"""
			lhzux RT, RA, RB
			->	lhzx RT, RA, RB
			->	add RT, RA, RB
		"""
		ret = []
		
		CFIR.lhzx.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.lhzx.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.lhzx.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.lhzx.toCode())
		
		CFIR.add.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.add.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.add.toCode())
		
		return ret	
		
	
	@classmethod
	def lwzux_rename(cls, insn):
		"""
			lwzux RT, RA, RB
			->	lwzx RT, RA, RB
			->	add RT, RA, RB
		"""
		ret = []
		
		CFIR.lwzx.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.lwzx.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.lwzx.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.lwzx.toCode())
		
		CFIR.add.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.add.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.add.toCode())
		
		return ret	
		
		
	@classmethod
	def lwaux_rename(cls, insn):
		"""
			lwaux RT, RA, RB
			->	lwax RT, RA, RB
			->	add RT, RA, RB
		"""
		ret = []
		
		CFIR.lwax.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.lwax.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.lwax.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.lwax.toCode())
		
		CFIR.add.setField(PFC.RT, insn.getField(PFC.RT))
		CFIR.add.setField(PFC.RA, insn.getField(PFC.RA))
		CFIR.add.setField(PFC.RB, insn.getField(PFC.RB))
		ret.append(CFIR.add.toCode())
		
		return ret	
		
		