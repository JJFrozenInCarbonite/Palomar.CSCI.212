.arch   armv7-a
.cpu    cortex-a72
.fpu    neon-fp-armv8

.section .data
prompt:
    .asciz "Enter a text string: "
string_prefix:
    .asciz "String: "
buffer:
    .space 100  @ Allocate 100 bytes for the input buffer
length_msg:
    .asciz "String Length: %d\n"
array_length:
    .asciz "Array Length: %d\n"
newline:
    .asciz "\n"  @ Newline character for clean output
max_length:
    .word 10    @ Set max_length to 10 characters (excluding null terminator)

.section .text
.global main

main:
    ldr r0, =prompt        @ Load the address of the prompt string
    bl writeStr            @ Call writeStr to print the prompt
    ldr r0, =buffer        @ Load the address of the input buffer
    ldr r1, =max_length    @ Load the address of max_length
    ldr r1, [r1]           @ Load the value of max_length into r1
    bl readLn              @ Call readLn to read the input with max_length

    ldr r0, =string_prefix @ Load the address of the string prefix "String: "
    bl writeStr            @ Print "String: "
    ldr r0, =buffer        @ Load the address of the input buffer
    bl writeStr            @ Call writeStr to echo the input

    ldr r0, =newline       @ Print a newline after the echoed string
    bl writeStr            @ To ensure clean output, print a newline

    ldr r0, =length_msg    @ Load the address of the length_msg string
    mov r1, r8             @ Move the character count to r1 (no addition here, length should exclude null terminator)
    bl printf              @ Call printf to print the string length

    ldr r0, =array_length  @ Load the address of the array_length string
    cmp r8, #10            @ Compare r8 (character count) with 10
    movle r1, r8           @ If r8 < 10, set r1 to r8 (array length without null terminator)
    movge r1, #10          @ If r8 >= 10, set r1 to 10 (array length fixed to 10)
    bl printf              @ Call printf to print the array length

    cmp r8, #10            @ Check if the input length is 10 or more characters
    blt skip_discard       @ If less than 10, skip the discard logic
    bl discard_extra       @ If 10 or more, call discard_extra to flush any remaining input

skip_discard:
    mov r0, #0             @ exit code 0
    mov r7, #1             @ syscall number for sys_exit
    svc 0                  @ make the syscall

readLn:
    push {lr}              @ Save the link register
    sub sp, sp, #4         @ Align stack pointer to 4-byte boundary
    mov r6, r1             @ Load max_length into r6
    mov r2, #0             @ Initialize character count to 0
    mov r3, r0             @ Set the buffer pointer (r0 points to buffer)
    add r4, r0, #100       @ Calculate the end of the buffer (buffer + 100)
    mov r5, #0             @ Initialize character count to 0

readLn_loop:
    cmp r5, r6             @ Compare character count with max_length
    bge readLn_done        @ If limit reached, exit loop
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
    strb r2, [r3]          @ Store the character in the buffer
    add r3, r3, #1         @ Increment buffer pointer
    add r5, r5, #1         @ Increment character count
    b readLn_loop          @ Repeat for next character

readLn_done:
    mov r2, #0             @ Null terminator
    strb r2, [r3]          @ Store null terminator in the buffer
    mov r8, r5             @ Save the character count in r8 (this should be the correct length)
    add sp, sp, #4         @ Restore stack pointer
    pop {lr}               @ Restore the link register
    bx lr                  @ Return from function

discard_extra:
    push {lr}              @ Save the link register
    sub sp, sp, #4         @ Allocate space for the discard buffer
    mov r7, #3             @ syscall number for sys_read
    mov r0, #0             @ file descriptor 0 (stdin)
    add r1, sp, #0         @ Use the allocated space as the discard buffer
    mov r2, #1             @ Read 1 byte at a time

discard_loop:
    svc 0                  @ Make the syscall to read 1 byte
    cmp r0, #1             @ Check if 1 byte was read
    bne discard_done       @ If not, exit loop (no more data to read)
    ldrb r3, [sp]          @ Load the character from the discard buffer
    cmp r3, #10            @ Compare with newline character
    beq discard_done       @ If newline, exit loop (end of line)
    b discard_loop         @ Continue discarding any remaining characters

discard_done:
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
