/* Linker script for Wildcat RISC-V SoC.
 *
 * Must match the scratchpad memory layout in RustSoCTop:
 *   - Text + data start at 0x0000 (loaded by bootloader)
 *   - Total available memory: 4 KB (0x0000 – 0x0FFF)
 *
 * The bootloader uploads the flat binary starting at address 0x0000,
 * so .text must begin there. The entry point is _start.
 */

ENTRY(_start)

MEMORY
{
    /* 4 KB scratchpad — must match RustSoCTop's memBytes parameter */
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 4K
}

SECTIONS
{
    .text :
    {
        *(.text._start)    /* Entry point first */
        *(.text .text.*)
    } > RAM

    .rodata : ALIGN(4)
    {
        *(.rodata .rodata.*)
    } > RAM

    .data : ALIGN(4)
    {
        *(.data .data.*)
    } > RAM

    .bss : ALIGN(4)
    {
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        __bss_end = .;
    } > RAM

    /* Stack grows downward from top of RAM */
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);

    /DISCARD/ :
    {
        *(.eh_frame)
        *(.comment)
    }
}
