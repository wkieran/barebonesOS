
#include <stddef.h>
#include <stdint.h>

// check if using corect compiler
#if defined(__linux__)
        #error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
        #error "This code must be compiled with an x86-elf compiler"
#endif

// textmode buffer
volatile uint16_t* vga_buffer = (uint16_t*)0xB8000;

// size of buffer
const int VGA_COLS = 80;
const int VGA_ROWS = 25;

// start displaying text top-left
int term_col = 0;
int term_row = 0;
uint16_t term_color = 0x0F; //black background, white foreground

// initiated terminal by clearing it
void term_init() {
    
    for (int row = 0; row < VGA_ROWS; row++) {

        for (int col = 0; col < VGA_COLS; col++) {

            const size_t index = (VGA_COLS * row) + col;
            vga_buffer[index] = ((uint16_t)term_color << 8) | ' ';

        }

    }
}

// placing a single character on the screen
void term_putc(char c) {

    switch (c)
    {
    case '\n':
        {
            term_col = 0;
            term_row++;
            break;
        }
    
    default:
        {
            const size_t index = (VGA_COLS * term_row) + term_col;
            vga_buffer[index] = ((uint16_t)term_color << 8) | c;
            term_col++;
            break;
        }
    }

    if (term_col >= VGA_COLS)
    {
        term_col = 0;
        term_row = 0;
    }

}

// prints an entire string onto the screen
void term_print(const char* str) {
    for (size_t i = 0; str[i] != '\0'; i++)
        term_putc(str[i]);
}

// main function
void kernel_main() {
    term_init();

    term_print("Hello, World!\n");
}