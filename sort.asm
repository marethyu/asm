; hand-compiled assembly for sort.c
; usage: first, input the number of array elements n. then, input each element. the output will be the sorted array
; run:   nasm -f elf64 sort.asm && gcc -no-pie -fno-pie -o sort sort.o && ./sort
; debug: nasm -f elf64 -g -F dwarf sort.asm && gcc -no-pie -fno-pie -o sort sort.o && gdb ./sort

        bits    64
        global  main
        extern  printf
        extern  scanf
        extern  malloc

        section .text
sort:
        push    rbp
        mov     rbp,         rsp
        push    rbx

        mov     rbx,         rdi
        mov     r8,          0               ; array index 'i'
outer:
        cmp     r8,          rsi
        je      quit_outer

        mov     rax,         [rbx+r8*8]      ; min element
        mov     rcx,         r8              ; index of the min element

        mov     r9,          r8              ; array index 'j'
        inc     r9
inner:
        cmp     r9,          rsi
        je      quit_inner

        cmp     rax,         [rbx+r9*8]
        jle     no_sorry
        mov     rax,         [rbx+r9*8]
        mov     rcx,         r9
no_sorry:

        inc     r9
        jmp     inner
quit_inner:

; swap
        mov     r10,         [rbx+r8*8]
        mov     r11,         [rbx+rcx*8]
        mov     [rbx+r8*8],  r11
        mov     [rdi+rcx*8], r10

        inc     r8
        jmp     outer
quit_outer:

        pop     rbx
        mov     rsp,         rbp
        pop     rbp
        ret
main:
        push    rbp                          ; upon entry to main, rsp is misaligned by 8, so this instruction ensures that rsp is 16-byte aligned
        mov     rbp,         rsp             ; save old rsp in rbp
        sub     rsp,         8               ; make space for 8-byte integer 'n'
        push    rbx

        mov     rdi,         fmt1            ; arg 1
        lea     rsi,         [rbp-8]         ; arg 2
        xor     rax,         rax             ; scanf is varargs
        call    scanf

        mov     rax,         8
        imul    rax,         [rbp-8]
        mov     rdi,         rax             ; rax stores number of bytes to allocate
        call    malloc                       ; base address of newly allocated array of size n will be stored in rax

; read input to the array
        mov     rbx,         rax
        mov     rcx,         0               ; rcx is array index
loop1:
        cmp     rcx,         [rbp-8]
        je      quit_loop1
        push    rcx
        sub     rsp,         8               ; stack align
        mov     rdi,         fmt1            ; arg 1
        lea     rsi,         [rbx+rcx*8]     ; arg 2
        xor     rax,         rax             ; scanf is varargs
        call    scanf
        add     rsp,         8
        pop     rcx
        inc     rcx
        jmp     loop1
quit_loop1:

; now sort the array
        mov     rdi,         rbx
        mov     rsi,         [rbp-8]
        call    sort

; output the array
        mov     rcx,         0
loop2:
        cmp     rcx,         [rbp-8]
        je      quit_loop2
        push    rcx
        sub     rsp,         8               ; stack align
        mov     rdi,         fmt2            ; arg 1
        mov     rsi,         [rbx+rcx*8]     ; arg 2
        xor     rax,         rax             ; printf is varargs
        call    printf
        add     rsp,         8
        pop     rcx
        inc     rcx
        jmp     loop2
quit_loop2:

        xor     rax,         rax             ; set exit code to zero
        pop     rbx
        add     rsp,         8               ; remove 'n'
        mov     rsp,         rbp             ; restore old rsp
        pop     rbp
        ret

        section .data
fmt1:   db      "%d", 0                   ; "%d\0"
fmt2:   db      "%d", 10, 0               ; "%d\n\0"
