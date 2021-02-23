	NULL            equ     0
    EXIT_SUCCESS    equ     0
    SYS_exit        equ     60

section .data
    strng          db      "41275"

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

find_string_size:
    mov al, byte [strng+rsi]    ; al = strng[rsi]
    inc rsi
    cmp al, NULL             ; if strng[rsi] is not NULL:
    jne find_string_size     ;     goto find_string_size for next char
    dec rsi                  ; rsi is size + 1 after the loop ends

    ;; rsi now contains the length of the string
    mov rbx, 0       ; string index
    mov rcx, rsi     ; outer loop counter
    mov r10, 0       ; final answer (rdx would get overwritten by mul)

strng_to_integer:
    mov rax, 0       ; must reset rax since use mul in the inner loop
    mov al, byte [strng+rbx]    ; al = strng[rbx]
    inc rbx
    sub al, 0x30                ; convert char to integer

    dec rsi     ; rsi = size - loop iteration
    mov r8, rsi ; inner loop counter, so we can preserve the value of rsi
    mov r9, 10  ; for use with mul
start_add_zeroes:
    cmp r8, 0
    je end_add_zeroes
    mul r9                      ; al *= 10
    dec r8
    jmp start_add_zeroes
end_add_zeroes:
    add r10, rax
    loop strng_to_integer

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

