		.286p
		EXTRN		_WRITE:WORD
		EXTRN		_Tarefa:WORD
		EXTRN		_Mensagem:WORD
		EXTRN		_Sincrona:WORD
		EXTRN		_Assincrona:WORD
		EXTRN		_Window:WORD
		EXTRN		_desenho_:WORD
		EXTRN		admtaref_data:WORD
		EXTRN		_interrompe:BYTE
		EXTRN		_impressao:WORD

_tarefaCorrente EQU		4aH
_filaValida	EQU		48H

_contaMSG	EQU		28H
_primeiraMSG	EQU		2AH

__classe	EQU		0
__proxMSG	EQU		2
__remetente	EQU		4
__nparam	EQU		6
__objeto	EQU		8
__seletor	EQU		10
__buffer	EQU		12

__estado	EQU		4
__priFixa	EQU		6
__priAtual	EQU		8
__proxTarefa	EQU		10
__filaMSG	EQU		12
__tss		EQU		18
__blink		EQU		20
__ip		EQU		34
__flags		EQU		36
__ax		EQU		38
__sp		EQU		46
__bp		EQU		48
__cs		EQU		56
__ss		EQU		58
__ds		EQU		60
__ldt		EQU		62
__identidade	EQU		44

__portaSincrona	EQU		70H

__pronto	EQU		0
__envia		EQU		1
__recebe	EQU		2

CODE		SEGMENT		PARA PUBLIC 'CODE'
		PUBLIC		INT_0,INT_1,INT_2,INT_3,INT_4,INT_5,INT_6
		PUBLIC		INT_7,INT_8,INT_9,INT_10,INT_11,INT_12,INT_13
		PUBLIC		INT_14,INT_15,INT_16,INT_32,INT_33,INT_81
		PUBLIC		INT_82,_INTERRUPT,_HABILITA

		ASSUME		CS:CODE,DS:NOTHING,ES:NOTHING,SS:NOTHING

; ----------------------------------------------------------------------------
; INTERRUPT - inicializa controlador de interrupcao (mapeamento - 20H a 2FH)
;             reset do teclado
;             inicializa timer (20ms)
; ----------------------------------------------------------------------------
_INTERRUPT	PROC		FAR
		MOV		AL,11H		; ICW1
		OUT		20H,AL
		jmp		short $+2
		MOV		AL,20H		; ICW2
		OUT		21H,AL
		jmp		short $+2
		MOV		AL,04H		; ICW3
		OUT		21H,AL
		jmp		short $+2
		MOV		AL,01H		; ICW4
		OUT		21H,AL
		jmp		short $+2

		MOV		AL,11H		; ICW1
		OUT		0A0H,AL
		jmp		short $+2
		MOV		AL,28H		; ICW2
		OUT		0A1H,AL
		jmp		short $+2
		MOV		AL,02H		; ICW3
		OUT		0A1H,AL
		jmp		short $+2
		MOV		AL,01H		; ICW4
		OUT		0A1H,AL
		jmp		short $+2



		MOV		AL,0FEH		; OCW1
		OUT		21H,AL
		jmp		short $+2

		MOV		AL,0FFH		; OCW1
		OUT		0A1H,AL
		jmp		short $+2

		MOV		AL,0FFH		; reset no teclado
		OUT		60H,AL
		jmp		$+2
I1:
		IN		AL,64H
		jmp		$+2
		AND		AL,1
		JZ		I1
		IN		AL,60H
		jmp		$+2
		CMP		AL,0AAH
		JNZ		I1

LA1:						; habilita gateA20
		IN		AL,64H
		AND		AL,2
		JNZ		LA1
		MOV		AL,0D1H
		OUT		64H,AL
		jmp		LA2
LA2:
		IN		AL,64H
		AND		AL,2
		JNZ		LA2
		MOV		AL,0DFH
		OUT		60H,AL
		jmp		LA3
LA3:
		IN		AL,64H
		AND		AL,2
		JNZ		LA3
		MOV		AL,0D0H
		OUT		64H,AL
		jmp		LA4
LA4:
		IN		AL,64H
		AND		AL,1
		JZ		LA4

		MOV		AL,34H		; INTERVALO DE 20ms
		OUT		43H,AL
		jmp		short $+2
		MOV		AL,0A8H
		OUT		40H,AL
		jmp		short $+2
		MOV		AL,61H
		OUT		40H,AL
		jmp		short $+2

		STI
		RET
_INTERRUPT	ENDP





_HABILITA	PROC		FAR
		CLI
		MOV		AL,0FCH		; OCW1
		OUT		21H,AL
		jmp		short $+2
		STI
		RET
_HABILITA	ENDP





; ----------------------------------------------------------------------------
; INT 0 - Divide Error
; ----------------------------------------------------------------------------
INT_0		PROC		FAR
		MOV		AL,'0'
		call		int
		call		tarefa
		call		teclado
INT_0		ENDP
; ----------------------------------------------------------------------------
; INT 1 - Single Step
; ----------------------------------------------------------------------------
INT_1		PROC		FAR
		MOV		AL,'1'
		call		int
		call		tarefa
		call		teclado
INT_1		ENDP
; ----------------------------------------------------------------------------
; INT 2
; ----------------------------------------------------------------------------
INT_2		PROC		FAR
		MOV		AL,'2'
		call		int
		call		teclado
INT_2		ENDP
; ----------------------------------------------------------------------------
; INT 3 - Breakpoint
; ----------------------------------------------------------------------------
INT_3		PROC		FAR
		MOV		AL,'3'
		call		int
		call		tarefa
		call		teclado
INT_3		ENDP
; ----------------------------------------------------------------------------
; INT 4 - Overflow
; ----------------------------------------------------------------------------
INT_4		PROC		FAR
		MOV		AL,'4'
		call		int
		call		tarefa
		call		teclado
INT_4		ENDP
; ----------------------------------------------------------------------------
; INT 5 - Bound Check
; ----------------------------------------------------------------------------
INT_5		PROC		FAR
		MOV		AL,'5'
		call		int
		call		tarefa
		call		teclado
INT_5		ENDP
; ----------------------------------------------------------------------------
; INT 6 - Undefined Opcode
; ----------------------------------------------------------------------------
INT_6		PROC		FAR
		MOV		AL,'6'
		call		int
		call		tarefa
		call		teclado
INT_6		ENDP
; ----------------------------------------------------------------------------
; INT 7 - Processor Extension Not Available
; ----------------------------------------------------------------------------
INT_7		PROC		FAR
		MOV		AL,'7'
		call		int
		call		tarefa
		call		teclado
INT_7		ENDP
; ----------------------------------------------------------------------------
; INT 8 - Double Fault
; ----------------------------------------------------------------------------
INT_8		PROC		FAR
		MOV		AL,'8'
		call		int
		call		imprime
		call		tarefa
		call		teclado
INT_8		ENDP
; ----------------------------------------------------------------------------
; INT 9 - Processor Extension Segment Overrun
; ----------------------------------------------------------------------------
INT_9		PROC		FAR
		MOV		AL,'9'
		call		int
		call		tarefa
		call		teclado
INT_9		ENDP
; ----------------------------------------------------------------------------
; INT 10 - Invalid TSS
; ----------------------------------------------------------------------------
INT_10		PROC		FAR
		MOV		AL,'A'
		call		int
		call		imprime
		call		tarefa
		call		teclado
INT_10		ENDP





; ----------------------------------------------------------------------------
; INT 11 - Not Present
; ----------------------------------------------------------------------------
aliasGDT	EQU		2
estaTarefa	EQU		4
msg		EQU		6
Rec		EQU		8
Rem		EQU		10

INT_11		PROC		FAR
;
; [bp-2] = aliasGDT
; [bp-4] = esta tarefa
; [bp-6] = mensagem enviada
; [bp-8] = Receptor
; [bp-10] = Remetente
;
		MOV		DX,'4'
		POP		CX
		MOV		BP,SP
		SUB		SP,10
		MOV		[BP-aliasGDT],SI
		MOV		[BP-estaTarefa],DI
		PUSH		CX
I11A:
		mov		ax,10h
		mov		es,ax
		mov		es:[154],dl
		mov		es:[2],dl
		xor		dl,1
		POP		CX
;
; se (!(msg=Mensagem[primeiraMSG]))
;        erro ();
;
		MOV		AX,seg _Mensagem     ; ds = Mensagem
		MOV		DS,AX
		MOV		AX,DS:[_primeiraMSG]
		CMP		AX,0
		JNZ		I11B
		MOV		AX,10H
		MOV		ES,AX
		mov		al,'M'
		mov		es:[0],al
		mov		al,'S'
		mov		es:[2],al
		mov		al,'G'
		mov		es:[4],al
		call		teclado
I11B:
;
; Mensagem[primeiraMSG] = msg[proxMSG];
; Mensagem[contaMSG]--;
;
		MOV		[BP-msg],AX          ; es = msg
		MOV		ES,AX
		MOV		AX,ES:[__proxMSG]
		MOV		DS:[_primeiraMSG],AX
		DEC		WORD PTR DS:[_contaMSG]
push	130
push	'CT'
push	word ptr ds:[_contaMSG]
call	regs
;
; Rem = aliasTSS[estaTarefa[__blink]][__identidade]
; msg[__remetente] = Rem
; segSTK = Rem[ss]
; topoSTK = Rem[bp]
;
		MOV		AX,[BP-estaTarefa]
		MOV		DS,AX
		MOV		BX,DS:[__blink]
		MOV		AX,[BP-aliasGDT]
		MOV		DS,AX
		MOV		AX,[BX]
		ADD		AX,4
		MOV		DS:[8],AX
		MOV		AX,[BX+2]
		MOV		DS:[10],AX
		MOV		AX,[BX+4]
		MOV		AH,92H
		MOV		DS:[12],AX
		MOV		AX,8
		MOV		DS,AX
		MOV		AX,DS:[__identidade]
		MOV		ES:[__remetente],AX
		MOV		[BP-Rem],AX          ; ds = Rem
		MOV		DS,AX
		MOV		DI,DS:[__ss]         ; di = stack do Rem
		MOV		SI,DS:[__bp]         ; si = topo stack do Rem
;
; cria aliasLDT do remetente
;
		MOV		BX,DS:[__ldt]
		MOV		AX,[BP-aliasGDT]     ; es = aliasGDT
		MOV		ES,AX
		MOV		AX,ES:[BX]
		MOV		ES:[8],AX
		MOV		AX,ES:[BX+2]
		MOV		ES:[10],AX
		MOV		AX,ES:[BX+4]
		MOV		AH,92H
		MOV		ES:[12],AX
		MOV		AX,8                 ; ds = alias LDT do Rem
		MOV		DS,AX
;
; cria alias do stack do remetente
;
		AND		DI,0FFF8H
		MOV		AX,[DI]
		MOV		BX,[DI+2]
		MOV		CX,[DI+4]
		MOV		ES:[8],AX
		MOV		ES:[10],BX
		MOV		ES:[12],CX
		MOV		AX,8                 ; ds = alias stack do Rem
		MOV		DS,AX
;
; seletor = aliasSTKRem[topoSTKR+10]
; nparam = seletor:[numeroParametros]
; msg[__seletor] = seletor
; msg[__nparam] = nparam
; copia msg
;
		MOV		DI,[SI+10]           ; es = di = seletor
		MOV		ES,DI
		MOV		CX,ES:[4]            ; cx = numero de param.
		MOV		AX,[BP-msg]
		MOV		ES,AX                ; es = msg
		MOV		ES:[__seletor],DI
		MOV		ES:[__nparam],CX
		MOV		BX,SI                ; bx = topoSTKR
		JCXZ		I11C
		ADD		SI,12
		MOV		DI,__buffer
		REP	MOVSW
I11C:
;
; Rem[__sp] = Rem[__bp] + 8
; Rem[__bp] = aliasSTKR[topoSTKR]
; Rem[__ip] = aliasSTKR[topoSTKR+2]
; Rem[__cs] = aliasSTKR[topoSTKR+4]
; Rem[__flags] = aliasSTKR[topoSTKR+6]
;
		MOV		AX,[bp-Rem]          ; es = Rem
push	80
push	'RM'
push	ax
call	regs
		MOV		ES,AX
		MOV		AX,8
		ADD		AX,BX
		MOV		ES:[__sp],AX
		MOV		AX,[BX]
		MOV		ES:[__bp],AX
		MOV		AX,[BX+2]
		MOV		ES:[__ip],AX
		MOV		AX,[BX+4]
		MOV		ES:[__cs],AX
		MOV		AX,[BX+6]
push	100
push	'FL'
push	ax
call	regs
		MOV		ES:[__flags],AX
;
; porta = aliasSTKRem[topoSTKR+8]
; if (porta & 0x04)
;       { porta &= 0xFFF8
;       cria aliasLDT do remetente
;       Rec = aliasLDT[porta]
;       dh = tipo de porta
;       bx = aliasLDT[porta+6] }
;
		MOV		DI,[BX+8]            ; di = porta
		MOV		AX,DI
		AND		AX,4
		JZ		I11D
		AND		DI,0FFF8H
		MOV		AX,[BP-Rem]
		MOV		DS,AX
		MOV		BX,DS:[__ldt]
		MOV		AX,[BP-aliasGDT]     ; es = aliasGDT
		MOV		ES,AX
		MOV		AX,ES:[BX]
		MOV		ES:[8],AX
		MOV		AX,ES:[BX+2]
		MOV		ES:[10],AX
		MOV		AX,ES:[BX+4]
		MOV		AH,92H
		MOV		ES:[12],AX
		MOV		AX,8                 ; ds = alias LDT do Rem
		MOV		DS,AX
		MOV		AX,[DI]
		MOV		[BP-Rec],AX
		MOV		DH,[DI+5]
		MOV		BX,[DI+6]
		JMP		I11E
I11D:
;
;  else { Rec = aliasGDT[porta]
;       dh = tipo de porta
;       bx = aliasGDT[porta+6] }
;
		MOV		AX,[BP-aliasGDT]     ; es = aliasGDT
		MOV		ES,AX
		MOV		AX,ES:[DI]
		MOV		[BP-Rec],AX
		MOV		DH,ES:[DI+5]         ; tipo de porta
		MOV		BX,ES:[DI+6]         ; bx = objeto local
I11E:
;
; msg[__objeto] = bx
; msg[__classe] = (!portaSincrona) ? Assincrona : Sincrona
;
		MOV		AX,[BP-msg]          ; es = msg
		MOV		ES,AX
		MOV		ES:[__objeto],BX
		CMP		DH,__portaSincrona
		JZ		I11F
		MOV		AX,seg _Assincrona
		JMP		I11G
I11F:
		MOV		AX,seg _Sincrona		
I11G:
		MOV		ES:[__classe],AX
;
; se (Rec[estado]==__recebe)
;        { Rec[estado] = __pronto
;        Rec[__ax] = msg
;        Rec[proxTarefa] = tarefaCorrente[proxTarefa]
;        tarefaCorrente[proxTarefa] = Rec }
;
		MOV		SI,[BP-Rec]          ; ds = si = Rec
		MOV		DS,SI
		CMP		WORD PTR DS:[__estado],__recebe
		JNZ		I11H
		MOV		WORD PTR DS:[__estado],__pronto
		MOV		AX,[BP-msg]
		MOV		DS:[__ax],AX
		MOV		AX,seg _Tarefa
		MOV		ES,AX
		MOV		AX,ES:[_tarefaCorrente]
		MOV		ES,AX                ; es = tarefaCorrente
		MOV		AX,ES:[__proxTarefa]
		MOV		DS:[__proxTarefa],AX
		MOV		ES:[__proxTarefa],SI
		JMP		I11J
;
;   else if (!Rec[filaMSG])
;               Rec[filaMSG] = msg[proxMSG] = msg
;          else { cx = Rec[filaMSG][proxMSG]
;               Rec[filaMSG][proxMSG] = msg
;               Rec[filaMSG] = msg
;               msg[proxMSG] = cx }
;
I11H:
		CMP		WORD PTR DS:[__filaMSG],0
		JNZ		I11I
		MOV		AX,[BP-msg]          ; es = msg
		MOV		ES,AX
		MOV		ES:[__proxMSG],AX
		MOV		DS:[__filaMSG],AX
		JMP		I11J
I11I:
		MOV		AX,DS:[__filaMSG]    ; es = Rec[filaMSG]
		MOV		ES,AX
		MOV		CX,ES:[__proxMSG]    ; cx = Rec[filaM][proxM]
		MOV		AX,[BP-msg]          ; ax = msg
		MOV		ES:[__proxMSG],AX
		MOV		DS:[__filaMSG],AX
		MOV		ES,AX                ; es = msg
		MOV		ES:[__proxMSG],CX
I11J:
;
; destroi entrada 8 da GDT
; se (!portaSincrona)
;        { Rem[__ax] = 0
;        ds = es = 0 }
;
		MOV		AX,[BP-aliasGDT]     ; es = aliasGDT
		MOV		ES,AX
		XOR		AX,AX
		MOV		ES:[13],AL
		CMP		DH,__portaSincrona
		JZ		I11K
		MOV		AX,[BP-Rem]          ; es = Rem
		MOV		ES,AX
		XOR		AX,AX
		MOV		ES:[__ax],AX
		MOV		DS,AX
		MOV		ES,AX
		JMP		I11L
;
;   else { dx = envia
;        di = estaTarefa
;        ds = Tarefa
;        ESCALA () }
; iret
; jmp I11A
;
I11K:
		PUSH		DX
		MOV		DX,__envia
		MOV		DI,[BP-estaTarefa]
		MOV		AX,seg _Tarefa       ; ds = Tarefa
		MOV		DS,AX
		CALL		ESCALA
		POP		DX
I11L:
		IRET
		JMP		I11A
INT_11		ENDP





; ----------------------------------------------------------------------------
; INT 12 - Stack Exception
; ----------------------------------------------------------------------------
INT_12		PROC		FAR
		MOV		AL,'C'
		call		int
		call		imprime
		call		tarefa
		call		teclado
INT_12		ENDP
; ----------------------------------------------------------------------------
; INT 13 - General Protection Fault
; ----------------------------------------------------------------------------
INT_13		PROC		FAR
		MOV		AL,'D'
		call		int
		call		imprime
		call		tarefa
		call		teclado
INT_13		ENDP
; ----------------------------------------------------------------------------
; INT 14
; ----------------------------------------------------------------------------
INT_14		PROC		FAR
		MOV		AL,'E'
		call		int
		call		teclado
INT_14		ENDP
; ----------------------------------------------------------------------------
; INT 15 - Ponto de Parada
; ----------------------------------------------------------------------------
INT_15		PROC		FAR
		call		tarefa
		call		teclado
INT_15		ENDP





; ----------------------------------------------------------------------------
; INT 16 - Espera Tecla
; ----------------------------------------------------------------------------
INT_16		PROC		FAR
		MOV		AX,10H
		MOV		DS,AX
		MOV		AX,seg admtaref_data
		MOV		ES,AX
		MOV		DL,'e'
tecla1:
		MOV		AL,0FDH
		OUT		21H,AL
		jmp		short $+2
tecla2:
		IN		AL,64H
		AND		AL,1
		JNZ		tecla3
		IN		AL,60H
		JMP		tecla2
tecla3:
		MOV		ES:[_interrompe],2
		STI
tecla4:
		MOV		DS:[0],DL
		XOR		DL,1
		CMP		ES:[_interrompe],2
		JZ		tecla4
		CLI
		MOV		AL,0FCH
		OUT		21H,AL
		jmp		short $+2
		IRET
		JMP		tecla1
INT_16		ENDP





; ----------------------------------------------------------------------------
; INT 32 - Timer
; ----------------------------------------------------------------------------
INT_32		PROC		FAR
		MOV		AX,seg _Tarefa
		MOV		DS,AX
		MOV		DX,'0'
VOLTA:
		mov		ax,10H
		mov		es,ax
		mov		es:[158],dl
		mov		es:[2],dl
		xor		dl,1
		CMP		WORD PTR DS:[_filaValida],0
		JZ		SAI
		PUSH		DX
		MOV		DX,__pronto
		CALL		ESCALA
		POP		DX
SAI:
		MOV		AL,20H
		OUT		20H,AL
		jmp		$+2
		IRET
		JMP		VOLTA
INT_32		ENDP





; ----------------------------------------------------------------------------
; INT 33 - Teclado
; ----------------------------------------------------------------------------
INT_33		PROC		FAR
		MOV		DX,'2'
LOOP1:
		IN		AL,60H
		mov		ds:[156],dl
		mov		ds:[2],dl
		xor		dl,1
		MOV		CX,seg admtaref_data
		MOV		ES,CX
		CMP		ES:[_interrompe],1
		JZ		RESET

		CMP		ES:[_interrompe],2
		JNZ		LOOP3
LOOP2:
		IN		AL,64H
		AND		AL,1
		JZ		LOOP2
		IN		AL,60H
		CMP		AL,143
		JNZ		LOOP2
		MOV		ES:[_interrompe],0
		JMP		FORA
LOOP3:
		PUSH		AX
		PUSH		seg _desenho_
		PUSH		seg _Window
		INT		50H
		ADD		SP,6
FORA:
		MOV		AL,20H
		OUT		20H,AL		; OCW2
		JMP		$+2
		IRET
		JMP		LOOP1


RESET:
		MOV		AL,0FEH
		OUT		64H,AL
R1:
		JMP		R1
INT_33		ENDP





; ----------------------------------------------------------------------------
; INT 81 - Recebe
; ----------------------------------------------------------------------------
INT_81		PROC		FAR
		MOV		DX,'6'
I81A:
		mov		ax,10h
		mov		es,ax
		mov		es:[152],dl
		mov		es:[2],dl
		xor		dl,1
;
; Rec = Tarefa[tarefaCorrente]
; if (Rec[filaMSG])
;        { cx = Rec[filaMSG][proxMSG]
;        Rec[__ax] = cx
;        if (cx==Rec[filaMSG])
;               Rec[filaMSG] = 0
;          else Rec[filaMSG][proxMSG] = cx[proxMSG]
;        ds = es = 0 }
;
		MOV		AX,seg _Tarefa
		MOV		DS,AX
		MOV		AX,DS:[_tarefaCorrente]
		MOV		ES,AX                ; es = Rec
		MOV		AX,ES:[__filaMSG]
		CMP		AX,0
		JZ		I81D
		MOV		DS,AX                ; ds = Rec[filaMSG]
		MOV		CX,DS:[__proxMSG]
		MOV		ES:[__ax],CX
		CMP		AX,CX
		JNZ		I81B
		XOR		AX,AX
		MOV		ES:[__filaMSG],AX
		JMP		I81C
I81B:
		MOV		ES,CX                ; es = Rec[flMSG][prxMSG]
		MOV		AX,ES:[__proxMSG]
		MOV		DS:[__proxMSG],AX
I81C:
		XOR		AX,AX
		MOV		DS,AX
		MOV		ES,AX
		JMP		I81E
I81D:
;
;   else { dx = recebe
;        ESCALA () }
; iret
; jmp I81A
;
		PUSH		DX
		MOV		DX,__recebe
		CALL		ESCALA
		POP		DX
I81E:
		IRET
		JMP		I81A
INT_81		ENDP





tarefcor	EQU		4

; ----------------------------------------------------------------------------
; INT 82 - Responde
; ----------------------------------------------------------------------------
INT_82		PROC		FAR
		MOV		DX,'8'
		MOV		BP,SP
		PUSH		SI
		DEC		SP
		DEC		SP
I82A:
		mov		ax,10h
		mov		es,ax
		mov		es:[150],dl
		mov		es:[2],dl
		xor		dl,1
;
; tarefcor = Rem = Tarefa[tarefaCorrente]
; si = Rem[__sp]
; di = Rem[__ss]
;
		MOV		AX,seg _Tarefa
		MOV		DS,AX
		MOV		AX,DS:[_tarefaCorrente]
		MOV		DS,AX                ; ds = tarefa corrente
		MOV		[BP-tarefcor],AX
		MOV		SI,DS:[__sp]
		MOV		DI,DS:[__ss]
;
; cria aliasLDT do remetente
;
		MOV		BX,DS:[__ldt]
		MOV		AX,[BP-aliasGDT]     ; es = aliasGDT
		MOV		ES,AX
		MOV		AX,ES:[BX]
		MOV		ES:[8],AX
		MOV		AX,ES:[BX+2]
		MOV		ES:[10],AX
		MOV		AX,ES:[BX+4]
		MOV		AH,92H
		MOV		ES:[12],AX
		MOV		AX,8                 ; ds = alias LDT do Rem
		MOV		DS,AX
;
; cria alias do stack do remetente
;
		AND		DI,0FFF8H
		MOV		AX,DS:[DI]
		MOV		BX,DS:[DI+2]
		MOV		CX,DS:[DI+4]
		MOV		ES:[8],AX
		MOV		ES:[10],BX
		MOV		ES:[12],CX
		MOV		AX,8                 ; ds = alias stack do Rem
		MOV		DS,AX
;
; msg = aliasSTK[si]
; if (msg[__classe]==Sincrona)
;        { Rec = msg[__remetente]
;        Rec[__ax] = aliasSTK[si+2]
;        if (Rec[estado]==envia)
;               { Rec[estado] = pronto
;               acorda Rec } }
;
		MOV		AX,DS:[SI]           ; es = msg
		MOV		ES,AX
		CMP		WORD PTR ES:[__classe],seg _Sincrona
		JNZ		I82B
		MOV		CX,ES:[__remetente]  ; es = Rec
		MOV		ES,CX
		MOV		AX,DS:[SI+2]
		MOV		ES:[__ax],AX
		CMP		WORD PTR ES:[__estado],__envia
		JNZ		I82B
		MOV		WORD PTR ES:[__estado],__pronto
		MOV		AX,[BP-tarefcor]     ; ds = Rem
		MOV		DS,AX
		MOV		AX,DS:[__proxTarefa]
		MOV		DS:[__proxTarefa],CX
		MOV		ES:[__proxTarefa],AX
;
; dealoca msg
; destroi entrada 8 da GDT
; ds = es = 0
; iret
; jmp I82A
;
I82B:
		MOV		AX,8                 ; es = alias stack do Rem
		MOV		ES,AX
		MOV		CX,ES:[SI]
		MOV		AX,seg _Mensagem     ; ds = Mensagem
		MOV		DS,AX
		MOV		AX,DS:[_primeiraMSG]
		MOV		DS:[_primeiraMSG],CX
		MOV		ES,CX
		MOV		ES:[__proxMSG],AX
		INC		WORD PTR DS:[_contaMSG]
push	130
push	'CT'
push	word ptr ds:[_contaMSG]
call	regs
		MOV		AX,[BP-aliasGDT]
		MOV		ES,AX
		XOR		AX,AX
		MOV		ES:[13],AL
		MOV		DS,AX
		MOV		ES,AX
		IRET
		JMP		I82A
INT_82		ENDP





ESCALA		PROC		NEAR
; ----------------------------------------------------------------------------
; BX - prioridade da tarefa a ser escalada
; CX - final da fila circular de tarefas no estado de pronto
; DX - tipo de operacao ---> parametro de entrada
;                 pronto: tarefa nao sera suspensa
;                 envia : tarefa sera suspensa em envia
;                 recebe: tarefa sera suspensa em recebe
;
; SI - tarefa a ser escalada
; DI - objeto-tarefa ---> parametro de entrada
;
; DS - segmento de dados da classe Tarefa ---> parametro de entrada
; ES - fila de objetos-tarefa no estado de pronto
; ----------------------------------------------------------------------------
		MOV		AX,DS:[_tarefaCorrente]
		MOV		CX,AX
		CMP		DX,__pronto
		JZ		V0
;
; pula tarefaCorrente que sera suspensa
;
		MOV		ES,AX
		MOV		AX,ES:[__proxTarefa]
V0:
		MOV		ES,AX
		MOV		SI,AX
		MOV		BX,ES:[__priAtual]
V1:
		DEC		WORD PTR ES:[__priAtual]
		MOV		AX,ES:[__proxTarefa]
		CMP		AX,CX
		JZ		V2
		MOV		ES,AX
		MOV		AX,ES:[__priAtual]
		CMP		BX,AX
		JLE		V1
		MOV		BX,AX
		MOV		SI,ES
		JMP		SHORT V1
V2:
		CMP		DX,__pronto
		JZ		V3
;
; suspende tarefaCorrente
;
		MOV		CX,DS
		MOV		DS,AX
		MOV		AX,DS:[__proxTarefa]
		MOV		ES:[__proxTarefa],AX
		XOR		AX,AX
		MOV		DS:[__proxTarefa],AX
		MOV		DS:[__estado],DX
		MOV		DS,CX
V3:
		MOV		DS:[_tarefaCorrente],SI
		MOV		ES,SI
		MOV		AX,ES:[__priFixa]
		MOV		ES:[__priAtual],AX
		MOV		AX,ES:[__tss]
		MOV		ES,DI
		MOV		ES:[__blink],AX
		XOR		AX,AX
		MOV		ES,AX

		MOV		AL,34H		; INTERVALO DE 20ms
		OUT		43H,AL
		jmp		short $+2
		MOV		AL,0A8H
		OUT		40H,AL
		jmp		short $+2
		MOV		AL,61H
		OUT		40H,AL
		jmp		short $+2
		RET
ESCALA		ENDP





rastro		proc		near
		push		bp
		mov		bp,sp
		push		ax
		push		es
		mov		ax,10h
		mov		es,ax
		mov		ax,[bp+4]
		mov		es:[0],al
		pop		es
		pop		ax
		pop		bp
		ret		2
rastro		endp





regs		proc		near
		push		bp
		mov		bp,sp
		push		ds
		push		ax
		push		bx
		push		cx
		push		si
		mov		si,[bp+8]
		add		si,12
		mov		ax,10h
		mov		ds,ax
		mov		ax,[bp+4]
		mov		bx,[bp+6]
		mov		ds:[si-12],bh
		mov		ds:[si-10],bl
		mov		bx,4
regs1:
		mov		bh,al
		and		bh,0fh
		mov		cx,4
		shr		ax,cl
		cmp		bh,9
		jg		regs2
		add		bh,'0'
		jmp		regs3
regs2:
		add		bh,'A'-0ah
regs3:
		mov		ds:[si],bh
		dec		si
		dec		si
		dec		bl
		jnz		regs1
		pop		si
		pop		cx
		pop		bx
		pop		ax
		pop		ds
		pop		bp
		ret		6
regs		endp





tarefa		proc		near
		push		ax
		push		es
		mov		ax,seg _Tarefa
		mov		es,ax
		mov		ax,es:[_tarefaCorrente]
		push		80
		push		'TC'
		push		ax
		call		regs
		push		100
		push		'  '
		xor		ax,ax
		push		ax
		call		regs
		pop		es
		pop		ax
		ret
tarefa		endp






int		proc		near
		mov		ah,'I'
		mov		ds:[6],ah
		mov		ds:[8],al
		ret
int		endp



teclado		proc		near
		mov		ax,seg admtaref_data
		mov		es,ax
		mov		es:[_interrompe],1
tec1:
		in		al,64h
		and		al,1
		jnz		tec2
		in		al,60h
		jmp		tec1
tec2:
		sti
tec3:
		nop
		nop
		jmp		tec3
teclado		endp



imprime		proc		near
		push		bp
		mov		bp,sp
		mov		bx,18
		mov		ax,[bp+4]
		mov		dx,4
l1:
		mov		ch,0fh
		and		ch,al
		cmp		ch,9
		jg		l2
		add		ch,'0'
		jmp		l3
l2:
		add		ch,'A'-0ah
l3:
		mov		[bx],ch
		mov		cl,4
		shr		ax,cl
		dec		bx
		dec		bx
		dec		dx
		jnz		l1

		pop		bp
		ret
imprime		endp


CODE		ENDS
		END
