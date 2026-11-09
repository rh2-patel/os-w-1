; task1_2.asm - lecture slide 22
; Read two integers from the keyboard and print their sum:
;   "The sum of <int1> and <int2> is: <result>"

%include "asm_io.inc"

segment .data
msg1        db  "Enter a number: ", 0
msg2        db  "The sum of ", 0
msg3        db  " and ", 0
msg4        db  " is: ", 0

segment .bss
integer1    resd 1              ; first integer
integer2    resd 1              ; second integer
result      resd 1              ; result

segment .text
    global asm_main
asm_main:
    enter   0, 0
    pusha

    mov     eax, msg1           ; note that this is a pointer!
    call    print_string
    call    read_int            ; read the first integer (returned in eax)
    mov     [integer1], eax     ; store it in memory

    mov     eax, msg1           ; same prompt again
    call    print_string
    call    read_int            ; read the second integer
    mov     [integer2], eax     ; store it in memory

    mov     eax, [integer1]     ; eax = first integer
    add     eax, [integer2]     ; eax += second integer
    mov     [result], eax       ; store the result

    mov     eax, msg2           ; note that this is a pointer
    call    print_string
    mov     eax, [integer1]     ; note that this is a value
    call    print_int
    mov     eax, msg3           ; pointer
    call    print_string
    mov     eax, [integer2]     ; value
    call    print_int
    mov     eax, msg4           ; pointer
    call    print_string
    mov     eax, [result]       ; value
    call    print_int
    call    print_nl

    popa
    mov     eax, 0
    leave
    ret
