; $ nasm -f elf64 scanf_ex.asm && gcc -o scanf_ex scanf_ex.o && ./scanf_ex
        bits    64
        global  main
        extern  printf, scanf

        section .text
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16

; printf("Enter n:\n");
        mov     rdi, fmt1
        xor     rax, rax
        call    printf

; scanf("%d", &x);
        mov     rdi, fmt2
        lea     rsi, [rbp - 4] ; store the raw address not the value at that address (pointer)
        xor     rax, rax
        call    scanf

; printf("You entered %d.\n", x);
        mov     rdi, fmt3
        mov     rsi, [rbp - 4]
        xor     rax, rax
        call    printf

        pop     rbp
        mov     rax, 60
        xor     rdi, rdi
        syscall

        section .data
fmt1:   db      "Enter n:", 10, 0
fmt2:   db      "%d", 0
fmt3:   db      "You entered %d.", 10, 0