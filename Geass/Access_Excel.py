from xlrd import open_workbook,cellname, XL_CELL_TEXT, XL_CELL_NUMBER
from xlwt import *

class Access_Excel(object):
	
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
		self.rsheet = self.book.sheet_by_name(sheetName)
			
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
		return val.encode()
	
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
		
if __name__ == "__main__":
	AE = Access_EXCEL("test.xls")
	lst = [str(i) for i in range(10)]
	AE.Set_OneCell(0, 0, "abc", True)
	AE.Set_OneRow(11, 1, len(lst)+1, lst);
	AE.Set_OneCol(1, 1, len(lst)+1, lst);
	AE.Save_Excel()