__classe	EQU		0
__metInstancia	EQU		4

CODE1		SEGMENT		PARA PUBLIC 'CODE'
		PUBLIC		_ENVIA

		ASSUME		CS:CODE1,DS:NOTHING,SS:NOTHING,ES:NOTHING

_ENVIA		PROC		FAR
		PUSH		BP
		MOV		BP,SP
		PUSH		DS
		PUSH		DI
mov	cx,10h
mov	es,cx
mov	cl,'<'
mov	es:[0],cl
		MOV		AX,[BP+8]
		MOV		DS,AX
mov	cx,10h
mov	es,cx
mov	cl,'>'
mov	es:[0],cl
		MOV		AX,DS:[__classe]
		MOV		ES,AX
mov	cx,10h
mov	ds,cx
mov	cl,'.'
mov	ds:[0],cl
MOV	AX,[BP+8]
MOV	DS,AX
		MOV		BX,__metInstancia
		JMP		DWORD PTR ES:[BX]
_ENVIA		ENDP

CODE1		ENDS
		END
