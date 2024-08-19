@ initBooks.s
@ Initialize all books to -1
@ 2024-08-17: JJ Hoffmann

@ Define Raspberry Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified        

@ Include the card struct definitions
    .include "cardStruct.s"         // card struct definitions

@ Declare external symbols
    .extern cardBooks

@ Function prototypes
    .global initBooks
    .type   initBooks, %function

.data
    .align  8                       // Align data section to 8-byte boundary
    start:  .asciz "Initializing books..."
    end:    .asciz " \033[92mComplete\033[0m.\n"

.text
    .align  4                       // Align text section to 4-byte boundary

@ Initialize unshuffled cardDeck
initBooks:
    push    {lr}                    // Save the return address

    ldr     r0, =start              // Load the address of the initialization message
    bl      printf                  // Print the initialization message

    ldr     r4, =cardBooks          // Load the base address of cardBooks
    mov     r5, #0                  // Initialize index to 0

loop:
    cmp     r5, #13                 // Compare index to 13
    bge     exit                    // If index >= 13, go to end
    mvn     r6, #0                  // Initialize book owner to -1
    str     r6, [r4, r5, LSL #2]    // Set cardBooks[r6] = -1
    add     r5, r5, #1              // Increment index
    b       loop                    // Continue loop

exit:

    ldr     r0, =end                // Load the address of the completion message
    bl      printf                  // Print the completion message

    pop     {lr}                    // Restore link register
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
