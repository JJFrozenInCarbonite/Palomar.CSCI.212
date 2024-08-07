.cpu cortex-a72
.fpu neon-fp-armv8
.extern piles
.extern size
.extern printf
.extern qsort

.global sort

.data
format: .asciz "%d: %d\n"  // Format string for printf

.text
.align 2

// Comparison function for qsort
compare:
    push    {lr}                // Save the link register

    ldr     r2, [r0]            // Load the first integer
    ldr     r3, [r1]            // Load the second integer

    cmp     r2, r3              // Compare the two integers
    movlt   r0, #1              // Return 1 if r2 < r3 (reverse order)
    moveq   r0, #0              // Return 0 if r2 == r3
    movgt   r0, #-1             // Return -1 if r2 > r3 (reverse order)

    pop     {lr}                // Restore the link register
    bx      lr                  // Return from the function

sort:
    push    {lr}                // Save the link register

    // Call qsort(piles, size, sizeof(int), compare)
    ldr     r0, =piles          // Load the base address of piles into r0
    ldr     r1, =size           // Load the address of size into r1
    ldr     r1, [r1]            // Load the value of size into r1
    mov     r2, #4              // sizeof(int) = 4
    ldr     r3, =compare        // Load the address of the compare function into r3

    bl      qsort               // Call qsort function

    pop     {lr}                // Restore the link register
    bx      lr                  // Return from the function

.section .note.GNU-stack,"",%progbits
