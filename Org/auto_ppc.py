from xlrd import open_workbook,cellname, XL_CELL_TEXT, XL_CELL_NUMBER
from xlwt import *
import os
import re

global s_row_glb, s_col_glb, NULL, CU_SUFFIX
s_row_glb = 0
s_col_glb = 0
NULL = ""
CU_SUFFIX = ["Wr", "Op"]
LOGS2 = {
	1:0,
	2:1,
	4:2,
	8:3,
	16:4,
	32:5,
	64:6
}


class Access_EXCEL(object):
	
	def __init__(self, path, sheetName=None):
		self.book = open_workbook(path)
		self.rsheet = None
		if sheetName is not None:
			self.Open_rsheet(sheetName)
		self.wbook = Workbook()
		self.path = path
		self.wsheet = None
		self.Open_wsheet("hazard")
		self.Set_DefaultFormat()
	
	# @function: open a sheet for reading
	# @param:
	#	name: name of the sheet
	def Open_rsheet(self, sheetName):
		try:
			self.rsheet = self.book.sheet_by_name(sheetName)
		except err:
			print "sheet can't open."
			
		self.nrows = self.rsheet.nrows
		self.ncols = self.rsheet.ncols
	
	# @function: get content of one row
	# @param:
	#	r_index: index of the row
	#	c_from: from this column
	#	c_to: to this colunm(not included)
	# @return: list()
	def Get_OneRow(self, r_index, c_from, c_to):
		ret = []
		for i in range(c_from, c_to):
			ret.append(self.Get_OneCell(r_index, i))
		return ret
	
	# @function: get content of one column
	# @param:
	#	c_index: index of the column
	#	r_from: from this row
	#	r_to: to this row(not included)
	# @return: list()
	def Get_OneCol(self, c_index, r_from, r_to):
		ret = []
		for j in range(r_from, r_to):
			ret.append(self.Get_OneCell(j, c_index))
		return ret
	
	# @function: get content of one cell
	# @param:
	#	c_index: index of the column
	#	r_index: index of the row
	# @return: str()
	def Get_OneCell(self, r_index, c_index):
		val = self.rsheet.cell(r_index, c_index).value
		if self.rsheet.cell_type(r_index, c_index)==XL_CELL_NUMBER:
			return str(int(val))
		return val
	
	# @function: get content of one block
	# @param:
	#	c_from: from this column
	#	c_to: to this colunm(not included)
	#	r_from: from this row
	#	r_to: to this row(not included)
	# @return: list()
	def Get_OneBlock(self, r_from, r_to, c_from, c_to):
		val = []
		for r_index in range(r_from, r_to):
			val += self.Get_OneRow(r_index, c_from, c_to)
		return val
		
	def Print_OneRow(self, r_index, c_from, c_to):
		cells = self.Get_OneRow(r_index, c_from, c_to)
		print cells
	
	def Print_OneCol(self, c_index, r_from, r_to):
		cells = self.Get_OneCol(c_index, r_from, r_to)
		print cells
		
	def Print_OneCell(self, r_index, c_index):
		print self.Get_OneCell(r_index, c_index)
	
	def Get_NRow(self):
		return self.nrows
		
	def Get_NCol(self):
		return self.ncols
	
	def Strip_Space(self, str):
		return "".join(str.split())
		
	# @function: open a sheet for reading
	# @param:
	#	name: name of the sheet
	def Open_wsheet(self, sheetName):
		try:
			self.wsheet = self.wbook.add_sheet(sheetName)
		except err:
			print "sheet can't open."
	
	# @function: set the format of the style
	def Set_DefaultFormat(self):
		font = Font()
		font.name = 'Courier New'
		font.bold = True
		font.colour_index = 2
		
		self.style = XFStyle()
		self.style.font = font
		
	# @function: write one cell
	# @param:
	#	r_index: row index
	#	c_index: column index
	#	val: the value need to be write
	#	withStype: boolean, if write with default styple or not
	def Set_OneCell(self, r_index, c_index, val, withStyle=False):
		if withStyle:
			self.wsheet.write(r_index, c_index, val, self.style)
		else:
			self.wsheet.write(r_index, c_index, val)
			
	# @function: write one row
	# @param:
	#	r_index: row index
	#	c_from: column write from
	#	c_to: column write to, not included
	#	vals: the values need to be write, need to be list(), set() or tuple()
	def Set_OneRow(self, r_index, c_from, c_to, vals):
		if isinstance(vals, (list, set, tuple)):
			if c_to-c_from > len(vals):
				c_to = c_from + len(vals)
			for c_index in range(c_from, c_to):
				self.Set_OneCell(r_index, c_index, str(vals[c_index-c_from]))

	# @function: write one column
	# @param:
	#	c_index: column index
	#	r_from: row write from
	#	r_to: row write to, not included
	#	vals: the values need to be write, need to be list(), set() or tuple()
	def Set_OneCol(self, c_index, r_from, r_to, vals):
		if isinstance(vals, (list, set, tuple)):
			if r_to-r_from > len(vals):
				r_to = r_from + len(vals)
			for r_index in range(r_from, r_to):
				self.Set_OneCell(r_index, c_index, str(vals[r_index-r_from]))
	
	
	
	# @function: save the tmp excel
	def Save_Excel(self):
		# save the auto_gen file in the same parent directory
		self.wbook.save("\\".join(self.path.split("\\")[0:-1]) + "auto_gen.xls")
	
class find_mux(object):
	
	def __init__(self, path, sname=None):
		self.AE = Access_EXCEL(path, sname)
		self.cells = []
		self.controls = []
		self.muxns = []
		self.connects = {}
		self.muxes_connects = {}
		self.s_row = s_row_glb
		self.s_col = s_col_glb
	
	##	Open the sheet of current EXCEL
	# @param
	#	name: the name of sheet			
	def Open_rsheet(self, sname):
		print "sheetname: name, working..."
		try:
			self.AE.Open_rsheet(sname)
		except err:
			print "sheet can't open."
		
	
	## Get the connection in certain Area. {(x,y)|f_row<=x<t_row, f_col<=y<t_col}
	# @param
	#	f_row: from this row
	#	t_row: to this row (not included)
	#	f_col: from this column
	#	t_col: to this column
	#	sname: the name of sheet(if sheet is not open)
	def Get_connect(self, f_row, t_row, f_col, t_col, sname=None):
		if sname is not None:
			Open_rsheet(sname)
		# if Fetch wrong column(control): 
		# 	  f_row = next_right_row
		if self.s_col > f_col:
			f_col = self.s_col
		if self.s_row > f_row:
			f_row = self.s_row
		"""	
		if (f_col - self.s_col) & 1 == 0:
			f_col += 1
		if (t_col - self.s_col) & 1 == 0:
			t_col -= 1
		"""
		for c_index in range(f_col, t_col, 1):
			lst = self.AE.Get_OneCol(c_index, f_row, t_row)	
			for item in lst:
				if item == NULL:
					pass
				else:
					self.cells.append(item)
		
	
	def Print_Cells(self):
		i = 1
		for item in self.cells:
			print item,
			if i&2 == 0:
				print
			i += 1
			
	def Gen_CondExp(self, Exp):
		if Exp[0] == '(':
			Exp = Exp[1:len(Exp)]
		if Exp[len(Exp)-1] == ')':
			Exp = Exp[0:len(Exp)-1]
		ques_pos = Exp.find('?')
		if ques_pos < 0:
			return [Exp]
		i = ques_pos + 1
		length = len(Exp)
		while Exp[i]==' ':
			i += 1
		beg = i
		ques_num = 0
		while True:
			if ques_num==0 and Exp[i]==':':
			  break
			if Exp[i] == '?':
			  ques_num += 1
			if Exp[i] == ':':
			  ques_num -= 1
			i += 1
		# val1, before colon
		subl1 = self.Gen_CondExp(Exp[beg:i])
		# val2, after colon
		subl2 = self.Gen_CondExp(Exp[i+1:len(Exp)])
		return subl1 + subl2		
	
	def Test_SameModule(self, val, key):
		v_ppos = val.find('.')
		k_ppos = key.find('.')
		if v_ppos < 0 or k_ppos < 0:
			return False
		if val[0:v_ppos] == key[0:k_ppos]:
			return True
		else:
			return False
	
	def Merge_connect(self):
		self.conncets = {}
		for item in self.cells:
			#exp = item.strip(' \t\n')
			exp = self.Split_Space(item)
			if '->' in exp:
				(val, key) = exp.split('->')[0:2]
				# We don't need the inner connection.
				if self.Test_SameModule(val, key):
					continue
				if key not in self.connects.keys():
					self.connects[key] = []
				if val not in self.connects[key]:	
					self.connects[key].append(val)
	
	def Split_Space(self, str):
		ret = ""
		for ch in str:
			if ch == '\t' or ch == ' ' or ch == '\n':
				pass
			else:
				ret += ch
		return ret		
	
	def Print_connect(self):
		for key in self.connects.keys():
			self.Print_CheckSel(key)
	
	def Print_CheckSel(self, key):
		srcs = self.connects[key]
		nums = len(srcs)
		# Multi Source you need to use MUX with select
		if nums > 1:
			print "\t\tYou need to Set SEL to MUX **  ", key, "  **"
			print "System has set: "
			for i in range(nums):
				print "%d: %s" % (i, srcs[i])
			print
	
	def Gen_MuxCode(self, tabn = 1):
		ret = ""
		for key in self.connects.keys():
			str = self.Gen_OneMuxCode(key, tabn)
			if str != NULL:
				ret += str + "\n"
		#return ret		
		self.MuxCode = ret
	
	def Get_isNeedMux(self, nums, key):
		if nums<=1 or self.Get_isControl(key):
			return False
		return True	
	
	def Gen_OneMuxCode(self, key, tabn = 1):
		srcs = []
		for exp in self.connects[key]:
			if exp.find('?') >= 0:
				sublist = self.Gen_CondExp(exp)
			else:
				sublist = [exp]
			for item in sublist:
				if item not in srcs:
					srcs.append(item)
		nums = len(srcs)
		# Multi Source you need to use MUX with select
		ret = ""
		if self.Get_isNeedMux(nums, key) == False:
			return ret
		# Need a mux, then SET Muxes_Connects
		self.muxes_connects[key] = srcs
		muxn = self.Cal_Muxn(nums)
		# add module name
		ret += "\t"*tabn + "mux" + str(muxn)
		# add parameter
		ret += " #() "
		# add utilize name
		ret += "U_"
		uname = self.Get_keyname(key)
		ret += uname
		ret += "_mux" + str(muxn)
		# add '(' and '\n'
		ret += " ("
		# add parameter
		for i in range(nums):
			if (i&3) == 0:
				ret += "\n"+ "\t"*(tabn + 1)
			ret += ".d"+str(i)+"("+self.Get_keyname(srcs[i])+"), "
		i = nums	
		while i < muxn:
			if (i&3) == 0:
				ret += "\n" + "\t"*(tabn + 1)
			ret += ".d"+str(i)+"(`MUX_D_DEFAULT), "
			i += 1
		# add select
		ret += "\n" + "\t"*(tabn + 1) + ".s("+ uname + self.MUX_SEL + "), "
		# add output
		ret += ".y("+uname+")"
		# add ");"
		ret += "\n" + "\t"*tabn + ");\n"
		return ret
	
	def Get_isControl(self, key):
		for item in CU_SUFFIX:
			if key.endswith(item):
				return True
		return False		
	
	def Get_keyname(self, key):
		ret = ""
		buf = key.split('.')
		if len(buf) != 2:
			return key
		if buf[0] in buf[1]:
			ret = buf[1]
		else:
			ret = buf[0]+'_'+buf[1]
		return ret
	
	def Cal_Muxn(self, nums):
		i = 2;
		while i < nums:
			i <<= 1
		return i
		
	def Auto_AnalyseMux(self):
		self.Get_connect(self.s_row+1, self.AE.Get_NRow(), self.s_col+1, self.AE.Get_NCol())
		self.Merge_connect()
		#self.Print_connect()
		#self.MuxCode = self.Gen_MuxCode()
		
	def Print_N(self):
		print "row=%d, col=%d" % (self.AE.Get_NRow(), self.AE.Get_NCol())
	
	def Get_connects(self):
		return self.connects
		
	def Merge_controls(self):
		for key in self.connects.keys():
			# if it's a control signal
			if self.Get_isControl(key):
				kname = self.Get_keyname(key)
				self.controls.append(kname)
				self.muxns.append(1)
			# if it's a MUX(SEL)	
			elif key in self.muxes_connects:
				kname = self.Get_keyname(key)
				self.controls.append(kname+'_Sel')
				nums = len(self.muxes_connects[key])
				muxn = self.Cal_Muxn(nums)
				self.muxns.append(muxn)
	
	def Get_muxes_connects(self):
		return self.muxes_connects
		
	def Get_controls(self):
		return self.controls
		
	def Get_Muxns(self):
		return self.muxns
	
	def Get_MuxCode(self):
		return self.MuxCode
	
class Auto_PPC(object):
	
	def __init__(self, work_path, xls_path, xls_sname=None):
		self.Auto_find_mux = find_mux(xls_path, xls_sname)
		self.AE = Access_EXCEL(xls_path, xls_sname)
		self.work_path = work_path
		if work_path.endswith('\\') == False:
			self.work_path += "\\"
		if os.path.isdir(self.work_path) == False:
			print "invalid work_path"
		self.s_row = s_row_glb
		self.s_col = s_col_glb
		# normal group of ISA
		self.instrs_ngp = []
		self.instrs_sgp = []
		self.instrs_boundry = []
		self.controls = []
		self.muxns = []
		self.defvs = []
		self.module_is_aRdWr = {}
		
	def Auto_handle_mux(self):
		self.Auto_find_mux.Auto_AnalyseMux()
		self.muxes_connects = self.Auto_find_mux.Get_muxes_connects()
		self.connects = self.Auto_find_mux.Get_connects()
		
	def Auto_Gen_CU(self, instr_col=0, idefname="instruction_def.v", fname="control.v"):
		# first, handle mux
		self.Auto_handle_mux()
		# then, merge controls & muxns
		self.Auto_find_mux.Merge_controls()
		self.controls = self.Auto_find_mux.Get_controls()
		self.muxns = self.Auto_find_mux.Get_Muxns()
		# read the define file and collect all instructions
		tb = self.Collect_Instrs(idefname)
		# according the tb we can classify the instrcutions (OPCD/XO)
		self.Gen_InstrGroups(tb)
		#### print self.instrs_ngp
		#### print self.instrs_sgp
		# Gen control code of all instruction
		core_code = self.Gen_AllInstrs(1)
		# Gen assign code
		assign_code = self.Gen_CUAssignCode(1)
		# Gen statement code
		state_code = self.Gen_CUStateCode(1)
		# Write into the file
		fout = open(self.work_path+fname, 'w')
		## Write include define
		self.Gen_defv()
		for defname in self.defvs:
			fout.write('`include '+'"'+defname+'"\n')
		fout.write('\n')
		## Write module
		fout.write('module control (')
		## Write signal
		clen = len(self.controls)
		for i in range( clen ):
			signame = self.controls[i]
			if i&3 == 0:
				fout.write('\n\t')
			fout.write(signame)
			if i+1 != clen:
				fout.write(', ')
		fout.write(', Instr')
		fout.write('\n);\n')
		## Write the state code
		fout.write(state_code)
		fout.write('\n')
		## Write the assign code
		fout.write(assign_code)
		fout.write('\n\n')
		## Write the core code
		fout.write(core_code)
		## Write endmodule
		fout.write('\nendmodule\n')
		fout.close()
	
	def Gen_CUAssignCode(self, tabn = 1):
		ret = "\n"
		ret += '\t'*tabn + "assign OPCD = Instr[`INSTR_OPCD];\n"
		ret += '\t'*tabn + "assign XO = Instr[`INSTR_XO];\n"
		list = []
		for key in self.connects:
			if self.Auto_find_mux.Get_isControl(key):
				sublist = self.Get_AssignCode(key)
				for item in sublist:
					if item not in list:
						list.append(item)
		pre = '\t' * tabn
		ret += pre
		ret += pre.join(list)
		return ret
		
	def Get_AssignCode(self, key):
		ret = []
		if key not in self.connects:
			return ret
		for skey in self.connects[key]:
			if skey[0] == '#':
				if '.' in key:
					kname = self.Auto_find_mux.Get_keyname(key)
				else:
					kname = key
				if '.' in skey[1:]:
					skname = self.Auto_find_mux.Get_keyname(skey[1:])
				else:
					skname = skey[1:]
				code = "assign %s = %s;\n" % (kname, skname)
				ret.append(code)
			# skey NOT Define	
			elif skey[0] != '`':
				words = self.Get_WordsInString(skey)
				for word in words:
					ret += self.Get_AssignCode(word)
		return ret
	
	def Get_WordsInString(self, str):
		words = []
		beg = 0
		found = True
		for i in range(len(str)):
			if str[i].isalpha():
				if found == False:
					beg = i
					found = True
			else:
				if found:
					words.append(str[beg:i])
					found = False
		if found:
			words.append(str[beg:i+1])
		return words
	
	def Gen_defv(self):
		lst = os.listdir(self.work_path)
		for fname in lst:
			if fname.endswith('_def.v'):
				self.defvs.append(fname)
	
	def Gen_CUStateCode(self, tabn=1):
		self.CU_Ucode = ""
		self.CU_WCode = ""
		utabn = 1
		ucode = '\t'*utabn + "control U_control (";
		wcode = ""
		ret = '\n'
		ret += '\t'*tabn + 'input [0:`INSTR_WIDTH-1] Instr;\n'
		for i in range( len(self.controls) ):
			sig = self.controls[i]
			ret += '\t'*tabn
			wcode += '\t'*utabn
			if i & 3 == 0:
				ucode += '\n' + '\t'*(utabn+1)
			ucode += '.' + sig + '(' + sig + '), '
			if sig.endswith('Wr'):
				ret += 'output reg ' + sig + ';\n'
				wcode += 'wire '+sig+';\n'
			elif sig.endswith('Op'):
				ret += 'output reg [0:`' + sig + '_WIDTH-1] ' + sig + ';\n'
				wcode += 'wire [0:`' + sig + '_WIDTH-1] ' + sig + ';\n';
			else:
				muxn = self.muxns[i]
				width = LOGS2[muxn]
				ret += 'output reg '
				wcode += 'wire '
				if width > 1:
					ret += '[0:' + str(width-1) + '] '
					wcode += '[0:' + str(width-1) + '] '
				ret +=	sig + ';\n'
		ucode += '.Instr(Instr)\n'
		ucode += '\t'*utabn + ');'
		self.CU_Wcode = wcode;
		self.CU_Ucode = ucode;
		return ret
		
	def Get_word(self, line, be):
		while line[be]==' ' or line[be]=='\t':
		  be+=1
		en = be
		while line[en]!=' ' and line[en]!='\t' and line[en]!='\n':
		  en+=1
		return (be, en)

	def Collect_Instrs(self, fname):
		fin = open(self.work_path+fname, "r")
		prefix = '`define'
		lprefix = len(prefix)
		flg = False
		tb = {}
		for line in fin:
			if flg == False:
				flg = line.startswith(prefix)
				if flg == False:
					continue
			index = line.find(prefix)
			if index < 0:
				break
			index += lprefix
			be = lprefix
			(be, en) = self.Get_word(line, be)
			opcd = line[be:en]
			be = en
			(be, en) = self.Get_word(line, be)
			val = line[be:en]
			if val in tb.keys():
			  tb[val].append(opcd)
			else:
			  tb[val] = [opcd]
		fin.close()
		return tb
	
	def Gen_InstrGroups(self, tb):
		self.instrs_ngp = []
		self.instrs_sgp = []
		for key in tb.keys():
			lst = tb[key]
			if len(lst) == 1:
				self.instrs_ngp.append(lst[0])
			else:
				lst.insert(0, key)
				self.instrs_sgp.append(lst)
				
	def Gen_InstrExp(self, instr):
		uinstr = instr.upper()
		if uinstr+"_OPCD" in self.instrs_ngp:
			instr_def_suffix = "_OPCD"
		else:
			instr_def_suffix = "_XO"
		return  '`' + uinstr + instr_def_suffix + ': '
	
	def Replace_CondExp(self, pre, srcs, exp):
		ques_pos = exp.find('?')
		if ques_pos < 0:
			if exp[0] == '(':
				l = 1
				ls = '('
			else:
				l = 0
				ls = ""
			if exp[len(exp)-1] == ')':
				r = len(exp)-1
				rs = ')'
			else:
				r = len(exp)
				rs = ""
			val = str(pre) + '\'d' + str( srcs.index(exp[l:r]) )
			return ls + val + rs
		i = ques_pos + 1
		length = len(exp)
		while exp[i]==' ':
			i += 1
		beg = i
		ques_num = 0
		while True:
			if ques_num==0 and exp[i]==':':
			  break
			if exp[i] == '?':
			  ques_num += 1
			if exp[i] == ':':
			  ques_num -= 1
			i += 1
		# val1, before colon
		sub1 = self.Replace_CondExp(pre, srcs, exp[beg:i])
		# val2, after colon
		sub2 = self.Replace_CondExp(pre, srcs, exp[i+1:len(exp)])
		ret = exp[0:beg] + sub1 + ':' + sub2
		return ret
	
	def Gen_AllInstrs(self, tabn=1):
		ret = ""
		# Add always @
		ret += '\t'*tabn + "always @(*) begin\n"
		# Add Main case
		ret += '\t'*(tabn+1) + 'case (OPCD)\n'
		## code generated by normal instrcution
		ncode = ""
		## code generated by special instrcution
		scode = [[] for i in range(len(self.instrs_sgp))]
		for i in range( len(self.instrs_boundry)-1 ):
			(instr, f_row) = self.instrs_boundry[i]
			t_row = self.instrs_boundry[i+1][1]
			uinstr = instr.upper()
			if uinstr+'_OPCD' in self.instrs_ngp:
				pcode = self.Gen_OneInstr(instr, f_row, t_row, tabn+2)
				ncode += pcode
			else:
				pcode = self.Gen_OneInstr(instr, f_row, t_row, tabn+4)
				hasFound = False
				for j in range( len(self.instrs_sgp) ):
					sublst = self.instrs_sgp[j]
					if uinstr+'_OPCD' in sublst:
						hasFound = True
						scode[j].append(pcode)
						break
				if hasFound == False:
					print instr + " not found."
		# Add the normal code
		ret += ncode	
		# Add the special code(not only one)
		for i in range( len(scode) ):
			## Add the case code
			ret += '\t'*(tabn+2) + self.instrs_sgp[i][0] + ': begin\n'
			ret += '\t'*(tabn+3) + 'case (XO)\n' 
			for subcode in scode[i]:
				ret += subcode
			## Add the default & endcase
			ret += self.Gen_ControlDefault(tabn+4)
			ret += '\t'*(tabn+3) + 'endcase\n'
			ret += '\t'*(tabn+2) + 'end\n';
		# Add Main default & endcase
		ret += self.Gen_ControlDefault(tabn+2)
		ret += '\t'*(tabn+1) + 'endcase\n'
		ret += '\t'*tabn + "end // end always\n\n"
		return ret
	
	def Gen_ControlDefault(self, tabn):
		ret = ""
		ret += '\t'*tabn + 'default: begin\n'
		length = len(self.controls)
		for i in range(length):
			ret += '\t'*(tabn+1) + self.controls[i] + ' = 0;\n'
		ret += '\t'*tabn + 'end\n'
		return ret
		
	def Gen_OneInstr(self, instr, f_row, t_row, tabn = 3):
		ret = ""
		# add '`XXX_OPCD: '
		ret += '\t'*tabn + self.Gen_InstrExp(instr)
		# add 'begin'
		ret += 'begin\n'
		# add control-signal
		## Read all RTL about this Instruction
		cells = self.Get_OneInstrCells(f_row, t_row)
		setControls = {}
		for item in cells:
			exp = self.Auto_find_mux.Split_Space(item)
			if '->' in exp:
				(val, key) = exp.split('->')[0:2]
				kname = self.Auto_find_mux.Get_keyname(key)
				if kname in self.controls:
					setControls[kname] = val
				else:
					kname += '_Sel'
					if kname in self.controls:
						muxn = self.muxns[self.controls.index(kname)]
						srcs = self.muxes_connects[key]
						if val in srcs:
							ival = srcs.index(val)
							nval = str(LOGS2[muxn]) + "'d" + str(ival)
						else:
							# val is a condition expression
							nval = self.Replace_CondExp(LOGS2[muxn], srcs, val)
						# assign new value to this signal
						setControls[kname] = nval
		## Add all contols
		length = len(self.controls)
		#ret += "\t"*(tabn+1)
		for i in range(length):
			ckey = self.controls[i]
			ret += "\t"*(tabn+1)
			ret	+= ckey + ' = ';
			if ckey in setControls.keys():
				ret += setControls[ckey]
			else:
				# if NOT SET then use default val(0).
				ret += str(self.muxns[i]) + "'d0"
			ret += ';\n'
		# add 'end'
		ret += '\t'*tabn + 'end\n'
		return ret
	
	def Get_OneInstrCells(self, f_row, t_row):
		f_col = self.s_col + 1
		t_col = self.AE.Get_NCol()
		cells = []
		for r in range(f_row, t_row):
			cells += self.AE.Get_OneRow(r, f_col, t_col)
		return cells
	
	## Get the instruction's r_index(Boundry) in certain column. 
	# @param
	#	c_index: certain column has instructions.
	def Get_InstrBoundry(self, c_index):
		f_row = self.s_row + 1
		t_row = self.AE.Get_NRow()
		for r in range(f_row, t_row):
			instr = self.AE.Get_OneCell(r, c_index)
			if instr != NULL:
				if instr[len(instr)-1] == '.':
					val = instr[0:len(instr)-1] + '_'
				else:
					val = instr
				self.instrs_boundry.append((val, r))
		# Add the end boundry
		self.instrs_boundry.append(("None", t_row))
		
	def Collect_Modules(self):
		self.modules = {}
		for key in self.connects:
			point_pos = key.find('.')
			# NO '.' NO Module
			if point_pos < 0:
				continue
			mname = key[0:point_pos]
			sname = key[point_pos+1:]
			if mname not in self.modules.keys():
				self.modules[mname] = {}
			self.modules[mname][sname] = self.connects[key]
		
	def Check_OneModule(self, fname):
		fin = open(self.work_path+fname, "r")
		pre_token = "module"
		found = False
		for line in fin:
			if ");" in line:
				found = False
				continue
			if found:
				nline = line.strip(" \t\n")
				snames = nline.split(',')
				dict = self.modules[mname]
				for item in snames:
					sname = item.strip(' ')
					if sname == NULL:
						continue
					if sname not in dict.keys():
						if sname=="clk" or sname=="rst_n" or sname=="rst":
							self.modules[mname][sname] = [sname]
						else:
							output = self.Auto_find_mux.Get_keyname(mname+'.'+sname)
							self.modules[mname][sname] = [output]
			if pre_token in line:
				beg = len(pre_token)
				while line[beg]==' ' or line[beg]=='\t':
					beg += 1
				end = line.find("(")
				if end < 0:
					continue
				end -= 1	
				while line[end]==' ' or line[end]=='\t':
					end -= 1
				mname = line[beg:end+1]
				if mname in self.modules.keys():
					found = True
		fin.close()
		
	def Check_Modules(self):
		dir_list = os.listdir(self.work_path)
		for fname in dir_list:
			if fname.endswith("_def.v"):
				continue
			self.Check_OneModule(fname)
		
	def Utilize_OneModule(self, mname, tabn):
		ret = ""
		# Add utilize statement
		ret += '\t' * tabn + mname + " U_" + mname + " ("
		# Add the signal instantion
		dict = self.modules[mname]
		i = 0
		n = len(dict.keys())
		for sname in dict.keys():
			srcs = dict[sname]
			if i&3 == 0:
				ret += '\n' + '\t'*(tabn+1)
			ret += '.' + sname + '('	
			if len(srcs) > 1:
				ret += self.Auto_find_mux.Get_keyname(mname+'.'+sname)
			elif self.Auto_find_mux.Get_isControl(mname+'.'+sname):
				ret += sname
			else:
				src = srcs[0]
				ppos = src.find('.')
				if ppos < 0:
					ret += src
				else:	
					beg = 0
					while True:
						if src[beg].isalpha():
							break
						beg += 1
					end = ppos + 1
					while end<len(src) and src[end].isalpha():
						end += 1
					alias = self.Auto_find_mux.Get_keyname(src[beg:end]) 	
					ret += src[0:beg] + alias + src[end:len(src)]
			ret += ')'
			if i+1 != n:
				ret += ', '
			i += 1	
		# Add end statement	
		ret += '\n' + '\t' * tabn + ");\n\n"
		return ret
		
	def Utilize_Modules(self, tabn = 1):
		ret = ""
		# Colletc all the modules
		self.Collect_Modules()
		# Check all the modules
		self.Check_Modules()
		for mname in self.modules:
			ret += self.Utilize_OneModule(mname, tabn)
		ret += self.CU_Ucode + '\n'
		return ret
	
	def Gen_TopAssignCode(self, tabn = 1):
		ret = "\n"
		list = []
		for key in self.connects:
			if self.Auto_find_mux.Get_isControl(key):
				continue
			sublist = self.Get_AssignCode(key)
			for item in sublist:
				if item not in list:
					list.append(item)
		pre = '\t' * tabn
		ret += pre
		ret += pre.join(list)
		return ret
	
	def Auto_Gen_Top(self, fname = "PPC.v", mname = "PPC"):
		# Open the file
		fout = open(self.work_path+fname, "w")
		# Write the includes file
		for defname in self.defvs:
			fout.write('`include '+'"'+defname+'"\n')
		fout.write('\n')
		# Write the module statement
		str = "module " + mname + " (\n\n);\n"
		fout.write(str)
		# Write the wire statement
		wire_code = self.Gen_WireCode(1)
		fout.write(wire_code + "\n")
		# Write the assign
		assign_code = self.Gen_TopAssignCode(1)
		print assign_code
		fout.write(assign_code + "\n")
		# Write the muxes statement
		self.Auto_find_mux.Gen_MuxCode(1)
		mux_code = self.Auto_find_mux.Get_MuxCode()
		fout.write(mux_code + "\n")
		# Write the utilize statament
		utilize_code = self.Utilize_Modules()
		fout.write(utilize + "\n")
		# Write the endmodule statement
		fout.write("endmodule\n")
		# Close the file
		fout.close()
				
	def Gen_OneWire(self, line, mname):
		ret = ""
		list = re.split(r'\s+', line)
		found = False
		for item in list:
			if item == '':
				continue
			if found:
				# signal must follow with ',' or ';'
				if item[len(item)-1] == ',' or item[len(item)-1] == ';':
					subitem = item[0:len(item)-1]
					if subitem == "clk" or subitem == "rst_n" or subitem == "rst":
						return ""
					sname = self.Auto_find_mux.Get_keyname(mname + '.' + subitem)
					ret += ' ' + sname + item[len(item)-1]
				else:
					ret += ' ' + item
				if item[len(item)-1] == ';':
					break
			if item == "input":
				ret += "wire"
				found = True
		ret += '\n'
		return ret
		
	def Gen_OneWireCode(self, fname, tabn = 1):
		ret = ""
		pre_token = "module"
		end_token = "endmodule"
		fin = open(self.work_path+fname, "r")
		found = False
		for line in fin:
			if end_token in line:
				found = False
			elif pre_token in line:
				beg = len(pre_token)
				while line[beg]==' ' or line[beg]=='\t':
					beg += 1
				end = line.find("(")
				if end < 0:
					continue
				end -= 1	
				while line[end]==' ' or line[end]=='\t':
					end -= 1
				mname = line[beg:end+1]
				if mname in self.modules.keys():
					found = True
					ret += '\t'*tabn + "/**** " + "about " + mname + " ****/\n"
				continue	
			if found and ("input" in line):
				wire = self.Gen_OneWire(line, mname)
				if wire != NULL:
					ret += '\t'*tabn + wire
		fin.close()
		return ret	
	
	def Gen_WireCode(self, tabn = 1):
		ret = ""
		dir_list = os.listdir(self.work_path)
		for fname in dir_list:
			if fname.endswith("_def.v"):
				continue
			ret += self.Gen_OneWireCode(fname, tabn) + '\n'
		ret += '\t'*tabn + "/**** " + "about CU ****/\n"
		ret += self.CU_Wcode + '\n'
		return ret
	
class Auto_PPC_ErrRobot():
	def __init__(self):
		self.wrong = False
		self.errNum = []
		self.errInfo = []
		self.init_errDict()
	
	# @function: init the Error Dictionary and some const value
	# @param: None
	def init_errDict(self):
		self.errDict = {
			-2: "Program BUG, WOO!!! there's a bug, fix it ASAP",
			-1: "Unexpectable error",
			0: "In One stage Multiple Sources connect into One destionation",
			1: "still has unconnected ports",
			2: "port has no father module",
			3: "Undefined module name",
			4: "Unknown Flow port",
			5: "Insn have a invalid addr port",
			6: "Mux missing one src"
		}
		self.PROGRAM_BUG = -2
		self.DEFAULT = -1
		self.MULTISRC_INTO_ONEDES = 0
		self.PORT_UNCONNECTED = 1
		self.PORT_NOMODULE = 2
		self.UNDEF_MODULE = 3
		self.UNKNOWN_FLOW = 4
		self.NO_ADDR = 5
		self.MUX_MISS = 6
	
	# @function: Add a errNum and errInfo
	# @param:
	#	errNum: NO of error
	#	instrName: name of the instruction
	#	rtl: the line of rtl with mistakes
	def Add_aError(self, errNum, srcName="Program", suffix=""):
		self.errNum.append(errNum)
		str = "["+srcName+"]: "
		if errNum in self.errDict:
			str += self.errDict[errNum]
		else:
			str += self.errDict[-1]	# -1 is default
		self.errInfo.append(str+": \n\t"+suffix)
	
	def Get_ErrInfo(self):
		return self.errInfo
	
	def Get_isWrong(self):
		self.wrong = len(self.errNum)>0
		return self.wrong
	
	def Get_ErrNum(self):
		return self.errNum
	
	def Print_Error(self):
		for info in self.errInfo:
			print info
	
class Auto_PPC_Pipeline():
	
	# @function
	# @param
	#	work_path: Verilog project path
	#	xls_path:  RTL description excel path
	#	xls_sname: sheet name of RTL description
	# @member variable
	# 	stage_names: names of all stages
		
	def __init__(self, work_path, xls_path, xls_sname=None):
		self.AE = Access_EXCEL(xls_path, xls_sname)
		self.work_path = work_path
		if work_path.endswith('\\') == False:
			self.work_path += "\\"
		if os.path.isdir(self.work_path) == False:
			print "invalid work_path"
		self.s_row = s_row_glb
		self.s_col = s_col_glb
		# normal group of ISA
		self.instrs_ngp = []
		self.instrs_sgp = []
		self.instrs_boundry = []
		self.Controls = []
		self.Connects = []
		# list(), means the num of all MUX
		self.muxns = []
		# list(), means the name of "_def.v"
		self.defvs = []
		self.ErrRobot = Auto_PPC_ErrRobot()
		self.stage_names = []
		self.stage_num = 0
		self.wb_col = -1
		self.instrs_RTLs = {}
		self.write_rtb = {}
		self.read_rtb = {}
		self.write_ports = []
		self.wrong = False
		self.init_const()
		self.MuxCode = []
		self.BypassMuxCode = []
		self.modules = {}
		self.module_portLength = {}
		self.BypassPorts = []
		self.TopAssignCode_Set = set()
		self.Controls = []
		self.addrOfInstrs = {}
		self.module_is_aRdWr = {}
		self.stallCond_ofStages = []
		self.ctrlPorts = []
		
	# @function: init the const variable
	def init_const(self):
		self.re_space = re.compile(r'\s+')
		self.re_portVar = re.compile(r'[a-zA-Z][\w.]*')
		self.re_rtlInstr = re.compile(r'Instr')
		self.re_rtlPort = re.compile(r'(.[a-zA-Z][\w.]*)')
		self.re_rtlCond = re.compile(r'([\w.\'`]+)')
		self.re_instrDef = re.compile(r'[\S]+')
		self.re_portAddr = re.compile(r'[a-zA-Z.]+(\d+)')
		self.re_getHDLModule = re.compile(r"\s*module\s+(\w+)\s*\(")
		self.COND_FLAG = '?'
		self.STALL = "stall"
		self.GROUP_PREFIX = "group_"
		self.PATTERN = "%16s\t"
		self.SUBPATTERN = "%4s"
		self.RD_GROUP_PRE = "rd_grp_"
		self.WR_GROUP_PRE = "wr_grp_"
		self.MUX_D_DEFAULT = "`MUX_D_DEFAULT"
		self.MUX_SEL = "_Sel"
		self.BYPASS_SUFFIX = "_Bp"
		self.HDL_DEFFILE = "_def.v"
		self.HDL_SUFFIX = ".v"
		# next two line need to correct together
		self.HDL_MODULE = "module"
		self.HDL_ENDMODULE = "endmodule"
		self.HDL_INPUT = "input"
		self.HDL_OUTPUT = "output"
		self.HDL_CLK = "clk"
		self.HDL_NRST = "rst_n"
		self.HDL_RST = "rst"
		self.HDL_WIRE = "wire"
		self.HDL_REG = "reg"
		self.HDL_RSTV = "`RST_N_DEFAULT"
		self.RTL_INSTR = "Instr"
		self.RTL_ADDR = "addr"
		self.HDL_INSTR_WIDTH = "[0:`INSTR_WIDTH]"
		self.HDL_DEFINE = "`define"
		self.HDL_OPCD = "opcd"
		self.HDL_XO = "xo"
		self.HDL_ASSIGN = "assign"
		self.HDL_RADDR = "raddr"
		self.HDL_WADDR = "waddr"
		self.HDL_FLUSH = "flush"
		self.HDL_STALL = "stall"
		self.HDL_NONEADDR = "noAddr"
		self.HDL_PIPEREGWR = "pipeRegWr"
		self.HDL_PCWr = "PCWr"
		self.HDL_OPCD_FIELD = "INSTR_OPCD"
		self.HDL_XO_FIELD = "INSTR_XO"
		self.HDL_OPCD_WIDTH = "INSTR_OPCD_WIDTH"
		self.HDL_OPCD_WIDTH = "INSTR_OPCD_WIDTH"
		self.RTL_PCWr_StageName = "D"
		
	# @function: set the stages of pipeline from the excel
	# @param:
	#	instr_col: the column presents the instructions
	def Set_PipeStage(self, instr_col, wb_stage):
		self.stage_names = self.AE.Get_OneRow(self.s_row, self.s_col+1, self.AE.Get_NCol())
		self.stage_num = len(self.stage_names)
		self.wb_stage = self.stage_names.index(wb_stage)
		self.stage_connects = [set() for i in range(self.stage_num)]
		self.Flows = [set() for i in range(self.stage_num)]
		self.Get_InstrBoundry(instr_col)
		self.instrs_num = len(self.instrs_boundry) - 1
		self.BypassSelPorts = [[] for i in range(self.stage_num)]
		self.BypassMuxCode = ["" for i in range(self.stage_num)]
		self.stallCond_ofStages = [[] for i in range(self.stage_num-1)]
		self.hazardAddrs = [[] for i in range(self.stage_num)]
		# Add null at the end of stage_names for convenient
		self.stage_names.append(NULL)
		# stall Port Name
		self.stallPorts = []
		for i_stage in range(self.stage_num):
			stallPortName = "%s_%s" % (self.HDL_STALL, self.stage_names[i_stage])
			self.stallPorts.append(stallPortName)
		# flush Port Name
		self.flushPorts = []
		for i_stage in range(self.stage_num):
			flushPortName = "%s_%s" % (self.HDL_FLUSH, self.stage_names[i_stage])
			self.flushPorts.append(flushPortName)
		# pipeRegWr Port Name
		self.pipeRegWrPorts = []
		for i_stage in range(self.stage_num):
			pipeRegWrPortName  = "%s_%s" % (self.HDL_PIPEREGWR, self.stage_names[i_stage])
			self.pipeRegWrPorts.append(pipeRegWrPortName)
		self.instrPorts = []
		for i_stage in range(self.stage_num):
			instrPortName = "%s_%s"\
				% (self.RTL_INSTR, self.stage_names[i_stage])
			self.instrPorts.append((instrPortName, self.HDL_INSTR_WIDTH))
		# for a_instr_boundry in self.instrs_boundry:
			# print a_instr_boundry
		
	# @function: set the read port Symbol by HUMAN
	# @param:
	#	ports: port name which uses as read port. Eg: rd, Rd
	def Set_ReadPorts(self, ports, o_stage):
		self.read_ports = {}
		for i in range(len(ports)):
			self.read_ports[ports[i]] = self.stage_names.index(o_stage[i])
	
	# @function: set the write port Symbol by HUMAN
	# @param:
	#	ports: port name which uses as write port. Eg: wd, Wd
	def Set_WritePorts(self, ports):
		self.wrte_ports = ports
	
	# @function: because some port need to valid after reg, some port don't
	#	so we need to exculde the special port
	# @param:
	#	specialPorts: the port valid without locking
	def Set_SpecialPorts(self, specialPorts):
		self.specialPorts = specialPorts
	
	# @function: top process of the auto_tool
	def Auto_topProcess(self, read_ports, special_ports, o_stage, wb_stage, instr_col = 0):
		tabn = 1
		# Following set must be done at first
		self.Set_SpecialPorts(special_ports)
		self.Set_PipeStage(instr_col, wb_stage)
	
		# collect the "_def.v" file
		self.Gen_defv()
		
		# Get all RTL Expression
		self.Get_All_RTLs()
		self.Get_All_DataTrace(read_ports, o_stage)
		self.Get_AllInstr_Connects()
		
		# Do some checking and generate mux code
		self.Check_AllFile()
		self.Gen_AllStage_Muxes()
		self.Gen_AllStage_MuxCode()
		
		# Generate the neccessary code:
		#	1. the utilize code;
		#	2. wire satetement code;
		#	3. reg statement code;
		#	4. pipeline reg code;
		#	5.
		utilizeCode = self.Utilize_AllModule(tabn)
		self.Gen_AllModuleLength()
		wireCode_forTop = self.Gen_AllModuleWireCode(tabn)
		regCode_forTop = self.Gen_AllModuleRegCode(tabn)
		muxCode = self.Gen_MuxCode(tabn)
		
		
		# normal Ctrl Code must before bypass
		self.Merge_AllCtrlPorts()
		alwaysCtrlCode = self.Gen_AllStageCtrlCode()
		
		pipeCode = self.Gen_PipelineRegCode(tabn)
		
		print "\n\n**** Print module Hazard Array ****\n"
		(hazard_wireCode, hazard_regCode, hazard_assignCode, hazard_alwaysCode) =\
			self.Gen_AllHazardArray(tabn)
		
		bypassCode = self.Gen_BypassCode()
		
		print "\n\n**** Print normal Ctrl Code ****\n"
		wireCtrlCode = self.Gen_ctrlWireCode(tabn)
		(regCtrlCode, wireCtrlCode_forTop) = self.Gen_ctrlRegCode(tabn)
		assignCtrlCode = self.Gen_ctrlAssignCode(tabn)
		
		print alwaysCtrlCode
		
		wireCtrlCode += hazard_wireCode
		regCtrlCode += hazard_regCode
		assignCtrlCode += hazard_assignCode
		alwaysCtrlCode += hazard_alwaysCode
		
		print "\n\n**** Print Stall Flush PCWr ****\n"
		# stallCode = (stall_wireCode, stall_regCode, stall_assignCode, stall_alwaysCode)
		(stall_wireCode, stall_regCode, stall_assignCode, stall_alwaysCode) = self.Gen_stallCode(tabn)
		wireCtrlCode += stall_wireCode
		regCtrlCode += stall_regCode
		assignCtrlCode += stall_assignCode
		alwaysCtrlCode += stall_alwaysCode
		# print stall_wireCode, stall_regCode, stall_assignCode, stall_alwaysCode
		
		### Generate control.v
		self.Auto_Gen_CU(wireCtrlCode, regCtrlCode, assignCtrlCode, alwaysCtrlCode, "control.v")
		
		### Generate PPC.v
		# write the code into the file
		# add control port to wireCode_forTop
		# wireCode_forTop += wireCtrlCode_forTop
		# add flush & PCWr to wireCode_forTop
		wireCode_forTop += wireCtrlCode_forTop
		self.Auto_Gen_Top(utilizeCode, muxCode, bypassCode, wireCode_forTop, regCode_forTop, pipeCode, "PPC.v")
		
		
		print "\n\n**** Print Bypass Mux Code ****\n"
		print bypassCode
		
		print "\n\n**** Print the Mux Code ****\n"
		print muxCode
		
		print "\n\n**** Print module Utilize Code ****\n"
		print utilizeCode
		
		print "\n\n**** Print the Flows ****\n"
		self.Print_Flows()
		
		print "\n\n**** Print the Connects ****\n"
		self.Print_Connects()
		
		print "\n\n**** Print the Modules ****\n"
		self.Print_Modules()
		
		print "\n\n**** Print the Errors ****\n"
		self.Print_Error()
		
		print "\n\n/**** Print the Length of the Module ****/"
		self.Print_ModulePortLength()
		
		print "\n\n/**** Print the Top Wire Code ****/"
		print wireCode_forTop
		
		print "\n\n/**** Print the Top Reg Code ****/"
		print regCode_forTop
		
		print "\n\n/**** Print the Bypass Ports ****/"
		self.Print_BypassPorts()
		
		print "\n\n/**** Print the Pipeline Reg ****/"
		print pipeCode
		
	# @function: generate the Top HDL Code, and write it into a file
	# @param:
	#	utilizeCode: Verilog code of module utilize
	#	muxCode: normal mux code
	#	bypassCode: bypass mux code
	#	wireCode: Verilog code of wire statement
	#	regcode: Verilog code of reg statement
	#	pipeCode: Verilog code of pipe statement
	#	fname: name of the writing file
	#	mname: name of the module
	def Auto_Gen_Top(self, utilizeCode, muxCode, bypassCode, wireCode, regCode, pipeCode, fname = "PPC.v", mname = "PPC"):
		# Open the file
		fout = open(self.work_path+fname, "w")
		
		# Write the includes file
		for defname in self.defvs:
			fout.write('`include ' + '"' + defname +'"\n' )
		fout.write('\n')
		
		# Write the module statement
		strLine = "module " + mname + " (\n\n);\n"
		fout.write(strLine)
		
		# Write the wire statement code
		title = "\n\t/*****     wire Statement HDL Code     *****/\n"
		fout.write(title)
		fout.write(wireCode)
		
		# Write the reg statement code
		title = "\n\t/*****     reg Statement HDL Code     *****/\n"
		fout.write(title)
		fout.write(regCode + "\n")
		
		# Write the assign
		assign_code = self.Gen_AssignCode(1, True)
		title = "\n\t/*****     Assign HDL Code     *****/\n"
		fout.write(title)
		fout.write(assign_code)
		
		# Write the utilize code
		title = "\n\t/*****     Utilize General Module HDL Code     *****/\n"
		utilizeCode += self.Utilize_CU()
		fout.write(title)
		fout.write(utilizeCode)
		
		# Write the muxes code
		title = "\n\t/*****     NORMAL MUX HDL Code     *****/\n"
		fout.write(title)
		fout.write(muxCode)
		
		# Write the Bypass code
		title = "\n\t/*****     Bypass MUX HDL Code     *****/\n"
		fout.write(title)
		fout.write(bypassCode)
		
		# Write the pipeline reg code
		title = "\n\t/*****     PipeReg HDL Code     *****/\n"
		fout.write(title)
		fout.write(pipeCode)
		
		# Write the endmodule statement
		fout.write("endmodule\n")
		
		# Close the file
		fout.close()
	
	# @function: generate the Control HDL Code, and write it into a file
	# @param:
	#	wireCtrlCode: wire of Control HDL Code
	#	regCtrlCode: reg of Control HDL Code
	#	assignCtrlCode: assign of Control HDL code
	#	alwaysCtrlCode: always of Control HDL code
	def Auto_Gen_CU(self, wireCtrlCode, regCtrlCode, assignCtrlCode,\
					alwaysCtrlCode, fname = "control.v", mname="control"):
		# Open the file
		fout = open(self.work_path+fname, "w")
		
		# Write the includes file
		for defname in self.defvs:
			fout.write('`include ' + '"' + defname +'"\n' )
		fout.write('\n')
		
		controlPorts = self.Gen_ctrlPorts()
		
		# Write the module statement
		strLine = "module %s (" % (mname)
		for i in range(len(controlPorts)-1):
			if (i&3) == 0:
				strLine += "\n\t"
			strLine += "%s, " % (controlPorts[i])
		strLine += "%s" % (controlPorts[-1])
		strLine += "\n);\n\n"
		fout.write(strLine)
		
		# Write the input & output statement
		#	input included:
		#	(1) clk, rst_n
		#	(2) instr
		inputCode = ""
		inputCode += "\tinput %s;\n" % (self.HDL_CLK)
		inputCode += "\tinput %s;\n" % (self.HDL_NRST)
		for (instrName, instrWidth) in self.instrPorts:
			inputCode += "\tinput %s %s;\n" % (instrWidth, instrName)
		#	output included:
		#	(1) self.ctrlPorts
		outputCode = ""
		for (portName, portWidth) in self.ctrlPorts:
			if portWidth!="1":
				outputCode += "\toutput %s %s;\n" % (portWidth, portName)
			else:
				outputCode += "\toutput %s;\n" % (portName)
		outputCode += "\n"
		fout.write(inputCode)
		fout.write(outputCode)
		
		# Write the wire Ctrl Code
		title = "\n\t/*****     wire statment HDL Code     *****/\n"
		fout.write(title)
		fout.write(wireCtrlCode)
		
		# Write the reg Ctrl Code
		title = "\n\t/*****     reg statment HDL Code     *****/\n"
		fout.write(title)
		fout.write(regCtrlCode)
		
		# Write the assign Ctrl Code
		title = "\n\t/*****     assign HDL Code     *****/\n"
		fout.write(title)
		fout.write(assignCtrlCode)
		
		# Write the always Ctrl Code
		title = "\n\t/*****     always HDL Code     *****/\n"
		fout.write(title)
		fout.write(alwaysCtrlCode)
		
		# Write the endmoule
		strLine = "\nendmodule\n"
		fout.write(strLine)
		
		# Close the file
		fout.close()
	
	# @function: utilize the module CU
	# @param:
	#	mname: name of module
	#	tabn: num of TAB
	def Utilize_CU(self, mname="control", tabn=1):
		ret = ""
		pre = "\t" * tabn
		controlPorts = self.Gen_ctrlPorts()
		
		# add module name & U_module
		ret += pre + "%s U_%s (" % (mname, mname)
		# add ports
		for i in range(len(controlPorts)-1):
			if (i&3) == 0:
				ret += "\n" + pre + "\t"
			ret += ".%s(%s), " % (controlPorts[i], controlPorts[i])
		ret += ".%s(%s)" % (controlPorts[-1], controlPorts[-1])
		ret += "\n" + pre + ");\n"
		return ret
	
	# @function: generate the port of Control
	# @logic: port of Control includes
	#	(0) instr*stage_num, clk, rst_n
	#	(1) normal control port
	#	(2) bypass select port
	#	(3) PCWr piepRegWr
	def Gen_ctrlPorts(self):
		# add instrs, clk, rst_n
		ret_ctrlPorts = [item[0] for item in self.ctrlPorts]
		ret_ctrlPorts += [item[0] for item in self.instrPorts]
		# ret_ctrlPorts += [item for item in self.pipeRegWrPorts[-1]]
		# ret_ctrlPorts.append("%s_%S" % (self.PCWr, self.RTL_PCWr_StageName))
		ret_ctrlPorts += [self.HDL_CLK, self.HDL_NRST]
		
		return ret_ctrlPorts
		
		# add normal control ports first
		# for i_stage in range(self.stage_num):
			# ctrlPorts = self.Controls[i_stage]
			# for portName in ctrlPorts:
				# pname = self.Gen_portName(portName,\
							# self.stage_names[i_stage])
				# if not self.is_aControl(portName):
					# it's a mux
					# pname += self.MUX_SEL					
				# ret_ctrlPorts.append(pname)
		
		# add bypass select
		# for i_stage in range(self.stage_num):
			# for item in BypassSelPorts[i_stage]:
				# ret_ctrlPorts.append(item[0])
				
		# add flush 
		# ret_ctrlPorts += self.flushPorts
		# add pipeRegWr
		# ret_ctrlPorts += self.pipeRegWrPorts
		# add PcWr
		# ret_ctrlPorts.append("%s_%s" % (self.HDL_PCWr, self.RTL_PCWr_StageName)) 
		
		# return ret_ctrlPorts
		
	# @function: generate the wire statement of Control HDL Code	
	# @logic: wire includes:
	#	(1) Instr of all stages
	#	(2) opcd & xo of all stages
	#	(3) some ports connects to ctrl Port
	def Gen_ctrlWireCode(self, tabn):
		wireCode = ""
		pre = "\t" * tabn
		# add instr first
		instrWidth = self.HDL_INSTR_WIDTH
		wirePorts = []
		wirePorts += self.instrPorts
		
		# add opcd
		for i_stage in range(1, self.stage_num):
			desPortName = "%s_%s" % (self.HDL_OPCD, self.stage_names[i_stage])
			desPortWidth = "[0:`%s]" % (self.HDL_OPCD_WIDTH)
			wirePorts.append((desPortName, desPortWidth))
		# add xo	
		for i_stage in range(1, self.stage_num):
			desPortName = "%s_%s" % (self.HDL_XO, self.stage_names[i_stage])
			desPortWidth = "[0:`%s]" % (self.HDL_OPCD_WIDTH)
			wirePorts.append((desPortName, desPortWidth))
			
		# add connected ports:
		#	if aPort -> Op/Wr, bPort -> aPort
		#		we need to make a wire statement for aPort
		for i_stage in range(self.stage_num):
			ctrlPorts = self.Controls[i_stage]
			stageName = self.stage_names[i_stage]
			nestPorts = set()
			for portName in ctrlPorts:
				if self.is_aControl(portName):
					connectedPorts = self.Gen_ctrlConnectedWirePorts(portName, i_stage)
					nestPorts.update(set(connectedPorts))
			wirePorts += [(self.Gen_portName(item[0], stageName), item[1])\
							for item in nestPorts]
		wireCode += self.Gen_HDLWireOrRegCode(wirePorts, tabn)
		wireCode += self.Gen_ctrlBypassAddrWireCode(tabn)
		
		return wireCode
	
	# @function: generate the wire statement of bypass addr wire Code
	def Gen_ctrlBypassAddrWireCode(self, tabn):
		wireCode = ""
		# addrSet = set()
		# for i_stage in range(self.stage_num):
			# hazardAddrs = self.hazardAddrs[i_stage]
			# for addr in hazardAddrs:
				# if addr[0]=="`" or addr[0]=="{":
					# continue
				# we must find the connection and width for following port
				# addrSet.add(addr)
		return wireCode
	
				
	# @function: generate the assign Control HDL Code
	# @logic: included:
	#	(1) nested connected port
	#	(2) XO & OPCD
	def Gen_ctrlAssignCode(self, tabn):
		assignCode = ""
		# add opcd
		for i_stage in range(1, self.stage_num):
			desPortName = "%s_%s" % (self.HDL_OPCD, self.stage_names[i_stage])
			srcPortName = "%s[`%s]" % (self.instrPorts[i_stage][0], self.HDL_OPCD_FIELD)
			assignCode += self.Gen_HDLAssignCode(desPortName, [srcPortName], tabn)
		# add xo
		for i_stage in range(1, self.stage_num):
			desPortName = "%s_%s" % (self.HDL_XO, self.stage_names[i_stage])
			srcPortName = "%s[`%s]" % (self.instrPorts[i_stage][0], self.HDL_XO_FIELD)
			assignCode += self.Gen_HDLAssignCode(desPortName, [srcPortName], tabn)		
		# add others
		for i_stage in range(self.stage_num):
			ctrlPorts = self.Controls[i_stage]
			stageName = self.stage_names[i_stage]
			nestPorts = set()
			for portName in ctrlPorts:
				if self.is_aControl(portName):
					connectedPorts = self.Gen_ctrlConnectedWirePorts(portName, i_stage)
					nestPorts.update(set(connectedPorts))
			for item in nestPorts:
				desPort = item[0]
				srcPorts = list(self.Connects[i_stage][desPort])
				srcPort = srcPorts[0][1:]
				desPortName = self.Gen_portName(desPort, stageName)
				srcPortName = self.Gen_portName(srcPort, stageName)
				assignCode += self.Gen_HDLAssignCode(desPortName, [srcPortName], tabn)
		return assignCode
	
	# @function: generated ->-> ctrl wire port, only one level nested
	# @param:
	#	portName: name of the port
	#	i_stage: index of stage
	def  Gen_ctrlConnectedWirePorts(self, portName, i_stage):
		wirePorts = []
		srcports = self.Connects[i_stage][portName]
		stageName = self.stage_names[i_stage]
		for srcName in srcports:
			if srcName in self.Connects[i_stage]:
				# only support one level nested
				wirePorts.append((srcName, "1"))
		return wirePorts	
	
	# @function: generate the wire statement of Control HDL Code	
	# @logic: wire includes:
	#	(1) normal control ports
	#	(2) bypass select control ports
	def Gen_ctrlRegCode(self, tabn):
		regCode = ""
		regPorts = []
		# add normal control ports first
		for i_stage in range(self.stage_num):
			ctrlPorts = self.Controls[i_stage]
			for portName in ctrlPorts:
				pname = self.Gen_portName(portName,\
							self.stage_names[i_stage])
				if not self.is_aControl(portName):
					# it's a mux
					pname += self.MUX_SEL				
				if ctrlPorts[portName] != 1:
					portWidth = "[0:%s]" % (str(ctrlPorts[portName]-1))
				else:
					if not portName.endswith("Wr"):
						prewidth = len(self.stage_names[i_stage])+1
						portWidth = "[0:`%s_WIDTH]" % (pname[:-prewidth])
					else:
						portWidth = "1"
				regPorts.append((pname, portWidth))
				
		# add bypass select ports
		for i_stage in range(self.stage_num):
			selPorts = self.BypassSelPorts[i_stage]
			# print "selPorts = ", selPorts
			regPorts += selPorts
		
		self.ctrlPorts += regPorts		
		regCode += self.Gen_HDLWireOrRegCode(regPorts, tabn, False)
		# wire Code is for Top
		wireCode = self.Gen_HDLWireOrRegCode(regPorts, tabn)
		
		return (regCode, wireCode)
		
	# @function: generate the top assign code
	# @param:
	#	tabn: num of TAB
	def Gen_AssignCode(self, tabn = 1, isTop = True):
		ret = "\n"
		pre = '\t' * tabn
		ret += pre
		if isTop:
			ret += pre.join(list(self.TopAssignCode_Set))
		else:
			pass
		return ret
		
	def Add_OneAssignCode(self, srcName, i_stage, isTop = True):
		# print "srcName =", srcName
		sublist = self.Gen_DFSAssignCode(srcName, i_stage)
		for item in sublist:
			if isTop:
				self.TopAssignCode_Set.add(item)
			else:
				pass
		
	# @function: generate the one assign code
	# @param:
	#	srcName: name of the source
	#	i_stage: index of the stage
	def Gen_DFSAssignCode(self, srcName, i_stage):
		ret = []
		if srcName not in self.Connects[i_stage]:
			return ret
		sname = self.Gen_portName(srcName, self.stage_names[i_stage])
		for desName in self.Connects[i_stage][srcName]:
			if desName[0] == '#':
				# print "dfs:%s = %s" % (sname, desName)
				dname = self.Gen_portName(desName, self.stage_names[i_stage])
				if dname[0] == '#':
					dname = dname[1:]
				code = self.Gen_OneAssignCode(sname, dname)
				ret.append(code)
				# search the desName also need assign expression
				sublist = self.Get_VarInString(desName)
				for pname in sublist:
					ret += self.Gen_DFSAssignCode(pname, i_stage)
		return ret
	
	# @function: generate one assign code
	# @param:
	#	srcName: name of the source
	#	desName: name of the destination
	def Gen_OneAssignCode(self, srcName, desName):
		return "assign %s = %s;\n" % (srcName, desName)
	
	# @function: generate the pipeline register
	def Gen_PipelineRegCode(self, tabn = 1):
		ret = ""
		pre = '\t'*tabn
		for i_stage in range(self.stage_num-1):
			title = pre + "/*****    %s    *****/\n\n" % (self.stage_names[i_stage+1])
			ret += title
			for pname in self.Flows[i_stage]:
				portName = self.Gen_portName(pname, self.stage_names[i_stage+1])
				ret += pre + "always @(posedge clk or negedge rst_n) begin\n"
				ret += pre + '\t' + "if (!rst_n) begin\n"
				ret += pre + '\t'*2 + portName + " <= " + self.HDL_RSTV + ";\n"
				ret += pre + '\t' + "end\n"
				ret += pre + '\t' + "else if ( %s ) begin\n" % (self.pipeRegWrPorts[i_stage])
				prePortName = self.Gen_portName(pname, self.stage_names[i_stage])
				if self.is_aBypass(pname, i_stage):
					prePortName += self.BYPASS_SUFFIX
				ret += pre + '\t'*2 + portName + " <= " + prePortName + ";\n"
				ret += pre + '\t' + "end\n"
				ret += pre + "end // end always\n\n"
		return ret
		
	# @function: generate all necessary reg code
	def Gen_AllModuleRegCode(self, tabn = 1):
		ret = ""
		pre = '\t'*tabn + self.HDL_REG + " "
		suffix = ";\n"
		for i_stage in range(self.stage_num):
			for portExp in self.Flows[i_stage]:
				pos = portExp.find('.')
				if pos!=-1:
					mname = portExp[0:pos]
					pname = portExp[pos+1:]
					length = self.module_portLength[mname][pname]
					uname = self.Gen_portName(portExp, self.stage_names[i_stage+1])
					ret += pre + length + " " + uname + suffix
				elif portExp ==	self.RTL_INSTR:
					uname = self.Gen_portName(portExp, self.stage_names[i_stage+1])
					ret += pre + self.HDL_INSTR_WIDTH + " " + uname + suffix
				else:
					self.ErrRobot.Add_aError(UNKNOWN_FLOW, portExp)
		return ret	
		
	# @function: generate all modules's wire code
	# @param:
	#	tabn : num of TAB
	def Gen_AllModuleWireCode(self, tabn = 1):
		self.TopWirePort = set()
		ret = ""
		ret += '\t'*tabn + self.HDL_WIRE + " " + self.HDL_INSTR_WIDTH + " " \
			+ self.Gen_portName(self.RTL_INSTR, self.stage_names[0]) + ";\n"
		for mname in self.modules:
			ret += self.Gen_OneModuleWireCode(mname, tabn)
		return ret
		
	# @function: generate all modules's wire code
	# @param:
	#	mname: name of the module
	def Gen_OneModuleWireCode(self, mname, tabn):
		ret = ""
		pre = '\t'*tabn + self.HDL_WIRE + " "
		suffix = ";\n"
		for pname in self.modules[mname]:
			if pname in self.module_portLength[mname]:
				length = self.module_portLength[mname][pname]
				(portExp, i_stage) = self.modules[mname][pname]
				# get all possible portname from the portExp
				portNames = self.Get_VarInString(portExp)
				for portName in portNames:
					if (portName, i_stage) in self.TopWirePort or self.Port_is_aPipe(portName, i_stage):
						continue
					self.TopWirePort.add(( portName, i_stage) )	
					if self.is_aControl(portName):
						continue
					uname = self.Gen_portName(portName, self.stage_names[i_stage])
					ret += pre + length + " " + uname + suffix
					# if it has Bypass then add a wire statement
					if self.is_aBypass(portName, i_stage, True):
						ret += pre + length + " " + uname + self.BYPASS_SUFFIX + suffix
		return ret
		
	# @function: generate the all modules's length dict()
	def Gen_AllModuleLength(self):
		dir_list = os.listdir(self.work_path)
		for fname in dir_list:
			if fname.endswith(self.HDL_SUFFIX) and not fname.endswith(self.HDL_DEFINE):
				self.Gen_OneModuleLength(fname)
		
	# @function: generate wire code from one file
	# @param:
	#	fname: name of the file
	def Gen_OneModuleLength(self, fname):
		fin = open(self.work_path+fname, "r")
		found = False
		for line in fin:
			if line.startswith(self.HDL_ENDMODULE):
				found = False
			if line.startswith(self.HDL_MODULE):
				m = self.re_getHDLModule.match(line)
				if m:
					mname = m.group(1)
					found = mname in self.modules
					if found and mname in self.modules:
						found = True
						self.module_portLength[mname] = {}
				else:
					self.ErrRobot.Add_aError(self.PROGRAM_BUG, "HDL re.match(module)", line)
				continue	
			elif found:
				if self.HDL_OUTPUT in line:
					self.Gen_OneWireStatment(line, mname, self.HDL_OUTPUT)
				elif self.HDL_INPUT in line:
					self.Gen_OneWireStatment(line, mname, self.HDL_INPUT)
		fin.close()

	# @function: generate one wirte statement
	# @logic:
	#	we need to store the length part, 
	#	because some ports need to state multiple times, such as flow ports.
	#   /**** You need to be sure of accurate of the core module ****/
	# @param:
	#	line: the line has key word "output"
	#	mname: name of the module
	#	wireKeyWord: key word of wire, such as input
	def Gen_OneWireStatment(self, line, mname, wireKeyWord):
		strings = re.split(r'\s+', line)
		found = False
		length = ""
		for substr in strings:
			if not substr == '':
				if found:
					# port name must follow with ',' or ';' And
					#	',' and ';' must closed to portName
					if substr[-1] == ',' or substr[-1] == ';':
						portName = substr[:-1]
						tmpName = portName.lower()
						if tmpName == self.HDL_CLK or tmpName == self.HDL_NRST or tmpName == self.HDL_RST:
							return NULL
						self.module_portLength[mname][portName] = length
						# length must hold until ';' comes out, 
						#	because all port share the same length
						# length = ""
					else:
						length = substr
					if substr[-1] == ';':
						break
				if substr == wireKeyWord:
					found = True
	
	# @function: Get the instruction's r_index(Boundry) in certain column. 
	# @param:
	#	c_index: certain column has instructions.
	def Get_InstrBoundry(self, c_index):
		f_row = self.s_row + 1
		t_row = self.AE.Get_NRow()
		for r in range(f_row, t_row):
			instr = self.AE.Get_OneCell(r, c_index)
			if instr != NULL:
				if instr[len(instr)-1] == '.':
					val = instr[0:len(instr)-1] + '_'
				else:
					val = instr
				self.instrs_boundry.append((val, r))
		# Add the end boundry
		self.instrs_boundry.append(("None", t_row))
	
	# @function: Merge all ports (maybe from different stages) into their module
	def Merge_AllModule(self):
		self.Merge_AllConnects()
		self.Merge_AllFlows()
	
	# @function: Merge all connects ports (maybe from different stages) into their module
	def Merge_AllConnects(self):
		self.modules = {}
		for i_stage in range(self.stage_num):
			Connects = self.Connects[i_stage]
			for portName in Connects:
				# NO '.' NO Module
				if '.' in portName:
					(mname, pname) = portName.split('.')[0:2]
					# uname = self.Gen_portName(portName, self.stage_names[i_stage])
					if mname not in self.modules:
						self.modules[mname] = {}
					# self.modules[mname][pname] = (Connects[portName], i_stage)
					# if it's a mux use Gen_portName to generate proper portName
					"""
						where need to merge, where to check if we need the assign code
						add assignCode to Top module
						we need to check in where needs mux and not control
					"""
					if len(Connects[portName]) > 1:
						uname = self.Gen_portName(portName)
						# means here must have a mux
						for sname in Connects[portName]:
							self.Add_OneAssignCode(sname, i_stage, True)
					else:
						dname = list(Connects[portName])[0]
						if self.is_aControl(portName):
							uname = self.Gen_ControlName(portName)
						else:
							self.Add_OneAssignCode(dname, i_stage, True)
							uname = dname
					self.modules[mname][pname] = (uname, i_stage)
				else:
					pass
					# if portName has no '.' then add an Error
					# self.ErrRobot.Add_aError(self.ErrRobot.PORT_NOMODULE, portName)
				# print "call Merge_srcOfConnects: portName =", portName
				self.Merge_srcOfConnects(Connects[portName], i_stage)
	
	# @function: Merge source of connection into their module
	# @logic: two or more combination circuits may link together, so some output
	#	may be used as some module's input, this condtion only works in combination circuit.
	#	so we can use function Port_is_aFlow to check if it's from the earlier stage.
	# @param:
	#	srcName: source name's list
	#	i_stage: index of stage
	def Merge_srcOfConnects(self, srcNames, i_stage):
		for portName in srcNames:
			if not self.Port_is_aFlow(portName, i_stage):
				# print "srcportName =", portName
				if portName[0]=='#':
					portName = portName[1:]
				if '.' in portName:
					(mname, pname) = portName.split('.')[0:2]
					# uname = self.Gen_portName(portName, self.stage_names[i_stage])
					if mname not in self.modules:
						self.modules[mname] = {}
					self.modules[mname][pname] = (portName, i_stage)
				
		
	# @function: Merge all flows ports(meaning output, because without input)
	# @logic:
	#	1. RTL is only a format of connection between ports,
	#		some ports like GPR.rd(especially output port) has no input connection.
	#		so we can only search it frow the flow.
	#	2. One trick is search from the earliest stage, because we need to cetain the stage.
	#	3. If we found such a flow and its name not in self.modules. 
	#		meaning it's definitely a port without any input, so must be mname error.
	# @param:
	#	mname: name of the module
	#	pname: name of the missing port
	def Merge_AllFlows(self):
		for i_stage in range(self.stage_num):
			for portName in self.Flows[i_stage]:
				if '.' in portName:
					(mname, pname) = portName.split('.')[0:2]
					# uname = self.Gen_portName(portName, self.stage_names[i_stage])
					if mname not in self.modules:
						self.ErrRobot.Add_aError(UNDEF_MODULE, mname, portName)
					elif pname not in self.modules[mname]:
						self.modules[mname][pname] = (portName, i_stage)
	
	# @function: check whether modules on one file has all ports connected
	# @param:
	#	fname: name of the file
	def Check_OneFile(self, fname):
		fin = open(self.work_path+fname, "r")
		found = False
		for line in fin:
			if ");" in line:
				found = False
				continue
			if found:
				nline = "".join(line.split())
				pnames = nline.split(',')
				U_Ports_of = self.modules[mname]
				for pname in pnames:
					if pname == NULL:
						continue
					if pname not in U_Ports_of:
						if pname=="clk" or pname=="rst_n" or pname=="rst":
							self.modules[mname][pname] = (pname, self.stage_num)
						else:
							# if there's still some port without any connections
							#	then there must be some errors
							if mname=="PC" and pname==self.HDL_PCWr:
								self.modules[mname][pname] =\
										(pname, self.stage_names.index(self.RTL_PCWr_StageName))
							self.ErrRobot.Add_aError(self.ErrRobot.PORT_UNCONNECTED, mname, pname)
			# module must at the most beginning				
			if line.startswith(self.HDL_MODULE):
				m = self.re_getHDLModule.match(line)
				if m:
					mname = m.group(1)
					found = mname in self.modules
				else:
					self.ErrRobot.Add_aError(self.PROGRAM_BUG, "HDL re.match(module)", line)	
		fin.close()
	
	# @function: check all the files about the module's connection
	def Check_AllFile(self):
		dir_list = os.listdir(self.work_path)
		for fname in dir_list:
			if fname.endswith(self.HDL_SUFFIX) and not fname.endswith(self.HDL_DEFINE):
				self.Check_OneFile(fname)
				
	# @function: utilize one module
	# @param:
	#	mname: name of the module
	#	tabn: num of the TAB
	def Utilize_OneModule(self, mname, tabn):
		ret = ""
		# Add utilize statement
		ret += '\t'*tabn + mname + " U_" + mname + " ("
		# Add the signal instantion
		portConnects_of = self.modules[mname]
		i = 0
		n = len(portConnects_of)
		for pname in portConnects_of:
			if i&3 == 0:
				ret += '\n' + '\t'*(tabn+1)
			ret += '.' + pname + '('
			(portName, i_stage) = portConnects_of[pname]
			uname = self.Gen_portName(portName, self.stage_names[i_stage])
			if self.is_aBypass(portName, i_stage):
				uname += self.BYPASS_SUFFIX	
			ret += uname
			"""
			if len(srcs) > 1:
				ret += self.Auto_find_mux.Get_keyname(mname+'.'+sname)
			elif self.Auto_find_mux.Get_isControl(mname+'.'+sname):
				ret += sname
			else:
				src = srcs[0]
				ppos = src.find('.')
				if ppos < 0:
					ret += src
				else:	
					beg = 0
					while True:
						if src[beg].isalpha():
							break
						beg += 1
					end = ppos + 1
					while end<len(src) and src[end].isalpha():
						end += 1
					alias = self.Auto_find_mux.Get_keyname(src[beg:end]) 	
					ret += src[0:beg] + alias + src[end:len(src)]
			"""
			ret += ')'
			if i+1 != n:
				ret += ', '
			i += 1	
		# Add end statement	
		ret += '\n' + '\t' * tabn + ");\n\n"
		return ret
	
	# @function: utilize all modules
	# @param:
	#	tabn: num of TAB
	def Utilize_AllModule(self, tabn = 1):
		ret = ""
		# Colletc all the modules
		self.Merge_AllModule()
		# Check all the file
		self.Check_AllFile()
		for mname in self.modules:
			ret += self.Utilize_OneModule(mname, tabn)
		# ret += self.CU_Ucode + '\n'
		return ret
	
	# @function: gen the logic of stall and flush HDL code
	# @logic:
	#	1.PCWr is absolutely caused by stall (to stop PCWr actually)
	#	2.Stall means:
	#		(1) PC not write
	#		(2) pipeline register not write (from current to initial stage)
	#		(3) flush current stage
	#	3.Flush need to consider Branch, which patch by human
	# @param:
	#	tabn: num of TAB
	def Gen_stallCode(self, tabn):
		pre = "\t"*tabn
		ret_wireCode = ""
		ret_regCode = ""
		ret_assignCode = "\n" + pre + "/*****     stall assign HDL Code     *****/\n"
		ret_alwaysCode = "\n" + pre + "/*****     stall always HDL Code     *****/\n"
		
		# Add some exception flush Conds
		excepFlushConds = self.Gen_excepFlushConds()
		
		# Add the stall reg statement
		ret_regCode += self.Gen_stallRelatedRegCode(tabn)
		ret_wireCode += self.Gen_stallRelatedWireCode(tabn)
		ret_alwaysCode += self.Gen_stallAlwaysCode(tabn)
		ret_alwaysCode += self.Gen_flushAlwaysCode(tabn)
		ret_alwaysCode += self.Gen_flushrAlwaysCode(tabn)
		ret_alwaysCode += self.Gen_pipeRegWrAlwaysCode(tabn)
		ret_assignCode += self.Gen_flushAssignCode(excepFlushConds, tabn)
		ret_assignCode += self.Gen_PCWrAssignCode(tabn)
		ret = "%s\n%s\n%s\n%s\n" % (ret_wireCode, ret_regCode, ret_assignCode, ret_alwaysCode)
		print ret
		
		# add pipeRegWr & PCWr to self.ctrlPorts
		self.ctrlPorts += [(item, "1") for item in self.pipeRegWrPorts[:-1]]
		PCWrName = "%s_%s" % (self.HDL_PCWr, self.RTL_PCWr_StageName)
		self.ctrlPorts.append((PCWrName, "1"))
		
		return (ret_wireCode, ret_regCode, ret_assignCode, ret_alwaysCode)
		
	# *******************************
	#  we may and flush_D at condexcep for branch
	# *******************************
	# @function: generate the exception flush condition, especially branch
	# @return: flushconditions, format as [[]...[]]
	def Gen_excepFlushConds(self):
		excepFlushConds = [[] for i in range(self.stage_num)]
		branchInstrs = ["b", "bc", "bcctr", "bclr"]
		branchStage = 1
		opcdName = "%s_%s" % (self.HDL_OPCD, self.stage_names[branchStage])
		xoName =  "%s_%s" % (self.HDL_XO, self.stage_names[branchStage])
		conditions = []
		for instrName in branchInstrs:
			uinstrName = instrName.upper()
			uinstrName_OPCD = "%s_%s" % (uinstrName, self.HDL_OPCD.upper())
			cond = "( %s == `%s" % (opcdName, uinstrName_OPCD)
			for insn in self.instrs_sgp:
				if insn==uinstrName:
					cond += " && %s == `%s_%s" % (xoName, uinstrName, self.HDL_XO.upper())
			cond += " )"
			conditions.append(cond)
		branchCond = "( ( ~%s ) && ( %s ) )" % (self.flushPorts[branchStage], " || ".join(conditions))
		excepFlushConds[branchStage-1] += [branchCond]
		return excepFlushConds
		
	# @function: generate the flush code
	# @logic:
	#	(1) stall cause flush
	#	(2) branch cause flush
	# @param:
	#	excepFlushConds: except flush conditions arrange by stage index
	#	tabn: num of TAB
	def Gen_flushAssignCode(self, excepFlushConds, tabn):
		ret = ""
		pre = "\t" * tabn
		stallPorts = self.stallPorts
		# for i_stage in range(self.stage_num):
			# stallPortName = "%s_%s" % (self.HDL_STALL, self.stage_names[i_stage])
			# stallPorts.append(stallPortName)
		# flushPort_pre = self.HDL_FLUSH + "_"
		
		for i_stage in range(0, self.stage_num):
			# print "flush assign stage index ", i_stage
			conditions = []
			if i_stage>0:
				# add normal stall condition
				conditions.append("( %s )" % (stallPorts[i_stage-1]))
			# add reg flush condition
			conditions.append("( %s_r )" % (self.flushPorts[i_stage]))
			# add except condition
			conditions += excepFlushConds[i_stage]
			flushPortName = self.flushPorts[i_stage]
			if len(conditions) > 0:
				assignCode = self.Gen_HDLAssignCode(flushPortName, conditions, tabn)
			else:
				assignCode = self.Gen_HDLAssignCode(flushPortName, ["0"], tabn)
			ret += assignCode
		
		return ret
	
	def Gen_flushAlwaysCode(self, tabn):
		ret = ""
		return ret
	
	# @function: generate the flush code
	# @logic:
	#	(1) stall cause PC not write
	def Gen_PCWrAssignCode(self, tabn):
		ret = ""
		pre = "\t" * tabn
		PCWrPortName = "%s_%s" % (self.HDL_PCWr, self.RTL_PCWr_StageName)
		stalls = " || ".join(self.stallPorts[:-1])
		conditions = ["~( %s )" % (stalls)]
		assignCode = self.Gen_HDLAssignCode(PCWrPortName, conditions, tabn)
		ret += assignCode
		return ret
	
	# @funciton: generate the always code in stall logic
	# @logic:
	#	(1) when we want to stall one pipieReg, also means
	#			we need to stall all regs after current stage;
	def Gen_stallAlwaysCode(self, tabn):
		ret = ""
		pre = "\t"*tabn
		stallPorts = self.stallPorts
		# for i_stage in range(self.stage_num):
			# stallPortName = "%s_%s" % (self.HDL_STALL, self.stage_names[i_stage])
			# stallPorts.append(stallPortName)
		stallCond_ofStages = self.stallCond_ofStages
		for i_stage in range(len(stallCond_ofStages)):
			alwaysCode = pre + "always @( * ) begin\n"
			# if there's no condtion to set stall we make it a const zero.
			if len(stallCond_ofStages[i_stage])==0:
				solu = pre + "\t%s = 1'b0;\n" % (stallPorts[i_stage])
				alwaysCode += solu
			else:
				stallConds = stallCond_ofStages[i_stage]
				solu = "%s = 1'b1;" % (stallPorts[i_stage])
				stallSolus = [solu] * len(stallCond_ofStages[i_stage])
				alwaysCode += self.Gen_HDLAlwaysCode(stallConds, stallSolus, tabn+1)
				solu = "%s = 1'b0;" % (stallPorts[i_stage])
				alwaysCode += self.Gen_HDLElseCode(solu, tabn+1)
			alwaysCode += pre + "end // end always\n\n"
			ret += ""
			ret += alwaysCode
		return ret
	
	# @function: generate shift register of stallr Always Code	
	def Gen_flushrAlwaysCode(self, tabn):
		alwaysCode = ""
		pre = "\t" * tabn
		ppre = pre + "\t"
		alwaysCode += pre + "always @(posedge clk or negedge rst_n) begin\n"
		# if nReset
		alwaysCode += ppre + "if ( !rst_n ) begin\n"
		for i_stage in range(self.stage_num):
			alwaysCode += ppre + "\t%s_r <= 1'b0;\n" % (self.flushPorts[i_stage])
		alwaysCode += ppre + "end\n"
		# else
		alwaysCode += ppre + "else begin\n"
		# flush_F_r is always zero, not need to shift	
		alwaysCode += ppre + "\t%s_r <= 1'b0;\n" %\
						(self.flushPorts[0])
		for i_stage in range(1, self.stage_num):
			alwaysCode += ppre + "\t%s_r <= %s;\n" %\
						(self.flushPorts[i_stage], self.flushPorts[i_stage-1])
		alwaysCode += ppre + "end\n"
		alwaysCode += pre + "end // end always\n\n"
		# print "finishing \n", alwaysCode
		return alwaysCode
		
	def Gen_pipeRegWrAlwaysCode(self, tabn):
		ret = ""
		pre = "\t" * tabn
		stallPorts = self.stallPorts
		pipeRegWr_pre = "%s_" % (self.HDL_PIPEREGWR)
		# for i_stage in range(self.stage_num-1):
			# stallPortName = "%s_%s" % (self.HDL_STALL, self.stage_names[i_stage])
			# stallPorts.append(stallPortName)
		for i_stage in range(self.stage_num-1):
			alwaysCode = pre + "always @( * ) begin\n"
			cond = " || ".join(stallPorts[i_stage:-1])
			solu = "%s = 1'b0;" % (self.pipeRegWrPorts[i_stage])
			alwaysCode += self.Gen_HDLAlwaysCode([cond], [solu], tabn + 1)
			solu = "%s = 1'b1;" % (self.pipeRegWrPorts[i_stage])
			alwaysCode += self.Gen_HDLElseCode(solu, tabn+1)
			alwaysCode += pre + "end // end always\n\n"
			ret += alwaysCode
		return ret
		
		"""
		stallConds = []
		stallSolus = []
		solus = []
		# get all stall condition at this stage
		stallConds = self.stallCond_ofStage[i_stage]
		# get the stall port value
		for i in len(i_stage):
			solu = "%s = 1'b1;" % (stallPorts[i])
			solus.append(solu)
		for i in len(i_stage+1, self.stage_num):
			solu = "%s = 1'b0;" % (stallPorts[i])
			solus.append(solu)
		stallSolus = [solus]*len(stallCodns)
		alwaysCode = self.Gen_HDLAlwaysCode(stallConds, stallSolus, tabn)
		if alwaysCode!=NULL:
			ret += alwaysCode
			solus = "%s = 1'b0;" % (stallPort)
			ret += self.Gen_HDLElseCode([solus], tabn)
		"""
		
	# @funciton: generate the reg statement code in stall logic
	def Gen_stallRelatedRegCode(self, tabn): 
		ret = ""
		pre = "\t"*tabn
		
		stall_regCode = ""
		flushr_regCode = ""
		# flush_regCode = ""
		# PCWr_regCode = ""
		pipeRegWr_regCode = ""
		for i_stage in range(self.stage_num-1):
			pipeRegWr_regCode += pre + "%s %s;\n"\
									% (self.HDL_REG, self.pipeRegWrPorts[i_stage])
			stall_regCode += pre + "%s %s;\n"\
								% (self.HDL_REG, self.stallPorts[i_stage])
		for i_stage in range(self.stage_num):						
			flushr_regCode += pre + "%s %s_r;\n"\
								% (self.HDL_REG, self.flushPorts[i_stage])
			# if i_stage+1<self.stage_num:
			# pipeRegWr_regCode += pre + "%s %s_%s;\n"\
									# % (self.HDL_REG, self.HDL_PIPEREGWR, self.stage_names[i_stage])
			# flush_regCode += pre + "%s %s_%s;\n"\
								# % (self.HDL_REG, self.HDL_FLUSH, sellf.stage_names[i_stage])
		# PCWr is in D Stage
		# stage_name = "D"
		# i_stage = self.stage_names(stage_name)
		# PCWr_regCode  += pre + "%s %s_%s;\n"\
							# % (self.HDL_REG, self.HDL_PCWr, sellf.stage_names[i_stage])
		ret += stall_regCode + flushr_regCode + pipeRegWr_regCode
		
		return ret
	
	# @funciton: generate the reg statement code in stall logic
	def Gen_stallRelatedWireCode(self, tabn): 
		ret = ""
		pre = "\t"*tabn
		flush_wireCode = ""
		# pipeRegWr_wireCode = ""
		for i_stage in range(self.stage_num):
			flush_wireCode += pre + "%s %s_%s;\n"\
								% (self.HDL_WIRE, self.HDL_FLUSH, self.stage_names[i_stage])
			# pipeRegWr_wireCode += pre + "%s %s_%s;\n"\
								# % (self.HDL_WIRE, pipeRegWr_wireCode, sellf.stage_names[i_stage])
		
		PCWr_wireCode  = pre + "%s %s_%s;\n"\
							% (self.HDL_WIRE, self.HDL_PCWr, self.RTL_PCWr_StageName)
		ret += flush_wireCode + PCWr_wireCode
		return ret
	
	# @function: generate the wire statement of HDL Codes
	# @param:
	#	ports: [(portName, portWidth)...]
	#			type(portName) = str
	#			type(portWidth) = str
	def Gen_HDLWireOrRegCode(self, ports, tabn, isWire=True):
		retCode = ""
		pre = "\t" * tabn
		HDLType = self.HDL_WIRE if isWire else self.HDL_REG
		for (portName, portWidth) in ports:
			if portWidth!="1":
				retCode += "%s%s %s %s;\n"\
						% (pre, HDLType, portWidth, portName)
			else:
				retCode += "%s%s %s;\n"\
						% (pre, HDLType, portName)
		return retCode		
	
	# @function: standard function, to generate always code
	# @logic: format as following
	#				if ( condition_0 ) begin
	#					solution_0;
	#				else if ( condition_1 ) begin
	#					solution_1;
	#		  we must add else statement if necessery by human	
	# @param:
	#	condition:
	#	solution: may be multiple solutions (don't use '\n' only use ';')
	def Gen_HDLAlwaysCode(self, condition, solution, tabn = 1):
		if len(condition)==0 or len(solution)==0:
			return NULL
		alwaysCode = ""
		pre = "\t"*tabn
		solPre = ";\n" + pre + "\t"
		ifNum = 0
		for i in range(len(condition)):
			cond = condition[i]
			sol = solution[i]
			alwaysCode += pre
			if i:
				alwaysCode += "else "
			alwaysCode += "if ( %s ) begin\n" % (cond)
			solsCodeList = sol[:-1].split(";")
			solsCode = solPre.join(solsCodeList)
			alwaysCode += pre + "\t%s;\n" % (solsCode)
			alwaysCode += pre + "end\n";
		return alwaysCode
	
	# @function: generate the else code, about the always blcok
	def Gen_HDLElseCode(self, solution, tabn):
		ret = ""
		pre = "\t" * tabn
		solPre = ";\n" + pre + "\t"
		ret += pre + "else begin\n"
		solsCodeList = solution[:-1].split(";")
		solsCode = solPre.join(solsCodeList)
		ret += pre + "\t%s;\n" % (solsCode)
		ret += pre + "end\n"
		return ret
	
	# @function: generate the assign code	
	def Gen_HDLAssignCode(self, desName, conditions, tabn):
		ret = ""
		if len(conditions) == 0:
			return ret
		condCode = " || ".join(conditions)
		assignCode = "assign %s = %s;\n" % (desName, condCode)
		ret += "\t" * tabn + assignCode
		return ret
	
	# @function: gen the all possible hazard array
	def Gen_AllHazardArray(self, tabn=1):
		pre = "\t" * tabn
		ret_wireCode = pre + "/*****     hazard wire HDL Code    *****/\n"
		ret_regCode  = pre + "/*****     hazard reg HDL Code    *****/\n"
		ret_assignCode  = pre + "/*****     hazard assign HDL Code    *****/\n"
		ret_alwaysCode  = pre + "/*****     hazard always HDL Code    *****/\n"
		self.hazardCouples = {}
		for readPortName in self.read_rtb:
			writePortNames = self.Gen_OneHazardArray_ReadPort(readPortName)
			if len(writePortNames) > 0:
				if readPortName not in self.hazardCouples:
					self.hazardCouples[readPortName] = []
				self.hazardCouples[readPortName] += writePortNames
		# print self.hazardCouples
		for readPortName in self.hazardCouples:
			(wireCode, regCode, assignCode, alwaysCode) =\
				self.Handle_OneHazardArray(readPortName, tabn)
			ret_wireCode += wireCode
			ret_regCode += regCode
			ret_assignCode += assignCode
			ret_alwaysCode += alwaysCode
		return (ret_wireCode, ret_regCode, ret_assignCode, ret_alwaysCode)
		# for readPortName in self.read_ports:
			# writePortNames = self.Gen_OneHazardArray_ReadPort(readPortName)
			# if it has hazard
			# if len(writePortNames) > 0:
				# if readPortName not in self.hazardCouples:
					# self.hazardCouples[readPortName] = []
				# self.hazardCouples[readPortName] += writePortNames
		# print self.hazardCouples
		# for readPortName in self.hazardCouples:
			# self.Handle_OneHazardArray(readPortName)
			
	# @function: handle one hazard array and print	
	# @logic: we only print the array in this function until now
	def Handle_OneHazardArray(self, readPortName, tabn = 1):
		# classification the instruction and stage which is related to readPortName
		readInstr_grp = []
		readStage_grp = []
		for stage_n in self.read_rtb[readPortName]:
			readInstr_grp.append(self.read_rtb[readPortName][stage_n])
			readStage_grp.append(stage_n)
		# print '\n* ',readPortName, self.read_ports[readPortName]
		min_readStage = min(readStage_grp+[self.read_ports[readPortName]])
		# print "min_readStage =", min_readStage, "readStage_grp = ", readStage_grp
		n_row = len(readStage_grp)
		
		# classification the instruction and stage which is related to writePortName
		writeInstr_grp = []
		writePortNames = self.hazardCouples[readPortName]
		# print "writePortNames = ", writePortNames
		for writePortName in writePortNames:
			for key in self.write_rtb[writePortName]:
				writeInstr_grp.append((writePortName, self.write_rtb[writePortName][key]))
		n_col = len(writeInstr_grp)
		
		(writeData, arrayInfo, bypassArrayItem) = self.Handle_HazardArrayItem(readPortName, readStage_grp, min_readStage, tabn)
		print writeData
		self.Print_HazardArrayTitle(readPortName, readInstr_grp, writeInstr_grp, min_readStage)
		print arrayInfo
		
		# generate the bypassCtrlCode use bypassArrayItem
		(wireCode, regCode, assignCode, alwaysCode) =\
			self.Gen_hazardCtrlCode(readPortName, readInstr_grp, readStage_grp, writeInstr_grp, bypassArrayItem, tabn)
		return (wireCode, regCode, assignCode, alwaysCode)
	
	# @function: check if the hazard really needs a bypass mux
	def hazard_needaBypass(self, AllbypassArrayItem):
		for bypassArrayItem in AllbypassArrayItem:
			for k in bypassArrayItem:
				if len(bypassArrayItem[k]) > 0:
					return True
		return False
	
	# @function: check if the rd_grp really needs a bypass mux
	def RdGrp_needaBypass(self, bypassArrayItem):
		for k in bypassArrayItem:
			if len(bypassArrayItem[k]) > 0:
				return True
		return False
		
	# @function: generate the hazardCtrlCode
	# @param:
	#	readPortName: name of the readPortName
	#	readInstr_grp: Instr group of readPort
	#	readStage_grp: Stage group of readPort
	#	writeInstr_grp: Instr group of writePort
	#	bypassArrayItem: element in hazard array
	#	tabn: num of TAB
	def Gen_hazardCtrlCode(self, readPortName, readInstr_grp, readStage_grp, writeInstr_grp, bypassArrayItem, tabn):
		# need to make sure there really needs bypass mux
		if not self.hazard_needaBypass(bypassArrayItem):
			return (NULL, NULL, NULL, NULL)
			
		print "\n/*****    Gen_hazardCtrlCode    *****/"
		print readPortName
		# print readInstr_grp
		# print "readStage_grp =", readStage_grp
		# print "\n/*****    Here is writeInstr_grp    *****/"
		# for subGrp in writeInstr_grp:
			# print subGrp
		# for item in bypassArrayItem:
			# print item
		ret_wireCode = ""
		ret_regCode = ""
		ret_assignCode = ""
		ret_alwaysCode = ""
		
		# some const
		pre = "\t"*tabn
		rdPortName_HDL = self.Gen_portName(readPortName)
		
		# we need to classify the write insn groups
		wrAddrs = []
		n_wr_grp = len(writeInstr_grp)
		# print "len(writePortNames) = %d, len(writeInstr_grp) = %d" % (len(writePortNames), len(writeInstr_grp))
		wr_grpNames = []
		for i_grp in range(n_wr_grp):
			(writePortName, Instrs_grp) = writeInstr_grp[i_grp]
			# print "writePortName = ", writePortName, "wr groups"
			subGrps = self.Gen_classifyInstr_grp(writePortName, Instrs_grp,\
									self.wb_stage, self.HDL_WADDR)
			if len(subGrps)==0:
				subGrps = {self.HDL_NONEADDR:Instrs_grp}
			# print "wr group subGrps =", subGrps
			# print "subGrps = \n",subGrps
			# for 
			# generate assign/wire code to implies the sepcific group
			subIndex = 0
			subGrps_wireCode = ""
			subGrps_assignCode = ""
			grpNames = []
			for srcName in subGrps:
				Instr_grp = subGrps[srcName]
				# because left column list from F to W
				# so we pretty sure 1st hazardArray line has the most hazard.
				for item in bypassArrayItem[0][i_grp]:
					wr_stage = item[0]
					grpName = rdPortName_HDL + "_" + self.stage_names[wr_stage] +\
							"_" + self.WR_GROUP_PRE + str(i_grp) + "_" + str(subIndex)
					subGrps_wireCode += pre + self.HDL_WIRE + " " + grpName + ";\n"
					subGrps_assignCode += pre + self.Gen_InstrGrpAssignCode(Instr_grp, wr_stage, grpName) + ";\n"
					grpNames.append(grpName)	
				subIndex += 1
			# add the groupNames into super groupNames
			wrAddrs.append(subGrps.keys())
			# print subGrps.keys()
			wr_grpNames.append(grpNames)
			ret_wireCode += subGrps_wireCode
			ret_assignCode += subGrps_assignCode
				
		
		# we need to classify the read Instruction groups
		n_rd_grp = len(readStage_grp)
		for i_rd_grp in range(n_rd_grp):
			try:
				if not self.RdGrp_needaBypass(bypassArrayItem[i_rd_grp]):
					continue
			except IndexError:
				print "IndexError %d" % (i_rd_grp)
			i_rd_stage = readStage_grp[i_rd_grp]
			subGrps = self.Gen_classifyInstr_grp(readPortName,\
						readInstr_grp[i_rd_grp], i_rd_stage, self.HDL_RADDR)
			# if subGrps is None means all insn in one group			
			if len(subGrps)==0:
				subGrps = {self.HDL_NONEADDR:readInstr_grp[i_rd_grp]}
			# print "read subGrps =\n", subGrps
			# generate assign/wire code to implies the sepcific group
			subGrps_wireCode = ""
			subGrps_assignCode = ""
			rd_grpNames = []
			subIndex = 0
			for srcName in subGrps:
				Instr_grp = subGrps[srcName]
				# grpName format:
				#	portName + stage_name + super group pre + super group index
				#		+ sub group index
				grpName = rdPortName_HDL + "_" + self.stage_names[i_rd_stage] +\
							"_" + self.RD_GROUP_PRE + str(i_rd_grp) + "_" + str(subIndex)
				rd_grpNames.append(grpName)
				subGrps_wireCode += pre + self.HDL_WIRE + " " + grpName + ";\n"
				subGrps_assignCode += pre + self.Gen_InstrGrpAssignCode(Instr_grp, i_rd_stage, grpName) + ";\n"
				subIndex += 1
			# generate always code for current bypass select
			subGrps_alwaysCode = self.Gen_bypassSel_alwaysCode(rdPortName_HDL, subGrps, rd_grpNames, wr_grpNames,\
										i_rd_stage, bypassArrayItem[i_rd_grp], wrAddrs, subGrps.keys(), tabn)
			ret_wireCode += subGrps_wireCode
			ret_assignCode += subGrps_assignCode
			ret_alwaysCode += subGrps_alwaysCode
			
		return (ret_wireCode, ret_regCode, ret_assignCode, ret_alwaysCode)
		
		# Let's do huge print
		# print
		# print "/*****    time to print bypass select wire code.    *****/"
		# print ret_wireCode
		# print
		# print "/*****    time to print bypass select assign code.    *****/"
		# print ret_assignCode
		# print
		# print "/*****    time to print bypass select always code.    *****/"
		# print ret_alwaysCode
		# print
	
	# @function: generate bypass select control signal for only one readPort 
	#		 		in one stage using always block
	def Gen_bypassSel_alwaysCode(self, rdPortName_HDL, rdGrps, rd_grpNames, wr_grpNames,\
									i_rd_stage, bypassArrayItem, wrAddrs, rdAddrs, tabn):
		ret = ""
		# Add always @(*) begin ... end
		opre = "\t"*tabn
		ret += opre + "always @( * ) begin\n"
		pre = opre + '\t'
		# print "\n/*****    Here is wrAddrs    *****/"
		# for subGrp in wrAddrs:
			# print subGrp
		# print "\n/*****    Here is rdAddrs    *****/"
		# for subGrp in rdAddrs:
			# print subGrp
		# print "\n/*****    Here is bypassArrayItem    *****/"
		# for kkey in bypassArrayItem:
			# print kkey, "=>", bypassArrayItem[kkey]
		# print "wrGrpNames = ", wr_grpNames
		# return ret
		# return ret
		srcNames = rdGrps.keys()
		ctrlPortName = rdPortName_HDL + "_" + self.stage_names[i_rd_stage] + self.MUX_SEL
		# we must consider bypass-send priority
		# that means when M and W both want to send to E
		# we choose M because priority
		minStage = self.stage_num + 1
		maxStage = -1
		# we need maxSel to calculate the width
		maxSel = -1	
		# bypassArrayItem_ByStage is a dict()
		#	we can use i_stage to find the tuple (wr_group_index, bypassMux_select)
		bypassArrayItem_ByStage = {}
		for i_grp in bypassArrayItem:
			if len(bypassArrayItem[i_grp]) == 0:
				continue
			for (i_stage, i_sel) in bypassArrayItem[i_grp]:
				minStage = i_stage if i_stage < minStage else minStage
				maxStage = i_stage if i_stage > maxStage else maxStage
				maxSel   = i_sel   if i_sel   > maxSel   else maxSel
				if i_stage not in bypassArrayItem_ByStage:
					bypassArrayItem_ByStage[i_stage] = []
				bypassArrayItem_ByStage[i_stage].append((i_grp, i_sel))
		
		# we really need to calculate the width for Select port
		muxn = self.Cal_Muxn(maxSel)
		width = LOGS2[muxn]
		
		
		for i_wr_stage in range(minStage, maxStage+1):
			ifNum = 0	
			for (i_wr_grp, i_sel) in bypassArrayItem_ByStage[i_wr_stage]:
				# the name of the group arrange by group stage then group index
				# means same group index with different stage continus
				nStage_OfGrp = len(bypassArrayItem[i_grp])
				# bypassArrayItem[i_grp][0] is a tuple()
				iStage_ofGrp = i_wr_stage - bypassArrayItem[i_grp][0][0]
				wrAddrs_ofGrp = wrAddrs[i_wr_grp]
				wr_subGrpNames = wr_grpNames[i_wr_grp]
				for i_name in range(0, len(wrAddrs_ofGrp)):
					waddrPortName = wrAddrs_ofGrp[i_name]
					hasAddr = (waddrPortName != self.HDL_NONEADDR)
					waddrName = self.Gen_portName(waddrPortName,\
										self.stage_names[i_wr_stage])
					# maybe mulitple sub group in wr_subGrpNames
					wr_grpName = wr_subGrpNames[iStage_ofGrp]
					# turn to next groupName
					iStage_ofGrp += nStage_OfGrp
					ififNum = 0
					grpCodes = []
					# search all rhe read_group
					for i_rd_grp in range(len(srcNames)):
						rd_grpName = rd_grpNames[i_rd_grp]
						raddrPortName = rdAddrs[i_rd_grp]
						raddrName = self.Gen_portName(raddrPortName,\
							self.stage_names[i_rd_stage])
						oneGrpCode = pre + "\t"
						selValid = True
						addrValid = True
						#	[else]if ()
						#			if
						# or
						#	[else]if ()
						#			else if
						if ififNum:
							oneGrpCode += "else "
						oneGrpCode += "if ( "
						# condExp is the expression we want to record for stalling
						condExp = rd_grpName
						# if need to check the addr
						if hasAddr:
							condExp += " && ( %s == %s )" % (waddrName, raddrName)
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# # # # # # # # # # # # # # # Optimal # # # # # # # # # # # # # # # #
							addrValid = self.RdAndWrAddr_isValid(raddrName, waddrName)
						oneGrpCode += "%s ) begin\n" % (condExp)
						oneGrpCode += pre + "\t"*2 + "%s = %d'd%d;\n" % (ctrlPortName, width, i_sel)
						oneGrpCode += pre + "\t" + "end\n"
						if i_sel<0:
							selValid = False
							condExp = "%s && %s" % (wr_grpName, condExp)
							# if addrValid is false means it's a invalid stall condition
							if addrValid:
								self.stallCond_ofStages[i_rd_stage].append(condExp)
						# if there's no stall and rd&wr addr is valid, then we append
						if selValid and addrValid:
							grpCodes.append(oneGrpCode)
							if hasAddr:
								self.hazardAddrs[i_rd_stage].append(raddrPortName)
								self.hazardAddrs[i_wr_stage].append(waddrPortName)
					# if there's more than 1 always block in the list, then we add to ret code
					if len(grpCodes)>0:	
						ret += pre
						if ifNum:
							ret += "else "
						ret += "if ( %s ) begin\n" % (wr_grpName)
						ifNum += 1
						ret += "".join(grpCodes)
					
						# This else is for rd_grps
						ret += pre + "\t" + "else begin\n"
						ret += pre + "\t"*2 + "%s = %d'd0;\n" % (ctrlPortName, width)
						ret += pre + "\t" + "end\n"
						ret += pre + "end\n"
			# Add else
			# this else is for wr_grps
			if ifNum:
				ret += pre + "else begin\n"
				ret += pre + "\t%s = %d'd0;\n" % (ctrlPortName, width)
				ret += pre + "end\n"
			else:
				ret += pre + "\t%s = %d'd0;\n" % (ctrlPortName, width)
			
		ret += opre + "end // end always\n\n"
		print "bypass always\n"
		print ret
		
		return ret
		
	# @function: classify insn into smaller group with common addrName
	# @param:
	#	portName: name of the readPort
	#	Instrs: large groups of insn
	#	i_stage: index of stage for portName
	#	addrName: raddr or waddr
	def Gen_classifyInstr_grp(self, portName, Instrs, i_stage, addrName):
		ret_Instr_subGrp = {}
		# SPR.LRWd is an exception
		tmpAddr = self.classify_Exception(portName)
		if tmpAddr != NULL:
			return {tmpAddr:Instrs}
		# print "here to classify\n"
		moduleName = portName.split('.', 1)[0]
		if not self.Module_is_aRdandWr(moduleName):
			# print "%s no Rd & Wr"  % (moduleName)
			return ret_Instr_subGrp
		# print "instrs =", Instrs	
		matchObj = self.re_portAddr.match(portName)
		suffix = matchObj.group(1) if matchObj else NULL
		addrPort = moduleName + "." + addrName + suffix
		# print "portName = %s, addrPort = %s\n" % (portName, addrPort)
		# waddrPort = moduleName + ".waddr"
		for instrName in Instrs:
			rep_instrName = instrName.replace('.', '_')
			if rep_instrName in self.addrOfInstrs:
				if addrPort in self.addrOfInstrs[rep_instrName]:
					(stage, srcName) =  self.addrOfInstrs[rep_instrName][addrPort]
					if srcName not in ret_Instr_subGrp:
						ret_Instr_subGrp[srcName] = []
						ret_Instr_subGrp[srcName].append(instrName)
					"""
					if stage == i_stage:
						if srcName not in ret_Instr_subGrp:
							ret_Instr_subGrp[srcName] = []
						print "I'm in the right palce"
						ret_Instr_subGrp[srcName].append(instrName)
					else:
						self.ErrRobot.Add_aError(self.ErrRobot.NO_ADDR, portName,\
									instrName+"_"+self.stage_names[i_stage]+" in "+addrPort)
					"""	
				else:
					self.ErrRobot.Add_aError(self.ErrRobot.NO_ADDR, portName, "["+instrName+"] in "+addrPort)
			else:
				print "%s not in self.addrOfInstrs" % (rep_instrName)
		# print "////****\n",ret_Instr_subGrp
		return ret_Instr_subGrp
	
	def classify_Exception(self, portName):
		if portName == "SPR.LRWd":
			return "`LR_SPRN"
		return NULL
	
	# @function: check the module needs write port and read port at the same time
	# @param:
	#	moduleName: name of the module
	def Module_is_aRdandWr(self, moduleName):
		# print "%s is checking RD & Wr" % (moduleName)
		# in this function we can use cache to make it faster
		if moduleName in self.module_is_aRdWr:
			return self.module_is_aRdWr[moduleName]
		portConnects = self.modules[moduleName]
		Rd = False
		Wr = False
		Rd_pre = self.HDL_RADDR
		Wr_pre = self.HDL_WADDR
		for pname in portConnects:
			if not Rd:
				Rd = pname.startswith(Rd_pre)
			if not Wr:
				Wr = pname.startswith(Wr_pre)
		# print "Rd_flag =", Rd, "Wr_flag =", Wr
		self.module_is_aRdWr[moduleName] = Rd and Wr
		return Rd and Wr
	
	# @function: check if the raddrName and waddrName is valid opposite
	# @param:
	#	raddrName: name of the raddr
	#	waddrName: name of the waddr
	def RdAndWrAddr_isValid(self, raddrName, waddrName):
		if raddrName[0]=='`' and waddrName[0]=='`':
			return raddrName == waddrName
		return True
		
	# @function: generate the Sub Instr group assignment code
	def Gen_InstrGrpAssignCode(self, Instr_grp, i_stage, desName):
		# print "assingCode Instr_grp =", Instr_grp
		ret = ""
		ret += self.HDL_ASSIGN + " " + desName + " = "
		opcd = self.HDL_OPCD + "_" + self.stage_names[i_stage]
		xo = self.HDL_XO + "_" + self.stage_names[i_stage]
		exps = []
		for instrName in Instr_grp:
			uinstrName = instrName.replace('.', '_').upper()
			exp = opcd + " == `" + uinstrName + "_OPCD"
			if self.Instr_is_aSpecial(instrName):
				exp += " && " + xo + " == `" + uinstrName + "_XO"
			exps.append('( ' + exp + ' )')
		# current stage mustn't be flushed
		ret += "( ~" + self.HDL_FLUSH + "_" + self.stage_names[i_stage] + " ) && "
		ret += "( " + " || ".join(exps) + " )"
		return ret
		
	# @function: print the title of the hazard Array
	# @param:
	#	readPortName: name of the read port which has a hazard
	#	readInstr_grp: the group of reading instructions
	#	writeInstr_grp: the group of writing instructions
	#	min_readStage: current min read Stage, just for print format
	def Print_HazardArrayTitle(self, readPortName, readInstr_grp, writeInstr_grp, min_readStage):
		writePortNames = self.hazardCouples[readPortName]
		n_row = len(readInstr_grp)
		n_col = len(writeInstr_grp)
		
		# print the overall title
		# print readPortName,"    <->    ", self.hazardCouples[readPortName]
		# print

		## for debug
		for writePortName in writePortNames:
			print writePortName
			for key in self.write_rtb[writePortName]:
				print key
		print
		
		# print the read group information
		for i in range(n_row):
			print self.RD_GROUP_PRE+str(i)+":", readInstr_grp[i]
		print
		
		# print the write group information
		for i in range(len(writeInstr_grp)):
			print self.WR_GROUP_PRE+str(i)+":", writeInstr_grp[i]
		print
		
		# print the 1st row title
		info = []
		pre = " "*20
		title = ""
		for writePortName in writePortNames:
			sub_title = self.PATTERN % writePortName
			title += sub_title*len(self.write_rtb[writePortName])
		info.append(pre+title)
	
		# print the 2nd row title
		sub_title = ""
		for i in range(n_col):
			sub_title += self.PATTERN % ("wr_grp_"+str(i))
		title = sub_title
		info.append(pre+title)
		
		# print the 3rd row title
		sub_title = ""
		for i in range(min_readStage+1, self.stage_num):
			sub_title += self.SUBPATTERN % self.stage_names[i]
		sub_title = self.PATTERN % sub_title
		title = sub_title*n_col
		info.append(pre+title)
		
		print "\n".join(info)
	
	# @function: Generate the Byasspass Array
	# @param:
	#	readPortName: the name of the read port
	#	readStage_grp: the stage indexes of the read port
	def Handle_HazardArrayItem(self, readPortName, readStage_grp, min_readStage, tabn):
		writePortNames = self.hazardCouples[readPortName]
		n_row = len(readStage_grp)
		
		# print the write data index
		write_data = []
		printInfo = []
		
		# ret bypass Select
		ret_bypassArrayItem = []
		
		# print the hazard
		for i_grp in range(n_row):
			i_stage = readStage_grp[i_grp]
			# Format: groupName readPortName stageName
			title = self.RD_GROUP_PRE+str(i_grp)+"  "+readPortName+"  "+self.stage_names[i_stage]
			line = "%20s" % (title)
			# bypassMux_srcs contain the write data which current bypass mux realy needs
			bypassMux_srcs = [readPortName]
			# bypassMux_srcs_Stage contain the stage number of all the data in bypassMux_srcs
			bypassMux_srcs_Stage = [i_stage]
			bypassArrayItem = {}
			writeInstr_grpIndex = 0
			for writePortName in writePortNames:
				for key in self.write_rtb[writePortName]:
					writeDataName = key[0]
					# print "writeDataName = ",writeDataName
					# we add some select Item in this ditc()
					bypassArrayItem[writeInstr_grpIndex] = []
					# we must ignore the last stage, because any data should valid after a REG
					if writeDataName in self.specialPorts:
						stages = key[1:]
					else:
						stages = key[1:-1]
					sub_title = ""
					# ignore the stage before current stage(i_stage)
					for i in range(max(i_stage, min_readStage)+1, self.stage_num):
						### All about generate the Hazard Array
						if i in stages:
							data = writeDataName+"_"+self.stage_names[i]
							# 0 index always the original write data
							if data not in write_data:
								write_data.append(data)
								bypassSel = len(write_data)
							else:
								bypassSel = write_data.index(data) + 1
							bypassMux_srcs.append(writeDataName)
							bypassMux_srcs_Stage.append(i)
						else:
							bypassSel = -1
						sub_title += self.SUBPATTERN % str(bypassSel)
						### All about the Bypass Select Control Code 
						# bypass select all starts from 1, because 0 means no need for bypass
						bypassArrayItem[writeInstr_grpIndex].append((i, bypassSel))
					line += self.PATTERN % sub_title
					writeInstr_grpIndex += 1
			ret_bypassArrayItem.append(bypassArrayItem)	
				
			self.BypassMuxCode[i_stage] += self.Gen_OneBypassMuxCode(bypassMux_srcs, bypassMux_srcs_Stage, tabn)
			printInfo.append(line)
		
		writeData = "\n"	
		# Print the write data
		for i in range(len(write_data)):
			writeData += ("%2s" % str(i+1))+": "+write_data[i]+" "
		writeData += "\n"
		
		#self.Print_HazardArrayTitle(readPortName, readInstr_grp, writeInstr_grp, min_readStage)
		
		# print the array info
		arrayInfo = "\n".join(printInfo)
		
		return (writeData, arrayInfo, ret_bypassArrayItem)
	
	# @function: Generate Only One Byasspass Mux Code
	# @param:
	#	bypassMux_srcs: the write data list which current stage read port really need
	#					bypassMux_srcs[0] is the name of the read port
	#	bypassMux_srcs_Stage: the stage index of data in bypassMux_srcs
	#	tabn: num of the TAB
	def Gen_OneBypassMuxCode(self, bypassMux_srcs, bypassMux_srcs_Stage, tabn):
		ret = ""
		stages = bypassMux_srcs_Stage
		readPortName = self.Gen_portName(bypassMux_srcs[0], self.stage_names[stages[0]])
		# if only one source in bypassMux_srcs, means no hazard
		if len(bypassMux_srcs)<2:
			return ret
		# if it really needs byPass
		# add the srcPortName and its stage to BypassPorts
		#	Because we need to replace it with original ports
		self.BypassPorts.append( (bypassMux_srcs[0], stages[0]) )
		
		muxn = self.Cal_Muxn(len(bypassMux_srcs))
		
		# add the bypass mux utilization statement
		ret += "\t"*tabn;
		ret += "mux" + str(muxn) + " #() "; 
		mname = readPortName.replace('.', '_')
		ret += "U_" + mname + "_mux" + str(muxn) + " ("
		for i in range(len(bypassMux_srcs)):
			if (i&3) == 0:
				ret += "\n" + "\t"*(tabn+1)	
			# bypassMux_srcs has already has the 
			ret += ".d" + str(i) + "(" \
				+ self.Gen_portName(bypassMux_srcs[i], self.stage_names[stages[i]]) \
				+ "), "
		i += 1
		while i<muxn:
			ret += ".d" + str(i) + "(" + self.MUX_D_DEFAULT + "), "
			i += 1
		if muxn>2:
			ret += "\n" + "\t"*(tabn+1)
		ret += ".s(" + mname + self.MUX_SEL +"), "
		ret += ".y(" + mname + self.BYPASS_SUFFIX +")\n"
		ret += "\t"*tabn + ");\n\n";
		
		# add the mux selports into self.BypassSelPorts[]
		i_stage = stages[0]
		selPortName = "%s%s" % (mname, self.MUX_SEL)
		selPortwidth = "[0:%d]" % (LOGS2[muxn])
		self.BypassSelPorts[i_stage].append((selPortName, selPortwidth))
		return ret
			
	# @function: gen the hazard array with specific Read Port
	# @param:
	#	readPortName: name of read port
	def Gen_OneHazardArray_ReadPort(self, readPortName):
		# ret = [dict(String => list()), dict(String => list())]
		ret = []
		for writePortName in self.write_rtb:
			# print readPortName,"    ?    ",writePortName
			if self.is_aHazard(readPortName, writePortName):
				# print readPortName,"    <->    ",writePortName
				# print "self.write_rtb[writePortName] =",self.write_rtb[writePortName]
				ret.append(writePortName)
				# for lists in self.write_rtb[writePortName]:
					# print lists
					# print self.write_rtb[writePortName][lists]	
				# print "\n"
		return ret
		
	# @function: get all the rtl information for all instructions
	def Get_All_RTLs(self):
		for i in range(self.instrs_num):
			(instr_name, s_row) = self.instrs_boundry[i][0:2]
			t_row = self.instrs_boundry[i+1][1]
			self.instrs_RTLs[instr_name] = self.Get_One_RTLs(s_row, t_row)
	
	# @function: get rtl information of Only one instruction
	# @param:
	# 	s_row: start of the row to this instruction
	#	t_row: end of the row for this instruction
	def Get_One_RTLs(self, s_row, t_row):
		rtls = []
		for i_col in range(self.s_col+1, self.AE.Get_NCol()):
			# here, we erase all the space to make port UNIQUE, UNIQUE is the most import thing in this tool
			rtls.append([self.Erase_Space(rtl) for rtl in self.AE.Get_OneCol(i_col, s_row, t_row)])
		return rtls
	
	# @function: get the Read & Write data trace, from back to the front
	# @param:
	def Get_All_DataTrace(self, rd_ports, o_stage):
		self.Set_ReadPorts(rd_ports, o_stage)
		for instr in self.instrs_RTLs:
			# WDatas & RDatas are all dictionaries
			(WDatas, RDatas) = self.Get_One_DataTrace(instr)
			for portname in WDatas:
				if portname not in self.write_rtb:
					self.write_rtb[portname] = {}
				src_list = tuple(WDatas[portname])
				if src_list not in self.write_rtb[portname]:
					self.write_rtb[portname][src_list] = []
				self.write_rtb[portname][src_list].append(instr)
			for src in RDatas:
				# print portnames
				if src not in self.read_rtb:
					self.read_rtb[src] = {}
				for stage in RDatas[src]:
					# pay attention to here, stage must later than the output stage
					if stage < self.read_ports[src]:
						stage = self.read_ports[src]
					if stage not in self.read_rtb[src]:
						self.read_rtb[src][stage] = []
					self.read_rtb[src][stage].append(instr)
				
	# @function: get the Read & Write data trace of Only One instruction
	# @param:
	#	instr_name: use it as key to get the rtl information
	# @return:
	#	(dictionary(), array())
	def Get_One_DataTrace(self, instr_name):
		# store the srouce port for the write data
		wt_src_ports = {}	# string => [string, 0..n]
		# all ports use nesting list to differ stages
		rd_ports = {}
		# print instr_name
		# We need to ASSUME write back is the last stage
		# handle write-back stage first, then scanning all other rtls in other stages in reverse order
		for i in range(self.wb_stage, -1, -1):
			for rtl in self.instrs_RTLs[instr_name][i]:
				if rtl == NULL:
					continue
				# stage_connects is a SET(), use add() not append()
				(src, des) = self.Split_Connects(rtl)[0:2];
				# des is not NULL means it's a Connect
				if self.RTL_is_aConnect(src, des):
					if "Wd" in des and i==self.wb_stage:
						wt_src_ports[des] = [src, self.wb_stage]				
					# handle the '?:' condition
					if self.COND_FLAG in src:
						srces = self.Gen_CondExp(src)
					else:
						srces = [src]
					for src in srces:
						if self.is_aReadPort(src):
							readPortName = src.split('[')[0]
							if readPortName not in rd_ports:
								rd_ports[readPortName] = []
							rd_ports[readPortName].append(i)
					self.stage_connects[i].add(rtl)
				elif self.RTL_is_aFlow(src, des):
					# means it's a Flow, and no need to use the rtl expression
					self.Flows[i].add(src)
					for des in wt_src_ports:
						if src == wt_src_ports[des][0]:
							wt_src_ports[des].append(i)
		return (wt_src_ports, rd_ports)
	
	# @function: get the ctrl code of all stages
	# @param:
	#	tabn: num of TAB
	def Gen_AllStageCtrlCode(self, tabn=1):
		ret = ""
		pre = "\t" * tabn
		for i_stage in range(self.stage_num):
			ret += pre + "/*****    %s    *****/\n" % (self.stage_names[i_stage])
			ret += self.Gen_OneStageCtrlCode(i_stage, tabn)
		return ret
	
	# @function: get the ctrl code of one stage
	# @param
	#	i_stage: index of stage
	#	tabn: num of TAB
	def Gen_OneStageCtrlCode(self, i_stage, tabn):
		alwaysCode = ""
		# if current stage has no control port then return NULL
		if len(self.Controls[i_stage])==0:
			return "\n"
		opcd = self.Gen_portName(self.HDL_OPCD, self.stage_names[i_stage])
		xo = self.Gen_portName(self.HDL_XO, self.stage_names[i_stage])
		pre = "\t" * tabn
		ttabn = tabn+1
		ppre = pre + "\t"
		# Add always @
		alwaysCode += pre + "always @( * ) begin\n"
		# Add if ~flush
		alwaysCode += ppre + "if ( ~%s ) begin\n" % (self.flushPorts[i_stage])
		# Add case (opcd_?)
		alwaysCode += ppre + '\tcase ( ' + opcd + ' )\n'
		## code generated by normal instrcution
		ncode = ""
		## code generated by special instrcution
		scode = [[] for i in range(len(self.instrs_sgp))]
		for i in range( len(self.instrs_boundry)-1 ):
			(instr, f_row) = self.instrs_boundry[i]
			t_row = self.instrs_boundry[i+1][1]
			uinstr = instr.upper()
			if uinstr+'_OPCD' in self.instrs_ngp:
				pcode = self.Gen_OneInstrCtrlCode(instr, i_stage, f_row, t_row, ttabn+2)
				ncode += pcode
			else:
				pcode = self.Gen_OneInstrCtrlCode(instr, i_stage, f_row, t_row, ttabn+4)
				hasFound = False
				for j in range( len(self.instrs_sgp) ):
					sublst = self.instrs_sgp[j]
					if uinstr+'_OPCD' in sublst:
						hasFound = True
						scode[j].append(pcode)
						break
				if hasFound == False:
					print instr + " not found."
		# Add the normal code
		alwaysCode += ncode
		# Add the special code(not only one)
		for i in range( len(scode) ):
			## Add the case code
			alwaysCode += '\t'*(ttabn+2) + self.instrs_sgp[i][0] + ': begin\n'
			# Add case (xo_?)
			alwaysCode += '\t'*(ttabn+3) + 'case ( ' + xo + ' )\n'
			for subcode in scode[i]:
				alwaysCode += subcode
			## Add the default & endcase
			alwaysCode += self.Gen_ControlDefault(i_stage, ttabn+4)
			alwaysCode += '\t'*(ttabn+3) + 'endcase\n'
			alwaysCode += '\t'*(ttabn+2) + 'end\n';
		# Add Main default & endcase
		alwaysCode += self.Gen_ControlDefault(i_stage, ttabn+2)
		alwaysCode += ppre + "\tendcase\n"
		alwaysCode += ppre + "end\n"
		# Add the end for no flush
		alwaysCode += ppre + "else begin\n"
		alwaysCode += self.Gen_ControlElseCode(i_stage, ttabn+1)
		alwaysCode += ppre + "end\n"
		# Add the fulsh condition
		alwaysCode += pre + "end // end always\n\n"
		return alwaysCode
	
	# @function: get the ctrl code of one instr
	# @param
	#	instr: name of the instr
	#	i_stage: index of stage
	#	f_row: from this row
	#	t_row: to this row
	#	tabn: num of TAB	
	def Gen_OneInstrCtrlCode(self, instr, i_stage, f_row, t_row, tabn):
		# print instr
		ret = ""
		# we need to record some addrs Each Insn such like raddr or waddr.
		instrAddrs = {}
		# add '`XXX_OPCD: '
		ret += '\t'*tabn + self.Gen_InstrHDLExp(instr) + ": "
		# add 'begin'
		ret += 'begin\n'
		# add control-signal
		## Read all RTL about this Instruction
		base_col = self.s_col + 1
		f_col = base_col + i_stage
		t_col = f_col + 1
		cells = self.AE.Get_OneBlock(f_row, t_row, f_col, t_col)
		setControls = []
		controls = self.Controls[i_stage]
		## Add all contols
		pre = "\t"*(tabn+1)
		for item in cells:
			exp = self.Erase_Space(item)
			if '->' in exp:
				(srcName, desName) = exp.split('->')[0:2]
				# if its aAddr like raddr, waddr, we need to record for hazardBypass
				if self.Port_is_aAddr(desName):
					instrAddrs[desName] = (i_stage, srcName)
				# if is aControl like Op, Wr...
				if desName in controls:
					portName = self.Gen_portName(desName, self.stage_names[i_stage])
					if self.is_aControl(desName):
						setControls.append(desName)
						srcName = self.Gen_portName(srcName, self.stage_names[i_stage])
					# if is a src of Mux
					else:
						# add address_sel port into instrControl
						portName += self.MUX_SEL
						width = controls[desName]
						if self.COND_FLAG in srcName:
							index_condFlag = srcName.index(self.COND_FLAG)
							preName = self.Gen_portName(srcName[:index_condFlag],\
												self.stage_names[i_stage])
							srcName = preName + srcName[index_condFlag:]
						srcName = self.ReplaceExp_withIndexOfMux(desName, i_stage, srcName, width)
						# assign new value to this signal
						setControls.append(desName)
					ret	+= pre + portName + ' = ';
					ret += srcName + ';\n'
					
		for portName in controls:
			if portName not in setControls:
				pname = self.Gen_portName(portName, self.stage_names[i_stage])
				if controls[portName] > 1:
					pname += self.MUX_SEL
				ret	+= pre + pname + ' = ';
				# if NOT SET then use default val(0).
				ret += str(controls[portName]) + "'d0"
				ret += ';\n'
		# add 'end'
		ret += '\t'*tabn + 'end\n'
		
		# add instrControls to self.addrOfInstrs
		# print "add instrControls to self.addrOfInstrs"
		# print instr
		if instr not in self.addrOfInstrs:
			self.addrOfInstrs[instr] = {}
		for desName in instrAddrs:
			self.addrOfInstrs[instr][desName] = instrAddrs[desName]
		
		return ret
	
	# @function: replace expression with index of Mux
	# @param:
	#	portName: name of the destination port
	#	i_stage: index of stage
	#	srcExp:	source rtl expression waiting for replace
	#	width: width of the select port of Mux
	def ReplaceExp_withIndexOfMux(self, portName, i_stage, srcExp, width):
		srcs = list(self.Connects[i_stage][portName])		
		if srcExp in srcs:
			index = srcs.index(srcExp)
			return str(width) + '\'d' + str(index)
		# _match = False
		def muxMatch(matchobj):
			# global _match
			# _match = True
			if matchobj.group(0) in srcs:
				index = srcs.index(matchobj.group(0))
				return str(width) + '\'d' + str(index)
			else:
				return matchobj.group(0)
		replaceExp = self.re_rtlCond.sub(muxMatch, srcExp)
		return replaceExp
		# if _match:
			# return replaceExp
		# else:
			# if srcExp in srcs:
				# index = srcs.index(srcExp)
				# return str(width) + '\'d' + str(index)
			# else:
				# self.ErrRobot.Add_aError(self.ErrRobot.MUX_MISS,\
					# portName, srcExp)
				# return replaceExp
		
	# @function: generate the default hdl code in some stage
	# @param:
	#	i_stage: index of stage
	#	tabn: num of TAB
	def Gen_ControlDefault(self, i_stage, tabn):
		ret = ""
		portNames = self.Controls[i_stage]
		ret += '\t'*tabn + 'default: begin\n'
		ret += self.Gen_ControlElseCode(i_stage, tabn+1)
		ret += '\t'*tabn + 'end\n'
		return ret
		
	# @function: generate the else hdl code in some stage
	# @param:
	#	i_stage: index of stage
	#	tabn: num of TAB
	def Gen_ControlElseCode(self, i_stage, tabn):
		ret = ""
		portNames = self.Controls[i_stage]
		pre = '\t' * tabn
		for portName in portNames:
			pname = self.Gen_portName(portName, self.stage_names[i_stage])
			if portNames[portName]>1:
				pname += self.MUX_SEL
			ret += pre + pname + ' = 0;\n'
		return ret
		
	# @function: get the opcode form the instruction define file
	# @param:
	#	fname: name ot the define file
	# @note:
	#	A blank line is necessary between OPCD and XO.
	def Get_OpFromInstrDef(self, fname):
		fin = open(self.work_path+fname, "r")
		flg = False
		tb = {}
		for line in fin:
			if flg == False:
				if line.startswith(self.HDL_DEFINE):
					flg = True
				else:
					continue
			if not line.startswith(self.HDL_DEFINE):
				break
			(opcd, val) = self.Get_WordInString(line[len(self.HDL_DEFINE):])[:2]
			if val in tb.keys():
			  tb[val].append(opcd)
			else:
			  tb[val] = [opcd]
		fin.close()
		return tb
	
	# @function: generate the groups from the instructions
	# @param:
	#	tb: table of instruction-opcd
	def Gen_InstrGroups(self, tb):
		self.instrs_ngp = []
		self.instrs_sgp = []
		for key in tb.keys():
			lst = tb[key]
			if len(lst) == 1:
				self.instrs_ngp.append(lst[0])
			else:
				lst.insert(0, key)
				self.instrs_sgp.append(lst)
	
	# @function: Merge all stages control port
	def Merge_AllCtrlPorts(self):
		self.Controls = [{} for i in range(self.stage_num)]
		for i_stage in range(self.stage_num):
			self.Merge_aStageCtrlPort(i_stage)
	
	# @function: Merge one stage control port
	# @param:
	#	i_stage: index of the stage
	# @note:
	#	some mux stores the desName and width insteads of select port
	def Merge_aStageCtrlPort(self, i_stage):
		connects = self.Connects[i_stage]
		for pname in connects:
			# if it's a control signal
			if self.is_aControl(pname):
				# pname = self.Gen_portName(pname, self.stage_names[i_stage])
				self.Controls[i_stage][pname] = 1
			# if it's a MUX(SEL)	
			elif len(connects[pname])>1:
				# pname = self.Gen_portName(pname, self.stage_names[i_stage])\
							# + self.MUX_SEL
				width = self.Cal_Muxn(len(connects[pname]))
				self.Controls[i_stage][pname] = width
	
	# @function: Check if the rtl is a Connect
	# @Logic: if is a Connect then 
	#				return TRUE
	#			else
	#				return FALSE
	def RTL_is_aConnect(self, src, des):
		return des != NULL

	# @function: Check if the rtl is a Flow
	# @Logic: if is a Flow then 
	#				return TRUE
	#			else
	#				return FALSE		
	def RTL_is_aFlow(self, src, des):
		return des == NULL and src != NULL
	
	# @function: check if the portName is a Flow
	# @param:
	#	portName: name of the port
	def Port_is_aFlow(self, portName, i_stage):
		if portName[0]=='#':
			portName = portName[1:]
		# split from the "["
		portName = portName.split("[")[0]
		for i in range(0, i_stage):
			if portName in self.Flows[i]:
				return True
		return False
		
	# @function: check if the portName is in a pipe
	# @param:
	#	portName: name of the port
	def Port_is_aPipe(self, portName, i_stage):
		if i_stage<1:
			return False
		# print "check portName =", portName, ", stage =", self.stage_names[i_stage]
		if portName[0]=='#':
			portName = portName[1:]
		# split from the "["
		portName = portName.split("[")[0]
		return portName in self.Flows[i_stage-1]
	
	# @function: check if the portName is a mux (for ctrlHDLCode)
	# @param:
	#	portName: name of the port
	#	i_stage: index of stage
	def Port_is_aMux(self, portName, i_stage):
		return portName in self.Controls[i_stage]
	
	# @function: check if the portName is a address
	# @param:
	#	portName: name of the port
	def Port_is_aAddr(self, portName):
		return self.RTL_ADDR in portName
	
	# @function: check if the Instr is a special Instruction
	# @param:
	#	instrName: name of the instr
	def Instr_is_aSpecial(self, instrName):
		instr = instrName.replace('.', '_').upper() + "_OPCD"
		# print instr
		# print "we're in instr_is_aSpecial"
		for sublist in self.instrs_sgp:
			# print "self.instrs_sgp sublist =", sublist
			if instr in sublist:
				return True
		return False
	
	# @function: check the portName is a read port
	def is_aReadPort(self, portName):
		if '.' in portName:
			portName = portName.split('[')[0]
			# (ModuleName, portName) = portName.split('.')[0:2]
			# if ModuleName == portName:
				# return True
			for item in self.read_ports:
				if item in portName:
					return True
		return False

	# @function: check the portName is a write port
	def is_aWritePort(self, portName):
		for item in self.write_ports:
			if item in portName:
				return True
		return False
		
	# @function: check the readPort hazard with writePort
	# @param:
	#	readPortName: name of the read port, it already is a read Port
	#	writePortName: name of the write port, it already is a write Port
	def is_aHazard(self, readPortName, writePortName):
		return self.Get_ModuleName(readPortName) == self.Get_ModuleName(writePortName)
			
	# @function: Rename the portname, cat with stage_name
	# @param:
	#	portname: name of some port
	#	i_stage: index of stage
	def Gen_Rename(self, portname, i_stage):
		return portname+"_"+self.stage_names[i_stage]
	
	# @function: Get the Module Name
	# @param:
	#	portName: name of the port
	def Get_ModuleName(self, portName):
		return portName.split('.')[0:1]
		
	# @function: split the connects
	#	@Logic: if des is not NULL then means a Connect
	#			if src is not NULL then means a Flow
	# @param:
	#	rtl: one RTL line
	def Split_Connects(self, rtl):
		if rtl == NULL:
			return [NULL]*2
		if '->' in rtl:
			return rtl.split("->")[0:2]
		elif '>>' in rtl:
			return [rtl.split(">>")[0], NULL]
		else:
			return [NULL]*2
	
	# @function: Generate HDL code of All Stage
	# @param:
	# 	tabn: num of TAB
	def Gen_AllStage_MuxCode(self, tabn=1):
		self.MuxCode = []
		for i_stage in range(self.stage_num):
			self.MuxCode.append(self.Gen_OneStage_MuxCode(i_stage, tabn));
		
	# @function: Generate HDL code of One Stage
	# @param:
	#	i_stage: index all stages
	# 	tabn: num of TAB
	def Gen_OneStage_MuxCode(self, i_stage, tabn):
		ret = ""
		for des in self.Connects[i_stage]:
			ret += self.Gen_OnePort_MuxCode(i_stage, des, tabn)
		return ret
		
	# @function: Generate HDL code of One MUX
	# @param:
	#	i_stage: index all stages
	#	des: name of destination port
	# 	tabn: num of TAB
	def Gen_OnePort_MuxCode(self, i_stage, desPort, tabn):
		srcs = list(self.Connects[i_stage][desPort])
		srcn = len(srcs)
		stage_suffix = self.stage_names[i_stage]
		# Multi Source you need to use MUX with select
		ret = ""
		if not self.is_aMux(srcn, desPort):
			return NULL
		muxn = self.Cal_Muxn(srcn)
		# add module name
		ret += "\t"*tabn + "mux" + str(muxn)
		# add parameter, the value need to fill in by human being
		ret += " #() "
		# add utilize name
		ret += "U_"
		uname = self.Gen_portName(desPort, stage_suffix)
		ret += uname + "_mux" + str(muxn)
		# add '(' and '\n'
		ret += " ("
		# add parameter
		for i in range(srcn):
			if (i&3) == 0:
				ret += "\n" + "\t"*(tabn + 1)
			dname = self.Gen_portName(srcs[i], stage_suffix)
			if self.is_aBypass(srcs[i], i_stage):
				dname += self.BYPASS_SUFFIX
			ret += ".d" + str(i) + "(" + dname + "), "
		i = srcn
		# Add the default value
		while i < muxn:
			if (i&3) == 0:
				ret += "\n" + "\t"*(tabn + 1)
			ret += ".d" + str(i) + "(" + self.MUX_D_DEFAULT + "), "
			i += 1
		# add select
		ret += "\n" + "\t"*(tabn + 1) + ".s(" + uname + self.MUX_SEL + "), "
		# add output
		ret += ".y("+uname+")"
		# add ");"
		ret += "\n" + "\t"*tabn + ");\n\n"
		return ret
	
	# @function: Generate All stages Muxes
	# @param:
	#	None
	# @note:
	#	self.Connects: [dict(IF), dict(ID), ..., dict(WB)],
	#					dict(): {des1:[src1,..., srcX], ..., desX:[src1,..., srcX]}
	def Gen_AllStage_Muxes(self):
		self.Connects = [{} for i in range(self.stage_num)] 
		for i_stage in range(self.stage_num):
			self.Gen_OneStage_Muxes(i_stage)
	
	# @function: Generate Muxes of ONE STAGE
	# @param:
	#	i_stage: index of stage
	def Gen_OneStage_Muxes(self, i_stage):
		retMuxes = self.Connects[i_stage]
		for instrName in self.AllInstr_Connects:
			try:
				for (src, des) in self.AllInstr_Connects[instrName][i_stage]:
					if des not in retMuxes:
						retMuxes[des] = set()	
					if self.COND_FLAG in src:
						srces = self.Gen_CondExp(src)
						for src in srces:
							retMuxes[des].add(src)
					else:
						retMuxes[des].add(src)
			except TypeError:
				self.ErrBobot.Add_aError(self.PROGRAM_BUG)
		
	# @function: Get rtl connects of ALL INSTR
	# @param:
	#	instrName: name of instruction
	# @note:
	#	self.AllInstr_Connects: dict(), 
	#						 { 
	#							instrName1: [[connects_IF], [connects_ID], ..., [connects_WB]],
	#							instrName2: [[connects_IF], [connects_ID], ..., [connects_WB]],
	#							instrName3: [[connects_IF], [connects_ID], ..., [connects_WB]],
	#											......
	#							instrNameX: [[connects_IF], [connects_ID], ..., [connects_WB]]
	#						 }
	def Get_AllInstr_Connects(self):
		self.AllInstr_Connects = {}
		for instrName in self.instrs_RTLs:
			self.AllInstr_Connects[instrName] = self.Get_OneInstr_Connects(instrName)
		
	# @function: Get rtl connects of ONE INSTR
	# @param:
	#	instrName: name of instruction
	# @return:
	#	retConnects: list(), [[connects_IF], [connects_ID], ..., [connects_WB]]
	def Get_OneInstr_Connects(self, instrName):
		retConnects = []
		for rtls in self.instrs_RTLs[instrName]:
			retConnects.append(self.Get_OneStage_Connects(instrName, rtls))
		return retConnects
		
	# @function: Get rtl connects in ONE STAGE of ONE INSTR
	# @param:
	#	instrName: name of instruction
	#	rtls: rtls of current
	# @return:
	#	retConnects: List(), [(src1, des1), ... (srcX, desX)]
	def Get_OneStage_Connects(self, instrName, rtls):
		retConnects = []
		dess = set()
		for rtl in rtls:
			# rtl = self.Erase_Space(rtl)
			if '->' in rtl:
				(src, des) = rtl.split('->')[0:2]
				# We don't need the inner connection.
				if not self.is_SameModule(src, des):
					if des not in dess:
						retConnects.append((src, des))
						dess.add(des)
					else:
						self.ErrRobot.Add_aError(self.ErrRobot.MULTISRC_INTO_ONEDES, instrName, rtl)
		return retConnects
	
	# @function: Generate the Condtion Expression from the rtl 
	# @param:
	#	Exp: the expression contain condition flag "?"
	def Gen_CondExp(self, Exp):
		if Exp[0] == '(':
			Exp = Exp[1:len(Exp)]
		if Exp[len(Exp)-1] == ')':
			Exp = Exp[0:len(Exp)-1]
		ques_pos = Exp.find('?')
		if ques_pos < 0:
			return [Exp]
		i = ques_pos + 1
		length = len(Exp)
		beg = i
		ques_num = 0
		while True:
			if ques_num==0 and Exp[i]==':':
			  break
			if Exp[i] == '?':
			  ques_num += 1
			if Exp[i] == ':':
			  ques_num -= 1
			i += 1
		# val1, before colon
		subl1 = self.Gen_CondExp(Exp[beg:i])
		# val2, after colon
		subl2 = self.Gen_CondExp(Exp[i+1:len(Exp)])
		return subl1 + subl2
	
	# @function: get all words (not space)
	# @param:
	#	strLine: one line of string.
	def Get_WordInString(self, strLine):
		return self.re_instrDef.findall(strLine)
	
	# @function: get the vars in one line string
	# @param:
	#	strLine: one line of string.
	def Get_VarInString(self, strLine):
		return self.re_portVar.findall(strLine)
	
	# @function: calculate the appropriate MUXN
	# @param:
	#	srcn: number of source port
	def Cal_Muxn(self, srcn):
		i = 2;
		while i < srcn:
			i <<= 1
		return i
	
	# @function: generate the hdl expression of instructions
	# @param:
	#	instrName: name of instruction
	def Gen_InstrHDLExp(self, instrName):
		uinstr = instrName.upper()
		if uinstr+"_OPCD" in self.instrs_ngp:
			instr_def_suffix = "_OPCD"
		else:
			instr_def_suffix = "_XO"
		return  '`' + uinstr + instr_def_suffix
	
	# @function: Get the Module name of the port
	# @param:
	#	portName: name of the port in some Module
	def Get_ModuleName(self, portName):
		return portName.split('.')[0:1]
	
	# @function: Generate the appropriate UNIQUE Port Name
	# @param:
	#	portNameExp: the expression of port name
	#	suffix: suffix of port, may be null
	def Gen_portName(self, portNameExp, suffix=""):
	
		# nested function define to use gloval variable
		def Gen_OnePortName(matchobj):
			pname = matchobj.group(0)
			if pname[0] == '`' or pname[0] == '\'':
				return pname
				
			slice = pname.split('.')
			ret = ""
			if len(slice) < 2:
				if suffix!=NULL:
					ret = pname + '_' + suffix
				else:
					ret = pname
				return ret
				
			if len(slice[0]) < len(slice[1]) and slice[1].startswith(slice[0]):
				ret = slice[1]
			else:
				ret = slice[0] + '_' + slice[1]
			if suffix!=NULL:
				ret += '_' + suffix
			return ret
			
		return self.re_rtlPort.sub(Gen_OnePortName, portNameExp)
		
	# @function: Generate the control name
	# @param
	#	portName: name of the port
	def Gen_ControlName(self, portName, stage_suffix=""):
		ret = ""
		slice = portName.split('.')
		if len(slice) < 2:
			ret = portName
		if len(slice[0])<len(slice[1]) and slice[1].startswith(slice[0]):
			ret = slice[1]
		else:
			ret = slice[0] + slice[1]
		if stage_suffix!=NULL:
			ret +=  "_" + stage_suffix
		return ret
	
	# @function: generate the "_def.v" file list for include
	def Gen_defv(self):
		lst = os.listdir(self.work_path)
		self.defvs = []
		for fname in lst:
			if fname.endswith(self.HDL_DEFFILE):
				self.defvs.append(fname)
				
	# @function: generate the mux code
	# @param:
	#	tabn: num of TAB
	def Gen_MuxCode(self, tabn):
		ret = ""
		pre = '\t' * tabn
		for i in range(self.stage_num):
			if self.MuxCode[i]!=NULL:
				ret += pre + "/******    " + self.stage_names[i] + "    ******/\n"
				ret += self.MuxCode[i]
		return ret
		
	# @function: generate the mux code
	def Gen_BypassCode(self):
		ret = ""
		for code in self.BypassMuxCode:
			ret += code
		return ret
	
	# @function: check the src Module and des Module is the same Module
	# @param:
	#	src: the expression of the souce
	#	des: the expression pf the destination
	def is_SameModule(self, src, des):
		s_ppos = src.find('.')
		d_ppos = des.find('.')
		if s_ppos < 0 or d_ppos < 0:
			return False
		return src[0:s_ppos] == des[0:d_ppos]
	
	# @function: check if the source port is a Bypass
	# @logic:
	#	ignore means to ignore the i_stage, for wire checking the bypass
	# @param:
	#	portName: name of the port
	#	i_stage: stage index of current port
	#	ignore: whether ignore the i_stage
	def is_aBypass(self, portName, i_stage, ignore=False):
		# print "Bypass test\n"
		# print "portName =", portName, ", stage =", self.stage_names[i_stage]
		for (pname, stage) in self.BypassPorts:
			if pname==portName and (ignore or i_stage==stage):
				return True
		return False
	
	# @function: check the port need a MUX
	# @param:
	#	srcn: number of source port
	#	portName: name of the port
	def is_aMux(self, srcn, portName):
		if srcn<=1 or self.is_aControl(portName):
			return False
		return True	
	
	# @function: check the portName is a port or `define or const
	# @param:
	#	portName: name of the port
	def is_aPort(self, portName):
		if '.' in portName:
			return True
		return False
	
	# @function: check the port is a control port
	# @param:
	#	portName: name of the port
	# @note:
	#	if the port fits the SUFFIX, it MUST be a control.
	def is_aControl(self, portName):
		for suffix in CU_SUFFIX:
			if portName.endswith(suffix):
				return True
		return False
	
	# @function: Delete All space
	# @param:
	#	str: the string
	def Erase_Space(self, str):
		return self.re_space.sub('', str);
		
	# @function: Print the Error
	def Print_Error(self):
		if self.ErrRobot.Get_isWrong:
			self.ErrRobot.Print_Error()
	
	# @function: Print the RTLs to user, For DEBUG
	# @param: None
	def Print_RTLs(self):
		print "number of instruction is ", len(self.instrs_RTLs)
		for instr in self.instrs_RTLs:
			print instr+": ",len(self.instrs_RTLs[instr])
			print self.instrs_RTLs[instr]
			
	# @function: Print the length of RTLs[key] to user, For DEBUG
	# @param: None
	def Print_RTLs_Element_Length(self):
		for instr in self.instrs_RTLs:
			print instr+":"
			print len(self.instrs_RTLs[instr])
			
	# @function: Print the DataTrace to user, For DEBUG
	# @param: None
	def Print_DataTrace(self):
		for portname in self.write_rtb:
			print "\n/****    "+portname+"    ****/"
			for lists in self.write_rtb[portname]:
				print lists
				print self.write_rtb[portname][lists]
		for portname in self.read_rtb:
			print "\n/****    "+portname+"    ****/"
			for stage in self.read_rtb[portname]:
				print stage,": ",self.read_rtb[portname][stage]
	
	# @function: Print the Connects in stages
	def Print_Connects(self):
		for i in range(len(self.Connects)):
			print "\n\n/*****\t\t",self.stage_names[i],"\t\t*****/"
			for des in self.Connects[i]:
				print des
				print '\t',list(self.Connects[i][des])
	
	# @function: Print the Flows
	def Print_Flows(self):
		for i in range(self.stage_num):
			print "STAGE", self.stage_names[i]
			print self.Flows[i]
			print 
	
	# @function: Print the Mux Code
	def Print_MuxCode(self):
		for i in range(self.stage_num):
			print self.stage_names[i]
			print self.MuxCode[i]
	
	# @function: Print the Mux Code
	def Print_BypassMuxCode(self):
		for code in self.BypassMuxCode:
			print code
			
	# @function: Print Connected modules
	def Print_Modules(self):
		for mname in self.modules:
			print "%s = {" % mname
			for pname in self.modules[mname]:
				(portName, i_stage) = self.modules[mname][pname]
				portName = self.Gen_portName(portName, self.stage_names[i_stage]);
				print "\t%14s => %s," % (portName, pname)
			print "};\n"
	
	# @function: print the length of ports in different modules
	def Print_ModulePortLength(self):
		for mname in self.module_portLength:
			print "/****    ", mname, "    ****/"
			for pname in self.module_portLength[mname]:
				print pname, "=>" ,self.module_portLength[mname][pname]
	
	# @function: print the bypass ports
	def Print_BypassPorts(self):
		for (portName, i_stage) in self.BypassPorts:
			print "portName =", portName, ", stage =", self.stage_names[i_stage]
	
	# @function: print the instrs_boundry
	def Print_instrsBoundry(self):
		for (instrName, r_index) in self.instrs_boundry:
			print instrName, "in line", r_index
	
	# @function: print the control ports	
	def Print_ctrlPorts(self):
		for i_stage in range(self.stage_num):
			print "/*****    " + self.stage_names[i_stage] + "    *****/"
			for portName in self.Controls[i_stage]:
				print portName, self.Controls[i_stage][portName]
			print
	
	# @function: print the normal instructions group
	def Print_Instr_ngp(self):
		print "Instr Normal Groul has:"
		for instrName in self.instrs_ngp:
			print instrName,
		print "\n"
		
	# @function: print the special instructions group
	def Print_Instr_sgp(self):
		print "Instr Special Groul has:"
		for instrName in self.instrs_sgp:
			print instrName,
		print "\n"
	
	# @function: print the address related ports of all insns	
	def Print_addrOfInstrs(self):
		print "ctrl Of Instrs"
		for instrName in self.addrOfInstrs:
			print instrName,":"
			for desName in self.addrOfInstrs[instrName]:
				print desName, "=>", self.addrOfInstrs[instrName][desName]
	
	# @function: print the hazard address related ports of all insns
	def Print_hazardAddrs(self):
		for i_stage in range(self.stage_num):
			print "/*****    hazard Addrs of %s    *****/" % (self.stage_names[i_stage])
			addrs = set(self.hazardAddrs[i_stage])
			for addr in addrs:
				print addr,
			print
		print
	
	# @function: print the bypass select ports	
	def Print_BypassSelPorts(self):
		for i_stage in range(self.stage_num):
			selPorts = self.BypassSelPorts[i_stage]
			print "/*****    " + self.stage_names[i_stage] + "    *****/"
			for (portName, width) in selPorts:
				print "%s %s" % (portName, width)
			print
			
if __name__ == "__main__":
	xls_path = ".\\ppc_pipeline.xls"
	sheet_name = "RTL"
	work_path = ".\\"
	read_ports = ["GPR.rd1", "GPR.rd2", "GPR.rd3", "SPR.SPR", "CR.CR",  "MSR.MSR"]
	special_ports = ["CRIn.CR0_CRWd", "CRIn.Mov_CRWd", "CRIn.ALU_CRWd", "CRIn.Cmp_CRWd", "XERIn.ALU_XERWd"]
	o_stage = ["D"]*6
	wb_stage = "W"
	instr_col = 0
	auto_tool = Auto_PPC_Pipeline(work_path, xls_path, sheet_name)
	tb = auto_tool.Get_OpFromInstrDef("instruction_def.v")
	auto_tool.Gen_InstrGroups(tb)
	# print "after Get_OpFromInstrDef"
	# for k in tb:
		# print k, "->", tb[k]
	auto_tool.Auto_topProcess(read_ports, special_ports, o_stage, wb_stage, instr_col)
	# auto_tool.Print_instrsBoundry()
	auto_tool.Merge_AllCtrlPorts()
	auto_tool.Print_ctrlPorts()
	print auto_tool.Gen_AllStageCtrlCode()
	auto_tool.Print_Instr_ngp()
	auto_tool.Print_Instr_sgp()
	auto_tool.Print_addrOfInstrs()
	print "ctrl ports"
	auto_tool.Print_ctrlPorts()
	auto_tool.Print_hazardAddrs()
	auto_tool.Print_BypassSelPorts()
	print "length of module"
	auto_tool.Print_ModulePortLength()
	"""
	auto_tool.Set_SpecialPorts(special_ports)
	auto_tool.Set_PipeStage(0, "W")
	#auto_tool.Get_All_DataTrace()
	auto_tool.Get_All_RTLs()
	auto_tool.Get_All_DataTrace(read_ports, o_stage)
	# auto_tool.Print_DataTrace()
	# auto_tool.Print_RTLs()
	auto_tool.Get_AllInstr_Connects()
	print "\n\n**** Print module Hazard Array ****\n"
	auto_tool.Gen_AllHazardArray()
	print "\n\n**** Print Bypass Mux Code ****\n"
	auto_tool.Print_BypassMuxCode()
	auto_tool.Check_AllFile()
	auto_tool.Gen_AllStage_Muxes()
	#auto_tool.Print_Connects()
	auto_tool.Gen_AllStage_MuxCode()
	print "\n\n**** Print the Mux Code ****\n"
	auto_tool.Print_MuxCode()
	# print '\n',auto_tool.stage_flows
	# print
	# print auto_tool.read_rtb
	# print auto_tool.read_ports
	# print type(auto_tool.read_rtb)
	# print auto_tool.read_rtb.keys()
	# print auto_tool.instrs_RTLs
	# print 	auto_tool.read_ports
	# print 	auto_tool.write_ports
	print "\n\n**** Print module Utilize Code ****\n"
	print auto_tool.Utilize_AllModule(1)
	print "\n\n**** Print the Flows ****\n"
	auto_tool.Print_Flows()
	print "\n\n**** Print the Connects ****\n"
	auto_tool.Print_Connects()
	print "\n\n**** Print the Modules ****\n"
	auto_tool.Print_Modules()
	print "\n\n**** Print the Errors ****\n"
	auto_tool.Print_Error()
	print "\n\n/**** Print the Length of the Module ****/"
	auto_tool.Gen_AllModuleLength()
	auto_tool.Print_ModulePortLength()
	print "\n\n/**** Print the Top Wire Code ****/"
	print auto_tool.Gen_AllModuleWireCode(1)
	print "\n\n/**** Print the Top Reg Code ****/"
	print auto_tool.Gen_AllModuleRegCode(1)
	print "\n\n/**** Print the Bypass Ports ****/"
	auto_tool.Print_BypassPorts()
	print "\n\n/**** Print the Pipeline Reg ****/"
	print auto_tool.Gen_PipelineRegCode(1)
	"""
	"""
	auto_tool.Auto_Gen_CU()
	auto_tool.Collect_Modules()
	utilize = auto_tool.Utilize_Modules()
	wires = auto_tool.Gen_WireCode()
	auto_tool.Auto_Gen_Top()
	#auto_tool.Auto_handle_mux()
	#print auto_tool.muxes_connects
	"""