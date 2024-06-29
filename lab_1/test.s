.arch armv6                  @ Target architecture
    .fpu vfp                @ Floating point unit version
    .eabi_attribute 28, 1   @ Hardware floating point
    .eabi_attribute 20, 1   @ ABI version
    .eabi_attribute 21, 1   @ No specific ABI
    .eabi_attribute 23, 3   @ Stack alignment
    .eabi_attribute 24, 1   @ Data alignment
    .eabi_attribute 25, 1   @ Architecture profile (A/R/M)
    .eabi_attribute 26, 2   @ Thumb instruction set
    .eabi_attribute 30, 6   @ Virtualization extensions
    .eabi_attribute 34, 1   @ Unaligned access
    .eabi_attribute 18, 4   @ FP arch
    .file	"test.c"        @ Source file name
    .text                   @ Code section
    .align	2               @ Align the code on a 4-byte boundary
    .global	test            @ Makes the test function globally accessible
    .syntax unified         @ Unified syntax for ARM and Thumb instructions
    .arm                    @ ARM instruction set
    .type	test, %function  @ Declares 'test' as a function
test:
    @ Function prologue
    str	fp, [sp, #-4]!   @ Save frame pointer on the stack
    add	fp, sp, #0       @ Set frame pointer to current stack pointer
    sub	sp, sp, #12      @ Allocate space on the stack for local variables

    @ Function body
    str	r0, [fp, #-8]    @ Store function argument (r0) on the stack
    ldr	r2, [fp, #-8]    @ Load function argument into r2
    ldr	r3, .L3          @ Load constant value (1717986919) into r3
    smull	r1, r3, r3, r2   @ Multiply r3 by r2, result in r1:r3 (double-word result)
    asr	r1, r3, #2       @ Arithmetic shift right r3 by 2 bits, result in r1
    asr	r3, r2, #31      @ Arithmetic shift right r2 by 31 bits (sign bit), result in r3
    sub	r1, r1, r3       @ Subtract r3 from r1, result in r1
    mov	r3, r1           @ Move r1 to r3
    lsl	r3, r3, #2       @ Logical shift left r3 by 2 bits
    add	r3, r3, r1       @ Add r1 to r3, result in r3
    lsl	r3, r3, #1       @ Logical shift left r3 by 1 bit
    sub	r1, r2, r3       @ Subtract r3 from r2, result in r1
    mov	r3, r1           @ Move r1 to r3
    mov	r0, r3           @ Move r3 to r0 (function return value)

    @ Function epilogue
    add	sp, fp, #0       @ Reset stack pointer to frame pointer
    ldr	fp, [sp], #4     @ Restore frame pointer from the stack
    bx	lr               @ Return from function

    @ Constants and literals
.L4:
    .align	2               @ Align the following data on a 4-byte boundary
.L3:
    .word	1717986919      @ Constant value used in the function
    .size	test, .-test     @ Specifies the size of the 'test' function

    .section	.rodata       @ Read-only data section
    .align	2               @ Align the data on a 4-byte boundary
.LC0:
    .ascii	"The digit in the ones place of %d is %d\012\000" @ String literal