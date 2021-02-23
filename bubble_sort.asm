    EXIT_SUCCESS    equ     0
    SYS_exit        equ     60

    TRUE            equ     1
    FALSE           equ     0
    
    LIST1_LENGTH    equ     10

section .data

    list1           dd      1, 2, 3, 4, 5, 6, 7, 8, 9, 10

section .text
global _start
_start:
    mov rcx, LIST1_LENGTH       ; outer loop counter
    mov rbx, LIST1_LENGTH       ; inner loop counter (should always be 1 less than outer loop counter)
    sub rbx, 1
    
outer_loop:
    mov rdx, FALSE
    mov rsi, 0                  ; array index

inner_loop:
    mov eax, dword [list1+(rsi*4)] ; compare item at curr index to item at next index
    mov r8d, dword [list1+(rsi*4)+4]
    cmp eax, r8d
    jle end_swap

swap:
    mov dword [list1+(rsi*4)], r8d
    mov dword [list1+(rsi*4)+4], eax
    mov rdx, TRUE
end_swap:

    inc rsi
    cmp rsi, rbx
    jne inner_loop
end_inner_loop:

    cmp rdx, FALSE
    je last         ; skip to end if no swaps occurred in inner loop; sorting is complete
    sub rbx, 1                  ; keep inner loop counter set to outer counter minus 1
    loop outer_loop
end_outer_loop:

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
