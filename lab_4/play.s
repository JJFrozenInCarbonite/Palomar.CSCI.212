.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8

.extern piles             // External reference to the piles array
.extern size              // External reference to the size of the array
.extern display           // External reference to display function
.extern printf            // External declaration for printf

.global play                // Main play globally accessible

.data
game_over:     .asciz "Bulgarian Solitaire Completed!\n"

.text

play:
    push {lr}

restart:
    mov r4, #0                      // Counter
    ldr r5, =piles                  // Load the base address of piles into r5
    ldr r6, =size                   // Load the address of size into r6
    ldr r6, [r6]                    // Load the value of size into r6

play_start:
    ldr     r8, [r5, r4, LSL #2]    // r8 = piles[r4]
    
    cmp     r8, #0                  // Compare current array value to 0
    beq     play_end
    
    sub     r8, r8, #1              // Subtract 1 from the current value
    str     r8, [r5, r4, LSL #2]    // Store the new value back in the array
    add     r4, r4, #1              // Increment the counter
    b       play_start                   // Repeat the loop

play_end:
    mov     r9, r4                  // Postion of new card stack in array 
    str     r9, [r5, r4, LSL #2]    // Store the new value in the array   
    bl      sort
    bl      display

    mov     r4, #0                  // Reset counter (i)
    mov     r6, #9                  
check_start:
    ldr     r7, [r5, r4, LSL #2]    // r7 = piles[r4]
    cmp     r6, r7                  // Compare r6 & r7
    bne     restart                 // Play another hand if numbers do not match
    sub     r6, r6, #1              // subtract 1 from r6
    cmp     r6, #0                  // Compare r6 to 0
    beq     end_game                // If r6 == 0 then goto end_game
    add     r4, r4, #1              // Increment counter by 1 (i++)
    b       check_start

end_game:
    ldr     r0, =game_over          // Load game over message into r0          
    bl      printf                  // Print game over message

    pop     {lr}                    // Restore the link register
    bx      lr                      // Return from the function


.section .note.GNU-stack,"",%progbits
