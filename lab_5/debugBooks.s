@ debugBooks.s
@ Debugging function for books
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
    .extern printf

@ Function prototypes
    .global debugPrintBooks
    .type   debugPrintBooks, %function

.data
    .align  8                       // Align data section to 8-byte boundary
    cBooks:     .asciz "  Books: "
    user:       .asciz "\033[92m%d\033[0m "
    computer:   .asciz "\033[91m%d\033[0m "
    unowned:    .asciz "\033[0m%d\033[0m "
    newline: .asciz "\n"
    num:   .asciz "%d\n"
.text
    .align  4                       // Align text section to 4-byte boundary

@ Function to debug books
debugPrintBooks:
    push    {lr}                    // Save the return address

    ldr     r0, =newline            // Load the address of the newline
    bl      printf                  // Print the newline

    ldr     r0, =cBooks             // Load the address of the cBooks
    bl      printf                  // Print the cDeck

    ldr     r4, =cardBooks          // Load the address of the cardBooks
    mov     r5, #0                  // Initialize index to 0

printStart:
    cmp     r5, #13                 // Compare index to 13
    bge     printEnd                // If index >= 13, go to end
    add     r6, r5, #1              // Calculate the value of the card
    ldr     r1, [r4, r5, LSL #2]    // Load the value of the current book
    cmp     r1, #0                  // Compare owner to 0 (user)
    blt     printUnowned            // If owner < 0, print unowned
    beq     printUser               // If owner == 0, print user  
    bgt     printComputer           // If owner > 0, print computer

printUnowned:
    ldr     r0, =unowned            // Load the address of the message format
    b       printBooks              // Print the message

printUser:
    ldr     r0, =user               // Load the address of the message format
    b       printBooks              // Print the message

printComputer:
    ldr     r0, =computer           // Load the address of the message format
    b       printBooks              // Print the message

printBooks:
    bl      printf                  // Print the message
    add     r5, r5, #1              // Increment index
    b       printStart              // Continue loop

printEnd:
    ldr     r0, =newline
    bl      printf

    pop     {lr}                    // Restore link register
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
