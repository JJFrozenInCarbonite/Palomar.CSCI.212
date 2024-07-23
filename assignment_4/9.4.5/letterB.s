.arch armv7-a               @ Target architecture
.cpu cortex-a72             @ CPU
.fpu neon-fp-armv8          @ Floating point unit version
.text                       @ Code section
.align  2                   @ Align the code on a 4-byte boundary
.global letterB             @ Makes the letterB function globally accessible
.arm
.type   letterB, %function  @ Declares 'letterB' as a function

.section .text
letterB:
    mov r0, #'B             @ Set return value to B
    bx lr                   @ Return from letterB
