.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8
.extern rand

.global generateRandomNumber

.text
.align 2

generateRandomNumber:
    push    {lr}            // Save the link register to the stack
    bl      rand            // Call rand() to get a random number in r0

    // Scale the result to the range 0-50 (inclusive)
    mov     r1, #51         // Load 51 into r1
    udiv    r2, r0, r1      // r2 = r0 / 51 (number of full ranges)
    mls     r0, r2, r1, r0  // r0 = r0 - (r2 * r1) -> remainder of r0 / 51

    // Add the base value (50) to shift the range to 50-100
    add     r0, r0, #50     // Add 50 to the result

    pop     {lr}            // Restore the link register from the stack
    bx      lr              // Return to the caller with the result in r0

.section .note.GNU-stack,"",%progbits
