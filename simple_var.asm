; $ nasm -f elf64 simple_var.asm && gcc -o simple_var simple_var.o && ./simple_var
;
; simple_var.py
; x = 3
; y = 7
; print(x + y)

    BITS 64
    GLOBAL main
    EXTERN printf

    SECTION .TEXT
main:
    PUSH RBP
    MOV RBP, RSP
    SUB RSP, 16 ; must be a multiple of 16

; x = 3 (store)
    PUSH 3
    POP RAX
    MOV DWORD[RBP - 8], EAX ; OR: MOV [RBP - 8], RAX

; y = 7 (store)
    PUSH 7
    POP RAX
    MOV DWORD[RBP - 4], EAX

; load x
    MOV EAX, DWORD[RBP - 8]
    PUSH RAX

; load y
    MOV EAX, DWORD[RBP - 4]
    PUSH RAX

; compute x + y
    POP RAX
    POP RBX
    ADD RAX, RBX
    PUSH RAX

; print(x + y)
    POP RSI
    MOV RDI, fmt
    XOR RAX, RAX
    CALL printf

    POP RBP
    MOV RAX, 60
    XOR RDI, RDI
    SYSCALL

    SECTION .DATA
fmt: DB "%d", 10, 0