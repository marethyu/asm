; nasm -f win64 -o hello_world_win64.obj hello_world_win64.asm
; gcc -g -m64 hello_world_win64.obj -o hello_world_win64.exe

bits 64
default rel

segment .data
    msg db "Hello world!", 0xd, 0xa, 0

segment .text
global main
extern ExitProcess

extern printf

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    lea     rcx, [msg]
    call    printf

    xor     rax, rax
    call    ExitProcess