; calculator
; compatible with Proteus Proffesional version 8.11+

ASSUME DS:DATA
data segment	
   ORG 100H
   SEG7 DB 0FCH,060H,0DAH,0F2H,066H,0B6H,0BEH,0E0H,0FEH,0F6H
   KEYPAD DB 7,4,1,10,8,5,2,0,9,6,3,11,15,14,13,12
   OPER_1 DB 9 DUP(0)
   OPER_2 DB 9 DUP(0)
   HELP_O DB 18 DUP(0)
   DIGIT_FLAG DB 0
   OPER_FLAGS DB 0
   O_F DB 0
   FIRST_OPER DB 0
   DIV_ZERO DB 0
   CMP_DIV DB 0
data ends
stack segment
   DW 128 dup(0)
stack ends
code segment
   start:IN AX,1
   XOR AX,AX
   MOV ES,AX
   MOV BX,8
   MOV SI,OFFSET[READ_KEY]
   MOV ES:[BX],SI
   ADD BX,2
   MOV AX,CS
   MOV ES:[BX],AX
   MOV AX,data
   MOV DS,AX
   MOV ES,AX
   MOV AX,07FH
   CIRCLE:MOV CX,8
   MOV DIGIT_FLAG,0
   C2:PUSH AX
   MOV BX,CX
   MOV AL,OPER_1[BX-1]
   CMP AL,0
   JE CHECK_DF
   MOV DIGIT_FLAG,1
   JMP SHOW_DIGIT
   CHECK_DF:CMP DIGIT_FLAG,1
   JE SHOW_DIGIT
   CMP BX,1
   JE SHOW_DIGIT
   JMP NOT_SHOW_DIGIT
   SHOW_DIGIT:LEA BX,SEG7
   XLATB
   XCHG DX,AX
   POP AX
   OUT DX, AX
   JMP NOT_POP
   NOT_SHOW_DIGIT:POP AX
   NOT_POP:ROR AL,1
   LOOP C2
   JMP CIRCLE
   READ_KEY:PUSH AX
   PUSH BX
   PUSH CX
   IN AX,1

   LEA BX,KEYPAD
   XLATB
   CMP AL,10
   JS NOT_OF
   MOV O_F,1
   NOT_OF:CMP AL,10
   JNE N1
   CALL ON_P
   JMP FULL
   N1:CMP AL,11
   JNE N2
   CALL EQU_P
   JMP FULL
   N2:CMP AL,12
   JS N3
   SUB AL,11
   MOV OPER_FLAGS,AL
   MOV FIRST_OPER,0
   JMP FULL
   N3:CMP O_F,0
   JE READ_DIGIT
   CALL CLEAR_OP_2
   CALL O1_XCHG_O2
   READ_DIGIT:MOV O_F,0
   CMP OPER_1[7],0
   JNE FULL
   MOV CX,7
   SHIFT:MOV BX,CX
   MOV AL,OPER_1[BX-1]
   MOV OPER_1[BX],AL
   LOOP SHIFT
   IN AX,1
   LEA BX,KEYPAD
   XLATB
   MOV OPER_1[0],AL
   FULL:POP CX
   POP BX
   POP AX
   IRET
   ON_P:PUSH CX
   PUSH BX
   MOV CX,9
   C3:MOV BX,CX
   MOV OPER_1[BX-1],0
   MOV OPER_2[BX-1],0
   LOOP C3
   MOV OPER_FLAGS,0
   MOV FIRST_OPER,0
   MOV O_F,0
   CALL CLEAR_HELP
   POP BX
   POP CX
   RET
   EQU_P:CMP OPER_FLAGS,0
   JE E4
   CMP FIRST_OPER,0
   JNE NFO
   CALL O1_XCHG_O2
   MOV FIRST_OPER,1
   NFO:CMP OPER_FLAGS,1

   JNE E1
   CALL ADD_P
   E1:CMP OPER_FLAGS,2
   JNE E2
   CALL SUB_P
   E2:CMP OPER_FLAGS,3
   JNE E3
   CALL MUL_P
   E3:CMP OPER_FLAGS,4
   JNE E4
   CALL DIV_P
   E4:RET
   ADD_P:PUSH AX
   PUSH BX
   PUSH CX
   MOV CX,8
   XOR BX,BX
   MOV AH,0
   C5:MOV AL,OPER_1[BX]
   ADD AL,AH
   ADD AL,OPER_2[BX]
   MOV AH,0
   AAA
   MOV OPER_1[BX],AL
   INC BX
   LOOP C5
   POP CX
   POP BX
   POP AX
   RET
   SUB_P:PUSH AX
   PUSH BX
   PUSH CX
   MOV CX,8
   XOR BX,BX
   MOV AH,0
   C6:MOV AL,OPER_1[BX]
   ADD AL,AH
   SUB AL,OPER_2[BX]
   MOV AH,0
   AAS
   MOV OPER_1[BX],AL
   INC BX
   LOOP C6
   POP CX
   POP BX
   POP AX
   RET
   MUL_P:PUSH AX
   PUSH BX
   PUSH CX
   PUSH DI
   MOV CX,8
   XOR DI,DI
   CALL CLEAR_HELP
   C77:PUSH CX
   MOV CX,8
   XOR BX,BX
   C7:MOV AL,OPER_1[BX]
   MUL OPER_2[DI]
   ADD AL,HELP_O[BX+DI]
   AAA
   MOV HELP_O[BX+DI],AL
   ADD AH,HELP_O[BX+DI+1]
   XCHG AH,AL
   MOV AH,0
   AAA
   MOV HELP_O[BX+DI+1],AL
   ADD HELP_O[BX+DI+2],AH
   INC BX
   LOOP C7
   INC DI
   POP CX
   LOOP C77
   CALL MOV_HELP_TO_OPER1
   POP DI
   POP CX
   POP BX
   POP AX
   RET
   DIV_P:PUSH AX
   PUSH BX
   PUSH CX
   PUSH DX
   CALL CHECK_DIV_ZERO
   CMP DIV_ZERO,0
   JE END_DIV
   CALL PREP_DIV
   XOR DX,DX
   NEXT_SHIFT_L:CALL CMP_OPER
   CMP CMP_DIV,0
   JE NOT_SHIFT_L
   INC DX
   MOV CX,8
   C8:MOV BX,CX
   MOV AL,OPER_2[BX-1]
   MOV OPER_2[BX],AL
   LOOP C8
   MOV OPER_2[0],0
   JMP NEXT_SHIFT_L
   NOT_SHIFT_L:CMP DX,0
   JE NOT_SHIFT_R
   NEXT_SHIFT_R:DEC DX
   MOV CX,8
   XOR BX,BX
   C_8:INC BX
   MOV AL,OPER_2[BX]
   MOV OPER_2[BX-1],AL
   LOOP C_8
   MOV OPER_2[8],0
   NOT_SHIFT_R:CALL CMP_OPER
   CMP CMP_DIV,0
   JE NOT_SUB
   CALL SUB_AT_DIV
   MOV BX,DX
   INC OPER_1[BX]
   JMP NOT_SHIFT_R
   NOT_SUB:CMP DX,0
   JE NOT_ON

   JMP NEXT_SHIFT_R
   END_DIV:CALL ON_P
   NOT_ON:POP DX
   POP CX
   POP BX
   POP AX
   RET
   O1_XCHG_O2:PUSH CX
   PUSH BX
   PUSH AX
   PUSH DX
   MOV CX,8
   C4:MOV BX,CX
   MOV AL,OPER_1[BX-1]
   MOV DL,OPER_2[BX-1]
   MOV OPER_1[BX-1],DL
   MOV OPER_2[BX-1],AL
   LOOP C4
   POP DX
   POP AX
   POP BX
   POP CX
   RET
   CLEAR_HELP:PUSH CX
   PUSH BX
   MOV CX,18
   XOR BX,BX
   C9:MOV HELP_O[BX],0
   INC BX
   LOOP C9
   POP BX
   POP CX
   RET
   CLEAR_OP_2:PUSH CX
   PUSH BX
   MOV CX,9
   XOR BX,BX
   C_9:MOV OPER_2[BX],0
   INC BX
   LOOP C_9
   POP BX
   POP CX
   RET
   MOV_HELP_TO_OPER1:PUSH CX
   PUSH BX
   PUSH AX
   MOV CX,8
   XOR BX,BX
   C10:MOV AL,HELP_O[BX]
   MOV OPER_1[BX],AL
   INC BX
   LOOP C10
   POP AX
   POP BX
   POP CX
   RET
   PREP_DIV:PUSH CX
   PUSH BX
   PUSH AX
   MOV CX,8

   XOR BX,BX
   C11:MOV AL,OPER_1[BX]
   MOV HELP_O[BX],AL
   MOV OPER_1[BX],0
   INC BX
   LOOP C11
   POP AX
   POP BX
   POP CX
   RET
   CHECK_DIV_ZERO:PUSH CX
   PUSH BX
   MOV CX,8
   MOV DIV_ZERO,0
   C12:MOV BX,CX
   CMP OPER_2[BX-1],0
   JE NOT_ZERO
   MOV DIV_ZERO,1
   NOT_ZERO:LOOP C12
   POP BX
   POP CX
   RET
   CMP_OPER:PUSH CX
   PUSH BX
   PUSH AX
   MOV CX,9
   MOV CMP_DIV,1
   C13:MOV BX,CX
   MOV AL,HELP_O[BX-1]
   CMP AL,OPER_2[BX-1]
   JE EQU_1_2
   JNC END_CMP
   MOV CMP_DIV,0
   JMP END_CMP
   EQU_1_2:LOOP C13
   END_CMP:POP AX
   POP BX
   POP CX
   RET
   SUB_AT_DIV:PUSH AX
   PUSH BX
   PUSH CX
   MOV CX,8
   XOR BX,BX
   MOV AH,0
   C14:MOV AL,HELP_O[BX]
   ADD AL,AH
   SUB AL,OPER_2[BX]
   MOV AH,0
   AAS
   MOV HELP_O[BX],AL
   INC BX
   LOOP C14
   POP CX
   POP BX
   POP AX
   RET
code ends
end start