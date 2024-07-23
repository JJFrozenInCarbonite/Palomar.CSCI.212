.arch armv7-a               @ Target architecture
.cpu cortex-a72            @ CPU
.fpu neon-fp-armv8         @ Floating point unit version
.text                      @ Code section
.align  2                  @ Align the code on a 4-byte boundary
.global number2               @ Makes the number2 function globally accessible
.arm
.type   number2, %function    @ Declares 'number2' as a function

.section .text
number2:
    mov r0, #2             @ Set return value to 2
    bx lr                  @ Return from number2
