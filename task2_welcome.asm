; task2_welcome.asm - ask for a name and a count, then print a welcome
; message that many times.  The count must be greater than 50 and less
; than 100 (i.e. 51..99), otherwise an error message is printed.
;
; C equivalent:
;   read name; read n;
;   if (n <= 50)       puts("too small");
;   else if (n >= 100) puts("too large");
;   else for (i = n; i != 0; i--) printf("Welcome, %s!\n", name);

%include "asm_io.inc"

NAME_MAX equ 63                 ; longest name we store (plus the NUL)

segment .data
prompt_name  db "Enter your name: ", 0
prompt_count db "How many times should I print the welcome message? ", 0
welcome1     db "Welcome, ", 0
welcome2     db "!", 0
err_small    db "Error: the number must be greater than 50.", 0
err_large    db "Error: the number must be less than 100.", 0

segment .bss
user_name    resb NAME_MAX + 1

segment .text
global asm_main
asm_main:
    enter   0, 0
    pusha

    ; ---- read the name, one character at a time, up to the newline ----
    mov     eax, prompt_name
    call    print_string

    xor     ebx, ebx                    ; ebx = number of characters stored
.read_name:
    call    read_char
    cmp     eax, 10                     ; newline ends the name
    je      .name_done
    cmp     eax, -1                     ; so does end of input
    je      .name_done
    cmp     ebx, NAME_MAX               ; buffer full? throw the rest away
    jae     .read_name
    mov     [user_name + ebx], al
    inc     ebx
    jmp     .read_name
.name_done:
    mov     byte [user_name + ebx], 0   ; terminate the string

    ; ---- read the count and validate it ----
    mov     eax, prompt_count
    call    print_string
    call    read_int
    mov     ecx, eax                    ; ecx = n (also the loop counter)

    cmp     ecx, 50
    jle     .too_small                  ; n <= 50
    cmp     ecx, 100
    jge     .too_large                  ; n >= 100

    ; ---- print the welcome message n times ----
.loop_top:
    mov     eax, welcome1
    call    print_string
    mov     eax, user_name
    call    print_string
    mov     eax, welcome2
    call    print_string
    call    print_nl
    dec     ecx
    jnz     .loop_top
    jmp     .finish

.too_small:
    mov     eax, err_small
    call    print_string
    call    print_nl
    jmp     .finish

.too_large:
    mov     eax, err_large
    call    print_string
    call    print_nl

.finish:
    popa
    mov     eax, 0
    leave
    ret
