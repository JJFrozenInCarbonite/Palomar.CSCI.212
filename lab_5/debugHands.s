@ debugPrintHands.s
@ Debugging function for hands
@ 2024-08-17: JJ Hoffmann

@ Define Raspberry Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified         @ modern syntax

@ Include the card struct definitions
    .include "cardStruct.s"         // card struct definitions

@ Declare external symbols
    .extern cardDeck
    .extern pointerDeck
    .extern printf

@ Function prototypes
    .global debugPrintHands
    .type   debugPrintHands, %function

.data
    .align  8                       // Align data section to 8-byte boundary
    userHandMsg:      .asciz "  User Hand: "
    compHandMsg:      .asciz "  Computer Hand: "
    nonzero:       .asciz "\033[92m%d\033[0m "
    zero:   .asciz "\033[91m%d\033[0m "
    newline: .asciz "\n"
.text
    .align  4                       // Align text section to 4-byte boundary

@ Function to debug hands
debugPrintHands:
    push    {lr}                    // Save the return address

    ldr     r0, =newline
    bl      printf

    mov     r4, #0                  // Initialize index to 0
handsLoopStart:
    cmp     r4, #2                  // Compare index to 2
    bge     handsLoopEnd            // If index >= 1, go to end

    cmp     r4, #0
    beq     userHandAddress
    bgt     compHandAddress

userHandAddress:
    ldr     r0, =userHandMsg
    ldr     r5, =userHand
    b       handLoop

compHandAddress:
    ldr     r0, =compHandMsg
    ldr     r5, =compHand
    b       handLoop

handLoop:
    bl      printf
    mov     r6, #0                  // Initialize index to 0

handLoopStart:
    cmp     r6, #52                 // Compare index to 52
    bge     handLoopEnd             // If index >= 52, go to end
    ldr     r7, [r5, r6, LSL #2]    // Load card value from hand using the address
    cmp     r7, #0                  // If value == 0
    beq     printZero               // printZero
    bne     printNonZero            // Else, printNonZero

printZero:
    ldr     r0, =zero               // Load the address of the message format
    b       printValue              // Print the message

printNonZero:
    ldr     r0, =nonzero            // Load the address of the message format
    b       printValue              // Print the message

printValue:
    mov     r1, r7                  // Load the card value
    bl      printf                  // Print the message
    add     r6, r6, #1              // Increment index
    b       handLoopStart           // Continue loop

handLoopEnd:
    add     r4, r4, #1              // Increment index
    ldr     r0, =newline
    bl      printf
    b       handsLoopStart          // Continue loop

handsLoopEnd:
    pop     {lr}                    // Restore link register
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
