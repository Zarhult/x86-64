    EXIT_SUCCESS    equ     0
    SYS_exit        equ     60

    TRUE            equ     1
    FALSE           equ     0

section .data
    testString      dq      "hannnnah"
    STRINGLEN       equ     8

section .text
global _start
_start:
    mov rcx, STRINGLEN          ; loop counter
    mov rdx, TRUE               ; is testString a palindrome?

lp1:                            ; push string to stack starting from the end
    push qword [testString+rcx-1]
    loop lp1

    mov rcx, STRINGLEN
    ;; only need to loop through the first half of the string to verify if it's a palindrome,
    ;; so now we use a separate register for the string index, and half of the string
    ;; length for the loop counter
    mov rbx, rcx
    shr rcx, 1

lp2:                            ; find out if string is a palindrome
    pop rax
    cmp al, byte [testString+rbx-1] 
    je end_not_palindrome               

    mov rdx, FALSE
    jmp last
end_not_palindrome:
    ;; now must manually decrement string index each loop since loop counter and string index
    ;; have been separated
    dec rbx
    loop lp2

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
