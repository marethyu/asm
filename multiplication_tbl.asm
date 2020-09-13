; Prints 10x10 multiplication table. It shows how 2D arrays are represented in assembly.
;
; $ nasm -f elf64 multiplication_tbl.asm && gcc -o multiplication_tbl multiplication_tbl.o && ./multiplication_tbl

    bits 64
    global main
    extern printf, putchar

    section .text
main:
    push rbp
    mov rbp, rsp

; nxn integer 2D array takes n * n * 4 bytes of memory so align the stack accordingly. (must be a multiple of 16)
; the dirty truth is that there's no such thing as 2D array in assembly (1D array as well). 2D arrays are flattened into
; 1D arrays which are stored in contiguous memory blocks.
    sub rsp, 688

    lea rbx, [rbp - n * n * 4] ; store a pointer to a first element in the '2D array'

;
; initialize a multiplication table
;

    xor r12, r12 ; initialize 'i' to 0
loop1:
    xor r13, r13 ; initialize 'j' to 0
loop2:
; we access the '2D array' the same way as we access 1D arrays.
; so the index of the '2D array' in 1D array version is i * ncols + j.
    mov r14, r12
    imul r14, n
    add r14, r13

; calculate (i + 1) * (j + 1). put the result in the register r15.
    push r12
    push r13
    inc r12
    inc r13
    imul r12, r13
    mov r15, r12
    pop r13
    pop r12

    mov [rbx + r14 * 4], r15 ; store the result in the '2D array'

    inc r13
    cmp r13, n
    jl loop2

    inc r12
    cmp r12, n
    jl loop1

;
; display the table
;

    xor r12, r12
loop3:
    xor r13, r13
loop4:
    mov r14, r12
    imul r14, n
    add r14, r13

    mov rdi, fmt
    mov rsi, [rbx + r14 * 4]
    xor rax, rax
    call printf

; if (j < n - 1) {
;     putchar(' ');
; } else {
;     putchar('\n');
; }
    mov r15, n
    dec r15
    cmp r13, r15
    je else_branch1
    mov rdi, 32
    jmp end_if1
else_branch1:
    mov rdi, 10
end_if1:
    call putchar

    inc r13
    cmp r13, n
    jl loop4

    inc r12
    cmp r12, n
    jl loop3

    pop rbp
    mov rax, 60
    xor rdi, rdi
    syscall

    section .data
n equ 13
fmt: db "%3d", 0