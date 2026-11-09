; task1.asm - lecture slide 18
; Add two integers stored in global memory (.data), keep the result in
; global memory (.bss) and print it with print_int.

%include "asm_io.inc"

segment .data
integer1    dd  15              ; first int  (initialised global)
integer2    dd  6               ; second int (initialised global)

segment .bss
result      resd 1              ; result (uninitialised global)

segment .text
    global asm_main
asm_main:
    enter   0, 0                ; set up the stack frame
    pusha                       ; save all general purpose registers

    mov     eax, [integer1]     ; eax = int1
    add     eax, [integer2]     ; eax = int1 + int2
    mov     [result], eax       ; result = int1 + int2
    call    print_int           ; print result (print_int prints eax)
    call    print_nl            ; new line

    popa                        ; restore registers
    mov     eax, 0              ; return 0 to the C driver
    leave
    ret
