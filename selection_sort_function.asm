;;; I absolutely cannot believe this worked on the first try.

    EXIT_SUCCESS    equ     0
    SYS_exit        equ     60

section .data
    lst1            dd      501, 23, -59, 0, -209
    len1            dd      5

    lst2            dd      0, 0, 0
    len2            dd      3

    lst3            dd      10, 9, 8, 7, 6, 5, 4, 3, 2, 1
    len3            dd      11

section .text

;;; Function to sort an array of dwords using selection sort
;;; C-like call:
;;;     selection_sort(arr, len);
;;; -----
;;; Arguments:
;;;     arr (array address) - rdi
;;;     len (array length) - esi
;;; Algorithm:
;;;     for i = 0 to len-1
;;;         small = arr[i]
;;;         index = i
;;;         for j = i to len-1
;;;             if(arr[j] < small)
;;;                 small = arr[j]
;;;                 index = j
;;;         arr[index] = arr[i]
;;;         arr[i] = small

global selection_sort
selection_sort:
    ;; Function prologue: preserve values of rbx, r12, and r13
    push rbx
    push r12
    push r13

    ;; Function body: selection sort
    mov r10d, 0                 ; r10d = i

outer_loop:
    mov r11d, dword [rdi+(r10*4)] ; r11d = small
    mov ebx, r10d                 ; ebx = index
    mov r12d, r10d                ; r12d = j
inner_loop:
    mov r13d, dword [rdi+(r12*4)] ; r13d = arr[j]
    cmp r13d, r11d
    jge end_if

    mov r11d, r13d
    mov ebx, r12d
end_if:
    inc r12d
    cmp r12d, esi
    jne inner_loop

    mov r13d, dword [rdi+(r10*4)]
    mov dword [rdi+(rbx*4)], r13d
    mov dword [rdi+(r10*4)], r11d

    inc r10d
    cmp r10d, esi
    jne outer_loop

    ;; Function epilogue: restore registers and return
    pop r13
    pop r12
    pop rbx
    ret

global _start
_start:
    ;; selection_sort(lst1, len1)
    mov rdi, lst1
    mov esi, dword [len1]
    call selection_sort

    ;; selection_sort(lst2, len2)
    mov rdi, lst2
    mov esi, dword [len2]
    call selection_sort

    ;; selection_sort(lst3, len3)
    mov rdi, lst3
    mov esi, dword [len3]
    call selection_sort

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


