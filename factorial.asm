; -----------------------------------------------------------------------------
;           x86-64 ssembly program to calculate factorials
;
; compile and run:
; $ nasm -f elf64 factorial.asm && gcc -o factorial factorial.o && ./factorial
; -----------------------------------------------------------------------------

        bits       64
        global     main                                 ; gcc entry point
        extern     printf                               ; external C function

        section    .text
main:
        push       rbp                                  ; set up stack frame, must be alligned
        mov        rdi, n                               ; use the integer input as the first argument for factorial function
        call       factorial                            ; compute the factorial
        mov        rdi, fmt                             ; printf format
        mov        rsi, n                               ; first argument for printf format
        mov        rdx, rax                             ; second argument for printf format (return value of factorial function)
        xor        rax, rax                             ; clear high bits of 'rax' register (because printf is varargs)
        call       printf                               ; print
        pop        rbp                                  ; restore stack
        mov        rax, 60                              ; system call number for exit (64-bit)
        xor        rdi, rdi                             ; exit code = 0 (success)
        syscall                                         ; invoke OS to exit

factorial:
        cmp        rdi, 1                               ; check whether if n is less than 1
        jle        basecase                             ; if so, don't do recursion
        push       rdi                                  ; push n onto the stack in order to save it (it aligns the 'rsp' register value)
        dec        rdi                                  ; n -= 1
        call       factorial                            ; recursively call factorial function
        pop        rdi                                  ; pop the stack onto the 'rdi' register (retrieve saved n)
        imul       rax, rdi                             ; multiply the return value of the previous recursive call with saved n
        ret                                             ; done!
basecase:
        mov        rax, rdi                             ; copy n into 'rax' register
        ret                                             ; terminate the function (return value is stored in the 'rax' register)

        section .data
fmt:    db      "The factorial of %ld is %ld.", 10, 0   ; null-terminated format string for printf (10's for a new-line character)
n:      equ     15                                      ; integer input for factorial function