;-----------------------------------------------------------------------
;
;                     triangle_win64_win64.asm
;
; compile:
; > nasm -f win64 -o triangle_win64.obj triangle_win64.asm
; > gcc -g -m64 triangle_win64.obj -o triangle_win64.exe
;-----------------------------------------------------------------------

            bits    64             ; enter 64 bit mode
            default rel            ; use relative addressing

            segment .text
            global main            ; entry point (export main)

            extern ExitProcess     ; import necessary functions
            extern printf
main:
            push    rbp            ; align stack frame
            mov     rbp, rsp
            sub     rsp, 32

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
            mov     byte[rbx], 13  ; write CR in decimal
            inc     rbx            ; advance pointer to next address to write
            mov     byte[rbx], 10  ; write LF in decimal
            inc     rbx            ; advance pointer to next address to write
            inc     rcx            ; the next line will be one star longer
            mov     rdx, 0         ; reset the counter (number of stars written on line)
            cmp     rcx, maxlines  ; did we exceed the maximum number of lines?
            jng     writestars     ; if not, continue writing stars

            mov     rcx, output    ; copy the address of string 'output' to output
            call    printf

            xor     rax, rax       ; zero exit status
            call    ExitProcess    ; terminate the program

            segment .data
maxlines    equ     10             ; maximum number of lines to write
nbytes      equ     75             ; (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10) + 10 * 2 = 75 bytes (each line of stars requires the 2-byte line terminator CRLF thus 10*2; CRLF is windows specific btw)

            segment .bss
output      resb    nbytes         ; initialize a string pointer by reserving number of bytes