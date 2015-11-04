from xlrd import open_workbook, cellname, XL_CELL_TEXT, XL_CELL_NUMBER

class Access_Excel(object):
	
	def __init__(self, path, sheetName=None):
		self.book = open_workbook(path)
		self.rsheet = None
		if sheetName is not None:
			self.Open_rsheet(sheetName)
		self.path = path
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
		return val.encode().strip()
	
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
		
