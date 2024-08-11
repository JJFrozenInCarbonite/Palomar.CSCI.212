@ loadStruct2.s
@ Stores values in a theTag struct
@ Calling sequence:
@        r0 <- address of the struct
@        r1 <- aChar
@        r2 <- anInt
@        r3 <- anotherChar
@        bl  loadStruct
@ Returns 0
@ 2017-09-29: Bob Plantz

@ Define my Raspberry Pi
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Constants for assembler
        .include "theTagStruct.s"  @ theTag struct defs.

@ The program
        .text
        .align  2
        .global loadStruct
        .type   loadStruct, %function
loadStruct:
        sub     sp, sp, 8       @ space for fp, lr
        str     fp, [sp, 0]     @ save fp
        str     lr, [sp, 4]     @   and lr
        add     fp, sp, 4       @ set our frame pointer

        strb    r1, [r0, aChar] @ aStruct->aChar = firstChar;
        str     r2, [r0, anInt] @ aStruct->anInt = aNumber;
        strb    r3, [r0, anotherChar] @ aStruct->anotherChar = secondChar;

        mov     r0, 0           @ return 0;
        ldr     fp, [sp, 0]     @ restore caller fp
        ldr     lr, [sp, 4]     @       lr
        add     sp, sp, 8       @   and sp

.section .note.GNU-stack,"",%progbits
