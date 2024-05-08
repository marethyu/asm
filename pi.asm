;-----------------------------------------------------------------------------------------
;         x86-64 assembly program to print digits of PI using Spigot's Algorithm
;                                    By Jimmy Y.
;
; compile and run:
; $ nasm -f elf64 pi.asm && gcc -no-pie -fno-pie -o pi pi.o && ./pi
;
; debug:
; $ nasm -f elf64 -g -F dwarf pi.asm && gcc -no-pie -fno-pie -o pi pi.o && gdb ./pi
; ----------------------------------------------------------------------------------------

        bits    64
        global  main
        extern  printf, putchar

        section .text
main:
        push    rbp                   ; this is a calle-saved register; since we are going to use it, we need to preserve it (main is also a function!)
        mov     rbp, rsp              ; rbp is a reference point for local variable access
        sub     rsp, 11204            ; allocate space for array of 2801 integers (4 bytes each)
        push    rbx                   ; this is a calle-saved register; since we are going to use it, we need to preserve it

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
        push    rbp
        mov     rbp, rsp
        and     rsp, -16              ; align stack
        mov     rdi, fmt
        mov     esi, eax
        xor     rax, rax
        call    printf
        mov     rsp, rbp              ; restore old rsp
        pop     rbp

        pop     rcx
        sub     ecx, 14
        or      ecx, ecx
        jnz     loop2

; putchar('\n');
        push    rbp
        mov     rbp, rsp
        and     rsp, -16              ; align stack
        mov     rdi, 10
        call    putchar
        mov     rsp, rbp              ; restore old rsp
        pop     rbp

        xor     rax, rax              ; set exit code to 0
        pop     rbx                   ; restore old rbx
        add     rsp, 11204            ; deallocate the array
        pop     rbp
        ret

        section .data
fmt:    db      "%.4d", 0
