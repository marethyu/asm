;--------------------------------------
;
;       triangle.asm
;
; compile and run:
; $ nasm -f elf64 triangle.asm
; $ ld -s -o triangle triangle.o
; $ ./triangle
;--------------------------------------

            bits    64             ; enter 64 bit mode (alternative: 32)
            global  _start

            section .text
_start:
            mov     rcx, 1         ; copy initial line length (maximum number of stars allowed for first line) to register 'rcx'
            mov     rdx, 0         ; number of stars written on line so far
            mov     rbx, output    ; copy address of the string pointer to register 'rbx'
writestars:
            mov     byte[rbx], '*' ; write a single star
            inc     rbx            ; advance pointer to next address to write
            inc     rdx            ; increment number of stars written on line so far by 1
            cmp     rdx, rcx       ; compare register values: check if we reached the maximum number of stars allowed for the current line
            jne     writestars     ; if not, continue writing stars
lineend:
            mov     byte[rbx], 10  ; write a new line character (ascii value for new-line is 10)
            inc     rbx            ; advance pointer to next address to write
            inc     rcx            ; the next line will be one star longer
            mov     rdx, 0         ; reset the counter (number of stars written on line)
            cmp     rcx, maxlines  ; did we exceed the maximum number of lines?
            jng     writestars     ; if not, continue writing stars
            mov     rax, 1         ; system call number for write (64-bit)
            mov     rdi, 1         ; file descriptor = stdout
            mov     rsi, output    ; copy the address of string 'output' to output
            mov     rdx, nbytes    ; copy number of bytes in output
            syscall                ; invoke OS to write
            mov     rax, 60        ; system call number for exit (64-bit)
            xor     rdi, rdi       ; exit status = 0
            syscall                ; invoke OS to exit

            section .data
maxlines    equ     10             ; maximum number of lines to write
nbytes      equ     65             ; (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10) + 10 = 65 bytes (don't forgot to take account of new-line characters!)

            section .bss
output      resb    nbytes         ; initialize a string pointer by reserving number of bytes