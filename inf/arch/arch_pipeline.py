import string

"""
arch_pipeline.py description
1. the definition of pipeline
2. operation of pipeline
"""

arch_pipe_stage_names = [
	'F',
	'D',
	'E',
	'M',
	'W'
]
arch_pipe_stage_ranges = [
	(1, 2),
	(2, 3),
	(3, 4),
	(4, 5),
	(5, 6),
]
b_ = arch_pipe_stage_ranges[0][0]
arch_pipe_stage_ranges = map(
	lambda t: (t[0]-b_, t[1]-b_), arch_pipe_stage_ranges
)