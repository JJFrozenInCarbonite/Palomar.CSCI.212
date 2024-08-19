@ initHand.s
@ Initialize the user's hand
@ 2024-08-17: JJ Hoffmann

@ Define Raspberry Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified        

@ Include the card struct definitions
    .include "cardStruct.s"         // card struct definitions

@ Declare external symbols
    .extern userHand
    .extern compHand

@ Function prototypes
    .global initHand
    .type   initHand, %function

.data
    .align  8                       // Align data section to 8-byte boundary
    start:  .asciz "Initializing hand..."
    end:    .asciz " \033[92mComplete\033[0m.\n"

.text
    .align  4                       // Align text section to 4-byte boundary

@ Initialize user hand
initHand:
    push    {lr}                    // Save the return address

    ldr     r0, =start              // Load the address of the initialization message
    bl      printf                  // Print the initialization message

    ldr     r4, =userHand           // Load the base address of userHand
    mov     r5, #0                  // Initialize index to 0
    mvn     r6, #0                  // Initialize card value to -1

startInitUserHandLoop:
    cmp     r5, #51                 // Compare index to 51
    bge     exitInitUserHandLoop    // If index >= 51, go to end
    str     r6, [r4, r5, LSL #2]    // Set userHand[r6] = -1
    add     r5, r5, #1              // Increment index
    b       startInitUserHandLoop   // Continue loop

exitInitUserHandLoop:

    ldr     r4, =compHand           // Load the base address of userHand
    mov     r5, #0                  // Initialize index to 0
    mvn     r6, #0                  // Initialize card value to -1

startInitCompHandLoop:
    cmp     r5, #51                 // Compare index to 51
    bge     exitInitCompHandLoop    // If index >= 51, go to end
    str     r6, [r4, r5, LSL #2]    // Set userHand[r6] = -1
    add     r5, r5, #1              // Increment index
    b       startInitCompHandLoop   // Continue loop

exitInitCompHandLoop:

    ldr     r0, =end                // Load the address of the completion message
    bl      printf                  // Print the completion message

    pop     {lr}                    // Restore link register
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
