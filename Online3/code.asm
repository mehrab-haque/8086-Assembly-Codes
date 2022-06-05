.MODEL SMALL 
.STACK 100H 
.DATA

CR EQU 0DH
LF EQU 0AH  

inputBasePromptMsg db "Enter base : $"
inputNumberPromptMsg db "Enter the number : $"   
outputPromptMsg db "Binary representation : $"
base dw ?
number dw ?
negFlag db 0

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX,inputBasePromptMsg
    MOV AH,9
    INT 21H
    CALL NUMBER_INPUT
    mov base,bx  
    CALL NEW_LINE
    LEA DX,inputNumberPromptMsg
    MOV AH,9
    INT 21H
    CALL BASED_NUMBER_INPUT
    mov number,bx  
    CALL NEW_LINE
    LEA DX,inputNumberPromptMsg
    MOV AH,9
    INT 21H
    call PRINT_BINARY_NUMBER
    MOV AH, 4CH
    INT 21H      
    
MAIN ENDP



PRINT_BINARY_NUMBER PROC   
    cmp bx,0
    jge NON_NEGATIVE_NUMBER
    mov dl,'-'
    mov ah,2
    int 21h
    neg bx 
NON_NEGATIVE_NUMBER:    
    MOV ax,bx
    MOV bx, 2
    XOR dx, dx 
    XOR cx, cx 
CALC_LOOP:
	XOR dx, dx 
	DIV bx 
	PUSH dx
	INC cx 
	CMP ax, 0 
	JNE CALC_LOOP
PRINT_LOOP:
	POP dx 
	ADD dx, '0'
	MOV ah, 2
	INT 21h
	LOOP PRINT_LOOP               
    CALL SPACE               
    ret               
PRINT_BINARY_NUMBER ENDP



NEW_LINE PROC
    mov dl,lf
    mov ah,2
    int 21h
    mov dl,cr
    mov ah,2
    int 21h
    ret
NEW_LINE ENDP

SPACE PROC
    mov dl,' '
    mov ah,2
    int 21h
    ret
SPACE ENDP

NUMBER_INPUT PROC
    XOR BX, BX
    MOV negFlag, 0
INPUT_LOOP: 
    MOV AH, 1
    INT 21H
    CMP AL, CR    
    JE END_INPUT_LOOP
    CMP AL, LF
    JE END_INPUT_LOOP
    CMP AL, ' '
    JE END_INPUT_LOOP
    CMP AL, '-'
    JNE NON_NEGATIVE
    MOV negFlag,1
    JMP INPUT_LOOP
NON_NEGATIVE:
    AND AX, 000FH 
    MOV CX, AX
    MOV AX, 10
    MUL BX
    ADD AX, CX
    MOV BX, AX
    JMP INPUT_LOOP 
END_INPUT_LOOP:
    CMP negFlag,1
    JNE LOOP_END
    NEG BX
LOOP_END:
    ret                                    
NUMBER_INPUT ENDP

BASED_NUMBER_INPUT PROC
    XOR BX, BX
    MOV negFlag, 0
BASED_INPUT_LOOP: 
    MOV AH, 1
    INT 21H
    CMP AL, CR    
    JE BASED_END_INPUT_LOOP
    CMP AL, LF
    JE BASED_END_INPUT_LOOP
    CMP AL, ' '
    JE BASED_END_INPUT_LOOP
    CMP AL, '-'
    JNE BASED_NON_NEGATIVE
    MOV negFlag,1
    JMP BASED_INPUT_LOOP
BASED_NON_NEGATIVE:
    AND AX, 000FH 
    MOV CX, AX
    MOV AX, base
    MUL BX
    ADD AX, CX
    MOV BX, AX
    JMP BASED_INPUT_LOOP 
BASED_END_INPUT_LOOP:
    CMP negFlag,1
    JNE BASED_LOOP_END
    NEG BX
BASED_LOOP_END:
    ret                                    
BASED_NUMBER_INPUT ENDP