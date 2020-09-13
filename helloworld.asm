;--------------------------------------
;
;       helloworld.asm
;
; compile and run:
; $ nasm -f elf64 helloworld.asm && ld -s -o helloworld helloworld.o && ./helloworld
;--------------------------------------

        bits    64
        global  _start

        section .text
_start: 
        mov     rax, 1      ; system call number for write (64-bit)
        mov     rdi, 1      ; file descriptor = stdout
        mov     rsi, msg    ; copy the address of string 'msg' to output
        mov     rdx, len    ; copy number of bytes
        syscall             ; invoke OS to write
        mov     rax, 60     ; system call number for exit (64-bit)
        xor     rdi, rdi    ; exit status = 0
        syscall             ; invoke OS to exit

        section .data
msg:    db      "Hello world!", 10
len:    equ     $-msg