TEMPLATE = app
CONFIG += console
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += main.c \
    ppc_trie.c \
    ppc_regs.c \
    ppc_mem.c \
    ppc_cu.c \
    ppc_alu.c \
    ppc_pc.c \
    ppc_arch.c \
    gen_ppc_opcode.c \
    ppc_cmd.c

HEADERS += \
    ppc_format.h \
    ppc_type.h \
    ppc_trie.h \
    ppc_regs.h \
    ppc_opcode.h \
    ppc_mem.h \
    ppc_cu.h \
    ppc_alu.h \
    ppc_global.h \
    ppc_pc.h \
    ppc_vdef.h \
    ppc_cu_vdef.h \
    ppc_arch.h \
    ppc_cmd.h

OTHER_FILES += \
    opcode \
    form

