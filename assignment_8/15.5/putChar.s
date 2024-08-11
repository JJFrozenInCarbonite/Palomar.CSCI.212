.arch   armv7-a
.cpu    cortex-a53
.fpu    neon-fp-armv8
.syntax unified

.global putChar
.section .text

putChar:
    // Save registers and set up stack frame
    sub     sp, sp, #8       @ space for fp, lr
    str     fp, [sp, #0]     @ save fp
    str     lr, [sp, #4]     @ save lr
    add     fp, sp, #4       @ set our frame pointer
    sub     sp, sp, #1       @ space for local variable

    // Store the character to be printed in the local buffer
    strb    r0, [fp, #-1]

    // Set up the parameters for the write system call
    mov     r7, #4           @ syscall number for write
    mov     r0, #1           @ file descriptor 1 (stdout)
    add     r1, fp, #-1      @ local buffer containing the character
    mov     r2, #1           @ number of bytes to write
    svc     #0               @ make the system call

    // Restore stack frame and return
    add     sp, sp, #1       @ deallocate local variable
    ldr     fp, [sp, #0]     @ restore caller fp
    ldr     lr, [sp, #4]     @ restore caller lr
    add     sp, sp, #8       @ restore sp
    bx      lr               @ return from function

.section .note.GNU-stack,"",%progbits
