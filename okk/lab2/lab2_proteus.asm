CODE    SEGMENT PUBLIC 'CODE'
        ASSUME CS:CODE
START:
        ORG 100H 
JMP begin 
ARRAY DB 3,6,9,2,8,4,5,7,1,3 
begin: 
    MOV CX, 9 
    MOV BX, 0 
next: 
    MOV AL, ARRAY[BX]
    TEST AL, 1 
    JNE n_xch 
    PUSH AX
    MOV AL, ARRAY[BX+1]
    TEST AL, 1 
    JZ n_xch
    MOV ARRAY[BX], AL 
    POP AX
    MOV ARRAY[BX+1], AL 
    INC CX 
    DEC BX 
    JMP next 
n_xch: 
    INC BX 
    LOOP next 
ENDLESS:
        JMP ENDLESS
CODE    ENDS
        END START