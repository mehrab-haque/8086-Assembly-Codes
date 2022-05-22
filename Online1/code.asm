.MODEL SMALL


.STACK 100H


.DATA
CR EQU 0DH
LF EQU 0AH

inputPrompt db 'Enter a character (A~H) : $' 
outputPrompt db 'Corresponding value is : $'
x db ?          
          
          
.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    lea dx,inputPrompt
    mov ah,9
    int 21h
    
    mov ah,1
    int 21h
    mov x,al
    
    mov dl,lf
    mov ah,2
    int 21h
    
    mov dl,cr
    mov ah,2
    int 21h
    
    lea dx,outputPrompt
    mov ah,9
    int 21h
           
    mov dl,'1'
    mov ah,2
    int 21h
    
    mov bh,48h
    sub bh,x
    add bh,30h       
           
    mov dl,bh
    mov ah,2
    int 21h
        
    
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
