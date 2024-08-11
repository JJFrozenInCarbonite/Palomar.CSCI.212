.arch armv7-a
.cpu    cortex-a72
.fpu    neon-fp-armv8

.section .data
hello_world:
    .asciz "Hello world\n"

.section .text
.global main

main:
    ldr r0, =hello_world  @ Load the address of the string
    bl writeStr           @ Call writeStr function
    mov r7, #1            @ syscall number for sys_exit
    mov r0, #0            @ exit code 0
    svc 0                 @ make the syscall

writeStr:
    push {lr}             @ Save the link register
    mov r1, r0            @ Move the string pointer to r1
    mov r2, #0            @ Initialize character count to 0

writeStr_loop:
    ldrb r3, [r1]         @ Load byte from string
    cmp r3, #0            @ Check if end of string (null terminator)
    beq writeStr_done     @ If end of string, exit loop
    add r1, r1, #1        @ Increment pointer
    add r2, r2, #1        @ Increment character count
    b writeStr_loop       @ Repeat for next character

writeStr_done:
    sub r1, r1, r2        @ Reset r1 to the start of the string
    mov r0, #1            @ STDOUT file descriptor
    mov r7, #4            @ syscall number for sys_write
    svc 0                 @ make the syscall
    mov r0, r2            @ Move character count to r0 (return value)
    pop {lr}              @ Restore the link register
    bx lr                 @ Return from function

.section .note.GNU-stack,"",%progbits
