.186
ASSUME DS:DATA
data segment
ORG 100h
S DB 3CH,7EH,0E7H,0C3H,0C3H,0E7H,7EH,3CH
DB 18H,38H,78H,18H,18H,18H,18H,3CH
DB 3CH,7EH,66H,0CH,18H,30H,7EH,7EH
DB 3CH,7EH,66H,0CH,0CH,66H,7EH,3CH
DB 0CH,1CH,3CH,6CH,0FFH,0FFH,0CH,0CH
DB 7EH,7EH,60H,7CH,7EH,06H,7EH,7CH
DB 3CH,7EH,60H,7CH,7EH,66H,7EH,3CH
DB 7EH,7EH,0CH,18H,3CH,18H,18H,18H
DB 3CH,7EH,66H,3CH,7EH,66H,7EH,3CH
DB 3CH,7EH,66H,7EH,3EH,06H,7EH,3CH
DB 18H,3CH,66H,0C3H,0FFH,0FFH,0C3H,0C3H
DB 7CH,7EH,66H,7CH,7CH,66H,7EH,7CH
DB 3CH,7EH,0C3H,0C0H,0C0H,0C3H,7EH,3CH
DB 7CH,7EH,67H,63H,63H,67H,7EH,7CH
DB 7EH,7EH,60H,7EH,7EH,60H,7EH,7EH
DB 7EH,7EH,60H,7EH,7EH,60H,60H,60H
data ends
stack segment
   DW 128 dup(0)
stack ends
code segment
START:
   BEGIN:
   MOV AL,7FH
   PUSH AX
   MOV CX,8
   XOR BX,BX
   C1:IN AL,4
   MOV DH,AL
   MOV DL,AL
   SHR DH,4
   CMP DH,15
   JZ NOT_KEY
   PUSH CX
   MOV CX,4
   XOR AH,AH
   C2:TEST DH,1
   JZ NOT_INC_H
   INC AH
   SHR DH,1
   LOOP C2
   NOT_INC_H:SHL AH,2
   MOV CX,4
   XOR AL,AL
   C3:TEST DL,1
   JZ NOT_INC_L
   INC AL
   SHR DL,1
   LOOP C3
   NOT_INC_L:ADD AL,AH
   XOR AH,AH
   MOV SI,AX
   SHL SI,3
   POP CX
   NOT_KEY:MOV AL,0FFH
   OUT 0,AL
   MOV AL,S[BX+SI]
   OUT 2,AL
   POP AX
   OUT 0,AL
   ROR AL,1
   PUSH AX
   INC BX
   LOOP C1
   JMP BEGIN
code ends
end start
