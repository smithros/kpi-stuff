.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

// Global memory locations.
.global vtable
.global reset_handler

/*
 * vector table 
 */
.type vtable, %object
vtable:
    .word __stack_start
    .word __hard_reset__+1
    .size vtable, .-vtable
__hard_reset__:
    ldr r0, =__stack_start
    mov sp, r0
    b __hard_reset__
