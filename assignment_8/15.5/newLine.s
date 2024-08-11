@ newLine.s
@ Writes a newline character to the standard output (screen).
@ Calling sequence:
@       bl    newLine
@ 2017-09-29: Bob Plantz

@ Define my Raspberry Pi
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Useful source code constants
        .equ    STDOUT,1

@ Constant program data
        .section .rodata
        .align   2
theChar:
        .ascii        "\n"

@ The code
        .text
        .align  2
        .global newLine
        .type   newLine, %function
newLine:
        sub     sp, sp, 8       @ space for fp, lr
        str     fp, [sp, 0]     @ save fp
        str     lr, [sp, 4]     @   and lr
        add     fp, sp, 4       @ set our frame pointer

        mov     r0, STDOUT      @ write to screen
        ldr     r1, theCharAddr @ address of newline char
        mov     r2, 1           @ write 1 byte
        bl      write

        mov     r0, 0           @ return 0;
        ldr     fp, [sp, 0]     @ restore caller fp
        ldr     lr, [sp, 4]     @       lr
        add     sp, sp, 8       @   and sp
        bx      lr              @ return

theCharAddr:
        .word   theChar

.section .note.GNU-stack,"",%progbits
