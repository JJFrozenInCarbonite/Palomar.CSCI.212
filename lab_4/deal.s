.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8
.extern rand
.extern piles
.extern size
.extern sort
.extern display

.global deal

.data

.text
.align 2

deal:
    push    {lr}                // Save the link register         

    // Load the value of size into r4
    ldr     r4, =size
    ldr     r4, [r4]

    // Load the base address of piles into r6
    ldr     r6, =piles

    // Initialize index register r7 to 0
    mov     r7, #0

loop_start:
    cmp     r4, #0              // Compare r4 with 0
    beq     loop_end            // If r4 is 0, exit loop

    bl rand                     // Call rand function

    mov     r1, r4              // Load r4 into r1
    udiv    r2, r0, r1          // r2 = r0 / r4 (number of full ranges)
    mls     r0, r2, r1, r0      // r0 = r0 - (r2 * r1) -> remainder of r0 / size
    add     r0, r0, #1          // Add 1 to the result to get a number between 1 and size

    // Store the random number in the piles array
    str     r0, [r6, r7, LSL #2] // Store r0 at address (r6 + r7 * 4)

    // Increment the index register r7
    add     r7, r7, #1

    mov     r5, r0              // Copy random number r0 into r5
    mov     r1, r0              // Copy random number r0 into r1

    sub     r4, r4, r5          // r4 = r4 - r5
    mov     r2, r4

    b       loop_start

loop_end:

    bl sort                     // Call sorting function
    bl display                  // Call the display function

    pop     {lr}                // Restore the link register
    bx      lr                  // Return from the function

.section .note.GNU-stack,"",%progbits
