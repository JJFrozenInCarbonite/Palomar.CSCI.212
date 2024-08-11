@ hexToInt2.s
@ Converts a hex text string to an int.
@ Calling sequence:
@       r0 <- address of string
@       bl hexToInt
@ returns equivalent int
@ 2017-09-29: Bob Plantz

@ Define my Raspberry Pi
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Constant for assembler
        .equ    gap,7   @ between alpha and numerical
        .equ    NUL,0
        .equ    no_ascii,0xf

@ The program
        .text
        .align  2
        .global hexToInt
        .type   hexToInt, %function
hexToInt:
        sub     sp, sp, 24      @ space for saving regs
                                @ (keeping 8-byte sp align)
        str     r4, [sp, 4]     @ save r4
        str     r5, [sp, 8]     @      r5
        str     r6, [sp,12]     @      r6
        str     fp, [sp, 16]    @      fp
        str     lr, [sp, 20]    @      lr
        add     fp, sp, 20      @ set our frame pointer
        
        mov     r4, r0          @ string pointer
        mov     r5, 0           @ accumulator = 0;
loop:
        ldrb    r6, [r4]        @ get char
        cmp     r6, NUL         @ end of string?
        beq     allDone         @ yes
        lsl     r5, r5, 4       @ room for four bits
        cmp     r6, '9          @ alpha char?
        subhi   r6, r6, gap     @ yes, remove gap
        and     r6, r6, no_ascii  @ strip off acsii
        add     r5, r5, r6      @ add in the four bits
        add     r4, r4, 1       @ next char
        b       loop
allDone:        
        mov     r0, r5          @ return accumulator;
        ldr     r4, [sp, 4]     @ restore r4
        ldr     r5, [sp, 8]     @      r5
        ldr     r6, [sp,12]     @      r6
        ldr     fp, [sp, 16]    @      fp
        ldr     lr, [sp, 20]    @      lr
        add     sp, sp, 24      @      sp
        bx      lr              @ return

        