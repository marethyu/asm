;---------------------------------------------------------------------------------------
;
;                                invtriangle.asm
;
; compile and run:
; $ nasm -f elf64 invtriangle.asm && ld -s -o invtriangle invtriangle.o && ./invtriangle
;---------------------------------------------------------------------------------------

                bits    64
                global  _start

                section .text
_start:
                mov     r8, 0          ; copy maximum number of whitespace characters allowed for first line to register 'r8'
                mov     r9, 10         ; copy maximum number of stars allowed for first line to register 'r9'
                mov     r10, 0         ; number of whitespace characters written on line so far
                mov     r11, 0         ; number of star characters written on line so far
                mov     r12, output    ; copy address of the string pointer to register 'r12'
writeline:
writewhitespace:
                cmp     r8, 0          ; check if the value of register 'r8' is zero
                je      writestars     ; if so, skip writing whitespaces
                mov     byte[r12], ' ' ; write a whitespace character
                inc     r12            ; advance pointer to next address to write
                inc     r10            ; increment number of whitespace characters written on line so far by 1
                cmp     r10, r8        ; compare register values: check if we reached the maximum number of whitespace characters allowed for the current line
                jne     writewhitespace; if not, continue writing whitespaces
writestars:
                cmp     r9, 0          ; check if the value of register 'r9' is zero
                je      lineend        ; if so, skip writing stars
                mov     byte[r12], '*' ; write s star
                inc     r12            ; advance pointer to next address to write
                inc     r11            ; increment number of star characters written on line so far by 1
                cmp     r11, r9        ; compare register values: check if we reached the maximum number of star characters allowed for the current line
                jne     writestars     ; if not, continue writing stars
lineend:
                mov     byte[r12], 10  ; write a new line character (ascii value for new-line is 10)
                inc     r12            ; advance pointer to next address to write
                inc     r8             ; the next line will be one whitespace longer
                dec     r9             ; the next line will be one star shorter
                mov     r10, 0         ; reset the counter (number of whitespace characters written on line)
                mov     r11, 0         ; reset the counter (number of star characters written on line)
                cmp     r8, maxlines   ; did we exceed the maximum number of lines?
                jng     writeline      ; if not, continue writing lines
                mov     rax, 1         ; system call number for write (64-bit)
                mov     rdi, 1         ; file descriptor = stdout
                mov     rsi, output    ; copy the address of string 'output' to output
                mov     rdx, nbytes    ; copy number of bytes in output
                syscall                ; invoke OS to write
                mov     rax, 60        ; system call number for exit (64-bit)
                xor     rdi, rdi       ; exit status = 0
                syscall                ; invoke OS to exit

                section .data
maxlines        equ     10             ; maximum number of lines to write
nbytes          equ     110            ; 10 * 10 + 10 = 110 bytes (don't forgot to take account of new-line characters!)

                section .bss
output          resb    nbytes         ; initialize a string pointer by reserving number of bytes