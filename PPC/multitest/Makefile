.PHONY : all clean

CROSS = powerpc-linux-gnu-
CC = $(CROSS)gcc
LD = $(CROSS)ld
AS = $(CROSS)as
OBJCOPY = $(CROSS)objcopy
OBJDUMP = $(CROSS)objdump

XXX = -fdump-final-insns
CFLAGS = $(XXX) -O0 -Wall -g -fno-builtin -fno-pic -mpowerpc -mno-powerpc-gpopt -mno-powerpc-gfxopt -mno-mulhw -mbig -mno-spe $(INCLUDE)
ASFLAGS = -gstabs -fno-pic -mpowerpc -mno-powerpc-gpopt -mno-powerpc-gfxopt -mbig -mno-spe -D__ASSEMBLY__ $(INCLUDE)
LDFLAGS = -T ./powerpc.lds
DUMPFLAGS = -lDS
COPYFLAGS = --gap-fill=0xff -O binary
BINELF = bin.elf
BINBIN = bin.bin
ALLDEP = Makefile.dep
GLOBALSRC = head.S
USERSOURCES = multitest.S
SOURCES = $(GLOBALSRC) $(USERSOURCES)

# .c -> .o, .s -> .o
OBJECTS = $(patsubst %.c, %.o, $(patsubst %.S, %.o, $(SOURCES)))
DEPENDS = $(patsubst %.o, %.d, $(OBJECTS)

all : $(BINBIN)
$(BINBIN) : $(BINELF)
	$(OBJCOPY) $(COPYFLAGS) $^ $@

$(BINELF) : $(OBJECTS)
	$(LD) -o $@ $(LDFLAGS) $^
	$(OBJDUMP) $(DUMPFLAGS) $@ > $@.txt
	
%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@ 

%.o : %.S
	$(CC) $(ASFLAGS) -c $< -o $@

clean:
	rm -vf $(OBJECTS) $(BINBIN) $(BINELF) $(ALLDEP) $(BINELF).txt

