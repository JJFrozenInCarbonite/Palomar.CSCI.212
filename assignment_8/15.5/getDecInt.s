@ getDecInt.s
@ Gets signed decimal integer from keyboard.
@ Calling sequence:
@       bl getDecInt
@ returns equivalent int
@ 2017-09-29: Bob Plantz

@ Define my Raspberry Pi
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Constants for assembler
        .equ    maxChars,12     @ max input chars
        .equ    inputString,-20 @ for input string
        .equ    locals,8        @ space for local vars

@ Useful source code constants
        .equ    POS,0
        .equ    NEG,1

@ The program
        .text
        .align  2
        .global getDecInt
        .type   getDecInt, %function
getDecInt:
        sub     sp, sp, 16      @ space for saving regs
                                @ (keeping 8-byte sp align)
        str     r4, [sp, 4]     @ save r4
        str     fp, [sp, 8]     @      fp
        str     lr, [sp, 12]    @      lr
        add     fp, sp, 12      @ set our frame pointer
        sub     sp, sp, locals  @ for the string
        
        add     r0, fp, inputString  @ place to store input
        mov     r1, maxChars    @ limit input length
        bl      readLn
        
        add     r0, fp, inputString  @ input string
        mov     r4, POS         @ assume postive int

        ldrb    r1, [r0]        @ get char
        cmp     r1, '-          @ minus sign?
        bne     checkPlus       @ no, check for plus sign
        mov     r4, NEG         @ yes, flag as neg
        add     r0, r0, 1       @ go to the number
        b       convert         @ and convert it
checkPlus:  
        cmp     r1, '+          @ plus sign?
        bne     convert         @ no, we're at the number
        add     r0, r0, 1       @ go to the number
convert:
        bl      uDecToInt
        
        cmp     r4, POS         @ positive int?
        beq     allDone         @ yes, we're done
        mvn     r0, r0          @ no, complement it
        add     r0, r0, 1       @ and finish negate       
allDone:        
        add     sp, sp, locals  @ deallocate local var
        ldr     r4, [sp, 4]     @ restore r4
        ldr     fp, [sp, 8]     @         fp
        ldr     lr, [sp, 12]    @         lr
        add     sp, sp, 16      @         sp
        bx      lr              @ return

.section .note.GNU-stack,"",%progbits
