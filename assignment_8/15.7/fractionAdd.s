.arch   armv7-a
.cpu    cortex-a72
.fpu    neon-fp-armv8

.section .text
.global fractionAdd

fractionAdd:
    @ Arguments:
    @ r0 - address of the fraction

    push {lr}           @ Save the link register (return address)

    @ Load the numerator and denominator of the fraction
    ldr r2, [r0]        @ r3 = fraction.numerator
    ldr r3, [r0, #4]    @ r4 = fraction.denominator

    
    @ Calculate the result numerator:
    mul r4, r3, r1      @ r4 = multiple denominator by integer
    add r5, r2, r4      @ r5 = add r4 to numerator

    @ Update the fraction
    str r5, [r0]       

    pop {lr}            @ Restore the link register (return address)
    bx lr               @ Return from the function

.section .note.GNU-stack,"",%progbits
