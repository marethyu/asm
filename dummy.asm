; $ nasm -f elf64 dummy.asm && gcc -o dummy dummy.o && ./dummy
    bits 64
    global main
    section .text
main:
    mov rax, 60
    xor rdi, rdi
    syscall