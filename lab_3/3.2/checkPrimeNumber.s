.arch armv7-a
.cpu cortex-a72
.fpu neon-fp-armv8

.text
.align 2

.global main
.extern printf
.extern scanf
.extern checkPrimeNumber

.section .text
main:
    push {fp, lr}                           // Save frame pointer and link register

    // Print start message
    ldr r0, =print_start
    bl printf                               // printf("Enter two positive integers: ")

    // Read two integers
    ldr r0, =scan_format
    sub sp, sp, #8                          // Space for n1 and n2
    add r1, sp, #4                          // Address of n2
    mov r2, sp                              // Address of n1
    bl scanf                                // scanf("%d %d", &n1, &n2)

    // Print initial message
    ldr r0, =print_range
    ldr r1, [sp, #4]                        // n1
    ldr r2, [sp]                            // n2
    bl printf                               // printf("Prime numbers between %d and %d are: ", n1, n2)

    // Prime checking loop
    ldr r4, [sp, #4]                        // r4 = n1
    add r4, r4, #1                          // Start from n1 + 1
    ldr r5, [sp]                            // r5 = n2

prime_loop:
    cmp r4, r5                              // Compare current number (r4) with n2 (r5)
    bge end_loop                            // If r4 >= r5, exit loop

    // Check if r4 is a prime number
    mov r0, r4                              // Argument for checkPrimeNumber
    bl checkPrimeNumber                     // Call checkPrimeNumber function
    cmp r0, #1                              // Check if return value is 1
    bne skip_print                          // If not prime, skip printing

    // Print the prime number
    ldr r0, =print_prime
    mov r1, r4                              // Current prime number
    bl printf                               // printf("%d ", r4)

skip_print:
    add r4, r4, #1                          // Increment the number
    b prime_loop                            // Repeat the loop

end_loop:
    // Clean up stack and return from main
    add sp, sp, #8                          // Deallocate stack space for n1 and n2
    pop {fp, lr}                            // Restore frame pointer and link register
    bx lr                                   // Return from main

.section .rodata
print_start:
    .asciz "Enter two positive integers: "
scan_format:
    .asciz "%d %d"
print_range:
    .asciz "Prime numbers between %d and %d are: "
print_prime:
    .asciz "%d "

.section .note.GNU-stack,"",%progbits
