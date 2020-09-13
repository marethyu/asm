;-----------------------------------------------------------------------------------------
;         x86-64 assembly program to print digits of PI using Spigot's Algorithm
;                                    By Jimmy Y.
;
; compile and run:
; $ nasm -f elf64 pi.asm && gcc -m64 -o pi pi.o && ./pi
;
; debug:
; $ nasm -f elf64 -g -F dwarf  pi.asm && gcc -m64 -o pi pi.o && gdb ./pi
; ----------------------------------------------------------------------------------------

        bits    64
        global  main
        extern  printf, putchar

        section .text
main:
        push    rbp
        push    rbx
        mov     rbp, rsp
        sub     rsp, 11216

        mov     r12d, 10000           ; int a = 10000;
        xor     r13d, r13d            ; int e = 0;

        lea     rbx, [rbp - 2801 * 4] ; int f[2801];

; while (b < c) {
;     f[b] = a / 5;
;     b++;
; }
        xor     ecx, ecx
loop1:
        mov     dword[rbx + rcx * 4], 2000
        inc     ecx
        cmp     ecx, 2800
        jl      loop1

; while (c) {
loop2:
; g = c * 2;
        mov     r14d, ecx
        add     r14d, r14d

        xor     r15d, r15d            ; d = 0;
        push    rcx                   ; b = c;

; while (1) {
loop3:
; d += f[b] * a;
        mov     eax, dword[rbx + rcx * 4]
        imul    eax, r12d
        add     r15d, eax

        dec     r14d                  ; g--;

; f[b] = d % g;
        mov     eax, r15d
        cdq
        idiv    r14d
        mov     dword[rbx + rcx * 4], edx

        mov     r15d, eax             ; d /= g;

        dec     r14d                  ; g--;
        dec     ecx                   ; b--;

; if (b == 0) {
;     break;
; }
        cmp     ecx, 0
        je      loop3_end

        imul    r15d, ecx             ; d *= b;

        jmp     loop3
loop3_end:
; d / a
        mov     eax, r15d
        cdq
        idiv    r12d

        add     eax, r13d             ; e + d / a
        mov     r13d, edx             ; e = d % a;

; printf("%.4d", e + d / a);
        mov     rdi, fmt
        mov     esi, eax
        xor     rax, rax
        call    printf

        pop     rcx
        sub     ecx, 14
        or      ecx, ecx
        jnz     loop2

; putchar('\n');
        mov     rdi, 10
        call    putchar

        pop     rbx
        pop     rbp
        mov     rax, 60
        xor     rdi, rdi
        syscall

        section .data
fmt:    db      "%.4d", 0