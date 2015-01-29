from xlwt import *

NULL = ""

class Access_EXCEL(object):
	
	def __init__(self, path, sheetName=""):
		self.wbook = Workbook()
		self.path = path
		self.rsheet = None
		if sheetName == NULL:
			sheetName = "Default"
		self.Open_wsheet(sheetName)
		self.Set_DefaultFormat()
		
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
	
	def Save_Excel(self):
		self.wbook.save(self.path)
	
if __name__ == "__main__":
	AE = Access_EXCEL("test.xls")
	lst = [str(i) for i in range(10)]
	AE.Set_OneCell(0, 0, "abc", True)
	AE.Set_OneRow(11, 1, len(lst)+1, lst);
	AE.Set_OneCol(1, 1, len(lst)+1, lst);
	AE.Save_Excel()