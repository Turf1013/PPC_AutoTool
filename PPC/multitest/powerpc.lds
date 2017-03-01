
OUTPUT_ARCH(powerpc)
ENTRY(_start)
SECTIONS
{
  . = 0x10000000;
  . = ALIGN(4);
  .text :
  {
	. = 0;
    head.o(.text)
	. = 0x010;
	*(.text)
  }

  . = 0x10010000;
  . = ALIGN(4);
  .rodata : { *(.rodata)}
  . = ALIGN(4);
  .data : { *(.data)}

  . = 0x10010100;   
  . = ALIGN(4);
  __bss_start = .;
  .bss (NOLOAD) : { *(.bss) }
  __bss_end = .;
  _end = .;
}

