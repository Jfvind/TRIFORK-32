/* architecture we are building for */
OUTPUT_ARCH(riscv)

/* The entry point of the program. */
ENTRY(_start)

/* Memory layout - HW Mapping */
/* TODO: Få de rigtige værdier */
MEMORY {
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 64K
    RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 32K
}

/* Sections -> Where is compilers output placed? */
SECTIONS {
    .text : {
        *(.text .text.*)
    } > ROM

    .rodata : {
        *(.rodata .rodata.*)
    } > ROM

    /* .data: Skal leve i RAM (VMA), men loades fra ROM (LMA) */
    .data : {
        /* _sdata markerer starten på .data i RAM */
        _sdata = .;
        *(.data .data.*)
        /* _edata markerer slutningen på .data i RAM */
        _edata = .;
    } > RAM AT> ROM

    /* LOADADDR giver os den fysiske adresse i ROM, hvor startværdierne ligger gemt */
    _sidata = LOADADDR(.data);

    /* .bss: Variabler uden startværdi (skal nulstilles) */
    .bss : {
        /* _sbss markerer starten på .bss i RAM */
        _sbss = .;
        *(.bss .bss.*)
        /* _ebss markerer slutningen på .bss i RAM */
        _ebss = .;
    } > RAM

    /* Stacken vokser nedad. Vi placerer den i toppen af RAM. */
    _stack_start = ORIGIN(RAM) + LENGTH(RAM);
}