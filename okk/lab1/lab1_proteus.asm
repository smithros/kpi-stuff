CODE    SEGMENT PUBLIC 'CODE'
        ASSUME CS:CODE
START:
	MOV AL, 5   ; AL = 5
	ADD AL, -3  ; AL = 2
ENDLESS:
        JMP ENDLESS
CODE    ENDS
        END START