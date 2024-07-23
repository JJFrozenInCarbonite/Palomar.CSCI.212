.arch armv7-a               @ Target architecture
.cpu cortex-a72             @ CPU
.fpu neon-fp-armv8          @ Floating point unit version
.text                       @ Code section
.align  2                   @ Align the code on a 4-byte boundary
.global letterA             @ Makes the letterA function globally accessible
.arm
.type   letterA, %function  @ Declares 'letterA' as a function

.section .text
letterA:
    mov r0, #'A             @ Set return value to A
    bx lr                   @ Return from letterA
