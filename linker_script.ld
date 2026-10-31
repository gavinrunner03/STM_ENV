/* Entry Point Definition */
ENTRY(Reset_Handler)

/* Highest address of the user mode stack */
_estack = 0x20005000;    /* End of 20KB RAM (0x20000000 + 20KB) */

/* Specify the memory areas available on the STM32F103C8 */
MEMORY
{
  FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 64K
  RAM   (xrw)     : ORIGIN = 0x20000000, LENGTH = 20K
}

SECTIONS
{
  /* 1. The Vector Table goes first into FLASH */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector)) 
    . = ALIGN(4);
  } >FLASH

  /* 2. The Program Code and read-only data go into FLASH */
  .text :
  {
    . = ALIGN(4);
    *(.text)           /* Your compiled C code instructions */
    *(.text*)          /* Sub-functions of code */
    *(.rodata)         /* Read-only constants (like permanent strings) */
    *(.rodata*)        
    
    /* PATCH: Include compiler helper sections so standard library utilities don't crash */
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */
    *(.eh_frame)
    
    . = ALIGN(4);
    _etext = .;        /* Create a pointer marking the exact end of code */
  } >FLASH

  /* Used by the startup code to find where the raw data sits in Flash */
  _sidata = LOADADDR(.data);

  /* 3. Initialized global/static variables go into RAM but are stored in FLASH */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* Pointer to the start of RAM data variables */
    *(.data)           /* Your initialized global variables */
    *(.data*)          
    . = ALIGN(4);
    _edata = .;        /* Pointer to the end of RAM data variables */
  } >RAM AT> FLASH

  /* 4. Uninitialized global/static variables (BSS) go completely into RAM */
  .bss :
  {
    . = ALIGN(4);
    _sbss = .;         /* Start of BSS pointer */
    *(.bss)            /* Variables like "int network_timeout;" (no starting value) */
    *(.bss*)
    *(COMMON)          /* PATCH: Allocate uninitialized variables tagged as COMMON */
    . = ALIGN(4);
    _ebss = .;         /* End of BSS pointer */
  } >RAM
}
