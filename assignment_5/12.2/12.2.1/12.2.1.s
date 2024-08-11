.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8

.section .text
.global main

main:
    mov r0, #1           @ STDOUT
    ldr r1, =numerals    @ Address of the numerals string
    bl display_string    @ Call the display_string function

    mov r7, #1           @ syscall number for sys_exit
    mov r0, #0           @ exit code 0
    svc 0                @ make the syscall

display_string:
    push {lr}            @ Save the link register
    mov r2, #1           @ Length of one character

display_loop:
    ldrb r3, [r1], #1    @ Load the current numeral into r3 and increment r1
    cmp r3, #0           @ Check if we have reached the end of the string
    beq end_display      @ If yes, exit the loop

    mov r7, #4           @ syscall number for sys_write
    mov r0, #1           @ STDOUT
    mov r2, #1           @ Length of one character
    svc 0                @ make the syscall

    b display_loop       @ Continue the loop

end_display:
    ldr r1, =newline     @ Address of the newline character
    mov r2, #1           @ Length of one character
    mov r7, #4           @ syscall number for sys_write
    mov r0, #1           @ STDOUT
    svc 0                @ make the syscall

    pop {lr}             @ Restore the link register
    bx lr                @ Return from the function

.section .data
numerals:
    .asciz "0123456789"  @ Define a string of numerals
newline:
    .asciz "\n"          @ Define a newline character

.section .note.GNU-stack,"",%progbits
