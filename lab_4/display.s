.cpu cortex-a72
.fpu neon-fp-armv8

.extern piles              // External reference to the piles array
.extern size               // External reference to the size of the array
.extern printf             // External declaration for printf

.global display
.text

display:
    push    {lr}                // Save the link register

    ldr     r0, =header
    bl      printf

    mov     r2, #0 // Loop counter

    // Load the value of size into r3
    ldr     r3, =size
    ldr     r3, [r3]

    // Load the base address of piles into r4
    ldr     r4, =piles

loop:
    cmp     r2, r3                  // Compare counter with size
    bge     end                     // If counter >= size, exit loop

    ldr     r0, =number             // Load the format string addres
    ldr     r1, [r4, r2, LSL #2]    // r1 = piles[r5]
    cmp     r1, #0
    beq     end


    push    {r2, r3}                // Save r2 & r3 before calling printf
    bl      printf                  // Call printf
    pop     {r2, r3}                // Restore r2 & r3 after calling printf

    add     r2, r2, #1              // Increment the loop counter

    b       loop                    // Repeat the loop

end:
    ldr     r0, =newline
    bl      printf

    pop     {lr}                    // Restore the link register
    bx      lr                      // Return from the function

// Data section for format strings
.data
header:     .asciz "Piles: "
number:     .asciz "%d "
newline:    .asciz "\n" 

.section .note.GNU-stack,"",%progbits
