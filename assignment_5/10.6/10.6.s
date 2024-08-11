@ echoChar2.s
@ Prompts user to enter a character and echoes it.
@ 2017-09-29: Bob Plantz

@ Define my Raspberry Pi
    .arch armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified     @ modern syntax

@ Useful source code constants
    .equ    STDIN,0
    .equ    STDOUT,1
    .equ    aLetter,-5
    .equ    local,8

@ Constant program data
    .section  .rodata
    .align  2
promptMsg:
    .asciz	 "Enter four characters: "
    .equ    promptLngth,.-promptMsg
responseMsg:
    .asciz	 "You entered: "
    .equ    responseLngth,.-responseMsg
newline:
    .asciz  "\n"

@ Program code
    .text
    .align  2
    .global main
    .type   main, %function
main:
    sub     sp, sp, 8       @ space for fp, lr
    str     fp, [sp, 0]     @ save fp
    str     lr, [sp, 4]     @   and lr
    add     fp, sp, 4       @ set our frame pointer
    sub     sp, sp, 4       @ allocate memory for local var

    mov     r0, #STDOUT     @ STDOUT
    ldr     r1, =promptMsg
    ldr     r2, =promptLngth @ length of the prompt string
    bl      write

    mov     r0, #STDIN      @ STDIN
    add     r1, fp, #-4     @ address of buffer
    mov     r2, #4          @ four chars
    bl      read

    mov     r0, #STDOUT     @ STDOUT
    ldr     r1, =responseMsg
    ldr     r2, =responseLngth @ length of the response string
    bl      write

    mov     r0, #STDOUT     @ STDOUT
    add     r1, fp, #-4     @ address of buffer
    mov     r2, #4          @ four chars
    bl      write

    mov     r0, #STDOUT     @ STDOUT
    ldr     r1, =newline
    mov     r2, #1          @ length of the newline
    bl      write

    mov     r0, #0          @ return 0;
    add     sp, sp, 4       @ deallocate local var
    ldr     fp, [sp, 0]     @ restore caller fp
    ldr     lr, [sp, 4]     @ restore caller lr
    add     sp, sp, 8       @ restore sp
    bx      lr              @ return

write:
    mov     r7, #4          @ syscall number for sys_write
    svc     0
    bx      lr

read:
    mov     r7, #3          @ syscall number for sys_read
    svc     0
    bx      lr

.section .note.GNU-stack,"",%progbits
