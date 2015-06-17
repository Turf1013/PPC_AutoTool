import sys
import os
import logging
import re

"""
oc 				  4 4 3 2 1 0
lw	$2,0($1)	F D E E M M M W
ic				    3     N
SW	$2,0($2)	  F D E E M M M W
					  3     N
SW	$2,0($2)	    F D E E M M M W
					    3     N
SW	$2,0($2)	      F D E E M M M W


mult $2,$3		F D U U U M M M W
lw	$3,0($2)	  F D E E M M M W
					F D E E M M M W
"""					


class Auto_PPC_Pipeline():
	
	# @param:
	#	ppl: description of pipeline
	def __init__(self, ppl):
		self.ppl = ppl
		pass
		
		
	def createGraph(self):
		pass
	