@ printBooks.s
@ Print the user's books
@ 2024-08-17: JJ Hoffmann

@ Define Pi architecture
    .arch   armv7-a
    .cpu    cortex-a72
    .fpu    neon-fp-armv8
    .syntax unified                  

@ Include the card struct definitions
    .include "cardStruct.s"         // Card struct definitions

@ Declare external symbols
    .extern cardBooks
    .extern updateBooks
    .extern printf
    .extern sprintf

@ Function prototypes
    .global printBooks
    .type   printBooks, %function

.data
    .align 8                        // Align data section to 8-byte boundary
    headerBooks:    .asciz "\nBooks:\n"
    userBooks:      .asciz "  User:"
    compBooks:      .asciz "  Comp:"
    firstBook:      .asciz "  %d"
    nextBook:       .asciz ",%d"
    noBook:         .asciz " None"
    newline:        .asciz "\n"
    test: .asciz "test\n"

.text
    .align  4                       // Align text section to 4-byte boundary

@ Print user card books
printBooks:
    push    {lr}                    // Save the return address

    bl      updateBooks             // Update the cardBooks array

    ldr     r4, =cardBooks          // Load the base address of deck array
    mov     r5, #0                  // Initialize index to 0
    mov     r6, #0                  // Initialize sentinel to 0

    ldr     r0, =headerBooks        // Load the address of the userBooks format
    bl      printf                  // Print the userBooks format

    ldr     r0, =userBooks          // Load the address of the userBooks format
    bl      printf                  // Print the userBooks format

startUserLoop:
    cmp     r5, #13                 // Compare index to 13  
    bge     endUserLoop             // If index >= 13, go to endUserLoop    
    ldr     r7, [r4, r5, LSL #2]    // Load the owner of cardBooks[r5]
    cmp     r7, #0                  // Compare the owner to 0
    bne     iterateUserLoop         // If owner == -1, continue loop
    cmp     r6, #0                  // Check the value of the sentinel
    beq     firstUserBook           // If sentinel == 0, go to firstUserBook
    bne     nextUserBook            // Else, go to nextUserBook

firstUserBook:
    mov     r6, #1                  // Set sentinel to 1
    ldr     r0, =firstBook          // Load the address of the firstBook format
    b       printUserBooks          // Go to printUserBooks

nextUserBook:
    ldr     r0, =nextBook           // Load the address of the nextBook format
    b       printUserBooks          // Go to printUserBooks

printUserBooks:
    add     r1, r5, #1              // Add 1 to the index to get card face value
    bl      printf                  // Print the userBooks format

iterateUserLoop:
    add     r5, r5, #1              // Increment loop index
    b       startUserLoop           // Continue loop

endUserLoop:
    cmp     r6, #0                  // Check the value of the sentinel
    beq     printNoUserBooks          // If sentinel == 0, go to printCompBooks
    b       outputUserBooks         // Else, go to outputUserBooks

printNoUserBooks:
    ldr     r0, =noBook             // Load the address of the noBook format
    bl      printf                  // Print the noBook format
    b       outputUserBooks         // Go to outputUserBooks

outputUserBooks:
    ldr     r0, =newline            // Load the address of the newline format
    bl      printf                  // Print the newline format

    mov     r5, #0                  // Initialize index to 0
    mov     r6, #0                  // Initialize sentinel to 0

    ldr     r0, =compBooks          // Load the address of the userBooks format
    bl      printf                  // Print the userBooks format

startCompLoop:
    cmp     r5, #13                 // Compare index to 13  
    bge     endCompLoop             // If index >= 13, go to endUserLoop    
    ldr     r7, [r4, r5, LSL #2]    // Load the owner of cardBooks[r5]
    cmp     r7, #1                  // Compare the owner to 1
    bne     iterateCompLoop         // If owner == -1, continue loop
    cmp     r6, #0                  // Check the value of the sentinel
    beq     firstCompBook           // If sentinel == 0, go to firstUserBook
    bne     nextCompBook            // Else, go to nextUserBook

firstCompBook:
    mov     r6, #1                  // Set sentinel to 1
    ldr     r0, =firstBook          // Load the address of the firstBook format
    b       printCompBooks          // Go to printUserBooks

nextCompBook:
    ldr     r0, =nextBook           // Load the address of the nextBook format
    b       printCompBooks          // Go to printUserBooks

printCompBooks:
    add     r1, r5, #1              // Add 1 to the index to get card face value
    bl      printf                  // Print the userBooks format

iterateCompLoop:
    add     r5, r5, #1              // Increment loop index
    b       startCompLoop           // Continue loop

endCompLoop:
    cmp     r6, #0                  // Check the value of the sentinel
    beq     printNoCompBooks          // If sentinel == 0, go to printCompBooks
    b       outputCompBooks         // Else, go to outputUserBooks

printNoCompBooks:
    ldr     r0, =noBook             // Load the address of the noBook format
    bl      printf                  // Print the noBook format
    b       outputCompBooks         // Go to outputUserBooks

outputCompBooks:
    ldr     r0, =newline            // Load the address of the newline format
    bl      printf                  // Print the newline format

    pop     {lr}                    // Restore the return address
    bx      lr                      // Return from function

.section .note.GNU-stack,"",%progbits
