.section .text
.global fractionConstruct

fractionConstruct:
    @ Arguments:
    @ r0 - address of the fraction struct
    @ r1 - numerator
    @ r2 - denominator

    str r1, [r0]       @ Store numerator at fraction.numerator
    str r2, [r0, #4]   @ Store denominator at fraction.denominator

    bx lr              @ Return from function

.section .note.GNU-stack,"",%progbits
