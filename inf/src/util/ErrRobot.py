import copy

class ErrRobot(object):
	'ErrRobot is a Error Robot to log the error'
	def __init__(self, errDict):
		self.hasErr = False
		self.errNum = []
		self.errInfo = []
		self.initErrDict(errDict)
	
	def initErrDict(self, errDict):
		self.errDict = copy.deepcopy(errDict)
	
	def addErr(self, errNum, errAspect="Program", errReason=""):
		self.errNum.append(errNum)
		pre = "[%s]: " % (errAspect)
		if errNum in self.errDict:
			pre += self.errDict[errNum]
		else:
			pre += self.errDict[-1]		# -1 is default
		self.errInfo.append("%s: \n\t%s" % (pre, errReason))
	
	def GetErrInfo(self):
		return self.errInfo
	
	def hasError(self):
		if not self.hasErr:
			self.hasErr = len(self.errNum)>0
		return self.self.hasErr
	
	def GetErrNum(self):
		return self.errNum
	
	def printErr(self):
		for info in self.errInfo:
			print info
	
	def __str__(self):
		return self.__repr__()
	
	def __repr__(self):
		return "It's a robot to record error"