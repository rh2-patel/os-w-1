; task2_range.asm - fill an array with 1..100, ask for a range, and sum
; just that part of the array.  The range is given as 1-based, inclusive
; start and end values, and must satisfy 1 <= start <= end <= 100.
;
; C equivalent:
;   if (start < 1 || end > 100 || start > end) error;
;   for (i = start - 1; i < end; i++) sum += array[i];

%include "asm_io.inc"

ARRAY_LEN equ 100

segment .data
prompt_start db "Enter the start of the range (1-100): ", 0
prompt_end   db "Enter the end of the range (1-100): ", 0
err_msg      db "Error: the range must satisfy 1 <= start <= end <= 100.", 0
result1      db "Sum of array elements ", 0
result2      db " to ", 0
result3      db " = ", 0

segment .bss
array   resd ARRAY_LEN

segment .text
global asm_main
asm_main:
    enter   0, 0
    pusha

    ; ---- array[i] = i + 1 ----
    xor     ecx, ecx
.init_loop:
    cmp     ecx, ARRAY_LEN
    jge     .init_done
    lea     eax, [ecx + 1]
    mov     [array + ecx*4], eax
    inc     ecx
    jmp     .init_loop
.init_done:

    ; ---- read the range: esi = start, edi = end ----
    mov     eax, prompt_start
    call    print_string
    call    read_int
    mov     esi, eax

    mov     eax, prompt_end
    call    print_string
    call    read_int
    mov     edi, eax

    ; ---- validate ----
    cmp     esi, 1
    jl      .invalid            ; start < 1
    cmp     edi, ARRAY_LEN
    jg      .invalid            ; end > 100
    cmp     esi, edi
    jg      .invalid            ; start > end

    ; ---- sum array[start-1 .. end-1] ----
    xor     eax, eax            ; eax = sum
    lea     ecx, [esi - 1]      ; ecx = i = start - 1 (0-based index)
.sum_loop:
    cmp     ecx, edi            ; i < end ?
    jge     .sum_done
    add     eax, [array + ecx*4]
    inc     ecx
    jmp     .sum_loop
.sum_done:
    mov     ebx, eax            ; keep the sum

    mov     eax, result1
    call    print_string
    mov     eax, esi
    call    print_int
    mov     eax, result2
    call    print_string
    mov     eax, edi
    call    print_int
    mov     eax, result3
    call    print_string
    mov     eax, ebx
    call    print_int
    call    print_nl
    jmp     .finish

.invalid:
    mov     eax, err_msg
    call    print_string
    call    print_nl

.finish:
    popa
    mov     eax, 0
    leave
    ret
