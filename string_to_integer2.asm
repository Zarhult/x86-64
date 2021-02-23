	NULL            equ     0
    EXIT_SUCCESS    equ     0
    SYS_exit        equ     60

section .data
    strng          db      "+41275"

section .text
global _start
_start:
    ;; -----------
    ;; Algorithm to convert an unsigned string of numbers into an integer
    ;; -----------
    ;; size = length(string)
    ;; iteration = 0
    ;; final_answer = 0
    ;; for char in string:
    ;;     iteration += 1
    ;;     char -= 0x30
    ;;     loop size - iteration times:
    ;;         char *= 10
    ;;     final_answer += char

    nop ; I have no idea why, but gdb won't debug properly without this
    mov rsi, 0

    ;; first, set a sign flag based on first char
    mov r11, 0                  ; sign flag (0 = positive, 1 = negative)
    mov al, byte [strng+rsi]    ; grab first char
    inc rsi
    
    ;; if the string does not start with a negative sign, assume positive
    cmp al, "-"
    jne find_string_size
    mov r11, 1

find_string_size:
    mov al, byte [strng+rsi]    ; al = strng[rsi]
    inc rsi
    cmp al, NULL             ; if strng[rsi] is not NULL:
    jne find_string_size     ;     goto find_string_size for next char
    sub rsi, 2 ; rsi is (digits + 2) after the loop ends and after covering the sign

    ;; rsi now contains the number of digits, so we can begin the conversion
    mov rbx, 1 ; string index (start at 1, after the sign)
    mov rcx, rsi     ; outer loop counter to loop over each digit
    mov r10, 0       ; final answer (rdx would get overwritten by mul, so use r10)

strng_to_integer:
    mov rax, 0       ; must reset rax since use mul in the inner loop
    mov al, byte [strng+rbx]    ; al = strng[rbx]
    inc rbx
    sub al, 0x30                ; convert char to integer

    dec rsi     ; rsi = size - (loop iteration)
    mov r8, rsi ; inner loop counter, so we can preserve the value of rsi
    mov r9, 10  ; for use with mul
start_add_zeroes: ; multiply by 10 until the digit is in the correct ten's place
    cmp r8, 0
    je end_add_zeroes
    mul r9 ; rdx:rax = rax * 10 (assume small enough that rax holds full number)
    dec r8
    jmp start_add_zeroes
end_add_zeroes:
    add r10, rax
    loop strng_to_integer

    ;; finally, negate the result if the negative flag was set
    cmp r11, 0
    je last
    not r10                     ; two's complement
    add r10, 1

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

