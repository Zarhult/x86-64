    EXIT_SUCCESS    equ     0
    SYS_exit        equ     60

section .data

section .text
global _start
_start:


last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall
