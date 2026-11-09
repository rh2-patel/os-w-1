; task2_sum.asm - fill an array with 1..100 and sum it
;
; C equivalent:
;   int array[100];
;   for (i = 0; i < 100; i++) array[i] = i + 1;
;   sum = 0;
;   for (i = 0; i < 100; i++) sum += array[i];
;   printf("%d\n", sum);

%include "asm_io.inc"

ARRAY_LEN equ 100

segment .data
msg     db  "Sum of 1..100 = ", 0

segment .bss
array   resd ARRAY_LEN          ; 100 doublewords (4 bytes each)

segment .text
global asm_main
asm_main:
    enter   0, 0
    pusha

    ; ---- initialise: array[i] = i + 1 ----
    xor     ecx, ecx            ; ecx = i = 0
.init_loop:
    cmp     ecx, ARRAY_LEN
    jge     .init_done          ; leave when i >= 100
    lea     eax, [ecx + 1]      ; eax = i + 1
    mov     [array + ecx*4], eax
    inc     ecx
    jmp     .init_loop
.init_done:

    ; ---- sum the array ----
    xor     eax, eax            ; eax = sum = 0
    xor     ecx, ecx            ; ecx = i = 0
.sum_loop:
    cmp     ecx, ARRAY_LEN
    jge     .sum_done
    add     eax, [array + ecx*4]
    inc     ecx
    jmp     .sum_loop
.sum_done:
    mov     ebx, eax            ; keep the sum while we print the label

    mov     eax, msg
    call    print_string
    mov     eax, ebx
    call    print_int
    call    print_nl

    popa
    mov     eax, 0
    leave
    ret
