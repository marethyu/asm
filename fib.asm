; -----------------------------------------------------------------------------
;        x86-64 assembly program to print first 80 Fibonacci numbers.
;
; compile and run:
; $ nasm -f elf64 fib.asm && gcc -o fib fib.o && ./fib
; -----------------------------------------------------------------------------

        bits     64
        global   main         ; standard gcc entry point
        extern   printf       ; external C library function to be called

        section .text
main:
        push    rbp           ; set up stack frame, must be alligned
        xor     rbx, rbx      ; a = 0
        mov     r12, 1        ; b = 1
        mov     r14, n        ; set up loop counter
mainloop:
        mov     rdi, fmt      ; format for printf
        mov     rsi, r12      ; first argument for printf
        xor     rax, rax      ; clear high bits of 'rax' register (because printf is varargs)
        call    printf        ; printf(fmt, b)
        mov     r13, rbx      ; c = a
        add     r13, r12      ; c += b
        mov     rbx, r12      ; a = b
        mov     r12, r13      ; b = c
        dec     r14           ; decrement the loop counter
        cmp     r14, 0        ; does the loop counter reach zero?
        jnz     mainloop      ; continue the loop if it's not zero
        pop     rbp           ; restore stack
        mov     rax, 60       ; system call number for exit (64-bit)
        xor     rdi, rdi      ; exit code = 0 (success)
        syscall               ; invoke OS to exit

        section .data
fmt:    db      "%ld", 10, 0  ; null-terminated format string (10 is ascii value for new line)
n:      equ     80            ; number of fibonacci numbers to print