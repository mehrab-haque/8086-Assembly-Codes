.MODEL SMALL


.STACK 100H


.DATA
CR EQU 0DH
LF EQU 0AH
 
outputPrompt1 db 'Equilateral$' 
outputPrompt2 db 'Isoscalers$'
outputPrompt3 db 'Scalers$'

a db ?
b db ?
c db ?         
          
          
.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    
    mov ah,1
    int 21h
    mov a,al
    sub a,30h
    
    mov ah,1
    int 21h
    mov b,al
    sub b,30h
    
    mov ah,1
    int 21h
    mov c,al
    sub c,30h
    
    mov dl,lf
    mov ah,2
    int 21h
    
    mov dl,cr
    mov ah,2
    int 21h
    
    mov ch,a
    cmp ch,b
    jne END_EQUILATERAL
    
    mov ch,b
    cmp ch,c
    jne END_EQUILATERAL
    
    mov ch,c
    cmp ch,a
    jne END_EQUILATERAL
    
    lea dx,outputPrompt1
    mov ah,9
    int 21h
    jmp ENDIF
    
END_EQUILATERAL:

    mov ch,a
    cmp ch,b
    je END_SCALERS
    
    mov ch,b
    cmp ch,c
    je END_SCALERS
    
    mov ch,c
    cmp ch,a
    je END_SCALERS
    
    lea dx,outputPrompt3
    mov ah,9
    int 21h
    jmp ENDIF
    
END_SCALERS:
    lea dx,outputPrompt2
    mov ah,9
    int 21h       

ENDIF:    
           
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
