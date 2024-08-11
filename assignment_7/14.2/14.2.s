.arch   armv7-a
.cpu    cortex-a72
.fpu    neon-fp-armv8

.section .data
prompt:
    .asciz "Enter alphabetic characters: "
buffer:
    .space 100  @ Allocate 100 bytes for the input buffer
result_msg:
    .asciz "Resulting string: "

.section .text
.global main

main:
    ldr r0, =prompt        @ Load the address of the prompt string
    bl writeStr            @ Call writeStr to print the prompt
    ldr r0, =buffer        @ Load the address of the input buffer
    mov r1, #100           @ Set the maximum number of bytes to read
    bl readLn              @ Call readLn to read the input
    ldr r0, =buffer        @ Load the address of the input buffer again
    bl toLowerCase         @ Call toLowerCase to convert uppercase to lowercase
    ldr r0, =result_msg    @ Load the address of the result_msg string
    bl writeStr            @ Call writeStr to print the result message
    ldr r0, =buffer        @ Load the address of the input buffer again
    bl writeStr            @ Call writeStr to print the modified string
    mov r0, #0             @ exit code 0
    mov r7, #1             @ syscall number for sys_exit
    svc 0                  @ make the syscall

readLn:
    push {lr}              @ Save the link register
    mov r2, r1             @ Move the length to r2
    mov r1, r0             @ Move the buffer address to r1
    mov r7, #3             @ syscall number for sys_read
    mov r0, #0             @ file descriptor 0 (stdin)
    svc 0                  @ make the syscall
    pop {lr}               @ Restore the link register
    bx lr                  @ Return from function

toLowerCase:
    push {lr}              @ Save the link register
    mov r1, r0             @ Move the buffer address to r1

toLowerCase_loop:
    ldrb r2, [r1]          @ Load byte from buffer
    cmp r2, #0             @ Check for null terminator
    beq toLowerCase_done   @ If null terminator, exit loop
    cmp r2, #'A'           @ Compare with 'A'
    blt toLowerCase_next   @ If less than 'A', skip conversion
    cmp r2, #'Z'           @ Compare with 'Z'
    bgt toLowerCase_next   @ If greater than 'Z', skip conversion
    add r2, r2, #32        @ Convert to lowercase by adding 32
    strb r2, [r1]          @ Store the converted character back in buffer

toLowerCase_next:
    add r1, r1, #1         @ Increment buffer pointer
    b toLowerCase_loop     @ Repeat for next character

toLowerCase_done:
    pop {lr}               @ Restore the link register
    bx lr                  @ Return from function

writeStr:
    push {lr}              @ Save the link register
    mov r1, r0             @ Move the string pointer to r1
    mov r2, #0             @ Initialize character count to 0

writeStr_loop:
    ldrb r3, [r1]          @ Load byte from string
    cmp r3, #0             @ Check for null terminator
    beq writeStr_done      @ If null terminator, exit loop
    mov r7, #4             @ syscall number for sys_write
    mov r0, #1             @ file descriptor 1 (stdout)
    mov r2, #1             @ write 1 byte
    svc 0                  @ make the syscall
    add r1, r1, #1         @ Increment string pointer
    b writeStr_loop        @ Repeat for next character

writeStr_done:
    pop {lr}               @ Restore the link register
    bx lr                  @ Return from function

.section .note.GNU-stack,"",%progbits

