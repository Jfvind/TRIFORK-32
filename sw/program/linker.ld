/* Linker script for Wildcat RISC-V SoC.
 *
 * Must match the scratchpad memory layout in RustSoCTop:
 *   - IMEM: 16 KB at 0x0000_0000 for instructions
 *   - DMEM: 16 KB at 0x0000_4000 for data, rodata, bss, and stack
 *
 * The entry point must stay at 0x0000_0000 because the CPU starts there.
 */

ENTRY(_start)

MEMORY
{
    /* Must match RustSoCTop's memBytes parameter and bootloader routing. */
    IMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 16K
    DMEM (rw)  : ORIGIN = 0x00004000, LENGTH = 16K
}

SECTIONS
{
    .text :
    {
        *(.text._start)    /* Entry point first */
        *(.text .text.*)
    } > IMEM

    .rodata : ALIGN(4)
    {
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    } > DMEM

    .data : ALIGN(4)
    {
        *(.data .data.*)
        *(.sdata .sdata.*)
    } > DMEM

    .bss (NOLOAD) : ALIGN(4)
    {
        . = ALIGN(4);
        __bss_start = .;
        *(.bss .bss.*)
        *(.sbss .sbss.*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
    } > DMEM

    /* Stack grows downward from top of DMEM. */
    _stack_top = ORIGIN(DMEM) + LENGTH(DMEM);

    ASSERT(ADDR(.text) + SIZEOF(.text) <= ORIGIN(IMEM) + LENGTH(IMEM), "IMEM overflow")
    ASSERT(__bss_end <= ORIGIN(DMEM) + LENGTH(DMEM), "DMEM overflow")

    /DISCARD/ :
    {
        *(.eh_frame)
        *(.comment)
    }
}
