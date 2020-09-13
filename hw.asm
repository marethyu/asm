; hw.asm
;
; compile: nasm -f elf64 hw.asm && gcc -o hw hw.o && ./hw

        global    main
        extern    puts

        section   .text
main:                                     ; This is called by the C library startup code
        push      rbp                     ; Call stack must be aligned
        mov       rdi, msg                ; First integer (or pointer) argument in rdi
        call      puts                    ; puts(msg)
        pop       rbp                     ; Fix up stack before returning
        ret                               ; Return from main back into C library wrapper

        section   .data
msg:    db        "Hello world!", 10, 0   ; Note strings must be terminated with 0 in C