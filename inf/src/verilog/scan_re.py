import re
from const_hdl import CFV

# re using by scan
re_moduleName 	= 	re.compile(r'\s*%s\s+(?P<name>[\w_]+)\s*' % (CFV.MODULE))
re_endmodule	=	re.compile(r'\s*%s' % (CFV.ENDMODULE))
re_portWidth 	= 	re.compile(r'\s*(?P<dir>%s|%s)\s+(?P<width>\[[\w`:_+-]+\])?' % (CFV.INPUT, CFV.OUTPUT))
re_portName 	= 	re.compile(r'\s*[\w_]+\s*[,;]')
