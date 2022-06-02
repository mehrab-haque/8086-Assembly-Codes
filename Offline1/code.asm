.MODEL SMALL 
.STACK 100H 
.DATA

CR EQU 0DH
LF EQU 0AH
ARR DW 100 DUP(?)
inputPromptMsg db "Enter the number of numbers : $"
inputIndexPromptMsg db "Enter an element in the array (32=New Arrau,64=Exit) : $"
inputErrorMsg db "Invalid input$" 
sortOutputTitle db "Sorted Array : $"
searchOutput db "Found index : $"
searchOutputNotFound db "Not Found$"
negFlag db 0
tmp dw ?
n dw ?
pos1 dw ?
pos2 dw ?
pos3 dw ?
posEnd dw ?
posStart dw ?
ub dw ?
lb dw ?
mid dw ?
numberToFind dw ?

.CODE 
MAIN PROC
    ; init DS
    MOV AX, @DATA
    MOV DS, AX
ARRAY_INPUT:
    LEA SI,ARR
    CALL NEW_LINE
    CALL NEW_LINE
    LEA DX,inputPromptMsg
    MOV AH,9
    INT 21H
    CALL NUMBER_INPUT
    mov n,bx
    mov tmp,bx
    CALL NEW_LINE    
    cmp bx,0
    jg MAIN_INPUT
    LEA DX,inputErrorMsg
    MOV AH,9
    INT 21H
    call NEW_LINE
    JMP ARRAY_INPUT  
MAIN_INPUT:
    CALL NUMBER_INPUT
    mov word ptr [si],bx
    add si,2
    dec tmp 
    jnz MAIN_INPUT
    CALL NEW_LINE
    CALL INSERTION_SORT
    LEA DX,sortOutputTitle
    MOV AH,9
    INT 21H
    CALL DISPLAY_ARRAY
    CALL NEW_LINE 
BINARY_SEARCH_INPUT:    
    CALL NEW_LINE 
    LEA DX,inputIndexPromptMsg
    MOV AH,9
    INT 21H
    CALL NUMBER_INPUT
    cmp bx,32
    je ARRAY_INPUT
    cmp bx,64
    je MAIN_END 
    CALL BINARY_SEARCH
    CALL NEW_LINE
    cmp bx,0
    jl NOT_FOUND
    LEA DX,searchOutput
    MOV AH,9
    INT 21H
    CALL PRINT_SINGLE_NUMBER
    jmp INDEX_OUTPUT_COMPLETED
NOT_FOUND:
    LEA DX,searchOutputNotFound
    MOV AH,9
    INT 21H
INDEX_OUTPUT_COMPLETED:
    call NEW_LINE
    jmp BINARY_SEARCH_INPUT       
MAIN_END:    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H       
MAIN ENDP

  
 
  
BINARY_SEARCH PROC
   mov numberToFind,bx
   mov lb,0
   mov bx,n
   mov ub,bx
   sub ub,1
SEARCH_LOOP:
   xor ax,ax
   add ax,lb
   add ax,ub
   mov bx,2
   div bx
   and ax,00ffh
   mov mid,ax
   LEA SI,ARR
   add si,mid
   add si,mid       
   mov cx,ARR[si]
   mov bx,mid
   cmp numberToFind,cx
   je SEARCH_END
   jg GREATER
   mov ub,bx
   sub ub,1
   jmp LOOP_CONDITIONS
GREATER:
   mov lb,bx
   add lb,1
LOOP_CONDITIONS:
   mov ax,lb
   cmp ax,ub
   jle SEARCH_LOOP       
   xor bx,bx
   sub bx,1       
SEARCH_END: 
   ret 
BINARY_SEARCH ENDP    

  
  
    
DISPLAY_ARRAY PROC
    LEA SI,ARR
    mov pos1,SI
    mov ax,n
    mov posEnd,ax
    sub posEnd,1
    mov ax,2
    mul posEnd
    mov posEnd,ax
    mov ax,pos1
    add posEnd,ax   
PRINT_NUMBER_LOOP:
    mov SI,pos1
    mov bx,ARR[SI]
    CALL PRINT_SINGLE_NUMBER
    add pos1,2
    mov ax,posEnd
    cmp pos1,ax
    jle PRINT_NUMBER_LOOP           
    ret 
DISPLAY_ARRAY ENDP

  
  
  
PRINT_SINGLE_NUMBER PROC   
    cmp bx,0
    jge NON_NEGATIVE_NUMBER
    mov dl,'-'
    mov ah,2
    int 21h
    neg bx 
NON_NEGATIVE_NUMBER:    
    MOV ax,bx
    MOV bx, 10D
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
PRINT_SINGLE_NUMBER ENDP   

  
  
  
INSERTION_SORT PROC
    LEA SI,ARR
    mov pos1,SI
    mov posStart,SI
    mov ax,n
    mov posEnd,ax
    sub posEnd,1
    mov ax,2
    mul posEnd
    mov posEnd,ax
    mov ax,pos1
    add posEnd,ax   
OUTER_LOOP:
    add pos1,2
    mov ax,posEnd
    cmp pos1,ax
    jg OUTER_LOOP_END
    mov ax,pos1
    mov pos2,ax
INNER_LOOP:
    mov ax,pos2
    mov pos3,ax
    sub pos3,2
    mov ax,posStart
    cmp pos3,ax
    jl INNER_LOOP_END
    mov si,pos2
    mov ax, ARR[si] 
    mov si,pos3
    mov bx, ARR[si]
    cmp ax,bx
    jge INNER_LOOP_END
    mov si,pos2
    mov word ptr [si],bx
    mov si,pos3
    mov word ptr [si],ax
    sub pos2,2
    jmp INNER_LOOP
INNER_LOOP_END:
    jmp OUTER_LOOP
OUTER_LOOP_END:        
    ret
INSERTION_SORT ENDP    
  
  
             
             
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




END MAIN 


