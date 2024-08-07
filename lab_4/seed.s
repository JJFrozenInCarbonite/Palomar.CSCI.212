.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8
.extern srand
.extern time

.global seed

.text
.align 2

seed:
    push    {lr}           // Save the link register to the stack
    mov     r0, #0         // Move 0 into r0 to pass NULL to time
    bl      time           // time(NULL) - returns the current time in seconds since the Epoch

    // Now r0 contains the return value from time, which we use as the seed for srand
    bl      srand          // srand(time(NULL))
    
    pop     {lr}           // Restore the link register from the stack
    bx      lr             // Return to the caller

.section .note.GNU-stack,"",%progbits
