@ doNothingProg2.s
@ Minimum components of a C program, in assembly language.
@ 2017-09-29: Bob Plantz 

@ Define my Raspberry Pi
        .cpu    cortex-a72
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Program code
        .text
        .align  2
        .global main
        .type   main, %function
main:
        str     fp, [sp, -4]!   @ save caller frame pointer
        add     fp, sp, 0       @ establish our frame pointer

        mov     r3, 1           @ return 1;
        mov     r0, r3          @ return values go in r0

        sub     sp, fp, 0       @ restore stack pointer
        ldr     fp, [sp], 4     @ restore caller's frame pointer
        bx      lr              @ back to caller

.section .note.GNU-stack,"",%progbits
