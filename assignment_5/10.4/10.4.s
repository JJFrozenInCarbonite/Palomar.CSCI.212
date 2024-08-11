.fpu    neon-fp-armv8
    .syntax unified             @ modern syntax

.section .data
input_buffer:
    .space 100                  @ buffer to store user input (100 bytes)
prompt_string:
    .asciz "What is your name?\n" @ prompt string to be printed with a newline
hello_string:
    .asciz "Hello, "            @ string to be printed before user input

.section .bss
buffer_size = 100               @ size of the input buffer

.section .text

.global main

main:
    @ Write "What is your name?\n" to stdout
    ldr r0, =1                  @ file descriptor 1 (stdout)
    ldr r1, =prompt_string      @ address of the prompt string
    mov r2, #19                 @ length of the prompt string (including newline)
    mov r7, #4                  @ syscall number for sys_write
    svc #0                      @ make the syscall to write the prompt string

    @ Read user input
    mov r0, #0                  @ file descriptor 0 (stdin)
    ldr r1, =input_buffer       @ address of the input buffer
    mov r2, #100                @ number of bytes to read
    mov r7, #3                  @ syscall number for sys_read
    svc #0                      @ make the syscall to read user input

    @ Write "Hello, " to stdout
    ldr r0, =1                  @ file descriptor 1 (stdout)
    ldr r1, =hello_string       @ address of the hello string
    mov r2, #7                  @ length of the hello string
    mov r7, #4                  @ syscall number for sys_write
    svc #0                      @ make the syscall to write the hello string

    @ Write user input to stdout
    ldr r0, =1                  @ file descriptor 1 (stdout)
    ldr r1, =input_buffer       @ address of the input buffer
    mov r2, #100                @ number of bytes to write
    mov r7, #4                  @ syscall number for sys_write
    svc #0                      @ make the syscall to write the user input

.section .note.GNU-stack,"",%progbits
