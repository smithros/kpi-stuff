.global lab1
.syntax unified
#define P0_DATA #3
#define P1_DATA #5
#define P2_DATA #7
#define P3_DATA #3

// (a&b)>> + c!

lab1:
push {lr}
// calculate
mov r0, P0_DATA
mov r1, P1_DATA
mov r2, P2_DATA
mov r3, P3_DATA
bl calc
pop {pc}

calc:
push { r4, r5, lr }
mov r4, r0 // save D0
rev r0, r0
and r1, r2
lsr r1, 1
adds r0, r1
//ror r0, #4
// calculate factorial here
mov r5, r0
mov r0, r4 // D0
bl factorial
add r0, r1
pop { r4, r5, pc }

factorial:
//param: 1 number
push { r4 }
//mov r4, 3
subs r0, #1
.fact_calc:
mul r4, r0
subs r0, #1
bne .fact_calc
mov r0, r4
pop { r4 }
bx lr

