org 100h
jmp begin
         
    note dw 11D0h
    TIME DW 65000
      
PLAYMUSIC MACRO NOTE
            
    in al, 61h
    or al, 00000011b
    out 61h, al    
    
    mov al, 0B6h
    out 43h, al
    
    mov ax, [NOTE]
    out 42h, al
    
    mov al, Ah
    out 42h, al 
    
    ENDM     
        
DELAYMUSIC MACRO TIME
LOCAL DELAY
LOCAL DELAY2
   
    MOV DX, TIME
    MOV CX, 12
    DELAY:
    DEC DX
    JNZ DELAY
    LOOP DELAY
     
    
    
    in al, 61h
    and al, 11111100b
    out 61h, al
    
    MOV DX, TIME
    MOV CX, 5
    DELAY2:
    DEC DX
    JNZ DELAY2
    LOOP DELAY2
ENDM
begin:

    MOV BX, 3
    MOV NOTE, 54BEH
    PLAYMUSIC NOTE
    DELAYMUSIC TIME
    MOV NOTE, 4342H
    PLAYMUSIC NOTE
    DELAYMUSIC TIME
    MOV NOTE, 4742H
    PLAYMUSIC NOTE
    DELAYMUSIC TIME
    MOV NOTE, 4B7FH
    PLAYMUSIC NOTE
    DELAYMUSIC TIME
    DEC BX
    JNZ BEGIN
    SUB TIME, 10000

    JMP BEGIN
    
    
    

    
    


RET