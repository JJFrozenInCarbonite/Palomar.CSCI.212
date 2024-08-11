.arch   armv7-a
.cpu    cortex-a53
.fpu    neon-fp-armv8
.syntax unified

.global getChar
.section .text

getChar:
    // Save registers and set up stack frame
    sub     sp, sp, #8       @ space for fp, lr
    str     fp, [sp, #0]     @ save fp
    str     lr, [sp, #4]     @ save lr
    add     fp, sp, #4       @ set our frame pointer
    sub     sp, sp, #1       @ space for local variable

    // Set up the parameters for the read system call
    mov     r7, #3           @ syscall number for read
    mov     r0, #0           @ file descriptor 0 (stdin)
    add     r1, fp, #-1      @ local buffer to store the character
    mov     r2, #1           @ number of bytes to read
    svc     #0               @ make the system call

    // Load the character from the local buffer into r0
    ldrb    r0, [fp, #-1]

    // Restore stack frame and return
    add     sp, sp, #1       @ deallocate local variable
    ldr     fp, [sp, #0]     @ restore caller fp
    ldr     lr, [sp, #4]     @ restore caller lr
    add     sp, sp, #8       @ restore sp
    bx      lr               @ return from function

.section .note.GNU-stack,"",%progbits
