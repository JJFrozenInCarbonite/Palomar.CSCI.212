.arch   armv7-a
.cpu    cortex-a72
.fpu    neon-fp-armv8

.global main
.extern printf
.extern scanf
.extern atoi
.extern sprintf

.section .data
input_msg:    .asciz "Enter a signed integer: "
output_msg:   .asciz "The result is: "
input_format: .asciz "%d"
output_format: .asciz "%d\n"
buffer:       .space 16

.section .text

main:
    // Print the input message
    ldr r0, =input_msg
    bl printf

    // Read the user input
    ldr r0, =input_format
    ldr r1, =buffer
    bl scanf

    // Convert input string to integer
    ldr r0, =buffer
    bl atoi

    // Add 5 to the integer in r0
    add r0, r0, #5
    mov r3, r0

    // Print the result
    ldr r0, =output_format
    mov r1, r3
    bl printf

    // Exit
    mov r7, #1          // syscall number for exit
    svc 0               // make the syscall

.section .note.GNU-stack,"",%progbits
