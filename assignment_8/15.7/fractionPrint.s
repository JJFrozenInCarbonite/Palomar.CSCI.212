.section .text
.global fractionPrint

.extern printf

fractionPrint:
    @ Arguments:
    @ r0 - address of the fraction struct

    push {lr}           @ Save the link register (return address)

    @ Load the numerator and denominator from the fraction struct
    ldr r1, [r0]        @ Load numerator into r1
    ldr r2, [r0, #4]    @ Load denominator into r2

    @ Prepare the format string for printf
    ldr r0, =fractionPrintFormat

    @ Call printf to print the fraction
    bl printf

    pop {lr}            @ Restore the link register (return address)
    bx lr               @ Return from the function

.section .data
fractionPrintFormat: .asciz "%d/%d\n"  @ Format string for printing the fraction

.section .note.GNU-stack,"",%progbits
