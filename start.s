.extern kernel_main

.global start

.set MB_MAGIC, 0x1BADB002           // GRUB will use this to detect kernel location
.set MB_FLAGS, (1 << 0) | (1 << 1)  // tells GRUB to 1: load modules on page boundaries and 2: provide memory map
.set MB_CHECKSUM, (0 - (MB_MAGIC + MB_FLAGS))


// multiboot header
.section .multiboot
        .align 4
        .long MB_MAGIC
        .long MB_FLAGS
        .long MB_CHECKSUM

// data initialized to zeroes
.section .bss
        .align 16
        stack_botton:
                .skip 4096
        stack_top:

// actual code to be run when kernel loads
.section .text
        start:
                mov $stack_top, %esp    // set sp to top of stack, in x86 stack grows down

                call kernel_main

                // if kernel code never returns, hang the CPU
                hang:
                        cli
                        hlt
                        jmp hang
