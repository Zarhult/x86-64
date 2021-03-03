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

selection_sort_outer_loop:
    mov r11d, dword [rdi+(r10*4)] ; r11d = small
    mov ebx, r10d                 ; ebx = index
    mov r12d, r10d                ; r12d = j
selection_sort_inner_loop:
    mov r13d, dword [rdi+(r12*4)] ; r13d = arr[j]
    cmp r13d, r11d
    jge selection_sort_end_if

    mov r11d, r13d
    mov ebx, r12d
selection_sort_end_if:
    inc r12d
    cmp r12d, esi
    jne selection_sort_inner_loop

    mov r13d, dword [rdi+(r10*4)]
    mov dword [rdi+(rbx*4)], r13d
    mov dword [rdi+(r10*4)], r11d

    inc r10d
    cmp r10d, esi
    jne selection_sort_outer_loop

    ;; Function epilogue: restore registers and return
    pop r13
    pop r12
    pop rbx
    ret
;;; Function to calculate approx unsigned integer square root of a dword
;;; C-like call:
;;;     sqrt(num);
;;; -----
;;; Arguments:
;;;     num (value to take square root of) - edi
;;; Return value:
;;;     approximate integer square root of num - rax
;;; Algorithm:
;;;     result = num;
;;;     loop 50 times:
;;;         result = ((num/result)+result)/2

global sqrt
sqrt:
    ;; Function prologue: unnecessary since no stack arguments,
    ;; function local variables, or use of preserved registers

    ;; Function body:
    mov r10, 50                 ; loop counter
    mov ecx, edi                ; final result
sqrt_loop:
    ;; prepare dx:ax for divison (dx:ax = edi),
    ;; with the rest of rdx and rax zeroed out
    mov rax, 0
    mov edx, edi
    shr edx, 16
    mov ax, di

    div ecx                     ; ax = num/result
    add eax, ecx                ; eax = (num/result)+result
    shr eax, 1                  ; rax = ((num/result)+result)/2
    mov ecx, eax                ; result = ((num/result)+result)/2
    
    dec r10
    cmp r10, 0
    jne sqrt_loop

    mov eax, ecx                ; return final answer

    ret                         ; Function epilogue: need only return
    
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

    ;; sqrt(lst1[4])
    ;; aka, sqrt(501) after the sort
    mov edi, dword [lst1+(4*4)]
    call sqrt

last:
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall


