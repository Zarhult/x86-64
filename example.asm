    EXIT_SUCCESS    equ     0
    SYS_exit        equ     60

section .data
    lst1            dd      501, 23, -59, 0, -209
    len1            dd      5

    lst2            dd      0, 0, 0
    len2            dd      3

    lst3            dd      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    len3            dd      11

section .text
; Function to sort an array of dwords using selection sort
; C-like call: 
;  selection_sort(arr, len);
; -----
; Arguments:
;  arr (array address) - rdi
;  len (array length) - esi
global selection_sort
selection_sort:
   ; No function prologue necessary since no local variables,
   ; no stack arguments, and no altering of preserved registers


global _start
_start:

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


