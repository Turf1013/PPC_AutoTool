from hdl_const import *

LOGS2 = {
	1:0,
	2:1,
	4:2,
	8:3,
	16:4,
	32:5,
	64:6,
}

SPECIAL_RULE = {
	"6'b000001": "RT",
	"6'b000000": "FUNCT",
}

FOR_PPC = False
ARCH_BE = False
NRST = True

HDL_DEFFILE = '_def' + DOTV
HDL_WIDTHONE = "[0:0]"
HDL_OPCD = "OPCD" if FOR_PPC else "OP"
HDL_XO = "XO" if FOR_PPC else "FUNCT"
HDL_RGRP_PRE = "rGrp"
HDL_WGRP_PRE = "wGrp"
HDL_MUX_SEL = "Sel"
HDL_BYPASS = "Bp"
HDL_STALL = "stall"
HDL_FLUSH = "flush"
HDL_MUX = "mux"
HDL_MUXDEFAULT = "`MUX_D_DEFAULT"
HDL_INSTR = 'Instr'
HDL_WIDTH = 'WIDTH'
HDL_PIPEREGWR = 'pipeRegWr'
HDL_CLK = 'clk'
HDL_RST = 'rst_n' if NRST else 'rst'
HDL_EGDEOFRST = 'negedge' if NRST else 'posedge'
HDL_CLKCOND = 'posedge %s' % (HDL_CLK)
HDL_CLKWITHRSTCOND = 'posedge %s or %s %s' % (HDL_CLK, HDL_EGDEOFRST, HDL_RST)
HDL_RSTCOND = '!%s' % (HDL_RST) if NRST else '%s' % (HDL_RST)
HDL_INSTR_WIDTH = "[0:`INSTR_WIDTH-1]" if ARCH_BE else "[`INSTR_WIDTH-1:0]"
HDL_CONTROL = 'control'
HDL_CPU = 'ppc' if FOR_PPC else 'mips'

RTL_CUSUFFIX = ['Wr', 'Op']
RTL_CONNECT = '->'
RTL_PIPE = '>>'
RTL_MODTOPORT = '.'
RTL_RDPORT = 'rd'
RTL_WDPORT = 'Wd'
RTL_WRPORT = 'Wr'
RTL_RADDR = 'raddr'
RTL_WADDR = 'waddr'
RTL_ADDR = 'addr'
RTL_PCWr = "PC.PCWr"
