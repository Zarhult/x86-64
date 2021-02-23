    EXIT_SUCCESS    equ     0
    SYS_exit        equ     60

%macro doubledlist 2 ; %1 is first element, %2 is list size (both in memory)
    mov ecx, dword [%2]         ; loop counter
    mov rsi, 0                  ; list index
    mov ebx, 2                  ; for use with imul
%%lp:
    mov rax, 0                  ; since imul alters upper dword of rax
    mov eax, dword [%1+(rsi*4)] ; *4 for dword
    imul ebx
    mov dword [%1+(rsi*4)], eax
    inc rsi
    loop %%lp
%endmacro

section .data
    lst1            dd      501, 23, -59, 0, -209
    len1            dd      5

    lst2            dd      0, 0, 0
    len2            dd      3

    lst3            dd      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    len3            dd      11

section .text
global _start
_start:
    doubledlist lst1, len1
    doubledlist lst2, len2
    doubledlist lst3, len3

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

