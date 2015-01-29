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
							self.modules[mname][pname] = pname
						else:
							# if there's still some port without any connections
							#	then there must be some errors
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