
class ConstError(Exception):
	def __init__(self, message, code=None, params=None):
		super(ConstError, self).__init__(message, code, params)
		if hasattr(message, "__str__"):
			print message, "is const"
		
class _const(object):
	def __setattr__(self, k, v):
		if k in self.__dict__:
			raise ConstError(k)
		else:
			self.__dict__[k] = v
			
const = _const()
			