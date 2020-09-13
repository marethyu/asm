; -----------------------------------------------------------------
; Writes "Hello world!" to the console using a C library.
;
; compile and run:
; $ nasm -f elf64 hello.asm && gcc -m64 -o hello hello.o && ./hello
; -----------------------------------------------------------------

; Equivalent C code
; // hello.c
; #include <stdio.h>
; int main()
; {
;   char msg[] = "Hello world!\n";
;   printf("%s\n",msg);
;   return 0;
; }

        global    main              ; the standard gcc entry point
; Declare needed C  functions
        extern    printf            ; the C function, to be called

        section .text               ; Code section.
main:                               ; the program label for the entry point
        push    rbp                 ; set up stack frame, must be alligned
        mov     rdi, fmt
        mov     rsi, msg
        mov     rax, 0              ; or can be  xor  rax, rax
        call    printf              ; Call C function
        pop     rbp                 ; restore stack
        mov     rax, 0              ; normal, no error, return value
        ret                         ; return

        section .data               ; Data section, initialized variables
msg:    db      "Hello world!", 0    ; C string needs 0
fmt:    db      "%s", 10, 0         ; The printf format, "\n",'0'