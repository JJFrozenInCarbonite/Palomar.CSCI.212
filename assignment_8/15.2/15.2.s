 structPass2.s
@ Allocates two structs and assigns a value to each field
@ in each struct, then displays the values.
@ 2017-09-29: Bob Plantz

@ Define my Raspberry Pi
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Constants for assembler
        .include "theTagStruct.s"  @ theTag struct defs.
        .equ    y,-36           @ y struct
        .equ    x,-24           @ x struct
        .equ    locals,24       @ space for the structs

@ Constant program data
        .section .rodata
        .align  2
displayX:
        .asciz        "x fields:\n"
displayY:
        .asciz        "y fields:\n"
dispAChar:
        .asciz        "         aChar = "
dispAnInt:
        .asciz        "         anInt = "
dispOtherChar:
        .asciz        "   anotherChar = "

@ The program
        .text
        .align  2
        .global main
        .type   main, %function
main:
        sub     sp, sp, 16      @ space for saving regs
                                @ (keeping 8-byte sp align)
        str     r4, [sp, 4]     @ save r4
        str     fp, [sp, 8]     @      fp
        str     lr, [sp, 12]    @      lr
        add     fp, sp, 12      @ set our frame pointer
        sub     sp, sp, locals  @ for the structs
        
@ fill the x struct
        add     r0, fp, x       @ address of x struct
        mov     r1, '1
        mov     r2, 456
        mov     r3, '2
        bl      loadStruct

@ fill the y struct
        add     r0, fp, y       @ address of y struct
        mov     r1, 'a
        mov     r2, 123
        mov     r3, 'b
        bl      loadStruct

@ display x struct
        add     r4, fp, x         @ address of x struct
        ldr     r0, displayXaddr
        bl      writeStr
        ldr     r0, dispACharAddr @ display aChar
        bl      writeStr
        ldrb    r0, [r4, aChar]
        bl      putChar
        bl      newLine
        ldr     r0, dispAnIntAddr @ display anInt
        bl      writeStr
        ldr     r0, [r4, anInt]
        bl      putDecInt
        bl      newLine
        ldr     r0, dispOtherCharAddr @ display anotherChar
        bl      writeStr
        ldrb    r0, [r4, anotherChar]
        bl      putChar
        bl      newLine

@ display y struct
        add     r4, fp, y         @ address of y struct
        ldr     r0, displayXaddr
        bl      writeStr
        ldr     r0, dispACharAddr @ display aChar
        bl      writeStr
        ldrb    r0, [r4, aChar]
        bl      putChar
        bl      newLine
        ldr     r0, dispAnIntAddr @ display anInt
        bl      writeStr
        ldr     r0, [r4, anInt]
        bl      putDecInt
        bl      newLine
        ldr     r0, dispOtherCharAddr @ display anotherChar
        bl      writeStr
        ldrb    r0, [r4, anotherChar]
        bl      putChar
        bl      newLine

        mov     r0, 0           @ return 0;
        add     sp, sp, locals  @ deallocate local var
        ldr     r4, [sp, 4]     @ restore r4
        ldr     fp, [sp, 8]     @         fp
        ldr     lr, [sp, 12]    @         lr
        add     sp, sp, 16      @         sp
        bx      lr              @ return
        
        .align  2
@ addresses of messages
displayXaddr:
        .word   displayX
displayYaddr:
        .word   displayY
dispACharAddr:
        .word   dispAChar
dispAnIntAddr:
        .word   dispAnInt
dispOtherCharAddr:
        .word   dispOtherChar
