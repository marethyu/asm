; Example showing how to use printf if you have more than 6 arguments.
;
; $ nasm -f elf64 printf2.asm && gcc -no-pie -fno-pie -o printf2 printf2.o && ./printf2

    bits 64
    global main
    extern printf

    section .text
main:
    push rbp
    mov rdi, fmt ; arg1
    mov rsi, 1 ; arg2
    mov rdx, 2 ; arg3
    mov rcx, 3 ; arg4
    mov r8, 4 ; arg5
    mov r9, 5 ; arg6
; further arguments are pushed in reverse order onwards
    push 7 ; arg8
    push 6 ; arg7
    xor rax, rax
    call printf
    pop rbp
    mov rax, 60
    xor rdi, rdi
    syscall

    section .data
fmt: db "%d %d %d %d %d %d %d", 10, 0