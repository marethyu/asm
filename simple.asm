; $ nasm -f elf64 simple.asm && gcc -o simple simple.o && ./simple
;
; simple.py
; print(3 + 5)

    bits 64
    global main
    extern printf

    section .text
main:
    push rbp
    
    push 3
    push 5
    
    pop rax
    pop rbx
    add rax, rbx
    push rax
    
    pop rsi
    mov rdi, fmt
    xor rax, rax
    call printf
    
    pop rbp
    mov rax, 60
    xor rdi, rdi
    syscall

    section .data
fmt: db "%d", 10, 0