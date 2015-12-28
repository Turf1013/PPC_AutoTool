
OUTPUT_ARCH(powerpc)
ENTRY(_start)
SECTIONS
{
  . = 0x10000000;
  . = ALIGN(4);
  .text :
  {
    . = 0;
    *global/head.o(.text)
    . = 0x100;
    *global/int_entry.o
    . = 0x300;
    *(.text)
  }
  
  . = 0x10010000;
  . = ALIGN(4);
  .rodata : { *(.rodata)}
  . = ALIGN(4);
  .data : { *(.data)}

  . = 0x10010300;
  . = ALIGN(4);
  __bss_start = .;
  .bss (NOLOAD) : { *(.bss) }
  __bss_end = .;
  _end = .;
}

