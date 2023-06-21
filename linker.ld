ENTRY(start)

SECTIONS
{
    . = 1M;


    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.multiboot)
    }

    /* executable code */
    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.text)
    }

    /* read-only data */
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    /* read-write data init */
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    /* read-write data uninit and stack */
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }
}