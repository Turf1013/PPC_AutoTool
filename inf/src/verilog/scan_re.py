import re
from const_hdl import *

# re using by scan
re_moduleName 	= 	re.compile(r'\s*%s\s+(?P<name>[\w_]+)\s*' % (hdl_MODULE))
re_endmodule	=	re.compile(r'\s*%s' % (hdl_ENDMODULE))
re_portWidth 	= 	re.compile(r'\s*(?P<dir>%s|%s)\s+(?P<width>\[[\w`:_+-]+\])?' % (hdl_INPUT, hdl_OUTPUT))
re_portName 	= 	re.compile(r'\s*[\w_]+\s*[,;]')
