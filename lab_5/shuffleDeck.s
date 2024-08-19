@ shuffleDeck.s
@ Shuffle the dekc of cards
@ 2024-08-17: JJ Hoffmann

@ Define my Raspberry Pi
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified         @ modern syntax

@ Include the card struct definitions
    .include "cardStruct.s"  @ card struct defs.

@ Declare external symbols
    .extern pointerDeck
    .extern printf

@ Function prototypes
    .global shuffleDeck
    .type   shuffleDeck, %function

.data
    .align  8                       // Align data section to 8-byte boundary
    start:  .asciz "Shuffling deck..."
    end:    .asciz " \033[92mComplete\033[0m.\n"
.text
    .align  4              // Align text section to 4-byte boundary

@ Shuffle the deck using the Fisher-Yates algorithm
shuffleDeck:
    push    {lr}                    // Save the return address

    ldr     r0, =start              // Load the address of the shuffling message
    bl      printf                  // Print the shuffling message

    ldr     r4, =pointerDeck        // Load the address of deck
    mov     r5, #51                 // Last position in the deck

loop:
    bl      rand                    // Call rand(), result in r0
    udiv    r6, r0, r5              // r6 = r0 / r5 (quotient)
    mls     r7, r6, r5, r0          // r7 = r0 - (r6 * r5) (remainder, effectively r0 % r5)
    
    @ Ensure r7 is within bounds
    cmp     r7, r5
    bge     loop                    // If r7 >= r5, repeat the loop

    @ Load pointers
    add     r8, r4, r5, LSL #2      // Calculate address of pointerDeck[r5]
    ldr     r9, [r8]                // Load pointerDeck[r5]

    add     r11, r4, r7, LSL #2     // Calculate address of pointerDeck[r7]
    ldr     r12, [r11]              // Load pointerDeck[r7]

    @ Swap pointers
    str     r9, [r11]               // Store pointerDeck[r5] into pointerDeck[r7]
    str     r12, [r8]               // Store pointerDeck[r7] into pointerDeck[r5]

    sub     r5, r5, #1              // r5 -= 1
    cmp     r5, #0                  // Compare r5 to 0
    bgt     loop                    // If r5 > 0 then repeat

    ldr     r0, =end                // Load the address of the complete message
    bl      printf                  // Print the complete message

    pop     {lr}                    // Restore the return address
    bx      lr                      // Return to the calling function

.section .note.GNU-stack,"",%progbits
