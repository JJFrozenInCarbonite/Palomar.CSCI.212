@ printHand.s
@ Print the user's hand
@ 2024-08-18: JJ Hoffmann

@ Define Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified                  

@ Include the card struct definitions
    .include "cardStruct.s"         // Card struct definitions

@ Declare external symbols
    .extern cardBooks
    .extern userHand
    .extern compHand
    .extern printf

@ Function prototypes
    .global printHand
    .type   printHand, %function

.data
    .align 8                        // Align data section to 8-byte boundary
    header:     .asciz "\nYour Hand:"
    firstCard:  .asciz " %d"
    nextCard:   .asciz ",%d"
    noCards:    .asciz "You have empty hands!"
    newline:    .asciz "\n"

.text
    .align  4                       // Align text section to 4-byte boundary

@ Print user's hand
printHand:
    push    {lr}                    // Save the return address

    ldr     r0, =header             // Load the address of the header format
    bl      printf                  // Print the header format

    ldr     r4, =userHand           // Load the base address of userHand
    mov     r5, #0                  // Initialize index to 0
    mov     r6, #0                  // Initialize sentinel to 0

startPrintLoop:
    cmp     r5, #52                 // Compare index to 52
    bge     endPrintLoop            // If index >= 51, exit print loop
    ldr     r7, [r4, r5, LSL #2]    // Load the value of the target card
    cmp     r7, #0                  // Compare the value of the target card to 0
    beq     iteratePrintLoop        // If value == 0, skip to next iteration
    cmp     r6, #0                  // Check the value of the sentinel
    beq     printFirstCard          // If sentinel == 0, go to printFirstCard branch
    ldr     r0, =nextCard           // Load the address of the next format
    mov     r1, r7                  // Load the value of the card
    bl      printf                  // Print the next format
    b       iteratePrintLoop        // Continue loop

printFirstCard:
    mov     r6, #1                  // Set sentinel to 1
    ldr     r0, =firstCard          // Load the address of the first format
    mov     r1, r7                  // Load the value of the card
    bl      printf                  // Print the first format
    b       iteratePrintLoop        // Continue loop

iteratePrintLoop:
    add     r5, r5, #1              // Increment index
    b       startPrintLoop          // Continue loop

endPrintLoop:
    cmp     r6, #0                  // Check the value of the sentinel
    beq     printNoCards            // If sentinel == 0, go to printNoCards branch
    bne     exitPrintLoop           // Else, go to exitPrintLoop branch

printNoCards:
    ldr     r0, =noCards            // Load the address of the noCards format
    bl      printf                  // Print the noCards format

exitPrintLoop:
    ldr     r0, =newline            // Load the address of the newline format
    bl      printf                  // Print the newline format

    pop     {lr}                    // Restore link register
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
