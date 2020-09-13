; Prints first ten square numbers.
;
; $ nasm -f elf64 square_nums.asm && gcc -m64 -o square_nums square_nums.o && ./square_nums

    bits 64
    global main
    extern printf

    section .text
main:
    push rbp
    push rbx ; we have to save this since we use it
    xor ecx, ecx
loop1:
    mov eax, ecx
    inc eax
    imul eax, eax
    push rcx ; printf may destroy the value stored in rcx, so we push this caller-save register in the stack
    mov rdi, fmt ; arg1
    mov esi, eax ; arg2
    xor rax, rax ; cuz printf is varargs
    call printf
    pop rcx ; restore caller-save register
    inc ecx
    cmp ecx, 10
    jl loop1
    pop rbx ; restore rbx before returning
    pop rbp
    mov rax, 60
    xor rdi, rdi
    syscall

    section .data
fmt: db "%d", 10, 0