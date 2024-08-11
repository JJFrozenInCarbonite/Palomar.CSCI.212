@ putDecInt.s
@ Converts an int to the corresponding signed
@ decimal text string.
@ Calling sequence:
@       r0 <- int to print
@       bl putDecInt
@ 2017-09-29: Bob Plantz

@ Define my Raspberry Pi
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Constants for assembler
        .equ    decString,-20   @ for  string
        .equ    locals,8        @ space for local varsbr

@ Useful source code constants
        .equ    POS,0
        .equ    NEGBIT,0x80000000

@ The program
        .text
        .align  2
        .global putDecInt
        .type   putDecInt, %function
putDecInt:
        sub     sp, sp, 16      @ space for saving regs
                                @ (keeping 8-byte sp align)
        str     r4, [sp, 4]     @ save r4
        str     fp, [sp, 8]     @      fp
        str     lr, [sp, 12]    @      lr
        add     fp, sp, 12      @ set our frame pointer
        sub     sp, sp, locals  @ space for the string
        
        add     r4, fp, decString  @ place to store string
        mov     r1, '+          @ assume positive
        strb    r1, [r4]
        tst     r0, NEGBIT      @ negative int?
        beq     positive        @ no, go on
        mov     r1, '-          @ yes, need to negate
        strb    r1, [r4]
        mvn     r0, r0          @ complement
        add     r0, r0, 1       @ two's complement
positive:
        mov     r1, r0          @ int to convert
        add     r0, r4, 1       @ skip over sign char
        bl      uIntToDec

        add     r0, fp, decString  @ string to write
        bl      writeStr

        add     sp, sp, locals  @ deallocate local var
        ldr     r4, [sp, 4]     @ restore r4
        ldr     fp, [sp, 8]     @         fp
        ldr     lr, [sp, 12]    @         lr
        add     sp, sp, 16      @         sp
        bx      lr              @ return+

.section .note.GNU-stack,"",%progbits
