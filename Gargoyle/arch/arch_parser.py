import string
import re
import sys

from .arch_pipeline import arch_pipe_stage_ranges as apsr

def merge_in_stage(data):
	if len(data) < apsr[-1][-1]:
		raise IndexError, "%d beyond range %d" % (apsr[-1][-1], len(data))
		return None
	else:
		ret_data = map(lambda r_: data[r_[0]:r_[-1]], aspr)
		return ret_data
		