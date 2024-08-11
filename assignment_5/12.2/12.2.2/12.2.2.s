.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8

.global main

main:
    mov r0, #1           @ STDOUT
    mov r4, #'A'         @ Start with the letter 'A'
    mov r5, #'Z'         @ End with the letter 'Z'
    ldr r3, =char_buffer @ Load the address of the character buffer

display_loop:
    cmp r4, r5           @ Compare current letter with 'Z'
    bgt end_display      @ If current letter is greater than 'Z', exit loop

    strb r4, [r3]        @ Store the current letter in the buffer
    mov r7, #4           @ syscall number for sys_write
    mov r1, r3           @ Address of the character buffer
    mov r2, #1           @ Length of one character
    svc 0                @ make the syscall

    add r4, r4, #1       @ Move to the next letter
    b display_loop       @ Continue the loop

end_display:
    ldr r1, =newline     @ Address of the newline character
    mov r2, #1           @ Length of one character
    mov r7, #4           @ syscall number for sys_write
    mov r0, #1           @ STDOUT
    svc 0                @ make the syscall

    mov r7, #1           @ syscall number for sys_exit
    mov r0, #0           @ exit code 0
    svc 0                @ make the syscall

.section .data
char_buffer:
    .byte 0              @ Buffer to hold the current character
newline:
    .asciz "\n"          @ Define a newline character

.section .note.GNU-stack,"",%progbits
