; $ nasm -f elf64 array_ex.asm && gcc -o array_ex array_ex.o && ./array_ex
    bits 64
    global main
    extern printf, scanf

    section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 48

; int i = 0;
    xor r12, r12 ; r12 is a loop index (initialized at 0)
; while (i < 10) {
loop1:
; printf("Enter a[%d]:\n", i);
    mov rdi, fmt1
    mov rsi, r12
    xor rax, rax
    call printf

; scanf("%d", &a[i]); OR scanf("%d", a + i);
    mov rdi, fmt2

; since the array has ten integer elements, it takes 40 (10 * 4bytes) bytes of memory.
; thus an offset for the first element is rbp - 40.
; remember that r12 is multiplied by 4 because integer takes 4 bytes of contiguous memory.
    lea rsi, [rbp - 40 + r12 * 4]
    xor rax, rax
    call scanf

; a[i] += a[i]; // double an array element
    mov eax, [rbp - 40 + r12 * 4]
    add dword[rbp - 40 + r12 * 4], eax

; i += 1;
    inc r12
    cmp r12, 10
    jl loop1

    xor r12, r12 ; reset the counter
loop2:
; printf("a[%d] = %d\n", i, a[i]);
    mov rdi, fmt3
    mov rsi, r12
    mov rdx, [rbp - 40 + r12 * 4]
    xor rax, rax
    call printf

    inc r12
    cmp r12, 10
    jl loop2

    pop rbp
    mov rax, 60
    xor rdi, rdi
    syscall

    section .data
fmt1: db "Enter a[%d]:", 10, 0
fmt2: db "%d", 0
fmt3: db "a[%d] = %d", 10, 0