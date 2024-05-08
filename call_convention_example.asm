; run:   nasm -f elf64 call_convention_example.asm && gcc -no-pie -fno-pie -o call_convention_example call_convention_example.o && ./call_convention_example
; debug: nasm -f elf64 -g -F dwarf call_convention_example.asm && gcc -no-pie -fno-pie -o call_convention_example call_convention_example.o && gdb ./call_convention_example

        bits    64
        global  main
        extern  printf

        section .text
f:
        push    rbp
        mov     rbp,      rsp
        sub     rsp,      24       ; allocates space for 3 8-byte integers
        push    r12
        push    r13
        mov     r12,      rdi
        mov     r13,      rsi
        imul    r12,      r13
        mov     rax,      r12
        imul    rax,      rdx
        imul    rax,      rcx
        imul    rax,      r8
        imul    rax,      r9
        imul    rax,      [rbp+16]
        imul    rax,      [rbp+24]
        mov     [rbp-8],  rax
        add     rax,      1
        mov     [rbp-16], rax
        imul    rax,      2
        mov     [rbp-24], rax
        mov     rax,      [rbp-8]
        add     rax,      [rbp-16]
        add     rax,      [rbp-24]
        pop     r13
        pop     r12
        add     rsp,      24       ; remove local variables from the stack
        pop     rbp
        ret
main:
        push    rbp                ; upon entry to main, rsp is misaligned by 8, so this instruction ensures that rsp is 16-byte aligned for printf call
        mov     rbp,      rsp      ; save old rsp in rbp
        mov     rdi,      3        ; arg 1
        mov     rsi,      4        ; arg 2
        mov     rdx,      5        ; arg 3
        mov     rcx,      6        ; arg 4
        mov     r8,       7        ; arg 5
        mov     r9,       8        ; arg 6
        mov     rax,      10
        push    rax                ; arg 8
        mov     rax,      9
        push    rax                ; arg 7
        call    f                  ; the return value will be in rax
        add     rsp,      16       ; remove arg 7 and arg 8 from the stack
        mov     rdi,      fmt      ; arg 1
        mov     rsi,      rax      ; arg 2
        xor     rax,      rax      ; since printf is varargs, so we need to clear rax
        call    printf
        xor     rax,      rax      ; set exit code to zero
        mov     rsp,      rbp      ; restore old rsp
        pop     rbp
        ret

        section .data
fmt:    db      "%d", 10, 0        ; "%d\n\0"
