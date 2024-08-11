.arch   armv7-a
.cpu    cortex-a72
.fpu    neon-fp-armv8

.section .data
prompt:
    .asciz "Enter a text string: "
buffer:
    .space 100  @ Allocate 100 bytes for the input buffer
length_msg:
    .asciz "Length of the string: "
array_length:
    .asciz "Length of the array: %d\n"

.section .text
.global main

main:
    ldr r0, =prompt        @ Load the address of the prompt string
    bl writeStr            @ Call writeStr to print the prompt
    ldr r0, =buffer        @ Load the address of the input buffer
    bl readLn              @ Call readLn to read the input
    ldr r0, =buffer        @ Load the address of the input buffer again
    bl writeStr            @ Call writeStr to echo the input
    mov r7, #1             @ syscall number for sys_exit
    mov r0, #0             @ exit code 0
    svc 0                  @ make the syscall

readLn:
    push {lr}              @ Save the link register
    sub sp, sp, #4         @ Align stack pointer to 4-byte boundary
    mov r2, #0             @ Initialize character count to 0
    mov r3, r0             @ Save the start of the buffer in r3
    add r4, r0, #100       @ Calculate the end of the buffer (buffer + 100)
    mov r5, #0             @ Initialize character count to 0

readLn_loop:
    cmp r3, r4             @ Compare current buffer pointer with buffer end
    bge readLn_done        @ If buffer is full, exit loop
    mov r7, #3             @ syscall number for sys_read
    mov r0, #0             @ file descriptor 0 (stdin)
    mov r1, sp             @ buffer to store the character
    mov r2, #1             @ read 1 byte
    svc 0                  @ make the syscall
    ldrb r2, [sp]          @ Load the character from the stack
    cmp r2, #10            @ Compare with newline character
    beq readLn_done        @ If newline, exit loop
    strb r2, [r3], #1      @ Store the character in the buffer and increment pointer
    add r3, r3, #1         @ Increment buffer pointer
    add r5, r5, #1         @ Increment character count
    b readLn_loop          @ Repeat for next character

readLn_done:
    mov r2, #0             @ Null terminator
    strb r2, [r3]          @ Store null terminator in the buffer
    mov r0, r5             @ Move the character count to r0
    mov r8, r0             @ Save the character count in r8

    ldr r0, =buffer        @ Load the address of the buffer
    ldr r1, =100           @ Load the buffer size
    bl clear_buffer        @ Call the function to clear the buffer

    ldr r0, =array_length  @ Load the address of the array_length string
    mov r1, r8             @ Move the character count to r1
    bl printf              @ Call printf to print the character count
    mov r0, r8             @ Move the character count to r0 (return value)
    add sp, sp, #4         @ Restore stack pointer
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

clear_buffer:
    push {lr}              @ Save the link register
    mov r2, #0             @ Initialize zero value
clear_buffer_loop:
    cmp r1, #0             @ Check if buffer size is zero
    beq clear_buffer_done  @ If zero, exit loop
    strb r2, [r0], #1      @ Store zero in buffer and increment pointer
    sub r1, r1, #1         @ Decrement buffer size
    b clear_buffer_loop    @ Repeat for next byte
clear_buffer_done:
    pop {lr}               @ Restore the link register
    bx lr                  @ Return from function

.section .note.GNU-stack,"",%progbits
